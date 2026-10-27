#!/bin/bash

# So we can see what we're doing
set -x

# Run bikeshed and exit with a non-zero exit code if there are any errors.
bikeshed --print=plain --die-on=everything spec || exit 1
