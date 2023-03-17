    1 open4,4
    2 cmd4
    3 printtab(20);
    4 printchr$(1);
    5 print" {rvon}{SHIFT-POUND}       "
    6 printtab(20);
    7 printchr$(1);
    8 print"{rvon}{SHIFT-POUND}        "
    9 printtab(20);
   10 printchr$(1);
   11 print"{rvon}  {rvof}      {rvon}     {rvof}{SHIFT-POUND}"
   12 printtab(20);
   13 printchr$(1);
   14 print"{rvon}  {rvof}      {rvon}    {rvof}{SHIFT-POUND}"
   15 printtab(20);
   16 printchr$(1);
   17 print"{rvon}  {rvof}      {rvon}   {rvof}{SHIFT-POUND}"
   18 printtab(20);
   19 printchr$(1);
   20 print"{rvon}  {rvof}      {rvon}   {CBM-*}"
   21 printtab(20);
   22 printchr$(1);
   23 print"{rvon}  {rvof}      {rvon}    {CBM-*}"
   24 printtab(20);
   25 printchr$(1);
   26 print"{rvon}  {rvof}      {rvon}     {CBM-*}"
   27 printtab(20);
   28 printchr$(1);
   29 print"{CBM-*}{rvon}        "
   30 printtab(20);
   31 printchr$(1);
   32 print" {CBM-*}{rvon}       "
   35 print:print:print
   50 c$(1)="   ccc  "
   51 c$(2)="  c   c "
   52 c$(3)=" c      "
   53 c$(4)=" c      "
   54 c$(5)=" c      "
   55 c$(6)="  c   c "
   56 c$(7)="   ccc  "
   57 o$(1)="   oo   "
   58 o$(2)="  o  o  "
   59 o$(3)=" o    o "
   60 o$(4)=" o    o "
   61 o$(5)=" o    o "
   62 o$(6)="  o  o  "
   63 o$(7)="   oo   "
   65 m$(1)=" m    m "
   66 m$(2)=" mm  mm "
   67 m$(3)=" m mm m "
   68 m$(4)=" m mm m "
   69 m$(5)=" m    m "
   70 m$(6)=" m    m "
   71 m$(7)=" m    m "
   75 d$(1)=" ddd    "
   76 d$(2)=" d  d   "
   77 d$(3)=" d   d  "
   78 d$(4)=" d   d  "
   79 d$(5)=" d   d  "
   80 d$(6)=" d  d   "
   81 d$(7)=" ddd    "
   85 r$(1)=" rrrrr  "
   86 r$(2)=" r    r "
   87 r$(3)=" r    r "
   88 r$(4)=" rrrrr  "
   89 r$(5)=" r  r   "
   90 r$(6)=" r   r  "
   91 r$(7)=" r    r "
   95 e$(1)=" eeeeee "
   96 e$(2)=" e      "
   97 e$(3)=" e      "
   98 e$(4)=" eeee   "
   99 e$(5)=" e      "
  100 e$(6)=" e      "
  101 e$(7)=" eeeeee "
  105 fori=1to7
  106 printc$(i)o$(i)m$(i)m$(i)o$(i)d$(i)o$(i)r$(i)e$(i):next
  107 print:print:print
  111 printchr$(1)chr$(1)"commodore"
  112 printchr$(1)chr$(1)spc(8)"business"
  113 printchr$(1)chr$(1)spc(15)"machines"
  114 printchr$(1)chr$(1)spc(22)"inc."
  117 x$="presents"
  118 print"{$0a}{CTRL-A}{CTRL-A}"tab((25-len(x$))/2)x$
  119 x$="the"
  120 print"{$0a}{CTRL-A}{CTRL-A}"tab((25-len(x$))/2)x$
  121 x$="model"
  122 print"{$0a}{CTRL-A}{CTRL-A}"tab((25-len(x$))/2)x$
  123 x$="2022 & 2023"
  124 print"{$0a}{CTRL-A}{CTRL-A}"tab((25-len(x$))/2)x$
  125 x$="printers"
  126 print"{$0a}{CTRL-A}{CTRL-A}"tab((25-len(x$))/2)x$
  127 fori=1to79:print"W";:next:x$=""
  260 printchr$(1)"each printer has full graphic capacity"
  280 print:printchr$(1)"upper case"
  285 printchr$(1)"{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}"
  290 print:forj=33to90:x$=x$+chr$(j):next:printtab((80-len(x$))/2)x$
  300 print:print:printchr$(1)"{down}lower case"
  305 printchr$(1)"{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}"
  310 print:x$="{down}":forj=33to90:x$=x$+chr$(j):next:printtab((80-len(x$))/2)x$
  320 print:print:printchr$(1)"{rvon}{up} reverse field upper case"
  325 printchr$(1)"{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}"
  330 print:x$="{rvon}":forj=33to90:x$=x$+chr$(j):next:printtab((80-len(x$))/2)x$
  340 print:print:printchr$(1)"{rvon}{down} reverse field lower case"
  345 printchr$(1)"{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}"
  350 print:x$="{rvon}{down}":forj=33to90:x$=x$+chr$(j):next:printtab((80-len(x$))/2)x$
  360 print:print:printchr$(1)"{rvof}graphics"
  365 printchr$(1)"{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}"
  370 x$="ABCDEFGHIJKLMNOPQRSTUVWXYZ{SHIFT-*}{SHIFT-+}{SHIFT--}{CBM-C}{CBM-V}{CBM-D}{CBM-F}{CBM-B}{SHIFT-@}~{CBM-*}{SHIFT-POUND}{CBM-POUND}{CBM--}{CBM-+}{CBM-M}{CBM-G}{CBM-@}{CBM-T}{CBM-I}{CBM-K}{CBM-A}{CBM-S}{CBM-Z}{CBM-X}{CBM-Q}{CBM-W}{CBM-R}{CBM-E}{CBM-H}{CBM-J}{CBM-L}{CBM-N}{CBM-P}{CBM-O}{CBM-U}{CBM-Y}"
  371 printtab((80-len(x$))/2)x$
  380 print:print:printchr$(1)"{rvon} reverse field graphics"
  385 printchr$(1)"{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}"
  390 x$="{rvon}ABCDEFGHIJKLMNOPQRSTUVWXYZ{SHIFT-*}{SHIFT-+}{SHIFT--}{CBM-C}{CBM-V}{CBM-D}{CBM-F}{CBM-B}{SHIFT-@}~{CBM-*}{SHIFT-POUND}{CBM-POUND}{CBM--}{CBM-+}{CBM-M}{CBM-G}{CBM-@}{CBM-T}{CBM-I}{CBM-K}{CBM-A}{CBM-S}{CBM-Z}{CBM-X}{CBM-Q}{CBM-W}{CBM-R}{CBM-E}{CBM-N}{CBM-L}{CBM-J}{CBM-H}{CBM-P}{CBM-O}{CBM-U}{CBM-Y}"
  391 printtab((80-len(x$))/2)x$
  392 print:print
  401 fori=1to79:print"#";:next:print
  402 print"{CTRL-A}you can easily construct graphs"
  405 print:print
  406 printtab(20)"stock"
  407 printtab(20)"     0      millions of shares      100"
  408 printtab(20)"     {CBM-A}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{CBM-S}"
  409 printtab(20)" #1  {SHIFT--}{rvon}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{CBM--}{rvof}                  {SHIFT--}"
  410 printtab(20)"     {CBM-Q}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{CBM-W}"
  413 printtab(20)" #2  {SHIFT--}{rvon}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{SHIFT-+}{rvof}         {SHIFT--}"
  414 printtab(20)"     {CBM-Q}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{CBM-W}"
  415 printtab(20)" #3  {SHIFT--}{rvon}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{CBM-POUND}{rvof}              {SHIFT--}"
  416 printtab(20)"     {CBM-Q}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{CBM-W}"
  418 printtab(20)" #4  {SHIFT--}{rvon}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{CBM-B}{rvof}               {SHIFT--}"
  419 printtab(20)"     {CBM-Q}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{CBM-W}"
  420 printtab(20)" #5  {SHIFT--}{rvon}{CBM-+}{CBM-M}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-M}{CBM-M}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-+}{CBM-M}{CBM-+}{rvof}         {SHIFT--}"
  421 printtab(20)"     {CBM-Z}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{CBM-X}"
  422 x$="horizontal bar graphs":printtab((80-len(x$))/2)x$
  500 print:print:fori=1to80:print"S";:next:print:print
  501 printchr$(1)"or format data in concise charts"
  510 print:print:printchr$(1)spc(7)"mortgage amortization table"
  511 printspc(19)"principal $ 2100    at 6 %    for 1.0 years"
  512 printspc(29)"regular payment = $ 75"
  515 print:print:printspc(11)"{CBM-A}";:fori=1to57:print"{SHIFT-*}";:next:print"{CBM-S}"
  516 printspc(11)"{SHIFT--} n{down}o{up} {SHIFT--} i{down}nterest{up} {SHIFT--} a{down}mortization{up} {SHIFT--} b{down}alance{up} {SHIFT--}";
  517 print" a{down}ccum{up} i{down}nterest{up} {SHIFT--}"
  518 printspc(11)"{CBM-Q}";:fori=1to57:print"{SHIFT-*}";:next:print"{CBM-W}"
  519 printspc(11)"{SHIFT--}    {SHIFT--}          {SHIFT--}              {SHIFT--}         {SHIFT--}                {SHIFT--}"
  520 printspc(11)"{SHIFT--}  1 {SHIFT--}$ 10.50   {SHIFT--}$   64.50     {SHIFT--}$2035.50 {SHIFT--}$     10.50     {SHIFT--}"
  521 printspc(11)"{SHIFT--}  2 {SHIFT--}  10.18   {SHIFT--}    64.82     {SHIFT--} 1970.68 {SHIFT--}      20.68     {SHIFT--}"
  522 printspc(11)"{SHIFT--}  3 {SHIFT--}   9.85   {SHIFT--}    65.15     {SHIFT--} 1905.53 {SHIFT--}      30.53     {SHIFT--}"
  523 printspc(11)"{SHIFT--}  4 {SHIFT--}   9.53   {SHIFT--}    65.47     {SHIFT--} 1840.06 {SHIFT--}      40.06     {SHIFT--}"
  524 printspc(11)"{SHIFT--}  5 {SHIFT--}   9.20   {SHIFT--}    65.80     {SHIFT--} 1774.26 {SHIFT--}      49.26     {SHIFT--}"
  525 printspc(11)"{SHIFT--}  6 {SHIFT--}   8.87   {SHIFT--}    66.13     {SHIFT--} 1708.13 {SHIFT--}      59.13     {SHIFT--}"
  526 printspc(11)"{SHIFT--}  7 {SHIFT--}   8.54   {SHIFT--}    66.46     {SHIFT--} 1641.67 {SHIFT--}      66.67     {SHIFT--}"
  527 printspc(11)"{SHIFT--}  8 {SHIFT--}   8.21   {SHIFT--}    66.79     {SHIFT--} 1574.88 {SHIFT--}      74.88     {SHIFT--}"
  528 printspc(11)"{SHIFT--}  9 {SHIFT--}   7.87   {SHIFT--}    67.13     {SHIFT--} 1507.75 {SHIFT--}      82.75     {SHIFT--}"
  529 printspc(11)"{SHIFT--} 10 {SHIFT--}   7.54   {SHIFT--}    67.46     {SHIFT--} 1440.29 {SHIFT--}      90.29     {SHIFT--}"
  530 printspc(11)"{SHIFT--} 11 {SHIFT--}   7.20   {SHIFT--}    67.80     {SHIFT--} 1372.49 {SHIFT--}      97.49     {SHIFT--}"
  531 printspc(11)"{SHIFT--} 12 {SHIFT--}   6.86   {SHIFT--}    68.14     {SHIFT--} 1304.35 {SHIFT--}     104.35     {SHIFT--}"
  535 printspc(11)"{CBM-Z}";:fori=1to57:print"{SHIFT-*}";:next:print"{CBM-X}"
  602 print:print:fori=1to79:print"V";:next:print:print
  603 printtab(39)"you":print
  604 printtab(39)"can":print
  605 printtab(35)chr$(1)"print":print:print
  606 printtab(26)chr$(1)chr$(1)"enhanced":print:print
  607 printtab(20)chr$(1)chr$(1)chr$(1)"characters"
  608 print:print:print
  609 printtab(10)chr$(1)"i{down}deal for your report headings."
  610 print:print:fori=1to79:print"&";:next:print:print
  630 a$=chr$(28)+chr$(34)+chr$(65)+chr$(65)+chr$(54)+chr$(34)
  631 open5,4,5
  632 print#5,a$:cmd4
  633 print"{CTRL-A}and for specific needs, you can even"
  634 printchr$(1)"design and print your own characters":print:print:print
  635 printtab(10);:fori=1to7:printchr$(254)chr$(1)" ";:next
  636 b$=chr$(17)+chr$(18)+chr$(124)+chr$(18)+chr$(17)+chr$(0)
  637 c$=chr$(7)+chr$(119)+chr$(95)+chr$(95)+chr$(119)+chr$(7)
  638 print:print
  639 print#5,b$:cmd4
  640 printtab(10);:fori=1to7:printchr$(254)chr$(1)" ";:next
  641 print:print
  642 print#5,c$:cmd4
  643 printtab(10);:fori=1to7:printchr$(254)chr$(1)" ";:next
  644 print:print
  650 fori=1to79:print"{CBM-B}";:next
  651 print:print:print"{CTRL-A}{CTRL-A}other benefits include:":print:print
  652 print"{CTRL-A}model 2023:"
  653 printspc(10)"1) f{down}ast{up}-o{down}nly{up} m{down}oments{up} b{down}efore{up} y{down}our{up} d{down}ata{up} i{down}s{up} ";
  654 print"p{down}ermanently{up} r{down}ecorded"
  655 printspc(10)"2) e{down}asy t{down}o{up} u{down}se{up}-e{down}liminates{up} c{down}omplex{up} i{down}nterfacing"
  656 printspc(10)"3) a{down}n{up} i{down}ntelligent{up} p{down}eripheral{up}- d{down}oes{up} n{down}ot{up} u{down}se{up} t{down}he";
  657 print" {up}c{down}omputer's{up} m{down}emory!{up}"
  658 printspc(10)"4) s{down}elf{up}-d{down}iagnostic {up}t{down}est{up} p{down}erformed{up} a{down}t{up} p{down}ower-up.
  659 printspc(10)"5) u{down}ses{up} s{down}tandard{up} p{down}aper{up} a{down}nd{up} r{down}ibbon"
  660 printspc(10)"6) s{down}erviced{up} b{down}y{up} o{down}ver{up} {CTRL-A}400 d{down}ealers"
  661 printspc(10)"7) a{down}n{up} o{down}utstanding{up} v{down}alue{up} a{down}t{up} o{down}nly{up} {CTRL-A}$849.00"
  666 print:print:print
  670 print"{CTRL-A}{CTRL-A}model 2022:"
  671 printspc(10)"1) h{down}as{up} a{down}ll{up} o{down}f{up} t{down}he{up} a{down}bove{up} f{down}eatures{up} p{down}lus-"
  672 printspc(10)"2) o{down}ffers{up} t{down}ractor{up} f{down}eed{up} m{down}echanism{up} f{down}or{up} p{down}recise{up} d{down}ocument";
  673 print"{up} f{down}eed{up} c{down}ontrol"
  674 printspc(10)"3) h{down}andles{up} a{down}ny{up} s{down}tandard{up} p{down}in{up} f{down}eed{up} f{down}orm{up}-f{down}or{up} a{down}ll{up}";
  675 print" y{down}our{up} b{down}usiness{up} n{down}eeds"
  676 printspc(10)"4) f{down}eatures{up} p{down}rogrammable{up} l{down}ine{up} s{down}pacing{up} f{down}or{up} c{down}ustom";
  677 print" {up}n{down}eeds"
  678 printspc(10)"5) e{down}conomically{up} p{down}riced{up} a{down}t{up} o{down}nly{up} {CTRL-A}{CTRL-A}$995.00"
  680 fori=1to79:print"{SHIFT-+}";:next:print
  690 print"{CTRL-A}see the other fine commodore products"
  695 print"{CTRL-A} including:{$0a}"
  700 print"{CTRL-A} the cbm business keyboard computer "
  710 print"{CTRL-A} the pet graphics keyboard computer "
  720 print"{CTRL-A}  & the cbm 2040 dual drive floppy disk "
  730 print"{CTRL-A} at your local commodore dealer."
10000 print#4:close4
