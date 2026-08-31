# Formulario

Captura y edición de datos. En un CRM manda la tabla; **en un ERP manda esto**.

Antes de leer esto ya decidiste **operativa u ojeada** y **qué librería**.

Default: **react-hook-form + zod**. El esquema de zod se escribe una vez y sirve para
tres cosas: el tipo en TypeScript, la validación en el navegador y la validación en el
servidor. Escribir esas tres por separado es como se llega a formularios que aceptan en
el frente lo que el servidor rechaza.

## Antes de nada: ¿esto es reversible?

Esta pregunta manda sobre todas las demás.

| | **Reversible** | **Irreversible** |
|---|---|---|
| Ejemplo | Editar el teléfono de un cliente | Emitir una factura a la DIAN, radicar ante una aseguradora |
| Guardado | Automático, sin preguntar | Explícito, con revisión antes |
| Errores | Se corrigen después | **Se previenen antes** |
| Confirmar | No hace falta, hay deshacer | Sí, y mostrando **qué** se va a enviar |

**Si el formulario dispara algo que no se puede deshacer** —un documento con
consecuencia legal o fiscal, un envío a un tercero, un registro inmutable— antes de
construirlo delega en el agente `guardian-dominio`. Él valida qué se rompe si el dato
sale mal, y esa respuesta cambia el diseño del formulario, no solo su validación.

Y en ese caso: **una pantalla de revisión antes de enviar**, que muestre exactamente lo
que se va a mandar. No un "¿está seguro?" — eso la gente lo acepta sin leer.

## La forma

- **Una sola columna.** Dos columnas hacen que la mirada zigzaguee y se salten campos.
  La excepción son campos que de verdad van juntos: ciudad y código postal, día y mes.
- **La etiqueta va arriba del campo**, no al lado. Se lee más rápido y no se rompe en
  pantallas angostas.
- **Marca la minoría.** Si casi todo es obligatorio, marca lo opcional. Si casi todo es
  opcional, marca lo obligatorio. Poner un asterisco en veinte campos de veintidós no
  informa nada.
- **Agrupa en secciones con título.** Un formulario de treinta campos corridos se
  abandona; el mismo en cuatro bloques con nombre, no.
- **El ancho del campo insinúa el largo del dato.** Un campo de código postal tan ancho
  como el de dirección hace dudar de si va completo.

## Pasos, solo si de verdad son pasos

Partir en pasos ayuda cuando el orden importa de verdad o cuando lo que se pregunta
después depende de lo de antes.

**No partas en pasos solo porque es largo.** Un formulario largo en secciones dentro de
una sola pantalla es mejor que cinco pasos: se ve cuánto falta, se puede volver sin
perder nada, y se revisa entero antes de enviar.

Si hay pasos: se ve en cuál va y cuántos son, se puede volver, y lo escrito no se
pierde al retroceder.

## Validar: cuándo y cómo

**El cuándo importa más que el qué:**

- **No valides mientras escribe.** Marcar en rojo un correo a medio escribir es
  regañar a alguien por no haber terminado.
- **Valida al salir del campo.** Ahí ya terminó de escribir.
- **Una vez que un campo dio error, sí valida mientras corrige** — así ve cuándo lo
  arregló, sin tener que salir otra vez.
- Lo que solo sabe el servidor —que la cédula ya existe— se valida al enviar, y el
  error aterriza en el campo que lo causó.

**El mensaje dice cómo arreglarlo, no qué está mal:**

- Mal: "Formato inválido"
- Bien: "El NIT va sin puntos ni guion, con el dígito de verificación al final"

Y va **debajo del campo**, no en una alerta arriba que se pierde de vista al bajar.

**Si falla el envío**, dos cosas a la vez: un resumen arriba que diga cuántos errores
hay y lleve al primero, y el detalle en cada campo. Con solo el resumen hay que
buscarlos; con solo el detalle no se sabe cuántos faltan.

## No perder el trabajo

Es la falla que más rabia da y la más fácil de prevenir.

- **Formulario largo**: guarda borrador solo, y dilo. "Guardado hace un momento".
- **Cerrar con cambios sin guardar**: avisa antes de salir.
- **Si el envío falla**, los datos siguen ahí. Un formulario que se limpia solo tras un
  error de red hace que la persona no vuelva a intentar.
- **Volver atrás en un paso** no borra lo escrito.

## Campos que dependen de otros

- Los que no aplican **se ocultan, no se deshabilitan**. Un campo gris que no se puede
  llenar solo genera la pregunta de por qué.
- Al cambiar el campo del que dependen, **limpia los de abajo**. Dejar la ciudad de un
  departamento que ya cambió es como se guardan datos imposibles.
- Si cargar las opciones toma tiempo, dilo en el campo. Un desplegable vacío parece
  roto.

## Los estados

- **Cargando los datos a editar**: esqueleto con la forma del formulario, no un
  spinner que después salta.
- **Enviando**: el botón se bloquea y dice que va en camino. Sin eso la gente hace
  doble clic, y ahí es donde salen las facturas duplicadas.
- **Enviado**: di qué pasó y qué sigue. "Guardado" a secas no dice si ya se radicó.
- **Error del servidor**: qué pasó, si puede reintentar, y los datos intactos.
- **Sin permiso para editar**: muestra los datos en modo lectura, no un formulario que
  falla al guardar.

## El piso de accesibilidad

- Cada campo con su etiqueta asociada de verdad. Un texto encima que solo *se ve* como
  etiqueta no lo es para un lector de pantalla.
- El error se anuncia y se asocia al campo, no solo se pinta de rojo.
- Se recorre entero con teclado, en el orden visual, con foco visible.
- Al fallar el envío, el foco va al primer campo con error.

## Lo que NO haces

- No construyes un formulario irreversible sin pasar por `guardian-dominio`.
- No validas mientras la persona escribe por primera vez.
- No dices "formato inválido" sin decir cuál es el formato.
- No pierdes lo escrito. Por ninguna razón.
- No partes en pasos solo porque es largo.
- No deshabilitas campos que no aplican: ocúltalos.
