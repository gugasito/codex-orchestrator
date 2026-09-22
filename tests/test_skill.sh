#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
install_script="$repo_root/install.sh"
source_files=(
  'skill/codex-orchestrator/SKILL.md'
  'skill/codex-orchestrator/agents/openai.yaml'
  '.codex/agents/luna-worker.toml'
  '.codex/agents/luna-repetitive.toml'
  '.codex/agents/luna-explorer.toml'
  '.codex/agents/luna-deep-worker.toml'
  '.codex/agents/luna-verifier.toml'
)
destination_files=(
  'skills/codex-orchestrator/SKILL.md'
  'skills/codex-orchestrator/agents/openai.yaml'
  'agents/luna-worker.toml'
  'agents/luna-repetitive.toml'
  'agents/luna-explorer.toml'
  'agents/luna-deep-worker.toml'
  'agents/luna-verifier.toml'
)

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

for relative_path in "${source_files[@]}"; do
  [[ -f "$repo_root/$relative_path" ]] || fail "source is missing: $relative_path"
done
bash -n "$install_script"

rg -Fq 'controller must never edit' "$repo_root/skill/codex-orchestrator/SKILL.md" || fail 'strict controller boundary is missing'
rg -Fq 'gpt-6-luna' "$repo_root/skill/codex-orchestrator/SKILL.md" || fail 'Luna routing is missing'
rg -Fq 'luna_deep_worker' "$repo_root/skill/codex-orchestrator/SKILL.md" || fail 'deep Luna role is missing'
rg -Fq 'model_reasoning_effort = "xhigh"' "$repo_root/.codex/agents/luna-deep-worker.toml" || fail 'deep Luna effort is missing'
rg -Fq 'model_reasoning_effort = "medium"' "$repo_root/.codex/config.toml" || fail 'controller medium effort default is missing'
rg -Fq 'model = "gpt-6-sol"' "$repo_root/.codex/config.toml" || fail 'Sol controller model is missing'
rg -Fq 'gpt-6-astra' "$repo_root/skill/codex-orchestrator/SKILL.md" || fail 'Astra controller option is missing'
rg -Fq 'max_concurrent_threads_per_session = 2' "$repo_root/.codex/config.toml" || fail 'concurrency limit is missing'

temp_root="$(mktemp -d "${TMPDIR:-/tmp}/fable-orchestrator.XXXXXX")"
trap 'rm -rf "$temp_root"' EXIT

assert_installed_fidelity() {
  local target="$1"
  for index in "${!source_files[@]}"; do
    cmp -s "$repo_root/${source_files[$index]}" "$target/${destination_files[$index]}" || fail "installed copy differs: ${destination_files[$index]}"
  done
}

target="$temp_root/target"
mkdir -p "$target"
printf 'keep\n' >"$target/config.toml"
config_before="$(mktemp "$temp_root/config.XXXXXX")"
cp "$target/config.toml" "$config_before"

dry_run_output="$temp_root/dry-run.txt"
"$install_script" --dry-run --target "$target" >"$dry_run_output"
[[ ! -e "$target/skills" && ! -e "$target/agents" ]] || fail 'dry-run created destination paths'
rg -Fq "$target/skills/codex-orchestrator" "$dry_run_output" || fail 'dry-run omitted skill destination'

"$install_script" --copy --target "$target" >/dev/null
assert_installed_fidelity "$target"
cmp -s "$config_before" "$target/config.toml" || fail 'copy modified unrelated config.toml'

snapshot="$temp_root/snapshot"
cp -R "$target" "$snapshot"
"$install_script" --copy --target "$target" >/dev/null
diff -r "$snapshot" "$target" >/dev/null || fail 'identical rerun changed destination'

conflict_target="$temp_root/conflict"
mkdir -p "$conflict_target/skills/codex-orchestrator"
printf 'conflict\n' >"$conflict_target/skills/codex-orchestrator/SKILL.md"
if "$install_script" --copy --target "$conflict_target" >/dev/null 2>&1; then
  fail 'conflicting destination was accepted'
fi
[[ ! -e "$conflict_target/agents" ]] || fail 'conflict preflight partially installed agents'
[[ "$(cat "$conflict_target/skills/codex-orchestrator/SKILL.md")" == 'conflict' ]] || fail 'conflict file was overwritten'
printf 'keep unrelated config\n' >"$conflict_target/config.toml"
"$install_script" --copy --update --target "$conflict_target" >/dev/null
cmp -s "$repo_root/skill/codex-orchestrator/SKILL.md" "$conflict_target/skills/codex-orchestrator/SKILL.md" || fail 'update did not replace managed conflict'
[[ "$(cat "$conflict_target/config.toml")" == 'keep unrelated config' ]] || fail 'update modified unrelated config'

symlink_target="$temp_root/symlink"
mkdir -p "$symlink_target/skills/codex-orchestrator"
ln -s "$temp_root/elsewhere" "$symlink_target/skills/codex-orchestrator/agents"
if "$install_script" --copy --target "$symlink_target" >/dev/null 2>&1; then
  fail 'destination symlink was accepted'
fi
[[ ! -e "$temp_root/elsewhere" ]] || fail 'symlink target was written'
[[ ! -e "$symlink_target/skills/codex-orchestrator/SKILL.md" ]] || fail 'interior symlink preflight wrote a skill file'

non_dir_target="$temp_root/non-dir"
mkdir -p "$non_dir_target"
printf 'not a directory\n' >"$non_dir_target/agents"
if "$install_script" --copy --target "$non_dir_target" >/dev/null 2>&1; then
  fail 'regular-file agents parent was accepted'
fi
[[ ! -e "$non_dir_target/skills" ]] || fail 'non-directory parent preflight created skill paths'

if "$install_script" --copy --target >/dev/null 2>&1; then
  fail 'missing --target argument was accepted'
fi
if "$install_script" --copy --dry-run --target "$temp_root/invalid" >/dev/null 2>&1; then
  fail 'multiple modes were accepted'
fi
if "$install_script" --bogus --target "$temp_root/invalid" >/dev/null 2>&1; then
  fail 'invalid argument was accepted'
fi

echo 'PASS: Codex installer behavioral checks'
