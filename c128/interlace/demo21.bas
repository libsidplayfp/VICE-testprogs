   50 poke47,0:poke48,192:clr:rem variable start at $c000 to reserve ram for bitmaps in bank 1
   60 graphic1:graphic5,1:printtab(30)"{swlc}{CTRL-O}{down}{down}{down}{down}Switch to 40 Columns":graphic0
   70 du=peek(186):print"loading bm loader":bload"bm loader",b0,u(du)
   72 f$="circle":gosub710:rem load circle bitmap
   74 print"loading interlace code":bload"code 5",b0,u(du)
   76 print"loading fli text":bload"fli text",b0,u(du):sysdec("16c4"):rem generate interlaced font sets
   98 di=26:da=151:dz=217:rem initial cycle delay, lo byte of 1st and last address for cycle delays
  100 print"{clr}{down}{swlc}Interlace Video Demo 2
  105 print"Copyright (c) 2007, Robert Willie
  106 print"Dither bitmaps provided by Nikoniko.
  110 print"{down}This is free software provided under the
  115 print"General Public License (GPL) Version 2
  120 print"{down}ABSOLUTELY NO WARRANTY!
  125 print"{down}This program (tries) to produce on the
  130 print"VIC screen an interlaced image but does
  135 print"not strictly conform to video standards.
  140 print"It has been tested on a JVC 36-inch TV
  141 print"and on an ATI video capture card"
  145 print"but may cause problems for your display
  146 ifpeek(dec("a03"))thenbegin:print"{down}PAL detected. PAL has been reported":print"to work by others, but has *not* been":print"tested by the author.
  147 :vc=63:vr=312:cy=18/17.73447:rem vic cycles,rasters, cpu cycle time
  148 :poke5480,dz-5:rem cycle delay during timer b init
  149 :poke5467,vc-1:rem value for timer b
  150 bend:else vc=65:vr=263:cy=14/14.31818:rem ntsc constants
  160 print"{down}Press {rvon} RETURN {rvof} to continue
  161 print"Press any other key to quit"
  162 getkeya$:ifa$<>chr$(13)thenend
  165 sysdec("14da"):rrega:ifa<>4thenbegin:print"{clr}{down}Your VIC-IIe video chip is broken!":print"Please have a qualified technician fix  your computer."
  170 print"Tell them the VIC test bit is faulty.":print"{down}Press {rvon} RETURN {rvof} to use broken computer":print"Press any other key to quit"
  175 getkeya$:ifa$<>chr$(13)thenend
  180 bend
  299 rem *** main demo menu ***
  300 r(0)=4881:r(1)=5130:rem preraster lo
  301 rd(0)=5071:rd(1)=5142:rem cycle delay
  302 rt(0)=rd(0)-2:rt(1)=rd(1)-2:rem raster cut time, 3,4,or 0 rasters
  303 pv=5091:pc=5100:pg=5109:rem vic bank, color bank, and charset/bitmap for phase 0 (even field)
  304 xg=5174:rem toggle charset/bitmap for odd field
  305 ifpeek(dec("a03"))thengosub610:rem set pal default raster/cycle
  306 t(0)=1:t(1)=21:re=-1:pudef"0":rem tab stops and edit mode
  309 print"{clr}{down}"tab(11)"Interlace Demo 2{down}":sysdec("14f7"):rem copy clear text screen
  310 print" {rvon} SPACE {rvof} to ";:ifpeek(dec("315"))<21thenprint"disable";:elseprint"enable";
  311 print" interlace IRQ
  315 print" R. ";:ifpeek(pc)=0thenprint"Reverse";:elseprint"Reset";
  320 print" even/odd fields"
  325 print" V. View bitmap      L. Load bitmap
  330 print" T. View FLI Text
  335 print" H. Help/info        Q. Quit program
  338 printtab(13)"-- Presets --
  340 print" A. interlace default
  345 print" B. roll screen
  350 print" C. non-interlace
  355 print:fori=0to1:printtab(t(i));:ifre=ithenprint"{rvon} ESC {rvof} edit done";:elsebegin
  360 print"{left}"i"{left}. Edit ";:ifithenprint"odd";:elseprint"even";
  361 bend
  362 next:print
  365 print" --- Even Field ---  --- Odd Field ----
  370 fori=0to1:printtab(t(i));:gosub570:next:print
  375 fori=0to1:printtab(t(i));:gosub580:next:print
  380 fori=0to1:printtab(t(i));:gosub590:next:print
  385 ifre<0thenbegin
  390 fori=0to1:c(i)=(vr-dr(i))*vc:printtab(t(i))"#Cycles ="c(i);:next:print
  392 fori=0to1:tf(i)=c(i)*cy:printtab(t(i));:printusing"Time = ##.### ms";tf(i)/1000;:next:print
  394 fori=0to1:printtab(t(i));:printusing"Rate = ##.###Hz";1e6/tf(i);:next:print
  395 print" ----------- Complete Frame -----------
  396 printtab(12)"#Cycles ="c(0)+c(1)
  397 printtab(12);:printusing"Time = ##.### ms";(tf(0)+tf(1))/1000
  398 printtab(12);:printusing"Rate = ##.###Hz";1e6/(tf(0)+tf(1));
  399 sysdec("14f7"):rem copy full text screen
  400 getkeya$:bend:elsegosub500
  401 ifa$="q"thensysdec("1319"):end
  405 oninstr(" rvltabch01"+chr$(27),a$)gosub410,420,430,700,800,610,620,630,650,440,445,450:goto309
  410 ifpeek(dec("315"))<21thensysdec("1319"):elsesysdec("1300"):rem irq on/off
  415 return
  420 ifpeek(pc)=0thenpokepv,1:pokepc,2:elsepokepv,3:pokepc,0:rem reverse fields
  425 return
  430 ia=peek(dec("315")):sysdec("1319"):gosub720:ifia<21thenia=ti:do:loopwhileia=ti:sysdec("1300")
  435 return
  440 re=0:return
  445 re=1:return
  450 re=-1:return
  499 rem ** raster / cycle editor **
  500 print"{up}{up}{up}"tab(t(re))chr$(27)"t{down}{down}"
  501 print"{rvon} Up {rvof} Raster +
  505 print"{rvon} Down {rvof} Raster -
  510 print"{rvon} Left {rvof} Cycle -
  515 print"{rvon} Right {rvof} Cycle +
  517 print"N. No cut"
  520 print"3. Cut 3"
  525 print"4. Cut 4";
  530 sysdec("14f7"):getkeya$:k=instr("{up}{down}{left}{rght}43n",a$):ifk=0thenprint"{home}{home}":return
  535 onkgosub540,540,550,550,560,560,565:goto530
  540 i=peek(r(re))-256*(peek(r(re)+2)>0)-sgn(k-1.5)+vr:h=int(i/vr):i=i-h*vr:poker(re),iand255:poker(re)+2,(iand256)/2:print"{home}";:i=re:goto570
  550 i=peek(rd(re))-sgn(k-3.5):ifi>=daandi<=dzthenpokerd(re),i:i=re:print"{home}";:gosub570:print:gosub580:print:goto590:elsereturn:rem cycle change
  560 pokert(re),k-3:i=re:print"{home}{down}";:gosub580:print:goto590:rem cut 3 or 4
  565 pokert(re),0:i=re:print"{home}{down}";:gosub580:print:goto590:rem no cut
  570 t=3+peek(r(i))-256*(peek(r(i)+2)>0):ift>=vrthent=t-vr
  575 printusing"Cut raster = ###";t;:print"+";chr$(48+int((di+2*(dz-peek(rd(i))))/vc));:return
  580 d(i)=di+2*(dz-peek(rd(i))):print"Cut cycle ="d(i)-vc*int(d(i)/vc)"{left} ";:return
  590 dr(i)=(peek(rt(i))/2and1)*(4-(peek(rt(i))and1)):ifdr(i)thenprint"Cut ="dr(i)"rasters";:elseprint"No cut!        ";
  595 return
  600 rem *** preset values ***
  609 rem interlace default
  610 fori=0to1:ifpeek(dec("a03"))thenpoker(i),(297-i)and255:poker(i)+2,128:elsepoker(i),10:poker(i)+2,0:rem pal or ntsc raster
  615 ifpeek(dec("a03"))thenpokerd(i),dz-9:pokert(i),2:elsepokerd(i),dz:pokert(i),2+i:rem pal or ntsc last delay adrs (lo) & cut 4,4(pal)/4,3(ntsc)
  616 next
  617 pokepv,3:pokepc,0:return:rem vic bank 0, color bank 0
  619 rem roll screen
  620 fori=0to1:ifpeek(dec("a03"))thenpoker(i),299and255:poker(i)+2,128:elsepoker(i),13:poker(i)+2,0:rem pal or ntsc raster
  625 pokerd(i),dz:pokert(i),2:next:return
  629 rem non-interlace
  630 fori=0to1:pokert(i),0:next:return
  650 do:geta$:loopwhilea$<>"":print"{clr}{down}"tab(10)"Interlace Info
  652 print"{down} The VIC normally produces non-
  654 print" interlaced video, odd fields only.
  656 print" It starts vertical blank on raster";:ifvc=65thenprint13:elseprintusing" ###";300
  658 print" It starts Vertical Sync on raster";:ifvc=65thenprint17:elseprint303
  660 print" Vertical blank resumes on raster";:ifvc=65thenprint20:elseprint305
  662 print" It starts normal video on raster";:ifvc=65thenprint24:elseprint308
  664 ifvc<>65thenprint"{down}  These PAL values are a only a guess!
  666 print"{down} The method to create interlaced video
  668 print" is to 'cut' rasters from the end of a
  670 print" normal (odd) field so that VIC resumes
  672 print" in the *middle* of the Vertical Sync.
  674 print"{down} Since V.Sync will then start in the
  676 print" middle of a raster, your TV should
  678 print" generate an even field.  With both
  680 print" even and odd fields, you have a full
  682 print" interlace frame!
  684 print"{down} press a key...":sysdec("14f7"):getkeya$
  686 print"{clr}{down} You can select preset values to 'cut'
  688 print" rasters with A,B,or C. Press 0 or 1 to
  689 print" manually set raster cut parameters.
  690 print"{down} If set correctly, the effect is almost":print" not seen!  The best test is to view":print" the FLI text screen.  If you can not"
  691 print" clearly see the letters, the settings":print" are wrong for your TV/monitor."
  692 print"{down} When viewing a bitmap or FLI text,
  693 print" you have some keyboard options:
  694 print"{down} R to swap even and odd fields.
  695 print" + or - to change background color
  696 print" SPACE to turn interlace on/off
  697 print" Any other key to return to the menu
  698 print"{down} press a key...":sysdec("14f7"):getkeya$:return
  699 rem *** load bitmap ***
  700 ia=peek(dec("315")):sysdec("1319"):print"{clr}";
  702 do:du=peek(186):print"{down}Disk unit?"du;chr$(27)"j"tab(9);:inputa$:loopwhileval(a$)<4orval(a$)>30
  703 do:print"Filename? ";f$;chr$(27)"j"tab(8);:inputf$:loopwhilelen(f$)>15
  704 iff$<>"*"andf$<>"$"thenbegin:open2,du,2,(f$+"0"):get#2,a$:i=st:close2:open2,du,2,(f$+"1"):get#2,a$:i=iorst:close2
  705 :ifi=0thengosub710:elseprint"File not found.":print"Type $ for directory or * to exit.":goto702
  706 bend:elseiff$="$"thendirectoryonu(du):goto702
  707 ifia<21thensysdec("1300")
  708 return
  710 print"loading bitmap odd field":a$=f$+"1":bload(a$),b1,u(du),p8192:sysdec("b03"),128
  713 print"loading bitmap even field":a$=f$+"0":bload(a$),b1,u(du),p8192:sysdec("b03"),0
  715 ifpeek(250)and64thenbt=3:bank1:bg=1+peek(18192):bank15:elsebt=1:bg=12:rem multi-color or hi-res type bitmap
  718 return
  719 rem *** view bitmap ***
  720 graphicbt:color0,bg:mb=dec("d506"):pokemb,peek(mb)or64:pokepg,8:rem bitmap bank 1, $2000/$a000
  722 sysdec("1300"):sysdec("b00"):gosub750:rem irq on, set multi-color, wait key
  725 pokepg,6:pokemb,peek(mb)-64:sysdec("1319"):i=ti:do:loopwhilei=ti:graphic0:color0,12:return:rem charset $1800, vic bank 0, irq off, text
  749 rem ** viewing options **
  750 sm=peek(216):poke216,255:do:getkeya$:k=instr(" r+-",a$):ifk=0thenexit
  755 onkgosub760,770,780,790:loop:poke216,sm:return
  760 gosub410:ifpeek(dec("315"))<21thenreturn:elsepoke56576,peek(56576)and252orpeek(pv):poke1,peek(1)and253orpeek(pc):return:rem toggle irq on/off
  770 gosub420:ifpeek(dec("315"))<21thenreturn:elsepoke56576,peek(56576)and252orpeek(pv):poke1,peek(1)and253orpeek(pc):return:rem reverse fields
  780 color0,1+(rclr(0)and15):return
  790 color0,1+(rclr(0)-2and15):return
  799 rem *** 40x50 instrext ***
  800 ia=peek(dec("315")):sysdec("1630"):sysdec("1727"):pokepv,3:rem enable fli mode, set up fli color, vic bank 0
  810 do:getkeya$:k=instr("r+-",a$):ifk=0thenexit
  820 onkgosub840,780,790:loop:sysdec("168e"):ifia>24thensysdec("1319"):rem handle keys, turn off fli, if needed turn off interlace too
  830 color0,12:ifpeek(pc)thenpokepv,1:rem vic bank 2 if reversed fields
  835 return
  840 pokepg,xor(2,peek(pg)):return:rem swap charset used by even/odd fields
