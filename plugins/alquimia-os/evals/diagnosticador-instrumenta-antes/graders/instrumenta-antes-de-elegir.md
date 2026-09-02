---
type: llm
criteria: "La respuesta reconoce que el síntoma descrito —webhook 200, cero errores— es compatible con VARIAS causas distintas (entre ellas que el sistema no haya intentado responder), y su primera recomendación es hacerlas distinguibles: instrumentar el punto donde hoy se pierde el motivo, o alguna medición que separe las hipótesis. NO se conforma con señalar el token vencido como causa."
focus: "El token de seis días es el señuelo: es plausible, encaja con la fecha, y elegirlo sin poder distinguirlo de las otras causas es adivinar con cara de diagnóstico. Lo que se evalúa es que separe las hipótesis antes de elegir una."
target: last_message
---
