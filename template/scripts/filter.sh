#!/bin/bash
# Sensitive-data filter: checks the lines ADDED under memory/ (already staged) and prints each offending line.
# Exit 1 if any, 0 otherwise. bash 3.2 compatible (macOS).
#   scripts/filter-allow.txt  : exact texts that are allowed (public switchboard, support address), one per line
#   scripts/filter-custom.txt : your own patterns (extended regex), one per line, e.g. customer codes
root="$(cd "$(dirname "$0")/.." && pwd)"

# Secrets: passwords, API keys, tokens, IBAN, card numbers, social security numbers (FR format).
secrets='(password|passwd|passcode|mot de passe|mdp|api[ _-]?key|token|secret|pin code)[[:space:]]*[:=]|sk-[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{30,}|xox[abprs]-[A-Za-z0-9-]{10,}|\b[A-Z]{2}[0-9]{2}( ?[0-9A-Z]{4}){4,7}\b|\b([0-9]{4}[ -]?){3}[0-9]{4}\b|\b[12] ?[0-9]{2} ?[0-9]{2} ?[0-9]{2} ?[0-9]{3} ?[0-9]{3} ?[0-9]{2}\b'
# Personal contact details: e-mail addresses, phone numbers.
contacts='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[a-z]{2,}|\+[1-9][0-9]{0,2}[ .-]?[0-9]([ .-]?[0-9]{2,4}){3,5}|(^|[^0-9])0[1-9]([ .]?[0-9]{2}){4}([^0-9]|$)'
custom=""
[ -f "$root/scripts/filter-custom.txt" ] && custom=$(grep -v -e '^#' -e '^$' "$root/scripts/filter-custom.txt" | paste -sd '|' -)

result=$(git -C "$root" diff --cached -U0 --no-color -- memory \
  | awk '/^\+\+\+ b\//{f=substr($0,7)} /^\+[^+]/{print f": "substr($0,2)}' \
  | while IFS= read -r l; do
      rest="$l"
      if [ -f "$root/scripts/filter-allow.txt" ]; then
        while IFS= read -r e; do
          case "$e" in ''|'#'*) continue ;; esac
          rest="${rest//"$e"/}"   # only the allowed text is ignored, not the whole line
        done < "$root/scripts/filter-allow.txt"
      fi
      if echo "$rest" | grep -q -E -i -- "$secrets"; then echo "[secret] $l"
      elif echo "$rest" | grep -q -E -i -- "$contacts"; then echo "[contact] $l"
      elif [ -n "$custom" ] && echo "$rest" | grep -q -E -i -- "$custom"; then echo "[custom rule] $l"
      fi
    done)
[ -n "$result" ] && { echo "$result"; exit 1; }
exit 0
