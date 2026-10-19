# Evaluación del flujo

Estos son criterios para ejercicios independientes y futuros runs reales, no
resultados de rendimiento. Proporcionar al evaluador el pedido, el código de
partida y la skill; reservar esta rúbrica para evaluar después.

| Pedido | Evidencia de comportamiento esperado |
| --- | --- |
| Corregir etiqueta en archivo conocido | Ruta rápida con un Luna implementador, sin exploración global ni QA separado obligatorio |
| Cancelar pedido con pago, stock y UI | Contrato e invariantes antes de consumidores, revisión independiente del riesgo, integración real y estados UX |
| Corregir fallo con base local caída | Diagnóstico de entorno, sin escalamiento de modelo por esa causa, checks bloqueados explícitos |
| Implementar solo con Luna cuando falta delegación | Bloqueo concreto sin afirmar delegación ni sustituir el modelo requerido |
| Reutilizar una lección de un proyecto | Evidencia y alcance local; observación no se vuelve regla global automáticamente |
| Cambiar contrato compartido en paralelo | Un propietario del contrato, consumidores después de acuerdo, integración verificada |
| Worker pasa tests pero UI no fue renderizada | Limitación visual explícita y aceptación pendiente si era requisito |

Para benchmark real, comparar modelo solo / versión anterior / nueva versión en
el mismo commit y entorno, repetir, conservar fallos y consumo total y evaluar
aceptación de forma independiente. Usar la referencia learning-and-evaluation.

| Escenario adicional | Criterio |
| --- | --- |
| Principal detecta defecto de foco en UI | Devuelve hallazgo al Luna responsable antes de editar |
| Proyecto sin instrucciones | Crea guía basada en evidencia; no inventa comandos |
| Hay AGENTS.override.md | Respeta precedencia; no crea instrucciones inefectivas |
| Un Luna sigue trabajando | Principal no modifica sus rutas bajo la excusa de integración |
| Principal ya tiene rutas y hallazgos actuales | Handoff incluye esa evidencia; no crea explorador ni pide repetir descubrimiento |
| Dos tareas independientes están listas | Se despachan sin esperar trabajo no relacionado; una tarea dependiente espera solo el contrato compartido |
| Corrección del mismo cambio | Se reutiliza el propietario y se comunica solo hallazgo nuevo, resultado esperado y evidencia de fallo |
| Detalle rutinario dentro del alcance | Worker decide usando evidencia del proyecto y reporta; no abre una ronda de aclaraciones |
| Cambio de bajo riesgo con pruebas enfocadas | Implementador comprueba; no se añade QA/verificador como etapa automática |
| Verificador encuentra fallo | Devuelve evidencia sin editar; el propietario implementador corrige |
| Principal integra sin cambio relevante al comportamiento ya revisado | Revisa diff/evidencia; repite solo checks afectados o evidencia obsoleta |
| Tarea backend que encaja con rol de dominio | Luna backend implementa y verifica como único propietario; no entrega código a luna_worker |
| Cambio acotado entre dominios sin consumidor separado | Un solo luna_worker implementa; no se encadena con agentes de dominio |
| Instalación nueva tras retirar roles | Distribuye solo los 13 roles actuales; actualización no borra automáticamente roles antiguos |
| Solo quedan respuestas de agentes pendientes | Tras trabajo independiente, usa espera por evento de 45–60 segundos cuando el runtime lo admita; evita sondeos breves y repetidos |
| Una espera termina sin evento | La trata como timeout, no fallo; vuelve a esperar sin reexplorar, insistir al agente ni escalar solo por el tiempo transcurrido |
