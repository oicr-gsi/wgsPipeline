#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

cd $1
ls -1
find . -regex '.*\.txt$' -exec sh -c "wc -l {}" \;