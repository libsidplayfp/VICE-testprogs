Reading from a write-only or non-existing register returns the value left on the 
internal data bus, which is refreshed not only on writes but also on valid reads 
from the read-only registers. 

This test just writes to a write-only register, reads from a read-only register 
and then reads from a non-existing register. The last value should be the same 
from the previous read. 

The test could be expanded to check different combinations.
