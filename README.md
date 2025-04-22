# flash-nvim

> My personal Neovim config for efficiency, speed and goodness of a mouse-free keyboard-loving juggernaut 🚀

# Plugin Manager: Lazy.nvim

This config uses Lazy.nvim as its plugin manager. All plugin-related configuration is modular and stored in the `lua/` directory.

# Theme & UI Setup

- Pre-installed colorschemes:

  - Mofiqul/vscode.nvim
  - folke/tokyonight.nvim
  - EdenEast/nightfox.nvim ← currently enabled
  - vv9k/vim-github-dark
  - ayu-theme/ayu-vim

- Minimalist UI with mini.nvim for:

  - Statusline
  - Icons

- No dedicated tabline (uses custom keymaps for tab-based file and terminal management)

# Key Features

- ✅ LSP support with lua-language-server

  - Uses blink.cmp for autocompletion
  - mason.nvim can be used to install other LSPs
  - lspconfig.lua is pre-configured only for Lua — others can be added easily

- ✅ Treesitter for powerful syntax highlighting

- ✅ telescope.nvim with fzf-native extension for blazing-fast fuzzy finding

- ✅ oil.nvim for modern file browsing (yes, it’s a file explorer!)

- ✅ Snippet support via luasnip and friendly-snippets

- ✅ Autoformatting with null-ls.nvim + .editorconfig

  - Triggered manually with keymaps using vim.lsp.buf.format()

- ✅ Floating terminal toggle with custom keymaps

- ✅ Custom keybindings designed for tab-based workflow

- ❌ No debugger or git integration included (by choice)

# Custom Plugins

These are plugins built by me to enhance my workflow:

1. floaterminal – A togglable floating terminal window for quick command execution.
2. multigrep – Fast grep tool using ripgrep, scoped to the current directory.
3. present.nvim – Present Markdown files like slides in floating windows:
   - :StartPresentation or <space>md (Markdown only)
   - n, p, q to navigate slides

# Plugin Modules

Each plugin or config feature is modularized:

- autocompletion.lua → blink.cmp setup
- colorschemes.lua → theme management
- lspconfig.lua → core LSP config (Lua language server only)
- luasnip.lua → snippets setup
- mason.lua → external LSP manager
- mini.lua → UI config
- null-ls.lua → formatter and linter integration
- oil.lua → file browser config
- plugin-loader.lua → loads custom plugins from NeoVim-Plugins/
- telescope.lua → fuzzy finder config
- treesitter.lua → syntax highlighting
- web-dev-autotag.lua → HTML/JS auto-tagging support

# Setup Instructions (Linux)

## Prerequisites

- Neovim 0.9+
- Git
- yay (or any AUR helper)
- alacritty terminal (optional, but preferred)
- Nerd Font (recommended for icons)

## Installation

1. Clone the repo:

   git clone https://github.com/lakshmeghani/flash-nvim ~/.config/nvim

2. Open Neovim:

   nvim

3. Lazy.nvim will auto-install and sync all plugins.

4. Use `<space>fn` inside Neovim to explore the config using telescope (with .ignore file support for hiding LSP folders).

5. Configure formatters if needed via .editorconfig or use mason.nvim to install them.

6. Ensure lua-language-server is in your runtime path OR use Mason UI to install it.

## Notes

- The config is thoroughly commented — reading the Lua files should be enough to understand what’s going on.
- Follows a modular structure inspired by kickstart.nvim but with more flexibility.
- Keybindings are located in the respective plugin modules or in plugin-loader.lua.

# Fonts and Aesthetics

- Terminal: alacritty
- Font: Nerd Font (any patched font with icon support)
- Colorscheme: nightfox.nvim by default, can be changed in colorschemes.lua

# Present.nvim Keymaps (for Markdown)

- :StartPresentation — start slide mode
- <space>md — start slide mode (Markdown files only)
- n — next slide
- p — previous slide
- q — quit presentation

# Tips

- Use Telescope (<space>fn) to open and explore config files fast
- .ignore file helps avoid clutter (e.g. for Mason-installed language servers)
- Don’t forget to read the comments — they’re there for you

---

Feel free to fork, tweak, and contribute if you find this setup helpful 🙌
