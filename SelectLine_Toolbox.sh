#!/bin/bash
#Creates sl.chache file in tmp-Directory with current valid Toolbox-Code for SelectLine ERP

FILE=/tmp/sl.cache
DATECUR=$(date +%d.%m.%Y)

USER='$$$Username$$$' # <--- CHANGE THIS
PASS='$$$Password$$$' # <--- CHANGE THIS

if test -f "$FILE"; then
        LINE=$(head -1 $FILE)

        if [ "$LINE" \> "$DATECUR" ]; then
        exit 1;
        else
        rm -rf $FILE
        fi
fi

touch cookies

curl -s -b cookies -c cookies 'https://www.selectline.de/wp-login.php' \
  -H 'Cookie: cookieconsent_status=allow;' \
  --data-raw 'log='"$USER"'&pwd='"$PASS"'&wp-submit=Anmelden&redirect_to=https%3A%2F%2Fwww.selectline.de%2Fwp-admin%2F%3Floginerror%3D1&testcookie=1' \
  --compressed > /dev/null

curl -s -b cookies -c cookies 'https://www.selectline.de/wp-admin/admin-ajax.php' \
  --data-raw 'action=getToolboxCodeData' \
  --compressed | egrep -m2 -o '(0[1-9]|[1-2][0-9]|3[0-1]).(0[1-9]|1[0-2]).[0-9]{4}' | tail -n1 >> $FILE

curl -s -b cookies -c cookies 'https://www.selectline.de/wp-admin/admin-ajax.php' \
  --data-raw 'action=getToolboxCodeData' \
  --compressed | egrep -o '[0-9A-F]{20}' >> $FILE

rm -rf cookies

# To display Code on bash use this:
# cat /tmp/sl.cache | head -2 | tail -1