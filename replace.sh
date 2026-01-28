#!/bin/bash

# Temp file to collect unsorted output
tmpfile=$(mktemp)

find . -type f -name "*.md" ! -name "*.bak" | while read -r md_file; do

    python3 - "$md_file" >> "$tmpfile" <<'EOF'
import sys
import re

md_path = sys.argv[1]

with open(md_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

in_fenced_block = False
in_html_block = False
headings = []

for i, line in enumerate(lines, 1):
    stripped = line.strip()

    if stripped.startswith("```"):
        in_fenced_block = not in_fenced_block
        continue

    if re.match(r'<pre\s+class=.*?>', stripped):
        in_html_block = True
        continue
    if stripped == "</code></pre>":
        in_html_block = False
        continue

    if in_fenced_block or in_html_block:
        continue

    if stripped.startswith('#'):
        hashes, _, content = stripped.partition(' ')
        if not content:
            continue
        length = len(content)
        if length > 55:
            heading_level = len(hashes)
            headings.append((length, heading_level, i, content.strip(), md_path))

for length, level, line_num, content, path in headings:
    print(f"{length:03}|H{level}|{line_num:03}|{path}|{content}")

EOF

done

# Sort numerically by length in descending order
sort -r "$tmpfile" | while IFS='|' read -r length heading line path content; do
    echo "$length chars in $heading on line $line of $path"
    echo "     → $content"
done

rm -f "$tmpfile"

