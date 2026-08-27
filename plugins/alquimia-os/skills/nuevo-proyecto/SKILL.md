---
description: Prepara un repositorio nuevo (o uno existente sin instrumentar) con el estándar de Alquimia. Úsalo al arrancar con un cliente nuevo.
---

# Arranque de proyecto

Proyecto / cliente:

$ARGUMENTS

El objetivo es que en una hora este repositorio tenga el mismo estándar que los demás.
La plantilla vive en `${CLAUDE_PLUGIN_ROOT}/plantilla/`.

## 1. Entiende antes de escribir

No generes un `CLAUDE.md` a partir del código. El código dice lo que **hay**;
`CLAUDE.md` debe decir lo que **no se puede romper**, y eso no está en el código.

Recorre el repositorio y determina:
- Stack, gestor de paquetes y comandos reales (léelos de `package.json`, no los inventes).
- Si hay tests y de qué tipo. Si no hay, es el hallazgo principal.
- Si hay CI y qué verifica de verdad.
- Dónde vive el estado (base de datos, storage, colas) y quién más lo consume.

## 2. Entrevista al humano

Estas respuestas no se deducen. Pregúntalas, una por una, y espera respuesta:

1. ¿Qué operación de este sistema, si se rompe, hace que el cliente llame furioso?
2. ¿Qué datos hay aquí que no pueden salir en un log, un error o una URL?
3. ¿Qué es irreversible una vez en producción? (dinero movido, documentos emitidos,
   registros cerrados, correos enviados)
4. ¿Qué contratos hay con terceros? (formatos, APIs, integraciones que rompen si cambian)
5. ¿Qué se rompió en los últimos tres meses y por qué?

Las respuestas a 1–4 son las reglas de dominio. La 5 arranca la sección de errores pasados.

## 3. Escribe los archivos

Copia y adapta desde `${CLAUDE_PLUGIN_ROOT}/plantilla/`:

- `CLAUDE.md` — con los comandos REALES y las respuestas de la entrevista.
  Tope duro: 150 líneas. Si no cabe, es que sobra.
- `REVIEW.md` — qué es bloqueante en este repo.
- `.claude/settings.json` — permisos del proyecto. **Versionado**, no `settings.local.json`
  (ese es el personal y va en `.gitignore`).
- `.github/ISSUE_TEMPLATE/soporte.yml` — el formato de reporte del cliente.
- `.github/workflows/claude.yml` — responde a `@claude` en issues y PRs.

## 4. Conecta el plugin al repo

En `.claude/settings.json` del proyecto, para que cualquiera que clone lo herede:

```json
{
  "extraKnownMarketplaces": {
    "alquimia": { "source": { "source": "github", "repo": "davilan21/alquimia-plugins" } }
  },
  "enabledPlugins": { "alquimia-os@alquimia": true }
}
```

## 5. Si no hay tests, esa es la primera tarea

No cinco tests unitarios bonitos: los cinco flujos que el cliente no puede perder ni
un día, cubiertos de punta a punta. El objetivo no es cobertura, es que un agente
pueda comprobar solo que no rompió lo que da de comer.

## 6. Registra el proyecto

Añádelo a la lista de repositorios de las rutinas de Alquimia en
claude.ai/code/routines, para que entre en la ronda diaria junto a los demás.

## 7. Reporta
Qué quedó instalado, qué falta, y cuál es el riesgo #1 de este repositorio hoy.
