#!/bin/bash

# So we can see what we're doing
set -x

# Output from bikeshed is logged here, along with a version with line
# numbers stripped out.
BSLOG="bs.log"
ERRLOG="actual-errs.txt"

# Remove ERRLOG when we're done with this script, but keep BSLOG so we
# can update the expected errors.
trap "rm $ERRLOG" 0

# Run bikeshed and save the output.  You can use this output as is
# to update expected-errs.txt.
bikeshed --print=plain -f spec 2>&1 > $BSLOG
# Remove the line numbers from the log, and make sure it ends with a
# newline.
sed 's;^LINE [0-9]*:;LINE:;' $BSLOG | sed -e '$a\' > $ERRLOG
# Do the same for the expected errors and compare the two.  Any
# differences need to be fixed.  Exit with a non-zero exit code if
# there are any differences.

sed 's;^LINE [0-9]*:;LINE:;' expected-errs.txt | sed -e '$a\' | diff -u - $ERRLOG

if [[ $? -ne 0 ]]
then
  echo "Actual errors are not exactly what is expected, log provided below:"
  cat $BSLOG
  exit 1
fi

