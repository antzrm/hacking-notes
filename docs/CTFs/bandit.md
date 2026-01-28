# OverTheWire - Bandit

## Open a file called **-

```
bandit1@bandit:~$ cat ./-
```

## **Bandit 5 -> Bandit 6**

1. Human — readable
2. 1033 bytes in size
3. Not executable

| Option             | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| `-type f`           | File is of type: **regular file**                                              |
| `-readable`         | Matches files which are readable                                               |
| `-executable`       | Matches files which are **executable** & directories which are **searchable**  |
| `! -executable`     | Matches files that are **NOT** executable & directories which are **NOT** searchable |
| `-size 1033c`       | File uses 1033 units of space. `c` refers to **bytes**                         |

```
find . -type f -readable -size 1033c ! -executable
```

## Grab unique line

```
cat data.txt | sort | uniq -u
```

## Hex dump to text

```
xdd -r $fileHexDump $newFile
```

## &#x20;**Localhost port** w/ SSL encryption

[https://www.feistyduck.com/library/openssl-cookbook/online/ch-testing-with-openssl.html](https://www.feistyduck.com/library/openssl-cookbook/online/ch-testing-with-openssl.html)

## SSH logs out automatically

SSH logs us out automatically after logging in through SSH because .bashrc was modified. But we can execute commands in SSH directly:

```
ssh bandit18@bandit.labs.overthewire.org -p 2220 cat /home/bandit18/readme
```

## Setuid binaries

[Setuid](https://en.wikipedia.org/wiki/Setuid)

Execute a binary as another user and read a file:

```
./bandit20-do id=11020 cat /etc/bandit_pass/bandit20
```



## Bandit Level 20 → Level 21

There is a setuid binary in the homedirectory that does the following: it makes a connection to localhost on the port you specify as a commandline argument. It then reads a line of text from the connection and compares it to the password in the previous level (bandit20). If the password is correct, it will transmit the password for the next level (bandit21).

[https://medium.com/secttp/overthewire-bandit-level-20-a1af9a042c56](https://medium.com/secttp/overthewire-bandit-level-20-a1af9a042c56)

Bandit 24 --> UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ
