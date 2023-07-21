

This program first writes a long(er) pause, then a series of $20/$40/$60/$40
pulses to an attached tap file (create/attach one before running.

The -inv version writes the same waveform, but inverted. The diagram below
illustrates the outcome - the inverted version produces a sequence like
$30/$50/$50/$30

-------------------------------------------------------------------------------

normal:


 10         2  2  4    4    6      6      4    4    2  2  4    4    6      6      4    4        cycles

0..........1..0..1....0....1......0......1....0....1..0..1....0....1......0......1....0....1    output bit
___________    __      ____        ______      ____    __      ____        ______      ____
           !__!  !____!    !______!      !____!    !__!  !____!    !______!      !____!    !    written signal

-----------X-----X---------X-------------X---------X-----X---------X-------------X---------X    read pulses

           10    4         8             12        8     4         8             12        8    tap values


inverted:


 10         2  2  4    4    6      6      4    4    2  2  4    4    6      6      4    4        cycles

1..........0..1..0....1....0......1......0....1....0..1..0....1....0......1......0....1....0    output bit
            __    ____      ______        ____      __    ____      ______        ____
___________!  !__!    !____!      !______!    !____!  !__!    !____!      !______!    !____!    written signal

--------------X-------X-----------X-----------X-------X-------X-----------X-----------X-----    read pulses

              12      6           10          10      6       6           10          10        tap values
