#!/usr/bin/env bash
# Tras cada edición: formatea y verifica tipos. Si algo falla, exit 2 devuelve el
# error al agente en el acto en vez de dejarlo acumularse durante media hora.
set -uo pipefail
source "$(dirname "$0")/_comun.sh"

INPUT=$(cat)
command -v jq >/dev/null 2>&1 || exit 0
desactivado && exit 0

DIR="$(proyecto_dir)"
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -n "$FILE" ] || exit 0

case "$FILE" in
  *.ts|*.tsx|*.mts|*.cts) ;;
  *.js|*.jsx|*.mjs|*.cjs) ;;
  *) exit 0 ;;
esac

cd "$DIR" 2>/dev/null || exit 0

# Formato: silencioso, nunca bloquea.
[ -x node_modules/.bin/prettier ] && node_modules/.bin/prettier --write "$FILE" >/dev/null 2>&1

# Tipos: solo si el proyecto realmente es TypeScript con tsc instalado.
[ -f tsconfig.json ] || exit 0
[ -x node_modules/.bin/tsc ] || exit 0

# `tsc -b` respeta project references; `--noEmit` no chequea nada si el tsconfig
# raíz es solo `references`. Se prefiere el script del proyecto si lo define.
if tiene_script typecheck; then
  OUT=$(npm run --silent typecheck 2>&1); RC=$?
else
  OUT=$(node_modules/.bin/tsc -b 2>&1); RC=$?
fi

if [ $RC -ne 0 ]; then
  {
    echo "alquimia: errores de tipos tras editar $FILE. Corrígelos antes de seguir."
    printf '%s\n' "$OUT" | head -30
  } >&2
  exit 2
fi
exit 0
