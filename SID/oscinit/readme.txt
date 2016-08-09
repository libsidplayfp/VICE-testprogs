The oscillator's value is $555555 at power up (all bits are 1 but odd ones are 
stored inverted) and is not changed on reset. 

This test checks the oscillator value. It should pass if run right after power 
up and fail after a reset if voice 3 has been used.
