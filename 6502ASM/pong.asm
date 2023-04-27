; Pong in 6502 assembly
; Written by ChatGPT

; Constants
SCREEN_WIDTH = 40
SCREEN_HEIGHT = 24
PADDLE_HEIGHT = 4
PADDLE_WIDTH = 1
BALL_SIZE = 1
BALL_SPEED = 2

; Variables
player1Y   = $00
player2Y   = $01
ballX      = $02
ballY      = $03
ballDX     = $04
ballDY     = $05
player1Score = $06
player2Score = $07

; Initialization
init:
  lda #SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2
  sta player1Y
  lda #SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2
  sta player2Y
  lda #SCREEN_WIDTH / 2 - BALL_SIZE / 2
  sta ballX
  lda #SCREEN_HEIGHT / 2 - BALL_SIZE / 2
  sta ballY
  lda #BALL_SPEED
  sta ballDX
  lda #BALL_SPEED
  sta ballDY
  lda #0
  sta player1Score
  sta player2Score

main:
  ; Move the paddles
  jsr movePaddles

  ; Move the ball
  jsr moveBall

  ; Draw the game screen
  jsr drawScreen

  ; Check for game over
  jsr checkGameOver
  bne main

  ; End of game
  jsr endGame
  rts

movePaddles:
  ; Move player 1 paddle
  lda player1Y
  clc
  adc #$01 ; Move up
  sta player1Y
  lda player1Y
  clc
  adc #$03 ; Move down
  cmp #SCREEN_HEIGHT - PADDLE_HEIGHT
  bcs .hitBottom
  sta player1Y
.hitBottom:
  lda player1Y
  cmp #$00
  bcc .hitTop
  sta player1Y
.hitTop:

  ; Move player 2 paddle
  lda player2Y
  clc
  adc #$01 ; Move up
  sta player2Y
  lda player2Y
  clc
  adc #$03 ; Move down
  cmp #SCREEN_HEIGHT - PADDLE_HEIGHT
  bcs .hitBottom2
  sta player2Y
.hitBottom2:
  lda player2Y
  cmp #$00
  bcc .hitTop2
  sta player2Y
.hitTop2:
  rts

moveBall:
  lda ballX
  clc
  adc ballDX
  cmp #SCREEN_WIDTH - BALL_SIZE
  bcs .hitRightWall
  bcc .notHitRightWall
.hitRightWall:
  lda ballDX
  eor #$ff
  inc player1Score
  lda #SCREEN_WIDTH / 2 - BALL_SIZE / 2
  sta ballX
  lda #SCREEN_HEIGHT / 2 - BALL_SIZE / 2
  sta ballY
.notHitRightWall:

  lda ballX
  sec
  sbc ballDX
  cmp #$00
  bcs .hitLeftWall
  bcc .notHitLeftWall
.hitLeftWall:
  lda ballDX
  eor #$ff
  inc player2Score
  lda #SCREEN_WIDTH / 2 - BALL_SIZE / 2
  sta ballX
  lda #SCREEN_HEIGHT / 2 - BALL_SIZE / 2
  sta
   ; Paddle position
   PADDLE_Y:
       .BYTE 28

   ; Ball position and velocity
   BALL_X:
       .BYTE 80
   BALL_Y:
       .BYTE 44
   BALL_VX:
       .BYTE 2
   BALL_VY:
       .BYTE 1

   ; Paddle velocity
   PADDLE_VY:
       .BYTE 0

   ; Constants
   SCREEN_WIDTH:
       .BYTE 40
   SCREEN_HEIGHT:
       .BYTE 25
   BALL_RADIUS:
       .BYTE 1
   PADDLE_HEIGHT:
       .BYTE 4
   PADDLE_WIDTH:
       .BYTE 1

   ; Game loop
   GAME_LOOP:
       ; Clear screen
       LDX #0
       CLEAR_LOOP:
           STX SCREEN_BUFFER,X
           INX
           CPX #1000
           BNE CLEAR_LOOP

       ; Draw ball
       LDA BALL_X
       STA X_POS
       LDA BALL_Y
       STA Y_POS
       LDA BALL_RADIUS
       JSR DRAW_CIRCLE

       ; Draw paddle
       LDA PADDLE_Y
       STA Y_POS
       LDA PADDLE_HEIGHT
       STA HEIGHT
       LDA PADDLE_WIDTH
       STA WIDTH
       JSR DRAW_RECTANGLE

       ; Update ball position
       LDA BALL_X
       CLC
       ADC BALL_VX
       STA BALL_X
       LDA BALL_Y
       CLC
       ADC BALL_VY
       STA BALL_Y

       ; Bounce off walls
       LDA BALL_X
       CMP #0
       BCC BOUNCE_RIGHT
       LDA BALL_X
       CMP #SCREEN_WIDTH-BALL_RADIUS
       BCS BOUNCE_LEFT
       LDA BALL_Y
       CMP #0
       BCC BOUNCE_DOWN
       LDA BALL_Y
       CMP #SCREEN_HEIGHT-BALL_RADIUS
       BCS BOUNCE_UP
       JMP CONTINUE_BALL_MOVEMENT

       BOUNCE_RIGHT:
           LDA #0
           STA BALL_VX
           JMP CONTINUE_BALL_MOVEMENT

       BOUNCE_LEFT:
           LDA #255
           STA BALL_VX
           JMP CONTINUE_BALL_MOVEMENT

       BOUNCE_DOWN:
           LDA #0
           STA BALL_VY
           JMP CONTINUE_BALL_MOVEMENT

       BOUNCE_UP:
           LDA #255
           STA BALL_VY
           JMP CONTINUE_BALL_MOVEMENT

       CONTINUE_BALL_MOVEMENT:

       ; Move paddle
       LDA PADDLE_Y
       CLC
       ADC PADDLE_VY
       STA PADDLE_Y
       LDA PADDLE_Y
       CMP #0
       BCC PADDLE_AT_TOP
       LDA PADDLE_Y
       CMP #SCREEN_HEIGHT-PADDLE_HEIGHT
       BCS PADDLE_AT_BOTTOM
       JMP END_PADDLE_MOVEMENT

       PADDLE_AT_TOP:
           LDA #0
           STA PADDLE_Y
           JMP END_PADDLE_MOVEMENT

       PADDLE_AT_BOTTOM:
           LDA #SCREEN_HEIGHT-PADDLE_HEIGHT
           STA PADDLE_Y
           JMP END_PADDLE_MOVEMENT

       END_PADDLE_MOVEMENT:

       ; Wait for vsync
       LDA $D012
       BIT #128
       BNE WAIT_FOR_VSYNC
       LDA $D011
       CMP #248
       BNE WAIT_FOR_VSYNC
       JMP GAME_LOOP

       WAIT_FOR_VSYNC:
           JMP WAIT_FOR_VSYNC

   ; Draw a rectangle
