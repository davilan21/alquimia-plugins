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

## Formato del reporte

Una tabla con: área · estado (✅ / ⚠️ / ❌) · hallazgo concreto con números.
Después, las tres brechas ordenadas por impacto, no por facilidad.
Y una línea final: cuál es el riesgo #1 de este repositorio hoy.

Sé específico y honesto en las dos direcciones. Si el repo está mejor de lo esperado,
dilo — un diagnóstico que solo encuentra problemas no es un diagnóstico, es un guion.
