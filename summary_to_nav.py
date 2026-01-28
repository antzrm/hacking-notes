import sys
import re

def parse_summary(lines):
    nav = []
    stack = [nav]

    for line in lines:
        # Skip empty lines or lines without links
        if not line.strip() or not line.strip().startswith('*'):
            continue
        
        # Count leading spaces (2 spaces = 1 indent level in GitBook)
        indent = (len(line) - len(line.lstrip(' '))) // 2

        # Extract title and link from markdown link format: [Title](path.md)
        match = re.search(r'\[(.+?)\]\((.+?)\)', line)
        if not match:
            continue
        
        title, link = match.group(1), match.group(2)

        # Create the entry to add
        entry = {title: link}

        # Adjust stack for current indent level
        while len(stack) > indent + 1:
            stack.pop()

        # Append entry in the right place
        stack[-1].append(entry)

        # Prepare for children (if any)
        stack.append(entry.setdefault('children', []))

    return nav

def print_nav(nav, level=0):
    indent = '  ' * level
    for item in nav:
        for title, content in item.items():
            if isinstance(content, list):
                # nested section
                print(f"{indent}- {title}:")
                print_nav(content, level + 1)
            else:
                # leaf page
                print(f"{indent}- {title}: {content}")

if __name__ == "__main__":
    with open('SUMMARY.md', 'r', encoding='utf-8') as f:
        lines = f.readlines()

    nav = parse_summary(lines)

    print("nav:")
    print_nav(nav)

