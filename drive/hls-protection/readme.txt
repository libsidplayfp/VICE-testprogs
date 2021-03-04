There is a protection (written by Herndon Labs?). It is described in a Vice bug
and was determined to be due to timing of the SO line with regards to sync
detection, as well as these tracks being written at a higher-than-standard
density.

https://sourceforge.net/p/vice-emu/bugs/203/

The timing of the test was modified in games that checked T18+, where it uses a
6 cycle delay instead of 4.

Interestingly, this disk layout is found on many disks, even those that don't
use this protection check. It must be common to one or more mastering facilities
of the time. For example, the original of Ultima III passes the test, as does
Garry Kitchen's Gamemaker, which uses a different protection (Xemag 2.0).



This protection is used on many commercial games- Here are some titles which
used this:

Title                            Publisher    Tracks checked
--------------------------------------------------------------
1943                            (Elite)            19, 19
4th and Inches                  (Accolade)         12, 17
Arcade Game Construction Kit    (Br0derbund)       16, 17
Alleykat                        (Thunder Mntn)      9, 9
Bad Dudes vs Dragon Ninja       (Data East)        17, 17
Bank Street Speller             (Br0derbund)       19
Bank Street Writer (1985)       (Br0derbund)       19
Batman                          (Data East)        16, 17
Batman: The Movie (v1.0)        (Ocean)            19, 19
Batman: The Movie (v1.1)        (Ocean)            17, 17
Blasteroids                     (Tengen)           17, 17
Boot Camp                       (Konami)           20, 19
Bop'N Wrestle                   (Mindscape)        16
Breakthru                       (Data East)        17, 16
Bubble Ghost                    (Accolade)         16, 17
Cabal                           (Capcom)           19, 19
Cauldron                        (Br0derbund)        6, 12
Cauldron II                     (Br0derbund)       17, 16
Centauri Alliance               (Br0derbund)       19, 19
Commando                        (Data East)        15
Designasaurus                   (Britannica)       17, 17
Doc the Destoyer                (Thunder Mntn)     17, 15
Downhill Challenge              (Br0derbund)       17, 17
Express Raider                  (Data East)        11, 6
Fairlight                       (Mindscape)        19
Forgotten Worlds                (Capcom)           19
Frightmare                      (Accolade)         19, 19
Guerrilla War                   (Data East)        17, 16
Head Over Heels                 (Mindscape)         7, 7
High Roller                     (Mindscape)        16
Hyper Sports                    (Konami)           19, 19
Ikari Warriors                  (Data East)        17, 17
Implosion                       (Thunder Mntn)     19, 19
Indoor Sports                   (Mindscape)        19
Infiltrator                     (Mindscape)        16
Jackal                          (Konami)           16
Jet Boys                        (Avantage)         17, 15
Karnov                          (Data East)        16, 17
Kid Niki: Radical Ninja         (Data East)        18, 19
Karateka (alt, not xelock)      (Br0derbund)       17, 17
Kung Fu Master                  (Data East)        17
Leviathan                       (English Soft.)    18, 19
License to Kill                 (Domark)           17
Life Force                      (Konami)           17
Lode Runner (yellow label)      (Br0derbund)       17, 16
Maniac Mansion                  (Lucasfilm)        17, 17
Mental Blocks                   (Accolade)         14, 14
Mikie                           (Action City)      17, 16
Mini-Putt                       (Accolade)         19, 19
Paradroid                       (Thunder Mntn)     10, 10
Parallax                        (Mindscape)         6, 6
Q-Bert                          (Data East)        17
Robocop                         (Data East)        12, 17
Rush'N Attack                   (Konami)           17, 16
Speed Buggy                     (Data East)        16, 16
Star Control                    (Accolade)         21, 21
Star Wars                       (Br0derbund)       17, 17
Stratego (PAL)                  (Accolade)         17, 17
Strike Aces                     (Accolade)         17
Superbike Challenge             (Br0derbund)       17, 16
Tag Team Wrestling              (Data East)        17, 17
The Cycles                      (Accolade)         17, 17
TNK III                         (Ocean)             9, 9
Top Gun                         (Thunder Mntn)     17, 15
Trailblazer                     (Mindscape)        12, 12
Uchi-Mata                       (Mindscape)        11, 11
Uridium                         (Data East)         9, 9
Victory Road                    (Data East)        23, 19
Vigilante                       (Data East)        23, 24
Warlock                         (Three Sixty)      17
Wizball                         (Mindscape)         4, 5
Yie Ar Kung Fu                  (Konami)            8, 17
Yie Ar Kung Fu II               (Konami)           17, 16
