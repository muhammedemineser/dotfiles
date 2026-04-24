# Dotfiles Setup

## Symlinks

```bash
ln -sf ~/dotfiles/kitty.conf ~/.config/kitty/kitty.conf
ln -sf ~/dotfiles/config.fish ~/.config/fish/config.fish
ln -sf ~/dotfiles/nvim/nvim ~/.config/nvim
```

## nvr (neovim-remote) — muss manuell installiert werden

`nvr` ist nicht in dotfiles — wird via pipx installiert.

```bash
# 1. nvr installieren
pipx install neovim-remote

# 2. setuptools downgraden (setuptools 72+ hat kein pkg_resources mehr → nvr crasht)
pipx inject neovim-remote "setuptools<72" --force
```

Prüfen:
```bash
nvr --version
# nvr 2.5.1
```

## kitty startup session

```bash
mkdir -p ~/.config/kitty
cat > ~/.config/kitty/startup.session << 'EOF'
launch nvim -c terminal
EOF
```

`kitty.conf` referenziert diese Session via `startup_session ~/.config/kitty/startup.session`.

## Was die Konfiguration tut

| Datei | Änderung | Effekt |
|-------|----------|--------|
| `kitty.conf` | `shell fish -c "nvim -c 'terminal'"` | Jedes neue kitty-Fenster/Tab öffnet nvim mit `:terminal` |
| `config.fish` | `function nvim` mit `$NVIM`-Check | `nvim datei` im `:terminal`-Buffer öffnet Datei im äußeren nvim via `nvr` — kein nested nvim |
| `nvim/init.lua` | `<Esc>` → `<C-\><C-n>` | Im `:terminal`-Buffer in Normal Mode wechseln |
