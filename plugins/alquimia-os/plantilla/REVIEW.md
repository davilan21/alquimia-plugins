# Instrucciones de revisión

`CLAUDE.md` dice cómo se construye. Este archivo dice qué se bloquea.

## Qué es 🔴 Importante en este repo
Reserva Importante para lo que rompe comportamiento, filtra datos o impide un rollback:
- <consulta a datos sin filtro de tenant / sede / rol>
- <datos sensibles en logs, errores o analytics>
- <migración no reversible o sin backfill>
- <cambio en un formato o contrato hacia un tercero>
- <dinero manejado en punto flotante>

Estilo, nombres y refactors son 🟡 Nit como máximo.

## Límite de nits
Máximo 5 por revisión. Si hay más, dilo como conteo en el resumen.
Si todo lo encontrado son nits, empieza con "Sin problemas bloqueantes".

## No reportes
- Lo que el CI ya valida: lint, formato, tipos.
- Archivos generados y lockfiles.
- Código de tests que rompe reglas de producción a propósito.

## Siempre verifica
- Todo bugfix trae un test del caso que falló.
- Ninguna ruta nueva queda sin autenticación ni control de tenant.
- El PR describe cómo se verificó, no solo qué se cambió.

## Barra de evidencia
Una afirmación sobre comportamiento necesita una cita `archivo:línea`.
No reportes hallazgos inferidos del nombre de una función.

## En re-revisiones
Después de la primera revisión, suprime nits nuevos y reporta solo lo Importante.
