#!/bin/bash

# So we can see what we're doing
set -x

# Output from bikeshed is logged here, along with a version with line
# numbers stripped out.
BSLOG="bs.log"
ERRLOG="actual-errs.txt"

# Remove it when we're done with this script.
trap "rm $BSLOG $ERRLOG" 0

# Run bikeshed and save the output.  You can use this output as is
# to update expected-errs.txt.
bikeshed --print=plain -f spec 2>&1 | tee $BSLOG
# Remove the line numbers from the log, and make sure it ends with a
# newline.
sed 's;^LINE [0-9]*:;LINE:;' $BSLOG | sed -e '$a\' > $ERRLOG
# Do the same for the expected errors and compare the two.  Any
# differences need to be fixed.  Exit with a non-zero exit code if
# there are any differences.
(sed 's;^LINE [0-9]*:;LINE:;' expected-errs.txt | sed -e '$a\' | diff -u - $ERRLOG) || exit 1

# If the out directory exists, copy everything needed for the HTML
# version of the spec to the out directory.

if [ -d out ]; then
    if [ ! -d out/images ]; then
	mkdir out/images || exit 1
    fi
    cp index.html out
    cp images/*.png out/images
    cp images/*.svg out/images
fi
