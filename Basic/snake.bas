10 DIM S(1000,2)
20 W = 40
30 H = 20
40 X = INT(RND(1)*W) + 1
50 Y = INT(RND(1)*H) + 1
60 VX = 1
70 VY = 0
80 L = 3
90 S(1,1) = X
100 S(1,2) = Y
110 FOR I = 1 TO L
120   S(I,1) = X - I
130   S(I,2) = Y
140 NEXT I
150 GOSUB 1000
160 DO
170   X = X + VX
180   Y = Y + VY
190   IF X < 1 THEN X = W
200   IF X > W THEN X = 1
210   IF Y < 1 THEN Y = H
220   IF Y > H THEN Y = 1
230   IF S(L,1) = X AND S(L,2) = Y THEN 800
240   FOR I = L TO 2 STEP -1
250     S(I,1) = S(I-1,1)
260     S(I,2) = S(I-1,2)
270   NEXT I
280   S(1,1) = X
290   S(1,2) = Y
300   GOSUB 1000
310   K$ = INKEY$
320   IF K$ = "q" THEN 800
330   IF K$ = "w" AND VY = 0 THEN VX = 0 : VY = -1
340   IF K$ = "s" AND VY = 0 THEN VX = 0 : VY = 1
350   IF K$ = "a" AND VX = 0 THEN VX = -1 : VY = 0
360   IF K$ = "d" AND VX = 0 THEN VX = 1 : VY = 0
370   FOR I = 2 TO L
380     IF S(I,1) = X AND S(I,2) = Y THEN 800
390   NEXT I
400   IF X = S(1,1) AND Y = S(1,2) THEN 800
410   IF RND(1) < 0.1 THEN
420     L = L + 1
430     S(L,1) = S(L-1,1)
440     S(L,2) = S(L-1,2)
450   END IF
460   GOSUB 100
470 LOOP
800 PRINT "GAME OVER"
810 END
900 REM SUBROUTINE TO DRAW SCREEN
910 FOR Y = 1 TO H
920   FOR X = 1 TO W
930     IF S(1,1) = X AND S(1,2) = Y THEN PRINT "@"; ELSE
940     IF X = S(L,1) AND Y = S(L,2) THEN PRINT "*"; ELSE
950     IF X = X AND Y = Y THEN PRINT "."; ELSE
960     FOR I = 2 TO L-1
970       IF S(I,1) = X AND S(I,2) = Y THEN PRINT "#"; ELSE
980     NEXT I
990     PRINT " ";
1000   NEXT X
1010   PRINT
1020 NEXT Y
1030 RETURN
