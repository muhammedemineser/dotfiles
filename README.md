# dotfiles

Ubuntu 24 · fish shell · kitty · nvim (LazyVim)

## Setup

### 1. Clone

```bash
git clone --recurse-submodules https://github.com/mu-mino/dotfiles.git ~/dotfiles
```

### 2. Symlinks

```bash
ln -sf ~/dotfiles/kitty.conf ~/.config/kitty/kitty.conf
ln -sf ~/dotfiles/config.fish ~/.config/fish/config.fish
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/speak.sh ~/utils/speak.sh
ln -sf ~/dotfiles/nvim/nvim ~/.config/nvim
ln -sf ~/dotfiles/ai/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/dotfiles/ai/skills ~/.claude/skills
```

### 3. kitty startup session

```bash
mkdir -p ~/.config/kitty
echo "launch nvim -c terminal" > ~/.config/kitty/startup.session
```

### 4. nvr (neovim-remote)

```bash
pipx install neovim-remote
pipx inject neovim-remote "setuptools<72" --force
```

Verify: `nvr --version`

## What's configured

### kitty
- Every window/tab opens nvim `:terminal`
- New tab (`ctrl+shift+t`) inherits CWD from last `cd`/`z`
- `allow_remote_control socket-only` for kitten @ overlay
- `alt+e` → edit current commandline in vi overlay

### fish
- `nvim` function: inside `:terminal` → routes to outer nvim via `nvr --remote`
- `cd` / `z` → write CWD to `/tmp/kitty_last_cwd` for new-tab inheritance
- `alt+e` → opens commandline in kitty vi overlay, injects result on `:wq`

### nvim (LazyVim)
- `<Esc>` in terminal buffer → Normal mode
- `:wq` → save + close buffer (keeps nvim + terminal alive)
- `:q` / `:q!` → close buffer without quitting nvim
- Terminal buffers show line numbers

## Sync

After local changes:

```bash
~/dotfiles/sync.sh
```

Copies configs → commits → force-pushes both dotfiles repo and nvim submodule.
