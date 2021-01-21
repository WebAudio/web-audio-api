#!/bin/bash

# Create a zip file containing everything we need to publish a CR.
# This assumes you've updated index.bs to add/change:
#   Status: CR
#   Date: <cr date>
#   Deadline: <one month past date>
#   Prepare for TR: yes

# Compile the spec, exit immediately if compile.sh fails
set -e
./compile.sh

# Create zip file of the things we need.  First the basic stuff.
rm -f cr.zip
zip cr index.html style.css implementation-report.html test-report.html favicon.png
# Now add all the images, but we don't need the graffle sources.
zip cr `find images | grep -v graffle`
