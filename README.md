# nvim2.0-config

nvim2.0-config is a batteries-included yet lightweight Neovim 0.9+ configuration tuned for daily engineering work. It delivers first-class language support, ergonomic navigation, tasteful UI polish, and integrated tooling so you can focus on shipping code.

## Quickstart

1. **Backup** your existing config (mandatory):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak-$(date +%Y%m%d-%H%M)
   ```
2. **Clone** this repository:
   ```bash
   git clone git@github.com:ZeroOneLogan/nvim2.0-config.git ~/.config/nvim
   ```
3. **Launch** Neovim:
   ```bash
   nvim
   ```
   The first start bootstraps [`lazy.nvim`](https://github.com/folke/lazy.nvim) and installs plugins.
4. **Install tooling** from inside Neovim:
   - Run `:Lazy` then press `U` to update/pin plugins.
   - Run `:Mason` and install any highlighted tools.

## Highlights

- Fast startup (<80 ms after first sync) thanks to granular lazy-loading.
- Toggleable IDE surface: bufferline, statusline, diagnostics list, integrated terminal, tree explorer, outline via Telescope, DAP UI.
- Tasteful defaults with Catppuccin/Tokyo Night themes, Noice command line, which-key hints, and compact notifications.
- Language-smart editing: Treesitter, LSP, completion, snippets, format-on-save via conform, lint-on-save via nvim-lint.
- Debugging with nvim-dap, DAP UI, and automatic adapter management (Python, Node/JS/TS, Go).
- Session persistence, TODO highlights, and Git tooling (gitsigns, Telescope pickers, Fugitive).

## Keymaps Cheat-Sheet

Leader = `<Space>`

### Core navigation
- `<leader>ff` – Telescope find files
- `<leader>fg` – Live grep project
- `<leader>fb` – Switch buffers
- `<leader>fr` – Recent files
- `<leader>fh` – Help tags
- `<leader>e` – Toggle Neo-tree explorer
- `<leader>fe` – Focus explorer
- `<leader>tt` – Toggle floating terminal
- `<leader>xx` – Trouble diagnostics toggle
- `[d` / `]d` – Prev/next diagnostic

### LSP & code actions
- `gd` / `gD` / `gi` / `gr` – Definition / Declaration / Implementation / References
- `K` – Hover docs
- `<leader>rn` – Rename symbol
- `<leader>ca` – Code actions (normal/visual)
- `<leader>lf` – Format buffer (conform)
- `<leader>ls` – Signature help

### Git (gitsigns + fugitive)
- `<leader>gg` – Fugitive status
- `<leader>gs` – Stage hunk
- `<leader>gr` – Reset hunk
- `<leader>gS` – Stage buffer
- `<leader>gp` – Preview hunk
- `<leader>gb` – Blame line
- `]c` / `[c` – Next/prev hunk

### Debugging (nvim-dap)
- `<F5>` / `<F10>` / `<F11>` / `<F12>` – Continue / Step over / Step into / Step out
- `<leader>db` – Toggle breakpoint
- `<leader>dB` – Conditional breakpoint
- `<leader>dr` – Toggle REPL
- `<leader>du` – Toggle DAP UI

### Sessions
- `<leader>qs` – Restore session
- `<leader>ql` – Restore last session
- `<leader>qd` – Disable session save for current dir

## Plugin Stack

| Area | Plugins |
| ---- | ------- |
| Theme & UI | `catppuccin`, `tokyonight`, `lualine`, `bufferline`, `noice`, `nvim-notify`, `dressing`, `which-key`, `indent-blankline`, `nvim-web-devicons` |
| Navigation | `telescope` (+fzf-native), `neo-tree`, `treesitter` |
| Editing | `nvim-cmp`, `LuaSnip`, `friendly-snippets`, `nvim-autopairs`, `nvim-surround`, `Comment.nvim` |
| Git | `gitsigns.nvim`, `vim-fugitive` |
| Diagnostics & Tools | `trouble.nvim`, `todo-comments`, `toggleterm`, `persistence.nvim`, `conform.nvim`, `nvim-lint` |
| LSP | `mason.nvim`, `mason-lspconfig`, `mason-tool-installer`, `nvim-lspconfig`, `schemastore`, `neodev`, `fidget.nvim`, `rust-tools`, `nvim-jdtls` |
| Debugging | `nvim-dap`, `nvim-dap-ui`, `mason-nvim-dap`, `nvim-dap-virtual-text` |

## Language Support Matrix

| Language | LSP | Formatter | Linter |
| -------- | --- | --------- | ------ |
| Lua | `lua_ls` | `stylua` | `selene` |
| Python | `pyright` + `ruff` | `isort` + `black` | `ruff` |
| JavaScript / TypeScript | `tsserver` | `prettierd`/`prettier`/`biome` | `eslint_d` |
| Go | `gopls` | `gofumpt` + `goimports` | `golangci-lint` |
| Rust | `rust_analyzer` (via rust-tools) | `rustfmt` | `clippy` via rust-analyzer |
| Ruby | `solargraph` | `rubocop` | `rubocop` |
| PHP | `intelephense` | `prettierd` | `intelephense` |
| YAML | `yamlls` | `prettierd` | `yamllint` |
| JSON | `jsonls` (with schema store) | `prettierd` | `jsonls` |
| Markdown | `marksman` | `prettierd` / `markdownlint` | `markdownlint` |
| Docker | `dockerls`, `docker_compose_language_service` | `prettierd` | `docker` LSP |
| Terraform | `terraformls` | `terraform` fmt (via LSP) | `terraformls` |
| Kotlin / Java | `kotlin_language_server`, `jdtls` | LSP | LSP |

> Mason ensures all listed servers and formatters are available; open `:Mason` to install extras on demand.

## Debugging Presets

- **Python** – Launch current file via `debugpy` in integrated terminal.
- **Node/JS/TS** – Use `js-debug-adapter` (`pwa-node`) to launch or attach to processes.
- **Go** – Managed by `delve`; `:MasonInstall delve` if missing.
- The DAP UI opens automatically when a session starts and closes on stop.

## Performance

Collect a startup timing snapshot after initial sync:
```bash
nvim --startuptime /tmp/nvim.startup.txt -c qa
```
Inspect `/tmp/nvim.startup.txt` for hot spots; typical cold starts land around 60–80 ms on Apple Silicon.

## Troubleshooting

- **Bootstrap failures**: ensure Git and a C compiler (for telescope-fzf) are installed, then rerun `:Lazy sync`.
- **Language tools missing**: open `:Mason`, install highlighted packages, or run `:MasonInstall <tool>`.
- **Java projects**: install `jdtls` system-wide or via Mason and ensure `JAVA_HOME` is set for Lombok support.
- **Formatter conflicts**: toggle format-on-save per buffer with `:ConformDisable` / `:ConformEnable`.
- **DAP issues**: run `:MasonInstall debugpy js-debug-adapter delve` and restart Neovim.
- **Health checks**: `:checkhealth` reports missing system deps (node, go, python3) used by external tooling.

## Acceptance Checklist

- [ ] `nvim --headless "+lua print('NVIM OK')" +qa`
- [ ] `nvim --headless "+lua require('lazy').sync()" +qa`
- [ ] `nvim --headless "+MasonUpdate" +qa`
- [ ] `nvim --headless "+checkhealth" +qa`
- [ ] `nvim --startuptime /tmp/nvim.startup.txt -c qa`
- [ ] Open project → confirm LSP attach (`:LspInfo`), format-on-save, Telescope pickers, Neo-tree toggle, Trouble, DAP UI.

## Changelog

### 2.0.0
- Initial release of nvim2.0-config: modular lazy.nvim setup, curated plugin stack, language tooling, DAP, and documentation.
