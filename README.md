# Codex Orchestrator — desarrollo adaptable con Sol y Luna

La skill convierte una solicitud de software en un cambio verificado, usando el
modelo principal seleccionado para requisitos, decisiones e integración y Luna
para implementación acotada cuando conviene delegar. Funciona con Codex nativo;
no necesita ECC ni un servicio externo.

## Uso

```text
$codex-orchestrator agrega cancelación de pedidos respetando la arquitectura y UX del proyecto
```

El coordinador inspecciona, decide y revisa. Luna implementa por defecto, también
las correcciones pequeñas. La edición funcional directa del principal requiere
una excepción explicada; integración o tamaño pequeño no bastan. Una funcionalidad separable
puede usar uno o dos workers. Los cambios críticos requieren revisión
independiente del riesgo relevante. No hay una cadena obligatoria de explorador,
implementador, QA y verificador.

Se recomienda GPT-6.1 Sol como principal. La selección activa del usuario manda:
la skill no cambia el modelo ni el esfuerzo de una sesión abierta. Los defaults
del proyecto son Sol medium, Luna medium y un máximo de tres subagentes; el
runtime puede imponer un límite menor. El instalador conserva el config global.

## Instalación y actualización

```bash
./install.sh --dry-run
./install.sh --copy
# Actualizar una instalación existente, tras revisar diferencias:
./install.sh --dry-run --update
./install.sh --copy --update
```

El destino es `${CODEX_HOME:-$HOME/.codex}`; `--target DIR` permite otra raíz de
configuración. Se instalan la skill, sus referencias y quince agentes. No se
modifica `config.toml` ni se eliminan archivos ajenos. Sin `--update`, un archivo
diferente bloquea la copia antes de escribir; `--update` reemplaza los archivos
administrados. Conserva una copia de tus personalizaciones antes de actualizar.
Abre un chat nuevo para que Codex descubra las instrucciones y roles actualizados.

La disponibilidad real de modelos y delegación depende de tu sesión. Si falta
un rol, el coordinador puede usar selección explícita cuando la herramienta la
admita. Si falta delegación, puede continuar directamente salvo que tu pedido
exija una separación estricta de modelos. No afirma haber delegado si no ocurrió.

## Roles y esfuerzo

Los doce roles Luna existentes se conservan: explorer, repetitive, worker,
deep_worker, verifier, infra, backend, frontend, database, qa, security y docs,
todos con prefijo `luna_`. Se añaden `sol_specialist`, `sol_reviewer` y
`astra_specialist` para escalamiento justificado. No se activan todos a la vez.

El dominio y el modelo son decisiones distintas. Los archivos de agentes fijan
modelo y esfuerzo; para otra combinación se necesita un spawn explícito
compatible o un rol adecuado. La tabla completa está en
[la referencia de routing](skill/codex-orchestrator/references/routing.md).
No se garantiza ahorro por tarea: deben medirse coordinación, reintentos y
calidad. Más tokens Luna pueden costar menos que menos tokens Sol.

## Arquitectura, UX y aprendizaje

La skill consulta documentación y código reales. Si faltan instrucciones durante
una tarea de desarrollo, prepara un AGENTS.md breve y basado en evidencia, sin
sobrescribir las reglas existentes. Incluye instrucciones por ámbito en cada delegación. Para trabajo recurrente puede
mantener un índice `.codex/knowledge/index.md` dentro del proyecto que enlaza las
fuentes existentes. Esa ruta es una convención que la skill lee explícitamente,
no una función automática de Codex.

- Backend: límites de módulos, contratos, autorización, transacciones e invariantes.
- UX: componentes y tokens existentes, estados, navegación, accesibilidad y evidencia visual.
- Lecciones: situación, acción propuesta, alcance, evidencia, fecha y estado.
- Métricas: tiempo y consumo observados; valores desconocidos quedan sin inventar.

Los aprendizajes son locales al proyecto. Una observación no se convierte en
regla global; la promoción global requiere mantenimiento explícito. No hay
observadores en segundo plano ni modificación automática de la skill instalada.
Las referencias se cargan según necesidad, no todas para cada solicitud.

## Verificación

```bash
bash tests/test_skill.sh
python3 tests/test_package.py
```

Los tests verifican instalación, actualización, idempotencia, protección frente
a conflictos/enlaces y distribución de referencias/agentes. La validación de
paquete requiere Python 3.11+ (tomllib). No son benchmarks con modelos.

[Los escenarios de evaluación](tests/workflow-scenarios.md) permiten probar el
flujo. Para medir mejoras, compara el mismo caso y commit entre modelo solo,
versión anterior y versión nueva en espacios aislados. Incluye fallos, retrabajo,
calidad arquitectónica y UX. No atribuyas a la nueva skill ganancias que aún no
se han medido.

## Compatibilidad y origen

Esta versión sustituye el modo controlador estricto por coordinación adaptable.
Conserva roles Luna y permisos existentes; los roles read-only declaran además
su restricción de no editar. Los overrides del runtime pueden prevalecer sobre
los valores de sandbox de los archivos.

Basado en [subagentes oficiales de Codex](https://learn.chatgpt.com/docs/agent-configuration/subagents).
Adaptado originalmente de [Fable Orchestrator](https://github.com/codejunkie99/fable-orchestrator).
Licencia MIT, ver [LICENSE](LICENSE). El historial conserva la versión anterior.

## Flujo recomendado

Inicia cada proyecto definiendo alcance y criterios de aceptación. Usa un chat
por funcionalidad y conserva el mismo para sus correcciones. Pide el resultado
y sus restricciones; la skill elige los agentes. Evita chats escribiendo archivos
compartidos en paralelo. Al cerrar, revisa quién implementó, las verificaciones
y las excepciones. Tras instalar, abre un chat nuevo y pide listar instrucciones
y delegación prevista. Los archivos AGENTS.md del proyecto se mantienen con él;
el AGENTS.md de este repositorio solo orienta el mantenimiento de la skill.
