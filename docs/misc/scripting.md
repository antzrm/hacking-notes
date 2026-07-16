# Scripting



## Bash

### Pitfalls / Vulnerabilities

[https://mywiki.wooledge.org/BashPitfalls](https://mywiki.wooledge.org/BashPitfalls)

## unix2dos
> Formatting, weird characters, encoding issues

`unix2dos`

## TOCTOU
> Time-of-check-time-of-use

If I can run a command between the time that it checks the target of the link and when it prints the contents of the file, I can change the target of the link.

## Go - asdf 
> Go version manager

```
- Download binary from Github releases and put it in ~/.local/bin

- Add this to ~/.zshrc
if command -v asdf &>/dev/null; then                                                                                                                                         
  eval "$(asdf env setup)"                                                                                                                                                   
fi                                                                                                                                                                           
                                                                                                                                                                             
export PATH="$HOME/.asdf/shims:$PATH"                                                                                                                                        
export PATH="$(asdf where golang)/bin:$PATH"

- Then install golang
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
asdf install golang latest
```


```go
export GOROOT=/usr/lib/go
go build
# Reduce binary size
go build -ldflags "-s -w" .
upx $BINARY
```

## pwntools

<pre class="language-python"><code class="lang-python"><strong>https://guyinatuxedo.github.io/02-intro_tooling/pwntools/index.html
</strong><strong>
</strong><strong>import * from pwn
</strong>...
if __name__ == '__main__':
	try: 
		makeRequest()
	except Exception as e:
		log.error(str(e))
		
# Get interactive revshell
shell = listen(PORT, timeout=20).wait_for_connection()
if shell.sock is not None:
	shell.interactive()
else:
	print("\n[!]No shell connection")
</code></pre>
## Badchars detection on a web register


```python
import requests
import string
import sectrets

loginurl = "http://10.10.10.0/login.php"
registerurl = "http://10.10.10.0/signup.php"
# Get all the symbols and add them in a list
characters = string.punctuaction
print("Blacklisted Characters: ")
# Iterate the list
for char in characters:
        # Create a random amount of hex characters
        random = secrets.token_hex(10)
        # Fill the username and password with letters
        data = {'email':f"{random}@test.test", 'username': char, 'password':'a', 'submit':''}
        r = requests.post(url = resgisterurl, data = data)
        data = {'username':char, 'password':'a', 'submit':''}
        r = requests.post(url = loginurl, data = data)
        # Check if we can log in with that specific character in the username
        if "incorrect" in r.text:
                print(char)
```


