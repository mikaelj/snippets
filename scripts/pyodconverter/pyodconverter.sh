#!/bin/bash

# Try to autodetect OOFFICE and OOOPYTHON.
OOFFICE=`ls /usr/bin/openoffice.org2.4 /usr/bin/ooffice /usr/lib/openoffice/program/soffice | head -n 1`
OOOPYTHON=`ls /opt/openoffice.org*/program/python /usr/bin/python | head -n 1`

if [ ! -x "$OOFFICE" ]
then
 echo "Could not auto-detect OpenOffice.org binary"
 exit
fi

if [ ! -x "$OOOPYTHON" ]
then
 echo "Could not auto-detect OpenOffice.org Python"
 exit
fi

echo "Detected OpenOffice.org binary: $OOFFICE"
echo "Detected OpenOffice.org python: $OOOPYTHON"

# Reference: http://wiki.services.openoffice.org/wiki/Using_Python_on_Linux
# If you use the OpenOffice.org that comes with Fedora or Ubuntu, uncomment the following line:
# export PYTHONPATH="/usr/lib/openoffice.org/program" 

# If you want to simulate for testing that there is no X server, uncomment the next line.
#unset DISPLAY

# Kill any running OpenOffice.org processes.
killall -u `whoami` -q soffice

# Download the converter script if necessary.
test -f DocumentConverter.py || wget http://www.artofsolving.com/files/DocumentConverter.py

# Start OpenOffice.org in listening mode on TCP port 8100.
$OOFFICE "-accept=socket,host=localhost,port=8100;urp;StarOffice.ServiceManager" -norestore -nofirststartwizard -nologo -headless  &

# Wait a few seconds to be sure it has started.
sleep 5s

# Convert as many documents as you want serially (but not concurrently).
# Substitute whichever documents you wish.
$OOOPYTHON DocumentConverter.py sample.ppt sample.swf
$OOOPYTHON DocumentConverter.py sample.ppt sample.pdf

# Close OpenOffice.org.
killall -u `whoami` soffice
