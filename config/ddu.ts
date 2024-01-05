import {
  BaseColumnParams,
  BaseConfig,
  BaseSourceParams,
  ColumnName,
  KindOptions,
  SourceOptions,
  UserSource,
  ActionFlags,
  Ddu,
  UiName,
  UiOptions,
  BaseUiParams,
} from "https://deno.land/x/ddu_vim@v3.6.0/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.6.0/base/config.ts";
import { Denops } from "https://deno.land/x/denops_core@v5.0.0/denops.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    // aliases
    args.setAlias('column', 'icon_filename_for_ff', 'icon_filename')

    // source
    const sources: UserSource[] = [];
    const sourceParams: Record<string, Partial<BaseSourceParams>> = {
      file: {
        ignoredDirectories: [
          // git
          ".git",
          // Node.js
          "node_modules",
          // Python
          ".venv",
          // Ruby
          ".ruby-lsp",
          // C#
          "bin",
          "obj",
        ],
      },
      file_rec: {
        ignoredDirectories: [
          // git
          ".git",
          // Node.js
          "node_modules",
          // Python
          ".venv",
          // Ruby
          ".ruby-lsp",
          // C#
          "bin",
          "obj",
        ],
      },
    };

    const sourceOptions: Record<string, Partial<SourceOptions>> = {
      _: {
        ignoreCase: true,
        matchers: ["matcher_substring"],
        maxItems: 50000,
      },
      help: { },
      file: {
        columns: ['icon_filename_for_ff'],
      },
      file_rec: {
        columns: ['icon_filename_for_ff'],
      },
      line: {
        matchers: ['matcher_kensaku']
      }
    };

    const columnParams: Record<ColumnName, Partial<BaseColumnParams>> = {
      icon_filename: {
        defaultIcon: { icon: '' },
      },
      icon_filename_for_ff: {
        defaultIcon: { icon: '' },
        padding: 0,
        pathDisplayOption: 'relative'
      }
    }

    // kind
    const kindOptions: Record<string, Partial<KindOptions>> = {
      file: { defaultAction: "open" },
      file_rec: { defaultAction: "open" },
      action: { defaultAction: "do" },
      command: { defaultAction: "edit" },
      command_history: { defaultAction: "edit" },
      help: { defaultAction: "open" },
      lsp: { defaultAction: "open" },
      lsp_codeAction: { defaultAction: "apply" },
    };

    // UI
    const kensakuAction = async (args: {denops: Denops; ddu: Ddu;}) => {
      args.ddu.updateOptions({
        sourceOptions: {
          _: {
            matchers: ['matcher_kensaku']
          }
        }
      })
      await args.denops.cmd("echomsg 'change to kensaku matcher'")
      return ActionFlags.Persist;
    }
    const uiOptions: Record<UiName, Partial<UiOptions>> = {
      ff: {
        actions: { kensaku: kensakuAction }
      }
    }
    const uiParams: Record<UiName, Partial<BaseUiParams>> = {
      // TODO: Use exported Params type of ddu_ui_ff deno package
      ff: {
        split: 'floating',
        startFilter: true,
        filterFloatingTitle: 'Filter',
        filterFloatingTitlePos: 'center',
        floatingBorder: 'rounded',
        floatingTitle: 'Candidates',
        floatingTitlePos: 'center',
        autoAction: { name: 'preview' },
        startAutoAction: true,
        previewFloating: true,
        previewFloatingBorder: 'rounded',
        previewFloatingTitle: 'Preview',
        previewFloatingTitlePos: 'center',
        previewSplit: 'vertical',
        previewWindowOptions: [
          ['&signcolumn', 'no'],
          ['&foldcolumn', 0],
          ['&foldenable', 0],
          ['&number', 0],
          ['&wrap', 0],
          ['&scrolloff', 0],
        ],
        prompt: '❯ ',
        highlights: {
          floating: 'Normal',
          floatingBorder: 'Normal'
        },
        ignoreEmpty: true,
        winHeight: '&lines / 8 * 6',
        winWidth: '&columns / 8 * 3',
        winRow: '&lines / 8',
        winCol: '&columns / 8',
        previewHeight: '&lines / 8 * 6',
        previewWidth: '&columns / 8 * 3',
        previewRow: '&lines / 8',
        previewCol: '&columns / 2 + 2',
      }
    }

    const filterParams = {
      matcher_kensaku: { highlightMatched: 'Search' },
      matcher_substring: { highlightMatched: 'Search' },
    }

    args.contextBuilder.patchGlobal({
      // UI
      ui: "ff",
      uiParams,
      uiOptions,
      // source
      sources: sources,
      sourceParams,
      sourceOptions,
      columnParams,
      // kind
      kindOptions,
      // Filter
      filterParams,
    });

    // Patch local
    // LSP
    const lspDefinitionMethods = [
      'textDocument/declaration',
      'textDocument/definition',
      'textDocument/typeDefinition',
      'textDocument/implementation',
    ]
    args.contextBuilder.patchLocal('lsp:definitions', {
      sources: lspDefinitionMethods.map((method) => (
        {
          name: 'lsp_definition',
          params: { method }
        }
      )),
      sync: true,
      uiParams: {
        ff: {
          immediateAction: 'open',
          floatingTitle: '',
          floatingBorder: 'solid',
          startFilter: false,
        }
      }
    })
    args.contextBuilder.patchLocal('lsp:code_action', {
      sources: [{ name: 'lsp_codeAction', }],
      sync: true,
      uiParams: {
        ff: {
          floatingTitle: '',
          floatingBorder: 'solid',
          startFilter: false,
        }
      }
    })
    args.contextBuilder.patchLocal('edgy:lsp:documentSymbol', {
      sources: [
        {
          name: 'lsp_documentSymbol',
          options: {
            converters: ['converter_lsp_symbol']
          }
        }
      ],
      sync: false,
      uiParams: {
        ff: {
          displayTree: true,
          focus: false,
          startFilter: false,
          split: 'vertical',
          autoAction: {},
          startAutoAction: false,
          ignoreEmpty: true,
        }
      },
      uiOptions: {
        ff: {
          persist: true,
        }
      },
    })
    args.contextBuilder.patchLocal('edgy:lsp:diagnostics', {
      sources: [
        {
          name: 'lsp_diagnostic',
          options: {
            converters: ['converter_lsp_diagnostic']
          }
        }
      ],
      sync: false,
      uiParams: {
        ff: {
          displayTree: true,
          focus: false,
          startFilter: false,
          split: 'vertical',
          autoAction: {},
          startAutoAction: false,
          ignoreEmpty: true,
        }
      },
      uiOptions: {
        ff: {
          persist: true,
        }
      },
    })
    args.contextBuilder.patchLocal('edgy:buffers', {
      sources: [
        {
          name: 'buffer',
        }
      ],
      sync: false,
      uiParams: {
        ff: {
          displayTree: false,
          focus: false,
          startFilter: false,
          split: 'vertical',
          autoAction: {},
          startAutoAction: false,
          ignoreEmpty: true,
        }
      },
      uiOptions: {
        ff: {
          persist: true,
        }
      },
    })

    // buffers
    args.contextBuilder.patchLocal('buffers', {
      sources: [ { name: 'buffer', }, ],
      sync: true,
      uiParams: {
        ...uiParams,
        ff: {
          ...uiParams.ff,
          floatingTitle: 'Buffers',
        }
      }
    })

    // grep
    args.contextBuilder.patchLocal('grep', {
      sources: [
        {
          name: 'rg',
          options: {
            matchers: [],
            volatile: true,
          }
        },
      ],
      sourceParams: {
        rg: {
          args: ['--json', '--column', '--no-heading', '--color', 'never'],
        }
      },
      sync: true,
      uiParams: {
        ...uiParams,
        ff: {
          ...uiParams.ff,
          ignoreEmpty: false,
          floatingTitle: 'Grep',
        }
      }
    })

    // Commands
    args.contextBuilder.patchLocal('command_palette', {
      sources: [
        { name: 'command' },
        { name: 'command_history' }
      ],
      sync: true,
      uiParams: {
        ...uiParams,
        ff: {
          ...uiParams.ff,
          floatingTitle: 'Command Palette',
        }
      }
    })

    return Promise.resolve();
  }
}
