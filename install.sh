#!/bin/sh
# Install vcode - the Vanta terminal coding agent.
set -e
DEST="$HOME/.vcode"
mkdir -p "$DEST/bin"
URL="https://raw.githubusercontent.com/Juanshep1/vcode/main/vcode.py"
echo "==> downloading vcode..."
curl -fsSL "$URL" -o "$DEST/vcode.py"
cat > "$DEST/bin/vcode" <<SH
#!/bin/sh
exec python3 "$DEST/vcode.py" "\$@"
SH
chmod +x "$DEST/bin/vcode"
# add ~/.vcode/bin to PATH in the shell profile
for RC in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile"; do
  if [ -f "$RC" ] && ! grep -q "/.vcode/bin" "$RC" 2>/dev/null; then
    printf '\n# >>> vcode >>>\nexport PATH="%s/.vcode/bin:$PATH"\n# <<< vcode <<<\n' "$HOME" >> "$RC"
  fi
done
echo "==> installed. Restart your terminal (or: export PATH=\"$DEST/bin:\$PATH\")"
echo "    then set a key:  export ANTHROPIC_API_KEY=...   (or OPENROUTER_API_KEY / OLLAMA_API_KEY)"
echo "    and run:         vcode"
