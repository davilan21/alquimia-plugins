---
description: Verificación completa antes de mezclar a producción. Úsalo cuando creas que un cambio está listo.
---

# Preflight

No confíes en que "ya quedó". Verifícalo.

1. `git status` y `git diff <base>...HEAD` — muestra exactamente qué cambia.
2. Corre la suite que define el `CLAUDE.md` del proyecto: lint, tipos, build, tests.
3. Si el proyecto tiene tests end-to-end, córrelos o di explícitamente por qué no
   se corrieron. "El CI nocturno los corre" no es haberlos corrido.
4. Delega en `revisor-critico` sobre el diff completo.
5. Si el diff toca dinero, datos regulados, formatos hacia terceros o registros
   inmutables, delega en `guardian-dominio`.
6. Variables de entorno nuevas: ¿documentadas? ¿configuradas en el entorno de destino?
7. Migraciones de base de datos: ¿reversibles? ¿respetan la convención de numeración
   del proyecto?
8. ¿El cambio es reversible con un revert limpio? Si no, di qué haría falta para
   deshacerlo un domingo a las 3 a.m.

Termina con un veredicto de una línea: **LISTO PARA MEZCLAR** o **NO LISTO** (y por qué).
No suavices el veredicto.
