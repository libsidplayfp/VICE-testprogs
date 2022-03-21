poke 37139,0  : poke 37154,0  : rem via1 ddra=in,  via2 ddrb=in
s1=peek(37137): s2=peek(37152): rem via1 pa,       via2 pb
poke 37139,255: poke 37154,255: rem via1 ddra=out, via2 ddrb=out
poke 37137,0  : poke 37152,0
s3=peek(37137): s4=peek(37152): rem via1 pa,       via2 pb
poke 37137,255: poke 37152,255
s5=peek(37137): s6=peek(37152): rem via1 pa,       via2 pb

poke 37139,0:poke 37154,255
print "{clear}"
print s1;s2
print s3;s5
print s4;s6
run
