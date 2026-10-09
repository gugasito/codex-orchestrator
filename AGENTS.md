# Mantener codex-orchestrator

Este repositorio distribuye una skill y agentes; no es una aplicación web.
La entrada está en `skill/codex-orchestrator/SKILL.md`, las referencias junto a
ella y los roles en `.codex/agents/`. `agents/openai.yaml` es metadata de UI.

Preserva la política: principal decide/revisa, Luna implementa por defecto,
incluso tareas pequeñas; excepciones explícitas y correcciones al propietario.
No conviertas límites orientativos en garantías técnicas ni benchmarks ficticios.

Al añadir recursos instalables, actualiza `install.sh` y la lista de fidelidad de
`tests/test_skill.sh`. Conserva preflight, idempotencia, protección de symlinks y
configuración ajena. No copies este archivo a proyectos consumidores: crea sus
instrucciones con evidencia del proyecto mediante la referencia project-setup.

Comprobaciones: `bash tests/test_skill.sh`, `python3 tests/test_package.py`
(Python 3.11+) y `git diff --check`. Valida escenarios de delegación cuando cambie
el flujo. Estos checks no demuestran ahorro o rendimiento con modelos reales.
