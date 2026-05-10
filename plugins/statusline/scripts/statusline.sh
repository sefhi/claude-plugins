#!/usr/bin/env bash
set -uo pipefail

ESC=$'\033'
BLUE_BOLD="${ESC}[1;34m"
CYAN="${ESC}[36m"
GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"
RED="${ESC}[31m"
DIM="${ESC}[2m"
RESET="${ESC}[0m"
SEP=" │ "

input=$(cat)

cwd=$(jq -r '.workspace.current_dir // .cwd // ""' <<<"$input")
transcript=$(jq -r '.transcript_path // ""' <<<"$input")
model_id=$(jq -r '.model.id // ""' <<<"$input")
cost=$(jq -r '.cost.total_cost_usd // 0' <<<"$input")

branch="-"
if [[ -n "$cwd" && -d "$cwd" ]]; then
  if b=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null); then
    branch="$b"
  fi
fi

diff_stat="${GREEN}clean${RESET}"
if [[ -n "$cwd" && -d "$cwd" ]] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  summary=$(git -C "$cwd" diff --shortstat HEAD 2>/dev/null || true)
  files=0; adds=0; dels=0
  if [[ -n "${summary:-}" ]]; then
    files=$(grep -oE '[0-9]+ files? changed' <<<"$summary" | grep -oE '[0-9]+' || echo 0)
    adds=$(grep -oE  '[0-9]+ insertion'      <<<"$summary" | grep -oE '[0-9]+' || echo 0)
    dels=$(grep -oE  '[0-9]+ deletion'       <<<"$summary" | grep -oE '[0-9]+' || echo 0)
  fi
  files=${files:-0}; adds=${adds:-0}; dels=${dels:-0}
  untracked=$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  untracked=${untracked:-0}
  if (( files > 0 || adds > 0 || dels > 0 || untracked > 0 )); then
    diff_stat="${CYAN}${files}f${RESET} ${GREEN}+${adds}${RESET} ${RED}-${dels}${RESET}"
    (( untracked > 0 )) && diff_stat="${diff_stat} ${RED}?${untracked}${RESET}"
  fi
fi

cost_str=$(awk -v c="$cost" 'BEGIN {
  if (c+0 == 0)   { printf "$0.00";    exit }
  if (c+0 < 0.01) { printf "$<0.01";   exit }
  if (c+0 < 10)   { printf "$%.2f", c; exit }
  if (c+0 < 100)  { printf "$%.1f", c; exit }
  printf "$%d", int(c+0.5)
}')

case "$model_id" in
  *"[1m]"*|*"1m"*) limit=1000000 ;;
  *)               limit=200000  ;;
esac

used=0
if [[ -n "$transcript" && -f "$transcript" ]]; then
  last_usage=$(grep '"usage"' "$transcript" 2>/dev/null | tail -n 1 || true)
  if [[ -n "${last_usage:-}" ]]; then
    used=$(jq -r '
      ((.message.usage.input_tokens               // 0) +
       (.message.usage.cache_creation_input_tokens // 0) +
       (.message.usage.cache_read_input_tokens     // 0))
    ' <<<"$last_usage" 2>/dev/null || echo 0)
  fi
fi
[[ "$used" =~ ^[0-9]+$ ]] || used=0

pct=0
(( limit > 0 )) && pct=$(( used * 100 / limit ))
(( pct < 0 ))   && pct=0
(( pct > 100 )) && pct=100

filled=$(( pct * 12 / 100 ))
(( filled > 12 )) && filled=12
empty=$(( 12 - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty;  i++)); do bar+="░"; done

if   (( pct < 70 )); then ctx_color="$GREEN"
elif (( pct < 85 )); then ctx_color="$YELLOW"
else                       ctx_color="$RED"
fi

fmt_tokens() {
  awk -v n="$1" 'BEGIN {
    if      (n >= 1000000) printf "%.1fM", n/1000000
    else if (n >= 1000)    printf "%.1fk", n/1000
    else                   printf "%d",    n
  }'
}
used_str=$(fmt_tokens "$used")
limit_str=$(fmt_tokens "$limit")

printf '%s%s%s │ %s │ %s%s%s │ %s%s %d%%%s %s(%s/%s)%s\n' \
  "$BLUE_BOLD" "$branch"   "$RESET" \
  "$diff_stat" \
  "$GREEN"     "$cost_str" "$RESET" \
  "$ctx_color" "$bar"      "$pct"  "$RESET" \
  "$DIM"       "$used_str" "$limit_str" "$RESET"
