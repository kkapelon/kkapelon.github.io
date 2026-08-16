#!/usr/bin/env bash
#
# Ensures the copyright bar and navigation are identical across all pages.
# The current-tab class is allowed to differ (each page highlights its own link).
#
set -euo pipefail

cd "$(dirname "$0")/.."

pages=(index.html presentations.html code.html contact.html)

extract() {
	local file=$1 start=$2 end=$3
	awk -v start="$start" -v end="$end" '
		$0 ~ start { inblock = 1 }
		inblock { print }
		inblock && $0 ~ end { exit }
	' "$file"
}

normalize() {
	sed 's/ class="current-tab"//g'
}

fail=0

ref_nav=$(extract "${pages[0]}" '<nav class="codrops-navigation">' '</nav>' | normalize)
ref_copy=$(extract "${pages[0]}" '<div class="codrops-top clearfix">' '</div>')

for page in "${pages[@]}"; do
	nav=$(extract "$page" '<nav class="codrops-navigation">' '</nav>' | normalize)
	if [[ "$nav" != "$ref_nav" ]]; then
		echo "MISMATCH: navigation differs in $page (reference: ${pages[0]})"
		fail=1
	fi

	copy=$(extract "$page" '<div class="codrops-top clearfix">' '</div>')
	if [[ "$copy" != "$ref_copy" ]]; then
		echo "MISMATCH: copyright bar differs in $page (reference: ${pages[0]})"
		fail=1
	fi
done

if [[ $fail -eq 0 ]]; then
	echo "OK: navigation and copyright bar are identical across all pages."
else
	echo "Please fix the mismatches above."
	exit 1
fi
