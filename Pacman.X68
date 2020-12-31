*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000   
START:                  ; first instruction of program

* Put program code here


;----------------------------------------------------------------Resize Screen---------------------------------------------------------------------------
* Open Window
    
     MOVE.B #33,D0
     MOVE.L #800*$10000+672,D1        Set screen to 512 x 512
     TRAP   #15
    
;----------------------------------------------------------------Draw Map-------------------------------------------------------------------------------
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
     
;----------------------------------------------------------------Draw PACMAN---------------------------------------------------------------------------
    
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
     BNE Draw_Pacman_Eyes
     Move.B PACMAN_DIRECTION,D0      CHECK PACMAN Direction
CHECK_DIRECTION_D
     CMP #$44,D0
     BNE CHECK_DIRECTION_A
     MOVE.L #RIGHT_MOUTH,A1
     BRA Draw_Pacman_Mouth
CHECK_DIRECTION_A
     CMP #'A',D0
     BNE CHECK_DIRECTION_W
     MOVE.L #LEFT_MOUTH,A1
     BRA Draw_Pacman_Mouth
CHECK_DIRECTION_W
     CMP #'W',D0
     BNE CHECK_DIRECTION_S
     MOVE.L #UP_MOUTH,A1
     BRA Draw_Pacman_Mouth
CHECK_DIRECTION_S
     CMP #'S',D0
     BNE Draw_Pacman_Mouth
     MOVE.L #DOWN_MOUTH,A1
     BRA Draw_Pacman_Mouth
Draw_Pacman_Mouth
     MOVE.B #88,D0                   draw pacman mouth
     MOVE.L PACMAN_POSITION_X,D1                      
     MOVE.L PACMAN_POSITION_Y,D2
     MOVE.L PACMAN_POSITION_X,D3                       
     MOVE.L PACMAN_POSITION_Y,D4 
     Add.L (A1)+,D1                   
     Add.L (A1)+,D2
     Add.L (A1)+,D3                 
     Add.L (A1),D4
     TRAP   #15
     
Draw_Pacman_Eyes
     MOVE.B #88,D0                   draw pacman eyes
     MOVE.L #EYES,A1
     MOVE.L PACMAN_POSITION_X,D1                      
     MOVE.L PACMAN_POSITION_Y,D2
     MOVE.L PACMAN_POSITION_X,D3                       
     MOVE.L PACMAN_POSITION_Y,D4 
     Add.L (A1)+,D1                   
     Add.L (A1)+,D2
     Add.L (A1)+,D3                 
     Add.L (A1),D4
     TRAP   #15
    
    
;----------------------------------------------------------------Game Loop-----------------------------------------------------------------------------
     
loop  
     BSR DRAW_SCORE
     Move.L #10,D0                             DELAY TIME
     BSR DELAY
     JSR clr_pacman                            Clear Pacman
     
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
     Move.B #'A',PACMAN_DIRECTION
     ENDI
     
     BTST.L #0,D1     ; test for 'w'
     IF <NE> THEN      ; if 'w'
     Move.L PACMAN_POSITION_Y,D6
     SUB.L #DY,D6
     Move.L D6,NPACMAN_POSITION_Y
     Move.B #'W',PACMAN_DIRECTION
     ENDI

     BTST.L #8,D1     ; test for 'd'
     IF <NE> THEN      ; if 'd'
     Move.L PACMAN_POSITION_X,D5 
     ADD.L #DX,D5
     Move.L D5,NPACMAN_POSITION_X
     Move.B #'D',PACMAN_DIRECTION
     ENDI
     
     BTST.L #16,D1     ; test for 's'
     IF <NE> THEN      ; if 's'
     Move.L PACMAN_POSITION_Y,D6
     ADD.L #DY,D6
     Move.L D6,NPACMAN_POSITION_Y
     Move.B #'S',PACMAN_DIRECTION
     ENDI
     BRA CHECK_BLOCK
COIN BRA CHECK_COIN
SKIP bra draw_player
 
;----------------------------------------------------------------CHECK Block---------------------------------------------------------------------------

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
    
;----------------------------------------------------------------CHECK Coin---------------------------------------------------------------------------

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
    
;----------------------------------------------------------------Draw Score---------------------------------------------------------------------------
    
DRAW_SCORE
    move.l		#11,d0			
	move.l		#0,d1			
	trap		#15
	lea		ScoreDisplay,a1
	move.l		#17,d0
	move.l		Score,d1
	trap		#15
    RTS 


;----------------------------------------------------------------Draw Blocks---------------------------------------------------------------------------

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

;----------------------------------------------------------------Draw Small Coin---------------------------------------------------------------------------

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

;----------------------------------------------------------------CLEAR PACMAN---------------------------------------------------------------------------

clr_pacman    
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
    
;----------------------------------------------------------------DELAY---------------------------------------------------------------------------------
   
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
    
 ;----------------------------------------------------------------CONSTANTS---------------------------------------------------------------------------

    SIMHALT             ; halt simulator
* Put variables and constants here
 ORG $2000
PACMAN_POSITION_X DC.L 195
PACMAN_POSITION_Y DC.L 38
PACMAN_MOUTH dc.b 1
PACMAN_DIRECTION dc.b 'D',0
LEFT_MOUTH dc.L -02,09,09,21      
RIGHT_MOUTH dc.L 16,09,28,21    
UP_MOUTH dc.L 09,-02,21,09
DOWN_MOUTH dc.L 09,16,21,26
EYES dc.L 11,10,15,14
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
