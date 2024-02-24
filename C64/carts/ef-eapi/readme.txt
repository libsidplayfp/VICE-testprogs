test-eapi.crt:  checks if AFTER calls to the EAPI functions the registers, CPU
status, and cartridge bank is the same as with the original 29F040 EAPI. Some
programs apparently rely on it more than they should have.

the left side of the screen shows register,status,bank tags *before* calling the
function, right side *after* the function returned. The colors on the left side
indicate which values are the same (green) or different (yellow) when the
function returns. The colors on the right side indicate what values are as
expected (green) or wrong (red) when the function returns.

