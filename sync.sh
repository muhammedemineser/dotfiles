#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"
NVIM_REPO="$DOTFILES/nvim/nvim"

# ── nvim (separate git repo) ─────────────────────────────────
rsync -a --exclude='.git' --delete ~/.config/nvim/ "$NVIM_REPO/"

if git -C "$NVIM_REPO" status --porcelain | grep -q .; then
    git -C "$NVIM_REPO" add -A
    git -C "$NVIM_REPO" commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
    git -C "$NVIM_REPO" push --force origin master
    echo "nvim: pushed"
else
    echo "nvim: no changes"
fi

# ── dotfiles repo ────────────────────────────────────────────
if git -C "$DOTFILES" status --porcelain | grep -q .; then
    git -C "$DOTFILES" add -A
    git -C "$DOTFILES" commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
    git -C "$DOTFILES" push --force origin master
    echo "dotfiles: pushed"
else
    echo "dotfiles: no changes"
fi