; Input: Y_POS - Y position
; HEIGHT - height
; WIDTH - width
; Output: rectangle drawn on screen
DRAW_RECTANGLE:
LDX #0
DRAW_RECTANGLE_LOOP:
LDA Y_POS
STA TEMP_Y
LDA HEIGHT
STA TEMP_HEIGHT
DRAW_RECTANGLE_INNER_LOOP:
LDA X_POS
STA TEMP_X
DRAW_RECTANGLE_INNER_LOOP2:
LDA SCREEN_WIDTH
SEC
SBC TEMP_X
CMP WIDTH
BCS DRAW_RECTANGLE_CONTINUE
JMP DRAW_RECTANGLE_END
DRAW_RECTANGLE_CONTINUE:
LDA TEMP_Y
SEC
SBC Y_POS
CMP HEIGHT
BCS DRAW_RECTANGLE_SKIP
LDA TEMP_X
STA (SCREEN_BUFFER),Y
INY
JMP DRAW_RECTANGLE_INNER_LOOP2
DRAW_RECTANGLE_SKIP:
INY
JMP DRAW_RECTANGLE_INNER_LOOP
DRAW_RECTANGLE_END:
INX
CPX WIDTH
BNE DRAW_RECTANGLE_LOOP
RTS

; Draw a circle
; Input: X_POS - X position
; Y_POS - Y position
; RADIUS - radius
; Output: circle drawn on screen
DRAW_CIRCLE:
LDX #0
LDA RADIUS
STA TEMP_R
DRAW_CIRCLE_LOOP:
LDA Y_POS
SEC
SBC TEMP_R
STA TEMP_Y
LDA X_POS
STA TEMP_X
DRAW_CIRCLE_INNER_LOOP:
LDA TEMP_Y
SEC
SBC Y_POS
CMP TEMP_R
BCS DRAW_CIRCLE_SKIP
LDA TEMP_X
STA TEMP_DIFF
SEC
SBC X_POS
CMP TEMP_R
BCS DRAW_CIRCLE_SKIP
LDA TEMP_Y
SEC
SBC Y_POS
LDA SCREEN_WIDTH
SEC
SBC TEMP_X
CMP TEMP_DIFF
BCS DRAW_CIRCLE_CONTINUE
JMP DRAW_CIRCLE_END
DRAW_CIRCLE_CONTINUE:
LDA TEMP_Y
SEC
SBC Y_POS
LDA TEMP_X
STA (SCREEN_BUFFER),Y
LDA Y_POS
SEC
SBC TEMP_Y
CMP TEMP_R
BCS DRAW_CIRCLE_SKIP2
LDA TEMP_Y
STA (SCREEN_BUFFER),Y
DRAW_CIRCLE_SKIP2:
LDA SCREEN_WIDTH
SEC
SBC TEMP_X
STA (SCREEN_BUFFER),Y
LDA Y_POS
SEC
SBC TEMP_Y
CMP TEMP_R
BCS DRAW_CIRCLE_SKIP2
LDA TEMP_Y
STA (SCREEN_BUFFER),Y
DRAW_CIRCLE_SKIP:
LDA SCREEN_WIDTH
SEC
SBC TEMP_X
INY
JMP DRAW_CIRCLE_INNER_LOOP
DRAW_CIRCLE_END:
INX
CPX TEMP_R
BNE DRAW_CIRCLE_LOOP
RTS

; End of program
.END
