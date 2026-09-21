#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: install.sh --dry-run|--copy [--update] [--target DIR]

Install the Codex Orchestrator skill and Luna agents under DIR. DIR defaults to
${CODEX_HOME:-$HOME/.codex}; --target names the Codex configuration root,
not the skills directory itself.
USAGE
}

mode=''
target_root=''
allow_update=false

while (($#)); do
  case "$1" in
    --dry-run|--copy)
      [[ -z "$mode" ]] || { echo 'Choose only one of --dry-run or --copy.' >&2; exit 64; }
      mode="${1#--}"
      ;;
    --target)
      (($# >= 2)) || { echo '--target requires a directory.' >&2; exit 64; }
      [[ -n "$2" ]] || { echo '--target cannot be empty.' >&2; exit 64; }
      target_root="$2"
      shift
      ;;
    --update)
      allow_update=true
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 64
      ;;
  esac
  shift
done

[[ -n "$mode" ]] || { usage >&2; exit 64; }
if [[ -z "$target_root" ]]; then
  if [[ -n "${CODEX_HOME:-}" ]]; then
    target_root="$CODEX_HOME"
  else
    [[ -n "${HOME:-}" ]] || { echo 'Set CODEX_HOME, set HOME, or pass --target DIR.' >&2; exit 64; }
    target_root="$HOME/.codex"
  fi
fi
while [[ "$target_root" != '/' && "$target_root" == */ ]]; do
  target_root="${target_root%/}"
done
[[ -n "$target_root" ]] || { echo 'The target directory cannot be empty.' >&2; exit 64; }
[[ "$target_root" != '/' ]] || { echo 'Refusing to install directly under /. Use a Codex configuration directory.' >&2; exit 64; }

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
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

for relative_path in "${source_files[@]}"; do
  source_path="$repo_root/$relative_path"
  [[ -f "$source_path" && ! -L "$source_path" ]] || {
    echo "Missing repository file: $source_path" >&2
    exit 66
  }
done

# Check every existing component at or below the requested target, including
# dangling links. This keeps mkdir/cp from writing through a destination link
# while permitting normal system path aliases such as macOS's /var link.
preflight_destination() {
  local candidate="$target_root"
  local relative_path="$1"
  local component
  [[ ! -L "$candidate" ]] || {
    echo "Refusing to use symlink in destination path: $candidate" >&2
    exit 73
  }
  if [[ -e "$candidate" && ! -d "$candidate" ]]; then
    echo "Destination root exists and is not a directory: $candidate" >&2
    exit 73
  fi
  while [[ -n "$relative_path" ]]; do
    component="${relative_path%%/*}"
    if [[ "$relative_path" == */* ]]; then
      relative_path="${relative_path#*/}"
    else
      relative_path=''
    fi
    [[ -n "$component" ]] || continue
    candidate="$candidate/$component"
    [[ ! -L "$candidate" ]] || {
      echo "Refusing to use symlink in destination path: $candidate" >&2
      exit 73
    }
    if [[ -e "$candidate" ]]; then
      if [[ -n "$relative_path" ]]; then
        [[ -d "$candidate" ]] || {
          echo "Destination parent exists and is not a directory: $candidate" >&2
          exit 73
        }
      else
        [[ -f "$candidate" ]] || {
          echo "Destination exists and is not a regular file: $candidate" >&2
          exit 73
        }
      fi
    fi
  done
}

for relative_path in "${destination_files[@]}"; do
  preflight_destination "$relative_path"
done

# Compare every existing target before any write occurs.
for index in "${!source_files[@]}"; do
  source_path="$repo_root/${source_files[$index]}"
  destination_path="$target_root/${destination_files[$index]}"
  if [[ -e "$destination_path" ]] && ! cmp -s "$source_path" "$destination_path" && [[ "$allow_update" != true ]]; then
    echo "Destination differs from repository file: $destination_path" >&2
    exit 73
  fi
done

if [[ "$mode" == 'dry-run' ]]; then
  printf 'Would create directory: %s\n' "$target_root/skills/codex-orchestrator/agents"
  printf 'Would create directory: %s\n' "$target_root/agents"
  for index in "${!source_files[@]}"; do
    action='copy'
    if [[ "$allow_update" == true && -e "$target_root/${destination_files[$index]}" ]]; then
      action='update'
    fi
    printf 'Would %s: %s -> %s\n' "$action" "$repo_root/${source_files[$index]}" "$target_root/${destination_files[$index]}"
  done
  exit 0
fi

mkdir -p "$target_root/skills/codex-orchestrator/agents" "$target_root/agents"
for index in "${!source_files[@]}"; do
  cp "$repo_root/${source_files[$index]}" "$target_root/${destination_files[$index]}"
done

printf 'Installed Codex Orchestrator skill and Luna agents under %s\n' "$target_root"
