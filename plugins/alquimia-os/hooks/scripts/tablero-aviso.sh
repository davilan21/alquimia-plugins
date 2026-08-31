#!/usr/bin/env bash
# Cuando el agente escribe una superficie de datos (tabla, bandeja, panel, ficha,
# formulario), le recuerda UNA VEZ por sesión que existe la skill `tablero`.
#
# Por qué existe: el problema no es que falte el conocimiento, es que no se dispara.
# Una skill que nadie abre es una skill que no existe.
#
# Por qué avisa y no bloquea: en PostToolUse la edición YA ocurrió; `exit 2` solo
# entrega el mensaje al agente. Y avisa una sola vez: un recordatorio en cada archivo
# de una pantalla de veinte componentes es ruido, y el ruido se desactiva.
set -uo pipefail
source "$(dirname "$0")/_comun.sh"

INPUT=$(cat)
command -v jq >/dev/null 2>&1 || exit 0
desactivado && exit 0

FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -n "$FILE" ] || exit 0
[ -f "$FILE" ] || exit 0

# Solo archivos de interfaz.
case "$FILE" in
  *.tsx|*.jsx|*.vue|*.svelte) ;;
  *) exit 0 ;;
esac

# Una vez por sesión. Sin id de sesión no se avisa: mejor callado que repetido.
SESION=$(printf '%s' "$INPUT" | jq -r '.session_id // empty')
[ -n "$SESION" ] || exit 0
MARCA="${TMPDIR:-/tmp}/alquimia-tablero-${SESION}"
[ -f "$MARCA" ] && exit 0

CUERPO=$(cat "$FILE" 2>/dev/null) || exit 0
RUTA=$(printf '%s' "$FILE" | tr '[:upper:]' '[:lower:]')

# Detección conservadora: ante la duda, no avisa. Un falso positivo enseña a ignorar
# el aviso; un falso negativo solo pierde una oportunidad.
SUP=""
if   printf '%s' "$CUERPO" | grep -qE '<t(able|body|head)|useReactTable|columnHelper|createColumnHelper|<DataTable|<TableHeader'; then
  SUP="tabla"
elif printf '%s' "$CUERPO" | grep -qE 'useForm\(|zodResolver|handleSubmit|<form[ >]|register\('; then
  SUP="formulario"
elif printf '%s' "$CUERPO" | grep -qE '<(Line|Bar|Area|Pie|Radar|Scatter)Chart|ResponsiveContainer|recharts'; then
  SUP="panel"
elif printf '%s' "$CUERPO" | grep -qiE 'unread|sin_leer|conversation|conversacion|thread_id|inbox'; then
  SUP="bandeja"
else
  case "$RUTA" in
    *dashboard*|*panel*)                    SUP="panel" ;;
    *bandeja*|*inbox*|*chat*|*conversaci*)  SUP="bandeja" ;;
    *formulario*|*form/*)                   SUP="formulario" ;;
    *)                                      exit 0 ;;
  esac
fi

touch "$MARCA" 2>/dev/null

{
  echo "alquimia: esto se ve como una superficie de datos ($SUP)."
  echo
  echo "Antes de seguir, abre la skill \`tablero\` y su archivo"
  echo "\`superficies/${SUP}.md\`. Trae dos cosas que no se improvisan bien:"
  echo "  · qué librería probada usar en vez de construir desde cero;"
  echo "  · el criterio que la librería no te da (estados vacíos, jerarquía,"
  echo "    alineación, umbrales)."
  echo
  echo "Esto es un recordatorio, no un error: el archivo se guardó bien. Si ya la"
  echo "consultaste, sigue. Este aviso no se repite en esta sesión."
} >&2
exit 2
