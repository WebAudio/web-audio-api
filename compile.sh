#!/bin/bash

usage () {
    echo "compile.sh [-Kh?]"
    echo "   -K       Keep the actual-errs.txt.  Useful for updating"
    echo "            expected-errs.txt.  (Otherwise removed when done.)"
    echo "   -h       This help"
    echo "   -?       This help"
    exit 0
}

KEEP=no
while getopts "Kh?" arg
do
  case $arg in
      K) KEEP=yes ;;
      h) usage ;;
      \?) usage ;;
  esac
done
  
# So we can see what we're doing
set -x

# Output from bikeshed is logged here, along with a version with line
# numbers stripped out.
BSLOG="bs.log"
ERRLOG="actual-errs.txt"

# Remove ERRLOG when we're done with this script, but keep BSLOG so we
# can update the expected errors.
if [ "$KEEP" = "no" ]; then
trap "rm $ERRLOG" 0
fi

# Run bikeshed and save the output.  You can use this output as is
# to update expected-errs.txt.
bikeshed --print=plain -f spec 2>&1 | tee $BSLOG
# Remove the line numbers from the log, and make sure it ends with a newline.
# Also remove any lines that start "cannot identify image file" because the path
# is based the machine doing the build so we don't want that in the results.
sed 's;^LINE [0-9]*:;LINE:;' $BSLOG |
  sed '/^cannot identify image file/d' |
  sed -e '$a\' > $ERRLOG
# Do the same for the expected errors and compare the two.  Any
# differences need to be fixed.  Exit with a non-zero exit code if
# there are any differences.
(sed 's;^LINE [0-9]*:;LINE:;' expected-errs.txt |
   sed '/^cannot identify image file/d' |
   sed -e '$a\' |
   diff -u - $ERRLOG) || exit 1

