---
description: Revisa un PR sin leer código. Te lo explica en lenguaje de negocio, te dice cómo comprobarlo en 3 pasos, y convierte tu opinión en cambios concretos. Úsalo para aprobar o devolver el trabajo.
---

# Revisar sin leer código

PR a revisar (número, link, o nada para tomar el más reciente):

$ARGUMENTS

Revisar código no es tu trabajo. Para eso están los tests, el CI y `revisor-critico`.
**Tu trabajo es decidir si esto es lo correcto**, y eso ninguna máquina lo sabe mejor
que tú.

## 1. Verifica que lo mecánico ya pasó

Antes de gastarle un minuto de atención al humano:

```bash
gh pr checks <numero> --repo <owner/repo>
```

Si el CI está en rojo, **no lo traigas a revisión**. Dilo en una línea y para ahí:
revisar algo que ni siquiera compila es desperdiciar la atención más cara que hay.

## 2. Traduce

Delega en el subagente `interprete`, dirección A. Presenta su informe tal cual.
No lo resumas ni le agregues jerga de vuelta.

## 3. Ofrece la prueba real

Si el proyecto tiene entorno de vista previa —Vercel, Netlify y similares comentan el
link en el PR— **dalo primero y destacado**. Ver la cosa funcionando vale más que
cualquier explicación, y es la única forma en que alguien que no lee código puede
verificar de verdad.

Si no hay vista previa, dá los pasos exactos para probarlo en local, o una captura.
Y anotá que montar vistas previas es la mejora número uno para este flujo.

## 4. Escucha y traduce de vuelta

La persona responde en lenguaje corriente. Cosas como:

> "no es lo que pide" · "el recepcionista no debería ver eso" · "se ve raro sin datos"
> "el cliente va a odiar dos clics" · "¿y si son 500 registros?"

Delega en `interprete`, dirección B. **Confirma la traducción antes de tocar nada.**

Después, según lo que resultó:

| Resultó ser | Qué haces |
|---|---|
| Defecto | Lo arreglas en el mismo PR |
| Malentendido del encargo | Volvés al plan, no al código. Puede que el PR entero sobre |
| Regla de negocio nueva | **La subes al `CLAUDE.md` en una línea**, y después arreglas |
| Preferencia | Nuevo issue. No lo metas de contrabando en este PR |

## 5. Cierra

Si aprueba: mezclá o dale el botón. Si devuelve: dejá el comentario en el PR con la
traducción, para que quede el registro de por qué se devolvió.

---

## La regla que hace esto funcionar

**Nunca le pidas que juzgue lo que no puede juzgar.** Si le preguntas si el manejo de
errores está bien, va a decir que sí porque no tiene cómo saberlo, y esa aprobación no
vale nada — peor, te da una falsa sensación de control.

Preguntale lo que sí sabe: si es lo que se pidió, si el usuario lo va a entender, si
algo se puede volver un problema con un cliente. En eso te gana a tú y le gana al CI.
