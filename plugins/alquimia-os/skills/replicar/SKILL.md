---
description: Audita si un repositorio cumple el estándar de Alquimia y reporta las brechas. Úsalo para revisar un proyecto existente o para comparar todos entre sí.
---

# Auditoría de estándar

Repositorio (si no se indica, el actual):

$ARGUMENTS

Revisa y reporta. **No arregles nada** sin que un humano lo apruebe.

## Qué verificar

**Contexto**
- ¿Existe `CLAUDE.md`? ¿Cuántas líneas? ¿Tiene una sección real de reglas de dominio,
  o solo describe el stack?
- ¿Existe `REVIEW.md`?
- Costo en tokens de la lectura obligatoria (ver la skill `memoria`).

**Verificación**
- ¿Hay tests? ¿Cuántos archivos? ¿De qué tipo (unitarios, integración, e2e)?
- ¿Hay CI? ¿Corre los tests en cada PR, o solo lint y build?
- ¿Los e2e protegen los PRs, o solo corren después de desplegar?
- ¿Hay hooks de git (`.githooks`, `core.hooksPath`)?

**Capa agéntica**
- ¿Qué hay en `.claude/`? ¿Hay `settings.json` versionado, o solo un
  `settings.local.json` committeado por error?
- ¿Los permisos incluyen algún `deny` de escritura o de comando destructivo, o solo
  denies de lectura?
- ¿Está el plugin `alquimia-os` habilitado en `.claude/settings.json` del proyecto?

**Operación**
- ¿Hay plantilla de issue para reportes de cliente?
- ¿Hay workflow de `claude-code-action`?
- ¿Cuántas ramas remotas hay sin limpiar?

**Infraestructura**

Esta parte se responde sin clonar nada. Ajusta el `owner`:

```bash
R=owner/repo
gh api "repos/$R/actions/workflows" -q '[.workflows[]?|select(.state=="active")|.name]'
gh secret list --repo "$R" --json name -q '[.[].name]'
gh api "repos/$R/environments" -q '[.environments[]?.name]'
for f in .env.example README.md vercel.json Dockerfile supabase; do
  gh api "repos/$R/contents/$f" >/dev/null 2>&1 && echo "si  $f" || echo "··  $f"
done
```

Con eso responde:

- **¿Corre algo cuando alguien sube código?** Cero workflows activos es el hallazgo
  más grave que puede tener un repositorio, y no se ve desde adentro del código.
- **¿Dónde viven las variables y los secretos?** ¿En GitHub, en el panel del
  proveedor, o repartidos? Repartidos es la respuesta más común y la peor: nadie sabe
  cuál manda.
- **¿Existe `.env.example`?** Es el contrato de qué hace falta para levantar el
  proyecto. Sin él, arrancar en una máquina nueva es adivinar.
- **¿Los entornos son una decisión o un efecto secundario?** Vercel crea
  `Preview`/`Production` solo al conectar el repo. Que existan no significa que
  alguien haya decidido qué va en cada uno.
- **¿Las migraciones a producción son reversibles, y hay a dónde volver?** Si hay
  migraciones, mira si el workflow que las corre es manual y si existe respaldo previo.
- **¿Hay README con cómo levantar el proyecto?** Un repo sin eso solo lo puede correr
  quien lo escribió.

**El orden importa: primero CI, después Claude.** Si el repositorio tiene revisión
automática de Claude pero no tiene tests corriendo en cada PR, el orden está invertido:
la opinión de un agente pasó a ser la única barrera. Repórtalo como brecha, no como
logro.

## Formato del reporte

Una tabla con: área · estado (✅ / ⚠️ / ❌) · hallazgo concreto con números.
Después, las tres brechas ordenadas por impacto, no por facilidad.
Y una línea final: cuál es el riesgo #1 de este repositorio hoy.

**Si auditas varios repositorios de una vez**, agrega antes que nada una tabla
comparativa de una fila por repo con: workflows activos · secretos · `.claude/` ·
README. Esa tabla sola suele responder dónde empezar, y las auditorías individuales
después sobran para la mitad de ellos.

**Ordena las brechas por lo que se rompe, no por lo que falta.** "No tiene
`REVIEW.md`" y "nada verifica el código antes de desplegarlo a producción" no son el
mismo tipo de hallazgo, aunque los dos sean una casilla vacía.

Sé específico y honesto en las dos direcciones. Si el repo está mejor de lo esperado,
dilo — un diagnóstico que solo encuentra problemas no es un diagnóstico, es un guion.
