#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RELEASE_BRANCH="${INFINITY_TRAIN_RELEASE_BRANCH:-main}"
TAG_PREFIX="${INFINITY_TRAIN_RELEASE_TAG_PREFIX:-v}"
DRY_RUN=0
MODE="publish"
TARGET_VERSION=""

usage() {
  cat <<'EOF'
Usage:
  ./scripts/release.sh release <version>
  ./scripts/release.sh prepare <version>
  ./scripts/release.sh publish [--dry-run]
  ./scripts/release.sh [--dry-run]

Environment:
  INFINITY_TRAIN_RELEASE_BRANCH      Branch allowed to prepare releases from.
  INFINITY_TRAIN_RELEASE_TAG_PREFIX  Tag prefix to use. Default: v
  INFINITY_TRAIN_PUBLISH_CMD         Optional publish command run during publish.

Options:
  --dry-run    Run validations without mutating git state or running publish steps.
  --help       Show this help.
EOF
}

log() {
  printf '==> %s\n' "$*"
}

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

validate_version() {
  local version="$1"
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?$ ]] || fail "invalid version: $version"
}

current_branch() {
  git -C "$ROOT_DIR" symbolic-ref --quiet --short HEAD || true
}

assert_clean_worktree() {
  if [[ -n "$(git -C "$ROOT_DIR" status --short)" ]]; then
    fail "git worktree is not clean"
  fi
}

assert_release_branch() {
  local branch
  branch="$(current_branch)"
  [[ -n "$branch" ]] || fail "release requires a checked out branch, not a detached HEAD"
  [[ "$branch" == "$RELEASE_BRANCH" ]] || fail "release must run from branch '$RELEASE_BRANCH' (current: '$branch')"
}

assert_tag_absent() {
  local tag_name="$1"

  if git -C "$ROOT_DIR" rev-parse -q --verify "refs/tags/$tag_name" >/dev/null 2>&1; then
    fail "tag already exists locally: $tag_name"
  fi
}

run_checks() {
  log "running repository checks"
  "$ROOT_DIR/scripts/check-code.sh"
}

prepare_release() {
  local version="$1"
  local tag_name="${TAG_PREFIX}${version}"

  validate_version "$version"
  assert_clean_worktree
  assert_release_branch
  assert_tag_absent "$tag_name"
  run_checks

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry run: would create annotated tag $tag_name"
    return 0
  fi

  git -C "$ROOT_DIR" tag -a "$tag_name" -m "Release $tag_name"
  log "created annotated tag $tag_name"
}

publish_release() {
  if [[ -z "${INFINITY_TRAIN_PUBLISH_CMD:-}" ]]; then
    log "no publish command configured; set INFINITY_TRAIN_PUBLISH_CMD when the release process is defined"
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry run: would run publish command: $INFINITY_TRAIN_PUBLISH_CMD"
    return 0
  fi

  log "running publish command"
  (
    cd "$ROOT_DIR"
    eval "$INFINITY_TRAIN_PUBLISH_CMD"
  )
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    release|prepare|publish)
      MODE="$1"
      shift
      if [[ "${1:-}" != "" && "$MODE" != "publish" ]]; then
        TARGET_VERSION="$1"
        shift
      fi
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

case "$MODE" in
  prepare)
    [[ -n "$TARGET_VERSION" ]] || fail "prepare requires a version"
    prepare_release "$TARGET_VERSION"
    ;;
  publish)
    publish_release
    ;;
  release)
    [[ -n "$TARGET_VERSION" ]] || fail "release requires a version"
    prepare_release "$TARGET_VERSION"
    publish_release
    ;;
esac
