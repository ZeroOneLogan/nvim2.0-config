# nvim2.0-config

Personalized all-in-one Neovim configuration targeting Neovim **0.11.4**. The goal is a fast, reliable IDE experience with batteries included while keeping personalization easy via a single preferences module.

## Quickstart

1. **Backup existing config** (recommended):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak-$(date +%Y%m%d-%H%M)
   ```
2. **Clone** this repository into `~/.config/nvim`:
   ```bash
   git clone https://github.com/ZeroOneLogan/nvim2.0-config ~/.config/nvim
   ```
3. **Launch Neovim**. The first start will bootstrap [lazy.nvim](https://github.com/folke/lazy.nvim) and install pinned plugins from `lazy-lock.json`.
4. Run `:Nvim2Setup` to let the onboarding assistant recommend language servers, formatters, linters, and debuggers based on project files.
5. Use `:Nvim2Keys` for a discoverable in-editor keymap cheatsheet.

> Subsequent startups should settle around ~80 ms on typical hardware (see [performance](#performance)).

## Feature Overview

| Area          | Highlights |
|---------------|------------|
| UI            | Catppuccin / Tokyo Night themes, lualine, bufferline, noice + notify, todo-comments, optional Alpha dashboard |
| Navigation    | Telescope + fzf-native, project-aware file switching, Neo-tree or Nvim-tree (configurable), Aerial outline |
| Editing       | Treesitter + textobjects, context-aware commenting, surround, autopairs, cmp + luasnip, indent guides |
| LSP & Tools   | Mason-managed servers, conform.nvim formatting, nvim-lint for gaps, diagnostics tuned with custom signs |
| Git           | gitsigns, fugitive commands, Telescope git pickers |
| Debugging     | nvim-dap + dap-ui + virtual text, Mason auto-install adapters (python, js, go) |
| Testing       | neotest with python/jest/go adapters (guarded by profile) |
| Terminal      | toggleterm with floating terminals, OSC52 remote clipboard integration |
| Sessions      | persistence.nvim for last-session restore, project.nvim for root switching |
| Writing Mode  | Zen-mode, Twilight, markdown ergonomics |
| Utilities     | Which-key groups, :Nvim2Setup onboarding, :Nvim2Doctor tooling summary, :Nvim2Profile profile switcher |

## Healthcheck & Fixes

This release targets Neovim **0.11.4** with a clean bill of health:

* ✅ `:checkhealth` finishes with zero errors and only informational warnings.
* Conform.nvim now uses ordered formatter fallbacks with single-notice reporting when tools are missing, plus Mason installs driven by detected CLIs.
* DAP bootstrap guards against missing adapters and ships Python/Node stubs so healthcheck no longer fails before installing packages.
* Lazy.nvim LuaRocks integration is disabled to silence redundant health warnings.
* Noice overrides LSP markdown rendering for hover/signature windows, matching upstream health expectations.
* Diagnostic signs use the modern `vim.diagnostic.config()` API (forward-compatible with 0.12).
* which-key v3 configuration adopts the new trigger/group syntax and resolves `<leader>` conflicts.
* Providers can be enabled per-host via `prefs.providers`, avoiding startup noise when Python/Ruby shims are absent.
* `:Nvim2Doctor` aggregates provider/formatter/DAP status with actionable install commands.

## Profiles & Preferences

Configuration defaults live in [`lua/user/prefs.lua`](lua/user/prefs.lua); overrides are written to the git-ignored `lua/user/prefs.local.lua` (created on first save). Use `:Nvim2Profile` to switch presets or edit either file directly—changes refresh plugins automatically.

Default preference table:

```lua
{
  theme = "catppuccin",
  profile = "Full-IDE",
  osc52 = true,
  explorer = "neo-tree",
  outline = true,
  tests = true,
  ai = false,
  alpha = false,
  project = true,
  ufo = true,
  statuscol = false,
  transparency = 0,
  diagnostics_virtual_text = true,
  format_on_save = true,
  providers = {
    python = false,
    ruby = false,
    python_host = nil,
    ruby_host = nil,
  },
}
```

### Profile presets

| Profile    | Description |
|------------|-------------|
| **Minimal** | Core editing, LSP basics, Telescope, no DAP/tests/outline/UFO. |
| **Full-IDE** | Everything enabled: DAP, neotest, outline, project/session helpers. |
| **Writing** | Markdown-first: Zen-mode, Twilight, spell/wrap defaults, coding extras trimmed. |

Switch profiles via `:Nvim2Profile` (interactive prompt) or editing `prefs.local.lua`. The command rewrites the overrides file and runs `:Lazy sync` to enable/disable guarded plugins automatically.

### Tweaking preferences

* `theme`: `"catppuccin"` or `"tokyonight"` (fallback to `habamax` if unavailable).
* `explorer`: `"neo-tree"` or `"nvim-tree"`.
* `outline`: toggles Aerial.
* `tests`: toggles neotest adapters and mappings.
* `ai`: reserved for future AI helpers (see [`lua/ai/init.lua`](lua/ai/init.lua)).
* `project`: toggles project.nvim and Telescope projects extension.
* `ufo`: enables advanced folds via nvim-ufo.
* `format_on_save`: integrates with conform.nvim for full-buffer formatting (per-language toolchain configured in [`lua/lsp/formatting.lua`](lua/lsp/formatting.lua)).
* `providers`: table controlling legacy remote plugins—set `providers.python = true` (and optionally `python_host = "/path/to/python"`) or `providers.ruby = true` when you have the host shims installed.

#### Language providers

Remote plugin hosts are noisy when the binaries are missing, so they are disabled by default. To enable Python (pynvim) or Ruby providers, add overrides in `prefs.local.lua` such as:

```lua
return {
  providers = {
    python = true,
    python_host = "/usr/bin/python3",
    ruby = true,
  },
}
```

`:Nvim2Doctor` will confirm whether the configured hosts are executable.

## Keymaps Cheat Sheet

Invoke `:Nvim2Keys` anytime or use the table below as a quick reference. Leader is `<Space>`, localleader is `,`.

| Mapping | Mode | Action |
|---------|------|--------|
| `<leader>ff` | Normal | Telescope find files |
| `<leader>fg` | Normal | Telescope live grep |
| `<leader>fb` | Normal | Telescope buffers |
| `<leader>fh` | Normal | Telescope help tags |
| `<leader>e`  | Normal | Toggle file explorer |
| `<leader>o`  | Normal | Toggle Aerial outline |
| `<leader>xx` | Normal | Toggle Trouble diagnostics list |
| `<leader>xq` | Normal | Send diagnostics to loclist |
| `[d` / `]d` | Normal | Previous/next diagnostic |
| `gd` / `gD` | Normal | LSP definition / declaration |
| `gr` / `gi` | Normal | LSP references / implementation |
| `K`         | Normal | Hover documentation |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal/Visual | Code actions |
| `<leader>f`  | Normal | Format (conform.nvim) |
| `<leader>gs` | Normal | Git stage hunk (gitsigns) |
| `<leader>gr` | Normal | Git reset hunk |
| `<leader>gp` | Normal | Git preview hunk |
| `<leader>gb` | Normal | Git blame line |
| `<leader>tt` | Normal | Toggle floating terminal |
| `<leader>db` | Normal | Toggle breakpoint (DAP) |
| `<leader>dc` / `<leader>do` / `<leader>di` | Normal | Continue / Step over / Step into |
| `<leader>du` | Normal | Toggle DAP UI |
| `<leader>tn` / `<leader>tf` | Normal | Run nearest / file tests (neotest) |
| `<leader>ts` / `<leader>to` | Normal | Toggle test summary / open output |
| `<leader>up` | Normal | Open preferences (creates `prefs.local.lua` on save) |
| Terminal `<Esc>` | Terminal | Exit terminal mode |

## Commands

| Command | Purpose |
|---------|---------|
| `:Nvim2Setup` | Detect project language fingerprints, propose Mason installs, and optionally install missing tools. |
| `:Nvim2Doctor` | Open a floating report summarizing providers, formatters, and debug adapter prerequisites. |
| `:Nvim2Profile` | Switch between Minimal / Full-IDE / Writing profiles (writes `prefs.local.lua`, runs `:Lazy sync`). |
| `:Nvim2Keys` | Open the which-key/Telescope keymap browser. |

## LSP, Formatting & Linting

* Language servers configured via [`lua/lsp/init.lua`](lua/lsp/init.lua) with per-server overrides in `lua/lsp/servers/`.
* Mason + mason-tool-installer ensure the following core tools: bashls, clangd, cssls, dockerls, gopls, html, jdtls, jsonls, kotlin, lua_ls, marksman, pyright, ruff-lsp/ruff, rust-analyzer, tailwindcss, taplo, tsserver, yamlls, eslint, intelephense, terraformls.
* Formatting by [conform.nvim](lua/lsp/formatting.lua): black/isort, goimports/gofumpt, stylua, biome/prettierd, rustfmt, taplo, shfmt, clang-format, terraform_fmt, yamlfmt, markdownlint, etc.
* Linting by [nvim-lint](lua/lsp/linting.lua): ruff, markdownlint, yamllint (triggered on write/leave insert).
* DAP via [`lua/dap/init.lua`](lua/dap/init.lua) with Mason-managed adapters: debugpy, js-debug, delve; dap-ui auto-opens, keymaps under `<leader>d*`.

### External tooling cheatsheet

| Tool | Purpose | Install command |
|------|---------|-----------------|
| `stylua` | Lua formatter | `:MasonInstall stylua` |
| `black` | Python formatter | `:MasonInstall black` |
| `isort` | Python import sorter | `:MasonInstall isort` |
| `prettierd` | JS/TS formatter daemon | `:MasonInstall prettierd` |
| `prettier` | JS/TS formatter (CLI) | `npm install -g prettier` |
| `biome` | JS/TS formatter/linter | `:MasonInstall biome` (requires Node.js) |
| `markdownlint` | Markdown linter/formatter | `:MasonInstall markdownlint` |
| `taplo` | TOML formatter | `:MasonInstall taplo` |
| `gofumpt` | Go formatter | `go install mvdan.cc/gofumpt@latest` |
| `goimports` | Go import organizer | `go install golang.org/x/tools/cmd/goimports@latest` |
| `rustfmt` | Rust formatter | `rustup component add rustfmt` |
| `shfmt` | Shell formatter | `:MasonInstall shfmt` |
| `yamlfmt` | YAML formatter | `go install github.com/google/yamlfmt/cmd/yamlfmt@latest` |
| `terraform` | Terraform fmt provider | `brew install terraform` or `choco install terraform` |
| `clang-format` | C/C++ formatter | `:MasonInstall clang-format` |


## Testing & Debugging Workflows

* Neotest adapters for Python (`pytest`/`unittest`), Jest/Vitest, and Go.
* Toggle tests within `<leader>t*` groups; summary panel and output windows for quick inspection.
* DAP UI toggled with `<leader>du`; breakpoints, stepping, evaluation through nvim-dap.

## Writing Profile Extras

Activating the **Writing** profile enables Zen-mode, Twilight, markdown-friendly options (`wrap`, `conceallevel`, spell checking) and keeps the interface distraction-free while retaining Telescope and key productivity tools.

## Performance

* Startup measurements captured via `nvim --startuptime /tmp/nvim.startup.txt -c qa`. The most recent run clocked at **61.26 ms** (see `/tmp/nvim.startup.txt` artifact during CI).
* Treesitter installations are managed lazily; run `:TSInstall <language>` manually if parsers fail to download (see `:Nvim2Doctor` for toolchain hints).

## Continuous Integration

[`health.yml`](.github/workflows/health.yml) runs on Ubuntu with Neovim 0.11.x. The workflow caches plugin downloads, bootstraps the config, runs headless health checks (`:checkhealth`, `:Lazy sync`), and stores the startup time log as an artifact.

## How to add a language

1. **Install tools**: add Mason package names to `ensure_installed` in [`lua/plugins/lsp.lua`](lua/plugins/lsp.lua) or run `:MasonInstall tool-name`.
2. **Add/adjust LSP server**: extend the `servers` table in [`lua/lsp/init.lua`](lua/lsp/init.lua) and provide per-server settings under `lua/lsp/servers/<name>.lua` as needed.
3. **Formatter/Linter**: update [`lua/lsp/formatting.lua`](lua/lsp/formatting.lua) and [`lua/lsp/linting.lua`](lua/lsp/linting.lua) with conform/nvim-lint entries.
4. **Optional DAP/Test adapters**: configure via [`lua/dap/init.lua`](lua/dap/init.lua) and [`lua/plugins/tests.lua`](lua/plugins/tests.lua).

## Troubleshooting

* Run `:Nvim2Doctor` for a floating summary of missing providers, formatters, and DAP adapters (with install hints).
* `lazy-lock.json` pins every plugin for reproducible installs. Regenerate via `:Lazy sync` after intentional updates.
* Remote clipboard issues? Ensure `prefs.osc52 = true` and that your terminal supports OSC52.
* If Treesitter parsers fail to compile in CI, install manually with `:TSInstall <lang>`.

## Contributing / Next Steps

* Explore additional language-specific test runners or DAP adapters.
* Integrate an optional AI assistant once an API key management strategy is settled (`lua/ai/init.lua` stub is ready).
* Add markdown preview or Obsidian integration guarded by the Writing profile.

Happy hacking! 🎉
