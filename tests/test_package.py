"""Validate installed package resources and callable-role configuration, not prose."""
import re
import tomllib
from pathlib import Path

root = Path(__file__).resolve().parents[1]
skill = root / 'skill/codex-orchestrator'
for source in skill.rglob('*.md'):
    for link in re.findall(r'\]\(([^)]+)\)', source.read_text()):
        if '://' not in link and not link.startswith('#'):
            assert (source.parent / link.split('#')[0]).is_file(), (source, link)
names = set()
for path in (root / '.codex/agents').glob('*.toml'):
    agent = tomllib.loads(path.read_text())
    for key in ('name', 'description', 'developer_instructions', 'model', 'model_reasoning_effort'):
        assert agent.get(key), (path, key)
    assert agent['name'] not in names, agent['name']
    names.add(agent['name'])
    assert agent['model'] in {'gpt-6-luna', 'gpt-6.1-sol', 'gpt-6-astra'}
    assert agent['model_reasoning_effort'] in {'low', 'medium', 'high', 'xhigh', 'max'}
    assert agent['sandbox_mode'] in {'read-only', 'workspace-write'}
config = tomllib.loads((root / '.codex/config.toml').read_text())
assert config['agents']['max_concurrent_threads_per_session'] == 3
assert config['agents']['default_subagent_model'] == 'gpt-6-luna'
assert len(names) == 15, names
print('PASS: package references and 15 agent configurations')
