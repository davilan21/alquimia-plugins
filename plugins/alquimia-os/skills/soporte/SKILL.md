---
description: Procesa un reporte de soporte de punta a punta hasta dejar un PR listo para revisión humana. Úsalo cuando llegue un bug reportado por un cliente o un incidente de producción.
---

# Soporte

Reporte:

$ARGUMENTS

Ejecuta el procedimiento completo. No preguntes entre pasos salvo que encuentres una
decisión de negocio que el `CLAUDE.md` del proyecto no resuelva.

## 1. Contexto
Lee el `CLAUDE.md` del proyecto. Las reglas de este cliente mandan sobre cualquier
criterio general.

## 2. Diagnóstico
Delega en el subagente `diagnosticador`. Espera su informe completo antes de decidir nada.

## 3. Semáforo
Según su veredicto:

- **BUG ACOTADO** → sigue al paso 4.
- **REQUIERE DECISIÓN HUMANA** → PARA. No escribas código. Entrega una página con el
  diagnóstico, las opciones y el costo de cada una. Terminar aquí es un resultado
  correcto, no un fracaso.
- **NO REPRODUCIBLE** → PARA. Entrega las preguntas exactas que faltan por responder.

## 4. Rama
`git checkout -b claude/fix-<descripcion-corta>`

## 5. Test primero
Escribe el test que reproduce el fallo. Córrelo y confirma que **falla**.
Si pasa a la primera, el diagnóstico está mal: vuelve al paso 2.

Si el proyecto no tiene infraestructura de tests, dilo explícitamente y sigue —
pero anótalo como deuda en el PR.

## 6. Arreglo mínimo
El cambio más pequeño que hace pasar el test. Nada de refactors de paso.

**Quién escribe el código: tú, la sesión principal.** Los subagentes de este plugin son
de solo lectura a propósito — diagnostican, revisan y validan, pero ninguno puede editar.
El que implementa es el hilo principal, que tiene el contexto de la conversación y a un
humano que puede interrumpirlo.

La excepción: si hay **varias tareas que deben avanzar en paralelo** sobre el mismo
repositorio, delega en el subagente `implementador`, que corre en un worktree aislado.
Para un solo ticket no lo uses: agrega una frontera de contexto donde se pierde
información, a cambio de nada.

## 7. Verificación
Corre lo que el `CLAUDE.md` del proyecto defina como suite (típicamente
`lint`, `typecheck`/`build` y `test`). Todo en verde.

## 8. Autocrítica
Delega en `revisor-critico`. Si encuentra algo BLOQUEANTE, arréglalo y vuelve al paso 7.

## 9. Guardián
Si el cambio toca dinero, datos regulados, formatos hacia terceros o registros
inmutables, delega también en `guardian-dominio`. Si su veredicto no es
SEGURO MEZCLAR, para y reporta.

## 10. PR

```
## Qué reportó el cliente
(cita textual)

## Qué estaba pasando en realidad
(causa raíz, con archivo:línea)

## Qué cambié
(lista corta)

## Cómo se verificó
(el test nuevo + qué se corrió)

## Cómo lo compruebas tú — 3 pasos
1. Entrá a <pantalla exacta>  (link de vista previa si existe)
2. Haz <acción exacta>
3. Deberías ver <resultado exacto>

## Riesgo y qué más toca esto
(radio de impacto del diagnóstico)

## Qué necesito que revises tú
(lo que un humano debe confirmar antes de mezclar)
```

## 11. Cierre
Devuelve el link del PR y una línea: qué era, qué hiciste, qué riesgo tiene.
Si el `CLAUDE.md` del proyecto define un ritual de cierre de sesión, cúmplelo.
