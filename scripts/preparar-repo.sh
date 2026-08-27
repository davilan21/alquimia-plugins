#!/usr/bin/env bash
# Prepara un repositorio para operar con alquimia-os:
# crea las etiquetas que usan las rutinas y las skills.
#
#   ./scripts/preparar-repo.sh davilan21/unidiagnostico-demo
#
# Requiere: gh instalado y autenticado (gh auth login).
set -euo pipefail

REPO="${1:?Uso: $0 <owner/repo>}"

crear() {
  local nombre="$1" color="$2" desc="$3"
  if gh label list --repo "$REPO" --json name -q '.[].name' | grep -qx "$nombre"; then
    echo "  = $nombre (ya existe)"
  else
    gh label create "$nombre" --repo "$REPO" --color "$color" --description "$desc" >/dev/null
    echo "  + $nombre"
  fi
}

echo "Etiquetas en $REPO:"
crear soporte          D93F0B "Reporte de un cliente"
crear triage           FBCA04 "Ya fue diagnosticado por una rutina"
crear needs-decision   F03F7F "Detenido: espera una decisión humana"
crear incidente        B60205 "Incidente de producción"
crear no-reproducible  BFD4F2 "Falta información para diagnosticar"

echo
echo "Listo. Ahora publica a tu cliente:"
echo "  https://github.com/$REPO/issues/new?template=soporte.yml"
