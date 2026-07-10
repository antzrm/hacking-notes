## Detecting Patterns
- ROT1 - common words look “one letter off”, spaces stay the same. Easy enough to detect.
- ROT13 - Look for three-letter words. Common ones like  `the` become `gur`. And `and` becomes `naq`. spaces stay the same.
- Base64 - Long strings containing mostly alphanumeric characters (i.e., `A-Z`, `a-z`, `0–9`), sometimes with `+` or `/`, often ending in `=` or `==`.
- XOR - A bit more tricky. Looks like random symbols but stays the same length as the original. If a short secret was reused, you may notice a tiny repeat every few characters.
## Unfamiliar Patterns
Cyberchef > Recipe `Magic`> Intensive mode ON