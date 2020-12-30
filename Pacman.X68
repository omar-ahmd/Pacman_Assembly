*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000   
START:                  ; first instruction of program

* Put program code here

* Open Window
     MOVE.B #33,D0
     MOVE.L #640*$10000+520,D1        Set screen to 512 x 512
     TRAP   #15


     Move.L #$0,D5                  VERTICAL LOOP INDEX INIT
     Move.L #MAP,A0                 LOAD MAP POSITION IN MEMORY
Draw_map
     Move.L #$0,D6                  HORIZONTAL LOOP INDEX INIT
Loop_draw_map
     Move.L D5,D7                   Calculate New Memory Position
     MULU.W #19,D7                  Calculate New Memory Position
     ADD.L D6,D7                    Calculate New Memory Position
     MOVE.B (A0,D7.w),D0
     CMP.B   #$43,D0
     BSR draw_block
     ADDQ #1,D6
     CMP #19,D6
     BNE Loop_draw_map
     ADDQ #1,D5
     CMP #21,D5
     BNE Draw_map

draw_player
     MOVE.B #80,D0
     Move.L #YELLOW,D1                Draw player pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #YELLOW,D1
     TRAP   #15
     Move.L PACMAN_POSITION_X,D5      Player x position
     Move.L PACMAN_POSITION_Y,D6      Player y position
     MOVE.B #88,D0                    draw player
     MOVE.L D5,D1                       
     MOVE.L D6,D2
     Add.L #20,D5
     Add.L #20,D6
     MOVE.L D5,D3
     MOVE.L D6,D4
     TRAP   #15
loop  
     Move.L #10,D0                             DELAY TIME
     BSR DELAY
     JSR clr_screen                             Clear screen
     MOVE.B #19,D0     
     MOVE.L #'A'<<24+'S'<<16+'D'<<8+'W',D1      Check for keypress (a,s,d,w)
     TRAP   #15
     
     BTST.L #24,D1     ; test for 'a'
     IF <NE> THEN      ; if 'a'
     Move.L PACMAN_POSITION_X,D5 
     SUB.L #DX,D5
     Move.L D5,PACMAN_POSITION_X
     ENDI
     
     BTST.L #0,D1     ; test for 'w'
     IF <NE> THEN      ; if 'w'
     Move.L PACMAN_POSITION_Y,D6
     SUB.L #DY,D6
     Move.L D6,PACMAN_POSITION_Y
     ENDI

     BTST.L #8,D1     ; test for 'd'
     IF <NE> THEN      ; if 'd'
     Move.L PACMAN_POSITION_X,D5 
     ADD.L #DX,D5
     Move.L D5,PACMAN_POSITION_X
     ENDI
     
     BTST.L #16,D1     ; test for 's'
     IF <NE> THEN      ; if 's'
     Move.L PACMAN_POSITION_Y,D6
     ADD.L #DY,D6
     Move.L D6,PACMAN_POSITION_Y
     ENDI
     bra draw_player
     
     
     
draw_block
     MOVE.B #80,D0
     Move.L #BLUE,D1                Draw block pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #BLUE,D1
     TRAP   #15
     MOVE.B #87,D0 
     MOVE.L D5,D1                   
     MOVE.L D6,D2
     Add.L #BX,D5
     Add.L #BY,D6
     MOVE.L D5,D3
     MOVE.L D6,D4
     TRAP   #15
     RTS


draw_coin     
     MOVE.B #80,D0
     Move.L #YELLOW,D1                Draw coin pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #YELLOW,D1
     TRAP   #15
     
clr_screen    
    move.l  #BLACK,d1   
    move.b  #80,d0  set pen color
    trap #15     

    move.l  #BLACK,d1   
    move.b  #81,d0  set fill color
    trap #15
    
    move.L  PACMAN_POSITION_X,d1    
    move.L  PACMAN_POSITION_Y,d2  
    move.L  d1,d3  
    move.L  d2,d4
    add.L  #DX,d3
    add.L  #DY,d4
    move.b  #87,d0     draw black filled rectangle
    trap #15
    RTS
    
DELAY ; TIME = D0 SECOND
    CMP.B #0,D0
    BEQ FIN
    MOVE.L #$FFFFF000,D2
LOOP_DELAY
    ADD.L #$01,D2
    BNE LOOP_DELAY
    ADD.L #$FFFFFFFF,D0
    BNE DELAY
FIN
    RTS
    
     

    SIMHALT             ; halt simulator
* Put variables and constants here
 ORG $2000
PACMAN_POSITION_X DC.L 16
PACMAN_POSITION_Y DC.L 16
DX EQU 32
DY EQU 32

BX EQU 16
BY EQU 16
MAP  DC.B 'BBBBBBBBBBBBBBBBBBBB'                01
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                02
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                03
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                04
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                05
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                06
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                07
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                08
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                09
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                10
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                11
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                12
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                13
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                14
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                15
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                16
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                17
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                18
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                19
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                20
     DC.B 'BBBBBBBBBBBBBBBBBBBB'                21


BLACK equ $00000000  
GREEN equ $00008000   
PURPLE equ $00800080 
TEAL equ $00808000 
GRAY equ $00808080 
RED equ $000000FF 
LIME equ $0000FF00 
YELLOW equ $0000FFFF 
BLUE equ $00FF0000 
WHITE equ $00FFFFFF 
    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
