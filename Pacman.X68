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
     MOVE.L #800*$10000+672,D1        Set screen to 512 x 512
     TRAP   #15
    
     Move.L #$0,D1                  RESET D1
     Move.L #$0,D5                  VERTICAL LOOP INDEX INIT
     Move.L #MAP,A0                 LOAD MAP POSITION IN MEMORY
     
Draw_map
     Move.L #$0,D6                  HORIZONTAL LOOP INDEX INIT
Loop_draw_map
     Move.L D5,D7                   Calculate New Memory Position
     MULU.W #25,D7                  Calculate New Memory Position
     ADD.L D6,D7                    Calculate New Memory Position
     Move.L D6,D3
     MULU.W #DX,D3                  PUT NEW X POSITION IN D3
     Move.L D5,D4
     MULU.W #DY,D4                  PUT NEW Y POSITION IN D4
     MOVE.B (A0,D7.w),D0
     
     CMP.B   #'B',D0
     BEQ draw_block
     
     CMP.B   #'C',D0
     BEQ draw_coin
     
Ctn0 ADDQ #1,D6
     CMP #25,D6
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
     Add.L #25,D5
     Add.L #25,D6
     MOVE.L D5,D3
     MOVE.L D6,D4
     TRAP   #15
     
     
     MOVE.B #80,D0
     Move.L #Black,D1                Black pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #Black,D1
     TRAP   #15
     
     Move.B PACMAN_MOUTH,D0
     BCHG #$0,PACMAN_MOUTH
     BNE Eyes
Mouth 
     MOVE.B #88,D0                   draw pacman mouth
     MOVE.L D5,D3                       
     MOVE.L D6,D4   
     add.L #2,D3                    
     sub.L #5,D4 
     sub.L #10,D5
     sub.L #15,D6
     MOVE.L D5,D1                      
     MOVE.L D6,D2
     TRAP   #15
     
Eyes MOVE.B #88,D0                   draw pacman eyes
     MOVE.L D1,D3                       
     MOVE.L D2,D4   
     sub.L #3,D1                   
     sub.L #3,D2 
     TRAP   #15
     

    BSR DRAW_SCORE
    
     
loop  
     Move.L #10,D0                             DELAY TIME
     BSR DELAY
     JSR clr_screen                             Clear screen
     
     MOVE.L PACMAN_POSITION_X,D1
     MOVE.L PACMAN_POSITION_Y,D2
     MOVE.L D1,NPACMAN_POSITION_X
     MOVE.L D2,NPACMAN_POSITION_Y     
     
     
     MOVE.B #19,D0     
     MOVE.L #'A'<<24+'S'<<16+'D'<<8+'W',D1      Check for keypress (a,s,d,w)
     TRAP   #15
     
     BTST.L #24,D1     ; test for 'a'
     IF <NE> THEN      ; if 'a'
     Move.L PACMAN_POSITION_X,D5 
     SUB.L #DX,D5
     Move.L D5,NPACMAN_POSITION_X
     ENDI
     
     BTST.L #0,D1     ; test for 'w'
     IF <NE> THEN      ; if 'w'
     Move.L PACMAN_POSITION_Y,D6
     SUB.L #DY,D6
     Move.L D6,NPACMAN_POSITION_Y
     ENDI

     BTST.L #8,D1     ; test for 'd'
     IF <NE> THEN      ; if 'd'
     Move.L PACMAN_POSITION_X,D5 
     ADD.L #DX,D5
     Move.L D5,NPACMAN_POSITION_X
     ENDI
     
     BTST.L #16,D1     ; test for 's'
     IF <NE> THEN      ; if 's'
     Move.L PACMAN_POSITION_Y,D6
     ADD.L #DY,D6
     Move.L D6,NPACMAN_POSITION_Y
     ENDI
     BRA CHECK_BLOCK
COIN BRA CHECK_COIN
SKIP bra draw_player
     

CHECK_BLOCK
    MOVE.L #83,D0
    MOVE.L NPACMAN_POSITION_X,D1
    MOVE.L NPACMAN_POSITION_Y,D2
    TRAP #15
    
    CMP.L #BLUE,D0
    BEQ SKIP
    MOVE.L D1,PACMAN_POSITION_X
    MOVE.L D2,PACMAN_POSITION_Y
    BRA COIN

