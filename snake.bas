1000 REM  *******************
1010 REM  * TI Snake Byte   *
1020 REM  * Ken Fitzpatrick *
1030 REM  * 07/15/2022      *
1040 REM  *******************
1050 CALL CLEAR
1060 REM  CALL SCREEN(1)
1070 PRINT "Build characters..."
1080 CALL CHAR(96,"FFFFFFFFFFFFFFFF")
1090 REM  Apple
1100 CALL CHAR(64,"0872DFBFFFFF7E66")
1110 REM  Door
1120 CALL CHAR(128,"0000000000000000")
1130 REM  Head
1140 CALL CHAR(129,"1824425A42424242")
1150 CALL CHAR(130,"424242425A422418")
1160 CALL CHAR(131,"003F409090403F00")
1170 CALL CHAR(132,"00FC02090902FC00")
1180 REM  Tail
1190 CALL CHAR(133,"4242241818181818")
1200 CALL CHAR(134,"1818181818244242")
1210 CALL CHAR(135,"00C0201F1F20C000")
1220 CALL CHAR(136,"000304F8F8040300")
1230 REM  Body Straight
1240 CALL CHAR(137,"4242424242424242")
1250 CALL CHAR(138,"00FF00000000FF00")
1260 REM  Body Turn
1270 CALL CHAR(139,"001F204040404342")
1280 CALL CHAR(140,"00F804020202C242")
1290 CALL CHAR(141,"4243404040201F00")
1300 CALL CHAR(142,"42C202020204F800")
1310 PRINT "Define colors..."
1320 REM  FOR CC=0 TO 14
1330 REM  CALL COLOR(CC,16,1)
1340 REM  NEXT CC
1350 REM  CALL COLOR(5,9,1)
1360 REM  CALL COLOR(13,2,1)
1370 REM  CALL COLOR(14,2,1)
1380 PRINT "Build Key Direction Table..."
1390 DIM KEYDIR(25,3)
1400 FOR II=0 TO 3
1410 FOR JJ=0 TO 25
1420 READ V
1430 KEYDIR(JJ,II)=V
1440 NEXT JJ
1450 NEXT II
1460 PRINT "Build Body Direction Table.."
1470 DIM BODYDIR(3,3)
1480 FOR II=0 TO 3
1490 FOR JJ=0 TO 3
1500 READ V
1510 BODYDIR(II,JJ)=V
1520 NEXT JJ
1530 NEXT II
1540 PRINT "Build Tail Direction Table.."
1550 DIM TAILDIR(3,5)
1560 FOR II=0 TO 3
1570 FOR JJ=0 TO 5
1580 READ V
1590 TAILDIR(II,JJ)=V
1600 NEXT JJ
1610 NEXT II
1620 PRINT "Define constants..."
1630 ENTERX=24 :: ENTERY=16 :: EXITX=2 :: EXITY=16
1640 LIVESX=1 :: LIVESY=10
1650 STARTSIZE=10 :: MAXAPPLES=10 :: LEVELS=4
1660 PRINT "Initialize variables..."
1670 LIVES=3 :: CURLEVEL=1
1680 PRINT "Prepare to start the game..."
1690 PRINT :: PRINT :: PRINT :: PRINT "Press [Enter] to continue..."
1700 GOSUB 2500
1710 CALL CLEAR
1720 REM  Draw the Info row
1740 DISPLAY AT(LIVESX,LIVESY):
1750 REM  Draw Border
1760 CALL VCHAR(2,1,96,23)
1770 CALL VCHAR(2,32,96,23)
1780 CALL HCHAR(2,2,96,30)
1790 CALL HCHAR(24,2,96,30)
1800 REM  Draw the next level
1810 ON CURLEVEL GOSUB 2540,2560,2590,2630
1820 REM  Init snake for a new turn
1830 RANDOMIZE
1840 LOSTLIFE=FALSE :: BODYSIZE=STARTSIZE :: CURSIZE=0
1850 HEADX=ENTERX :: HEADY=ENTERY
1860 TAILX=ENTERX :: TAILY=ENTERY
1870 OLDTAILX=ENTERX :: OLDTAILY=ENTERY
1880 DIR=0 :: APPLES=0
1890 REM  Put an apple on the board
1900 GOSUB 2440
1910 REM  Draw starting head
1920 CALL HCHAR(HEADX,HEADY,DIR+129)
1930 REM  Start the main loop
1940 OLDHEADX=HEADX :: OLDHEADY=HEADY
1950 IF DIR=0 THEN HEADX=HEADX-1
1960 IF DIR=1 THEN HEADX=HEADX+1
1970 IF DIR=2 THEN HEADY=HEADY-1
1980 IF DIR=3 THEN HEADY=HEADY+1
1985 REM Improve by saving the old head char rather then looking at what it is.
1990 CALL GCHAR(OLDHEADX,OLDHEADY,OLDHEAD)
2000 CALL GCHAR(HEADX,HEADY,WHAT)
2010 CALL HCHAR(OLDHEADX,OLDHEADY,BODYDIR(OLDHEAD-129,DIR))
2020 CALL HCHAR(HEADX,HEADY,DIR+129)
2030 IF CURSIZE<BODYSIZE THEN 2160
2040 CALL GCHAR(OLDTAILX,OLDTAILY,OLDTAIL)
2050 IF OLDTAIL=133 THEN TAILX=TAILX-1
2060 IF OLDTAIL=134 THEN TAILX=TAILX+1
2070 IF OLDTAIL=135 THEN TAILY=TAILY-1
2080 IF OLDTAIL=136 THEN TAILY=TAILY+1
2090 IF OLDTAIL=137 THEN OLDTAIL=133
2100 CALL GCHAR(TAILX,TAILY,BODY)
2110 IF OLDTAILX=ENTERX THEN SPOT=96 ELSE SPOT=32
2120 CALL HCHAR(OLDTAILX,OLDTAILY,SPOT)
2130 CALL HCHAR(TAILX,TAILY,TAILDIR(OLDTAIL-133,BODY-137))
2140 OLDTAILX=TAILX :: OLDTAILY=TAILY
2150 GOTO 2170
2160 CURSIZE=CURSIZE+1
2170 CALL KEY(0,K,S) :: IF K>=65 THEN DIR=KEYDIR(K-65,DIR)
2180 IF WHAT=32 THEN 1940
2190 IF WHAT=64 THEN 2230
2200 IF WHAT=128 THEN 2380
2210 GOTO 2310
2220 REM  Ate Apple
2240 BODYSIZE=BODYSIZE+5
2250 APPLES=APPLES+1
2260 IF APPLES=MAXAPPLES THEN 2360
2270 GOSUB 2440
2290 GOTO 1940
2300 GOSUB 2500
2310 LOSTLIFE=TRUE
2320 LIVES=LIVES-1
2330 IF LIVES=0 THEN END
2340 GOTO 1710
2350 REM  Open Door
2360 CALL HCHAR(EXITX,EXITY,128)
2370 GOTO 1940
2380 IF NOT LOSTLIVES THEN LIVES=LIVES+1
2390 CURLEVEL=CURLEVEL+1
2400 IF CURLEVEL<=LEVELS THEN 1810
2410 REM  * Get Apples *
2420 END
2430 REM  Draw Apple
2440 APPLEX=INT(RND*21)+3 :: APPLEY=INT(RND*30)+2
2450 CALL GCHAR(APPLEX,APPLEY,X)
2460 IF X<>32 THEN 2440
2470 CALL HCHAR(APPLEX,APPLEY,64)
2480 RETURN
2490 REM  * Wait for Keypress *
2500 CALL KEY(0,K,S)
2510 IF S=0 THEN 2500
2520 RETURN
2530 REM  Level 0
2540 RETURN
2550 REM  Level 1
2560 CALL HCHAR(12,6,96,22)
2570 RETURN
2580 REM  Level 2
2590 CALL VCHAR(7,16,96,13)
2600 CALL HCHAR(13,7,96,20)
2610 RETURN
2620 REM  Level 3
2630 CALL VCHAR(5,9,96,15)
2640 CALL HCHAR(5,10,96,13)
2650 CALL HCHAR(12,10,96,13)
2660 CALL HCHAR(19,10,96,13)
2670 RETURN
2680 REM  Key Direction Table
2690 REM  A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
2700 DATA 0,0,0,0,0,0,0,0,2,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0
2710 DATA 1,1,1,1,1,1,1,1,2,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1
2720 DATA 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,2,2,2,2,2,2,2,2,2
2730 DATA 1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,3,3,3,3,3,3,3,3,3
2740 REM  Body Direction Table
2750 DATA 137,0,140,139
2760 DATA 0,137,142,141
2770 DATA 141,139,138,0
2780 DATA 142,140,0,138
2790 REM  Tail Direction Table
2800 DATA 133,0,136,135,0,0
2810 DATA 134,0,0,0,136,135
2820 DATA 0,135,134,0,133,0
2830 DATA 0,136,0,134,0,133
