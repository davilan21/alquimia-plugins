#!/usr/bin/env bash
# Instalador de alquimia-os. Correr desde la carpeta que salió del zip:
#
#     bash instalar.sh
#
# No hace nada destructivo. Si algo falta, te dice qué y para.
set -uo pipefail

rojo()  { printf '\033[31m%s\033[0m\n' "$*"; }
verde() { printf '\033[32m%s\033[0m\n' "$*"; }
gris()  { printf '\033[90m%s\033[0m\n' "$*"; }

echo
echo "════════════════════════════════════════════"
echo "  Instalador de alquimia-os"
echo "════════════════════════════════════════════"
echo

# ── 1. ¿Estamos en la carpeta correcta?
if [ ! -f ".claude-plugin/marketplace.json" ]; then
  rojo "✗ No estás en la carpeta correcta."
  echo "  Tienes que estar parado en la carpeta que salió del zip"
  echo "  (la que tiene adentro una carpeta llamada .claude-plugin)."
  echo
  echo "  Estás en: $(pwd)"
  exit 1
fi
verde "✓ Carpeta correcta"

# ── 2. ¿Están las herramientas?
falta=0
for cmd in git claude gh; do
  if command -v "$cmd" >/dev/null 2>&1; then
    verde "✓ $cmd instalado"
  else
    rojo "✗ falta $cmd"
    falta=1
  fi
done

if [ "$falta" = "1" ]; then
  echo
  echo "Instala lo que falte y vuelve a correr esto:"
  echo "  claude → https://claude.com/product/claude-code"
  echo "  gh     → brew install gh     (macOS)"
  echo "  git    → xcode-select --install  (macOS)"
  exit 1
fi

# ── 3. ¿gh está autenticado?
if ! gh auth status >/dev/null 2>&1; then
  rojo "✗ gh no está conectado a tu cuenta de GitHub."
  echo "  Corre:  gh auth login"
  echo "  Elige: GitHub.com → HTTPS → sí, autenticar con navegador."
  echo "  Después vuelve a correr este script."
  exit 1
fi
USUARIO=$(gh api user -q .login 2>/dev/null)
verde "✓ gh conectado como: $USUARIO"

# ── 4. Poner el usuario real en los archivos que dicen TU_USUARIO
echo
gris "Reemplazando TU_USUARIO por $USUARIO en los archivos de plantilla…"
CAMBIADOS=0
while IFS= read -r f; do
  if grep -q 'TU_USUARIO' "$f" 2>/dev/null; then
    if [ "$(uname)" = "Darwin" ]; then sed -i '' "s|TU_USUARIO|$USUARIO|g" "$f"
    else sed -i "s|TU_USUARIO|$USUARIO|g" "$f"; fi
    echo "  · $f"
    CAMBIADOS=$((CAMBIADOS+1))
  fi
done < <(grep -rl 'TU_USUARIO' . --include='*.md' --include='*.json' --include='*.sh' 2>/dev/null)
verde "✓ $CAMBIADOS archivos actualizados"

# ── 5. Validar el plugin antes de subir nada
echo
if claude plugin validate ./plugins/alquimia-os >/dev/null 2>&1; then
  verde "✓ El plugin es válido"
else
  rojo "✗ El plugin no valida. Para acá y avisa."
  claude plugin validate ./plugins/alquimia-os
  exit 1
fi

# ── 6. Crear el repo en GitHub
echo
if [ -d .git ]; then
  gris "Ya hay un repositorio git en esta carpeta; no lo toco."
else
  git init -q .
  git add -A
  git -c user.email="${USUARIO}@users.noreply.github.com" \
      -c user.name="$USUARIO" commit -qm "alquimia-os: primera versión"
  verde "✓ Repositorio local creado"
fi

if gh repo view "$USUARIO/alquimia-plugins" >/dev/null 2>&1; then
  gris "El repo $USUARIO/alquimia-plugins ya existe en GitHub."
else
  echo
  echo "Voy a crear el repo PÚBLICO $USUARIO/alquimia-plugins."
  echo "Público es a propósito: no tiene datos de clientes ni contraseñas,"
  echo "y así funciona sin credenciales en la nube y en GitHub Actions."
  read -r -p "¿Lo creo? [s/N] " r
  case "$r" in
    s|S|si|SI|Si)
      gh repo create "$USUARIO/alquimia-plugins" --public --source=. --push \
        && verde "✓ Subido a github.com/$USUARIO/alquimia-plugins" ;;
    *) gris "No se creó. Puedes hacerlo después con:"
       echo "  gh repo create $USUARIO/alquimia-plugins --public --source=. --push"
       exit 0 ;;
  esac
fi

# ── 7. Instalar el plugin
echo
gris "Registrando el marketplace e instalando el plugin…"
claude plugin marketplace add "$USUARIO/alquimia-plugins" 2>&1 | tail -2
claude plugin install alquimia-os@alquimia 2>&1 | tail -3

echo
echo "════════════════════════════════════════════"
verde "  Listo."
echo "════════════════════════════════════════════"
echo
echo "Comprobalo así:"
echo
echo "  1. Ve a la carpeta de CUALQUIER proyecto tuyo"
echo "  2. Escribe:  claude"
echo "  3. Adentro, escribe una barra:  /"
echo "  4. Deberías ver comandos que empiezan con  alquimia-os:"
echo
echo "Si los ves, quedó instalado."
echo
