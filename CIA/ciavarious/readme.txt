
various CIA tests, originally by andre fachat.

the src dir contains the original tests which can be run like this:

LOAD"CIAn",8
LOAD"CIAnDATA",8,1
RUN

Now press keys A, B, ... for various tests. 
Last key varies but Last+1 key won't change screen.

Green characters indicate success, red characters indicate failure.

the following tests depend on old vs new CIA:

CIA3    K, L
CIA3A   D, H
CIA4    X
CIA8    A,C,F,J,L

additional reference data for new CIA has been added.

alternatively this directory contains packed/linked prg files of each test that
can be loaded and run directly.

FIXME:
- Test C of CIA15 fails on both of my machines, with "old" and "new" CIA. This
  is either a bug in the original test, or the reference data was dumped on a
  machine with some strange CIA (gpz)
- verify new CIA tests on real C64s


