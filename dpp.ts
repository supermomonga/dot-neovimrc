import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.7/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.0.7/deps.ts";
import { expandGlob } from "https://deno.land/std@0.206.0/fs/mod.ts";
import { DelimiterStream } from "https://deno.land/std@0.184.0/streams/delimiter_stream.ts";

// 1行目が `# nolazy` となっている toml ファイル以外を lazy とみなす
async function isLazyToml(filePath: string): Promise<boolean> {
  const file = await Deno.open(filePath);
  const reader = file
    .readable
    .pipeThrough(new DelimiterStream(new TextEncoder().encode("\n")))
    .pipeThrough(new TextDecoderStream())
    .getReader();
  const { value } = await reader.read();
  file.close();

  const immediate = value && value.startsWith("#") &&
    value.includes("nolazy");
  return !immediate;
}

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    args.contextBuilder.setGlobal({
      protocols: ["git"],
    });
    console.log("start makestate");

    type Toml = {
      hooks_file?: string;
      ftplugins?: Record<string, string>;
      plugins?: Plugin[];
    };

    const [context, options] = await args.contextBuilder.get(args.denops);

    const tomlPathPattern = `${
      Deno.env.get("HOME")
    }/ghq/github.com/supermomonga/dot-nvimrc/**/*.toml`;
    const tomls: Toml[] = [];
    for await (const entry of expandGlob(tomlPathPattern)) {
      const isLazy = await isLazyToml(entry.path);
      console.log(`Load: ${entry.path} (${isLazy ? "Lazy" : "Immediate"})`);
      const toml = await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: await fn.expand(args.denops, entry.path),
          options: {
            lazy: isLazy,
          },
        },
      ) as Toml;
      tomls.push(toml);
    }

    const plugins: Plugin[] = tomls.flatMap(({ plugins }) => plugins ?? []);
    const ftplugins: Record<string, string> = {};
    const hooks: string[] = [];
    tomls.forEach((toml) => {
      Object.entries(toml.ftplugins ?? {}).forEach(([filetype, ftplugin]) => {
        if (filetype in ftplugins) {
          ftplugins[filetype] += `\n${ftplugin}`;
        } else {
          ftplugins[filetype] = ftplugin;
        }
      });

      if (toml.hooks_file) {
        hooks.push(toml.hooks_file);
      }
    });

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: plugins,
      },
    ) as ConfigReturn;

    console.log("makestate finished.");

    return lazyResult;
  }
}
