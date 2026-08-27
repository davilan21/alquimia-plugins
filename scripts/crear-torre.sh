#!/usr/bin/env bash
# Crea (una sola vez) el issue "Torre de control" donde la ronda matutina publica.
#
#   ./scripts/crear-torre.sh davilan21/alquimia-plugins
set -euo pipefail
REPO="${1:?Uso: $0 <owner/repo-del-plugin>}"

if gh issue list --repo "$REPO" --search "Torre de control in:title" --json number -q '.[0].number' | grep -q .; then
  n=$(gh issue list --repo "$REPO" --search "Torre de control in:title" --json number -q '.[0].number')
  echo "Ya existe: https://github.com/$REPO/issues/$n"
  exit 0
fi

n=$(gh issue create --repo "$REPO" \
  --title "Torre de control" \
  --body $'La ronda matutina publica aquí un comentario consolidado cada día hábil.\n\nEsta es la única URL que hay que revisar en la mañana.\n\nNo cierres este issue.' \
  | grep -oE '[0-9]+$')

gh issue pin "$n" --repo "$REPO" 2>/dev/null || echo "(no se pudo fijar; fíjalo a mano)"
echo "Creado y fijado: https://github.com/$REPO/issues/$n"
echo "Pega esa URL en el prompt de la Rutina 1."
