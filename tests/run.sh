#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TKN="$ROOT_DIR/bin/tkn"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

export HOME="$TMP_DIR/home"
export TAKEN_DIR="$TMP_DIR/notebooks"
export TAKEN_CONFIG_DIR="$TMP_DIR/config"
export TAKEN_NO_FZF=1
export PATH="$ROOT_DIR/tests/bin:$PATH"

PASS_COUNT=0
FAIL_COUNT=0

fail() {
  echo "FAIL: $*" >&2
  FAIL_COUNT=$((FAIL_COUNT + 1))
  return 1
}

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  echo "PASS"
}

run_test() {
  local name="$1"
  local fn="$2"
  echo -n "Test: $name ... "
  if "$fn"; then
    pass
  else
    fail "$name"
  fi
}

today="$(date +%Y-%m-%d)"

test_add_notebook() {
  "$TKN" add tokens >/dev/null
  [[ -f "$TAKEN_DIR/tokens.md" ]]
}

test_default_notebook() {
  "$TKN" default tokens >/dev/null
  [[ -f "$TAKEN_CONFIG_DIR/default_notebook" ]] || return 1
  [[ "$(cat "$TAKEN_CONFIG_DIR/default_notebook")" == "tokens" ]]
}

test_append_default() {
  export TAKEN_TEST_CLIPBOARD="hello world"
  "$TKN" >/dev/null
  local content
  content="$(cat "$TAKEN_DIR/tokens.md")"
  [[ "$content" == *"## $today"* && "$content" == *"- hello world"* ]]
}

test_append_named() {
  export TAKEN_TEST_CLIPBOARD="second entry"
  "$TKN" tokens >/dev/null
  local content
  content="$(cat "$TAKEN_DIR/tokens.md")"
  [[ "$content" == *"- second entry"* ]]
}

test_search() {
  local out
  out="$("$TKN" search world || true)"
  [[ "$out" == *"tokens"* ]]
}

test_config_dir() {
  "$TKN" config dir "$TMP_DIR/alt-notebooks" >/dev/null
  [[ -d "$TMP_DIR/alt-notebooks" ]]
}

run_test "add notebook" test_add_notebook
run_test "default notebook" test_default_notebook
run_test "append uses default" test_append_default
run_test "append by name" test_append_named
run_test "search" test_search
run_test "config dir" test_config_dir

total=$((PASS_COUNT + FAIL_COUNT))
echo "Summary: $PASS_COUNT/$total passing"
if [[ "$FAIL_COUNT" -ne 0 ]]; then
  exit 1
fi
