#!/usr/bin/env bash
# Utilidades compartidas por los hooks del plugin.
#
# PRINCIPIO DE DISEÑO: estos hooks corren en TODOS los proyectos donde el plugin
# esté habilitado. Un hook que asume un stack concreto rompe los repos que no lo
# usan. Por eso todo aquí detecta antes de actuar y, ante la duda, SALE EN SILENCIO
# con exit 0. Un hook molesto se desactiva; un hook silencioso sobrevive.

proyecto_dir() { echo "${CLAUDE_PROJECT_DIR:-$PWD}"; }

# ¿Existe este script de npm en el proyecto?
tiene_script() {
  local nombre="$1" pkg="$(proyecto_dir)/package.json"
  [ -f "$pkg" ] || return 1
  node -e "process.exit(require('$pkg').scripts?.['$nombre'] ? 0 : 1)" 2>/dev/null
}

# Corre un script de npm solo si existe. Devuelve 0 si no existe (no es un fallo).
correr_si_existe() {
  local nombre="$1" log="$2"
  tiene_script "$nombre" || return 0
  npm run --silent "$nombre" >"$log" 2>&1
}

# ¿El plugin está desactivado para este repositorio?
# Escape: crear un archivo .alquimia-off en la raíz del proyecto.
desactivado() { [ -f "$(proyecto_dir)/.alquimia-off" ]; }
