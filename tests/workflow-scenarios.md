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
