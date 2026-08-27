#!/usr/bin/env bash
# Al arrancar la sesión: avisa si los archivos de lectura obligatoria se inflaron.
#
# POR QUÉ EXISTE. Un sistema de memoria de proyecto crece sin que nadie lo note,
# hasta que el archivo que existía para AHORRAR contexto se come media ventana en
# cada sesión. Nadie lo mide porque no duele de golpe: duele un poco cada vez.
# Este hook lo mide solo. Nunca bloquea.
set -uo pipefail
source "$(dirname "$0")/_comun.sh"

cat >/dev/null   # drena el stdin del hook
desactivado && exit 0

DIR="$(proyecto_dir)"
cd "$DIR" 2>/dev/null || exit 0

TOPE_TOKENS=${ALQUIMIA_TOPE_TOKENS:-8000}

# Candidatos: CLAUDE.md siempre, más cualquier .md que CLAUDE.md mande a leer.
ARCHIVOS="CLAUDE.md"
if [ -f CLAUDE.md ]; then
  REFS=$(grep -oE '`?(docs|\.claude)/[A-Za-z0-9_./-]+\.md`?' CLAUDE.md 2>/dev/null \
          | tr -d '`' | sort -u | head -8)
  ARCHIVOS="$ARCHIVOS $REFS"
fi

TOTAL=0; DETALLE=""
for f in $ARCHIVOS; do
  [ -f "$f" ] || continue
  B=$(wc -c < "$f" | tr -d ' '); T=$((B / 4)); TOTAL=$((TOTAL + T))
  [ "$T" -gt 1500 ] && DETALLE="$DETALLE
  $f — ~${T} tokens"
done

if [ "$TOTAL" -gt "$TOPE_TOKENS" ]; then
  cat <<MSG
alquimia · higiene de memoria

La lectura obligatoria de este proyecto cuesta ~${TOTAL} tokens por sesión
(tope recomendado: ${TOPE_TOKENS}). Los archivos más pesados:${DETALLE}

Corre /alquimia-os:memoria para repartir lo permanente, lo histórico y lo vivo.
MSG
fi
exit 0
