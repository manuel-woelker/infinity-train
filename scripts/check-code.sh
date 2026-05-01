#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GREEN=$'\033[32m'
RESET=$'\033[0m'

now_ns() {
  date +%s%N
}

format_duration() {
  local duration_ns="$1"
  local duration_ms=$((duration_ns / 1000000))
  local seconds=$((duration_ms / 1000))
  local millis=$((duration_ms % 1000))
  printf "%d.%03ds" "$seconds" "$millis"
}

print_timing_line() {
  local icon="$1"
  local label="$2"
  local elapsed_ns="$3"
  printf "%s %-28s %8s\n" "$icon" "$label" "$(format_duration "$elapsed_ns")"
}

run_optional_step() {
  local name="$1"
  local icon="$2"
  local command="${3:-}"

  if [[ -z "$command" ]]; then
    printf "⏭️  Skipping %-20s not configured\n" "$name"
    return 0
  fi

  local start_ns
  start_ns="$(now_ns)"
  (
    cd "$ROOT_DIR"
    eval "$command"
  )
  local end_ns
  end_ns="$(now_ns)"

  print_timing_line "$icon" "Running $name..." "$((end_ns - start_ns))"
}

TOTAL_START_NS="$(now_ns)"

run_optional_step "format" "🧹" "${INFINITY_TRAIN_FORMAT_CMD:-}"
run_optional_step "build" "🔨" "${INFINITY_TRAIN_BUILD_CMD:-}"
run_optional_step "lint" "📎" "${INFINITY_TRAIN_LINT_CMD:-}"
run_optional_step "test" "🧪" "${INFINITY_TRAIN_TEST_CMD:-}"
run_optional_step "extra checks" "🛰️" "${INFINITY_TRAIN_EXTRA_CHECK_CMD:-}"

TOTAL_END_NS="$(now_ns)"
print_timing_line "🏁" "Complete check..." "$((TOTAL_END_NS - TOTAL_START_NS))"

printf "🎉 All configured checks passed %s%s%s\n" "$GREEN" "successfully" "$RESET"
