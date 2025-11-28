#!/bin/bash

echo -e "content-type: text/html\n"

echo "<html><head><title>Paquets Debian</title></head><body>"
echo "<h1>Voici les paquets deb disponibles</h1>"

for i in $( ls /var/www/html/debian ); do
    echo "<p><a href=\"/debian/$i\" title=\"Telecharger\" download> $i </a></p>"
done

echo "</body></html>