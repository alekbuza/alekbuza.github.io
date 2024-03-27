#!/bin/bash
# shellcheck disable=SC1090

set -euxo pipefail

SHELL_NAME=$(basename "$SHELL")

export PATH="$HOME/.local/share/mise/shims:$PATH"
export MISE_VERBOSE=1
export MISE_COLOR=false

echo "[ * ] running mise installer..."
curl -fsSL https://mise.run | sh

case "$SHELL_NAME" in
  bash)
    export SHELL_RC="$HOME/.bashrc"
    echo "eval \"\$($(realpath ~)/.local/bin/mise activate bash)\"" >> "$(realpath ~)/.bashrc"
    echo "eval \"\$($(realpath ~)/.local/bin/mise activate --shims)\"" >> "$(realpath ~)/.bash_profile"
    ;;
  zsh)
    export SHELL_RC="$HOME/.zshrc"
    echo "eval \"\$($(realpath ~)/.local/bin/mise activate zsh)\"" >> "$(realpath ~)/.zshrc"
    echo "eval \"\$($(realpath ~)/.local/bin/mise activate --shims)\"" >> "$(realpath ~)/.zprofile"
    ;;
  *)
    echo "[ - ] Unsupported shell: $SHELL_NAME. Supported shells are bash and zsh"
    exit 1
    ;;
esac

. "$SHELL_RC"

mise trust
mise -E mise install --quiet
mise -E dev install --quiet
mise doctor
mise run install
mise run hygiene