CHECK_COIN
    MOVE.L #83,D0
    MOVE.L NPACMAN_POSITION_X,D1
    MOVE.L NPACMAN_POSITION_Y,D2
    ADD.L #12,D2
    ADD.L #12,D1
    TRAP #15
    
    CMP.L #WHITE,D0
    BNE SKIP
    AddI.L #1,SCORE
    BSR DRAW_SCORE
    BRA SKIP
    
    
    
    
    
    
    
    
DRAW_SCORE
    move.l		#11,d0			
	move.l		#0,d1			
	trap		#15
	lea		ScoreDisplay,a1
	move.l		#17,d0
	move.l		Score,d1
	trap		#15
    RTS 




draw_block
     MOVE.B #80,D0
     Move.L #BLUE,D1                Draw block pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #BLUE,D1
     TRAP   #15
     MOVE.B #87,D0 
     MOVE.L D3,D1                 
     MOVE.L D4,D2
     Add.L #BX,D3
     Add.L #BY,D4
     TRAP   #15
     BRA Ctn0


draw_coin     
     MOVE.B #80,D0
     Move.L #WHITE,D1                Draw coin pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #WHITE,D1
     TRAP   #15
     MOVE.B #88,D0
     ADD.L #8,D3
     ADD.L #8,D4
     Move.L D3,D1
     Move.L D4,D2
     
     ADD.L #16,D3
     ADD.L #16,D4
     TRAP   #15
     BRA Ctn0

     
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
    add.L  #DPX,d3
    add.L  #DPX,d4
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
PACMAN_POSITION_X DC.L 195
PACMAN_POSITION_Y DC.L 38
PACMAN_MOUTH dc.b 1
NPACMAN_POSITION_X DS.L 1
NPACMAN_POSITION_Y DS.L 1
SCORE DC.L 0
ScoreDisplay	dc.b		'Current Score: ',0
DX EQU 32
DY EQU 32

DPX EQU 25
DPY EQU 25

BX EQU 32
BY EQU 32
MAP  
     DC.B 'EEEEEBBBBBBBBBBBBBBBBBBBE'                01
     DC.B 'EEEEEBCCCCCCCCBCCCCCCCCBE'                02
     DC.B 'EEEEEBGBBCBBBCBCBBBCBBGBE'                03
     DC.B 'EEEEEBCCCCCCCCBCCCCCCCCBE'                04
     DC.B 'EEEEEBCBBCBCBBBBBCBCBBCBE'                05
     DC.B 'EEEEEBCCCCBCCCBCCCBCCCCBE'                06
     DC.B 'EEEEEBBBBCBBBEBEBBBCBBBBE'                07
     DC.B 'EEEEEEEEBCBEEEEEEEBCBEEEE'                08
     DC.B 'EEEEBBBBBCBEBBEBBEBCBBBBB'                09
     DC.B 'EEEEEEEEECEEBEEEBEECEEEEE'                10
     DC.B 'EEEEBBBBBCBEBBBBBEBCBBBBB'                11
     DC.B 'EEEEEEEEBCBEEEEEEEBCBEEEE'                12
     DC.B 'EEEEEBBBBCBEBBBBBEBCBBBBE'                13
     DC.B 'EEEEEBCCCCCCCCBCCCCCCCCBE'                14
     DC.B 'EEEEEBCBBCBBBCBCBBBCBBCBE'                15
     DC.B 'EEEEEBGCBCCCCCECCCCCBCGBE'                16
     DC.B 'EEEEEBBCBCBCBBBBBCBCBCBBE'                17
     DC.B 'EEEEEBCCCCBCCCBCCCBCCCCBE'                18
     DC.B 'EEEEEBCBBBBBBCBCBBBBBBCBE'                19
     DC.B 'EEEEEBCCCCCCCCCCCCCCCCCBE'                20
     DC.B 'EEEEEBBBBBBBBBBBBBBBBBBBE'                21


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
