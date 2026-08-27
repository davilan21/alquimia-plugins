# CLAUDE.md — <NOMBRE DEL PROYECTO>

> Se carga en cada sesión, cada PR y cada rutina. Tope duro: 150 líneas.
> Lo que no esté aquí, Claude lo adivina — y adivinar es de donde salen los bugs.

## Qué es esto
Una o dos frases. Quién lo usa y para qué.

## Stack y comandos
<!-- Léelos de package.json. No los inventes. -->
```bash
npm run dev
npm run lint
npm run typecheck
npm run test
npm run build
```

## Cómo se trabaja aquí
1. Nunca sobre la rama de producción. Rama por tarea: `claude/<tipo>-<descripcion>`.
2. Antes de escribir código: di en tres líneas qué vas a cambiar y por qué.
3. Un cambio, un PR. Si toca más de 5 archivos, para y propón un plan.
4. Todo bugfix trae un test que falla antes del arreglo y pasa después.
5. **Haz commit de local, empuja una sola vez.** Cada push a una rama con PR abierto dispara
   todos los workflows de CI. Ocho pushes cuestan ocho corridas para verificar lo mismo.
   Corre la suite local hasta que esté verde, y recién ahí `git push`.
6. El PR explica: qué se rompía, causa raíz con `archivo:línea`, qué cambió,
   cómo se verificó, qué riesgo tiene.

## Reglas de dominio que NO se negocian
<!-- ESTA ES LA SECCIÓN QUE IMPORTA. Sale de la entrevista, no del código.
     Es lo único que un competidor no puede copiar. Sé concreto y absoluto. -->
- <Qué es irreversible una vez en producción>
- <Qué datos no pueden salir en logs, errores ni URLs>
- <Qué contratos con terceros se rompen si cambia X>
- <Qué operación, si falla, hace que el cliente llame furioso>

## Errores que ya cometimos
<!-- Una línea por incidente. Un hecho, no un consejo.
     Mal: "cuidado con las migraciones".
     Bien: "toda columna nueva no-nullable necesita default o backfill en la misma migración". -->

## Lo que NO debes hacer
- No instales dependencias nuevas sin justificarlo en el PR.
- No toques configuración de deploy ni variables de entorno.
- No refactorices de paso. Anótalo en el PR y sigue.
- No borres tests. Si un test estorba, el cambio está mal.

## Memoria del proyecto
<!-- Si el proyecto lleva archivos de estado, decláralos aquí para que el hook
     memoria-guard vigile su tamaño. Tope: ~8.000 tokens de lectura obligatoria. -->
- `docs/ESTADO.md` — en qué se está trabajando ahora. Máx. 300 líneas.
- `docs/DECISIONES.md` — decisiones arquitectónicas. No se lee al arrancar.
