#!/bin/bash

set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Using the ADL submodule
HASKELLDIR=$HERE/../../../haskell/adl/haskell/
ADLSTDLIBDIR=$(cd $HASKELLDIR; stack exec adlc -- show --adlstdlib)

GENDIR=${HERE}/../src/adl-gen
SYSTEMADLSRCS=$(find $ADLSTDLIBDIR \
    -type d -name adlc -prune \
    -o \
    -type f -name '*.adl' -print)

rm -rf $GENDIR
mkdir -p $GENDIR

# Build ADL and dependencies setup
(cd $HASKELLDIR; stack build ./compiler)
(cd $HASKELLDIR; stack exec adlc -- typescript -I $ADLSTDLIBDIR -O $GENDIR --include-rt --include-resolver --runtime-dir runtime $SYSTEMADLSRCS)
