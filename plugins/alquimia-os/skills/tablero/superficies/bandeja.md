# Bandeja de conversaciones

Para chats, tickets, casos de soporte, mensajes de WhatsApp. Lista a un lado, hilo al
otro.

Antes de leer esto ya decidiste **operativa u ojeada** y **qué librería**. Una bandeja
es casi siempre operativa: quien la usa vive ahí.

## Esto no es una tabla con mensajes

Una tabla muestra datos quietos. Una bandeja muestra datos que **cambian mientras la
miras**, y eso trae problemas que una tabla no tiene: llega un mensaje nuevo, alguien
más contesta primero, la conversación que ibas a abrir se movió de lugar.

Aquí no hay una librería que resuelva todo como TanStack Table resuelve la tabla. Se
arma con piezas: lista virtualizada, cliente de tiempo real, y criterio. **La mayor
parte del criterio es esto.**

## Lo que ordena la lista

**Actividad reciente, no fecha de creación.** Un caso abierto hace un mes con un
mensaje de hace diez minutos va arriba. Si ordenas por creación, lo urgente se hunde.

Excepción: si la bandeja es una cola con compromiso de respuesta, manda **lo que está
por vencerse**, y se ve cuánto falta.

## Sin leer, asignado y estado son tres cosas distintas

Es el error de modelado más común de esta superficie. Confundirlas produce bandejas
donde nadie sabe qué le toca:

| Eje | Qué responde | Cambia por |
|---|---|---|
| **Sin leer** | ¿Yo ya vi esto? | Tú, al abrirlo |
| **Asignado** | ¿A quién le toca? | Una decisión, tuya o de alguien |
| **Estado** | ¿En qué va el caso? | El avance del trabajo |

Una conversación puede estar leída, asignada a otro y abierta. Las tres a la vez.
Si tu modelo tiene un solo campo para esto, está mal.

**Y define cuándo se marca como leída.** Abrirla no siempre alcanza: si se marca al
abrir y la persona la abrió sin querer, la perdió de vista. Un botón de "marcar como
no leída" es barato y salva el día.

## Lo que llega mientras miras

Esta es la parte que más se hace mal.

- **Nunca muevas lo que la persona está leyendo.** Si llega un mensaje que reordena la
  lista, no reordenes debajo del cursor: muestra un aviso arriba —"3 conversaciones
  nuevas"— y deja que ella decida cuándo.
- **Dentro del hilo abierto**: si está mirando el final, baja solo. Si subió a leer
  algo viejo, **no la bajes** — aparece un botón "nuevo mensaje" abajo y ella decide.
- **No pierdas el borrador.** Si escribió medio mensaje y se recarga la página, ese
  texto tiene que seguir ahí. Es la falla que más rabia da de todas.
- **La posición del scroll se conserva** al volver de una conversación a la lista.

## El hilo

- **Agrupa por autor y por tiempo**: cinco mensajes seguidos de la misma persona en dos
  minutos son un bloque, no cinco tarjetas con foto repetida.
- **La hora se muestra al final del bloque**, no en cada línea.
- **Marca el cambio de día** con un separador. Sin eso "10:30" no dice nada.
- **Distingue quién habla** por posición y fondo, no solo por color.
- Un mensaje que falló al enviarse **se ve distinto y ofrece reintentar**. No lo borres
  ni lo dejes igual que los enviados.

## Los estados

- **Bandeja vacía es buena noticia**: "no hay conversaciones pendientes". Dilo así, no
  como un error. Es la única superficie donde vacío se celebra.
- **Nada seleccionado**: el panel del hilo no puede quedar en blanco. Va una
  instrucción corta o un resumen del día.
- **Cargando la lista**: esqueleto con la forma de las filas.
- **Cargando el hilo**: solo el panel del hilo, la lista se queda quieta. Recargar toda
  la pantalla al cambiar de conversación se siente lento aunque no lo sea.
- **Error de conexión en vivo**: dilo. Una bandeja que se quedó sin tiempo real y no
  avisa hace que la persona crea que no hay mensajes nuevos.

## Volumen

- La lista se **virtualiza** desde el principio: una bandeja crece sin techo.
- **Buscar es obligatorio**, y busca dentro del contenido de los mensajes, no solo por
  nombre. Es como se encuentra un caso viejo.
- Filtros que de verdad se usan: sin leer, asignados a mí, sin asignar, por estado.

## Teclado

Quien trabaja ocho horas en una bandeja no usa el mouse para todo:

- Subir y bajar en la lista sin salir del hilo.
- Enviar sin soltar las manos, y que esté claro si es `Enter` o `Cmd+Enter`. Elige uno
  y sé consistente: cambiar eso entre pantallas hace que la gente mande mensajes a
  medias.
- Archivar o cerrar con una tecla, con deshacer disponible.

## Lo que NO haces

- No reordenas la lista debajo de quien está leyendo.
- No marcas como leída sin ofrecer volver atrás.
- No pierdes el borrador. Nunca.
- No metes el estado del caso y la asignación en el mismo campo.
- No muestras "en línea" o "escribiendo" si no lo tienes de verdad. Fingirlo se nota.
