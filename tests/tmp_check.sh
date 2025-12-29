#!/usr/bin/env bash
linkify_text() {
  local line="$1"
  printf '%s' "$line" | perl -pe '
    my @link_tokens;
    my $li = 0;
    s/(\[[^\[\]]+\]\([^)]+\))/push @link_tokens, $1; "__TAKEN_LINK_" . $li++ . "__"/ge;

    my @code_tokens;
    my $ci = 0;
    s/(`[^`]+`)/push @code_tokens, $1; "__TAKEN_CODE_" . $ci++ . "__"/ge;

    s|(https?://\S+)|[$1]($1)|g;
    s{(^|\s)(www\.\S+)}{$1 . "[$2](https://$2)"}ge;

    s/__TAKEN_LINK_(\d+)__/ $link_tokens[$1] /ge;
    s/__TAKEN_CODE_(\d+)__/ $code_tokens[$1] /ge;
  '
}

format_entry() {
  local text="$1"
  text="${text//$'\r'/}"

  local lines=()
  local line
  while IFS= read -r line; do
    lines+=("$line")
  done <<<"$text"

  if [[ ${#lines[@]} -eq 0 ]]; then
    printf '%s' "- "
    return
  fi

  local in_code_block=0
  if [[ "${lines[0]}" =~ ^[[:space:]]*``` ]]; then
    in_code_block=1
  fi
  local first
  if [[ "$in_code_block" == "1" ]] || [[ "${lines[0]}" =~ ^[[:space:]][[:space:]][[:space:]][[:space:]] ]] || [[ "${lines[0]}" =~ ^[[:space:]]*\t ]]; then
    first="${lines[0]}"
  else
    first="$(linkify_text "${lines[0]}")"
  fi
  printf '%s' "- ${first}"
  local i
  for ((i = 1; i < ${#lines[@]}; i++)); do
    if [[ "${lines[$i]}" =~ ^[[:space:]]*``` ]]; then
      if [[ "$in_code_block" == "1" ]]; then
        in_code_block=0
      else
        in_code_block=1
      fi
    fi
    local next
    if [[ "$in_code_block" == "1" ]] || [[ "${lines[$i]}" =~ ^[[:space:]][[:space:]][[:space:]][[:space:]] ]] || [[ "${lines[$i]}" =~ ^[[:space:]]*\t ]]; then
      next="${lines[$i]}"
    else
      next="$(linkify_text "${lines[$i]}")"
    fi
    printf '\n  %s' "$next"
  done
}
