#!/usr/bin/env bash
# Cuando el agente cree que terminó: corre la suite del proyecto.
# Que "ya quedó" signifique que la suite pasa, no que el modelo se sienta satisfecho.
set -uo pipefail
source "$(dirname "$0")/_comun.sh"

INPUT=$(cat)
command -v jq >/dev/null 2>&1 || exit 0
desactivado && exit 0

DIR="$(proyecto_dir)"
cd "$DIR" 2>/dev/null || exit 0
[ -f package.json ] || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Sin cambios en el árbol de trabajo no hay nada que verificar.
git diff --quiet && git diff --cached --quiet && exit 0

# Guarda contra bucles: si ya bloqueamos con EXACTAMENTE este estado del código,
# el agente no avanzó. Lo dejamos parar en vez de repetir el ciclo para siempre.
SESSION=$(printf '%s' "$INPUT" | jq -r '.session_id // "sin-sesion"')
ESTADO=$( { git diff HEAD; git status --porcelain; } 2>/dev/null | shasum | cut -d' ' -f1 )
MARCA="${TMPDIR:-/tmp}/alquimia-preentrega-${SESSION}"
if [ -f "$MARCA" ] && [ "$(cat "$MARCA" 2>/dev/null)" = "$ESTADO" ]; then
  echo "alquimia: la suite sigue fallando y el código no cambió desde el último aviso." >&2
  exit 0
fi

LOGDIR=$(mktemp -d)
FALLOS=""
correr_si_existe lint      "$LOGDIR/lint.log"      || FALLOS="$FALLOS lint"
correr_si_existe typecheck "$LOGDIR/typecheck.log" || FALLOS="$FALLOS typecheck"
if tiene_script test:run; then
  correr_si_existe test:run "$LOGDIR/test.log"     || FALLOS="$FALLOS test"
else
  correr_si_existe test     "$LOGDIR/test.log"     || FALLOS="$FALLOS test"
fi

if [ -n "$FALLOS" ]; then
  printf '%s' "$ESTADO" > "$MARCA"
  {
    echo "alquimia: no has terminado. Falla:$FALLOS. Arréglalo antes de reportar el trabajo como listo."
    for paso in $FALLOS; do
      log="$LOGDIR/${paso}.log"
      [ -s "$log" ] && { echo "--- $paso ---"; tail -25 "$log"; }
    done
  } >&2
  rm -rf "$LOGDIR"
  exit 2
fi

rm -rf "$LOGDIR" "$MARCA"
exit 0
