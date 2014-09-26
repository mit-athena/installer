#!/bin/sh

# To minimize the number of places we hardcode things, we use the
# preseed URL to figure out where to get the tarball from.
# This will break if the .preseed and tarball are not in the same
# location.  "Don't do that."

# "Because debconf"
chmod 755 $0

. /usr/share/debconf/confmodule

URI="$(debconf-get preseed/url | sed -e 's/debathena\.preseed$/debathena.tar.gz/')"
LOGFILE="/var/log/debathena-loader.log"

if [ -n "$URI" ]; then
    cd /
    echo "Retrieving $URI" >> "$LOGFILE"
    wget "$URI" >> "$LOGFILE" 2>&1
    echo "Extracting tarball" >> "$LOGFILE"
    [ -f debathena.tar.gz ] && tar xzf debathena.tar.gz >> "$LOGFILE" 2>&1
    echo "Executing installer.sh" >> "$LOGFILE"
    [ -x /debathena/installer.sh ] && exec /debathena/installer.sh
    echo "Could not execute /debathena/installer.sh" >> $LOGFILE
else
    echo "Error: failed to retrieve preseed/url from debconf" >> $LOGFILE
fi

cat <<EOF > /debathena-loader.templates
Template: debathena-loader/ohnoes
Type: note
Description: Installation Aborted
 Fatal error: debathena-loader.sh did not complete.
 .
 Log files can be found in $LOGFILE
 .
 This may indicate a network issue.  Please try again.
 If the problem persists, please contact release-team@mit.edu.
EOF
db_x_loadtemplatefile /debathena-loader.templates debathena-loader
while true; do
  db_title "Fatal Error"
  db_input critical debathena-loader/ohnoes
  db_go
done
