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
     MOVE.L #800*$10000+672,D1        Set screen to 800 x 672
     TRAP   #15
     BRA STARTG
    
;----------------------------------------------------------------Draw Map-------------------------------------------------------------------------------
     BSR RESET_TIME
STARTG BSR DRAW_LEVEL
     Move.L #$0,D1                  RESET D1
     Move.L #$0,D5                  VERTICAL LOOP INDEX INIT
     MOVE.L LEVEL,D0
     SUB.L #1,D0
     Move.L #MAP,A0
     ADD.L D0,A0                 LOAD MAP POSITION IN MEMORY


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
     BNE COI
     BSR draw_block     
     
COI  CMP.B   #'C',D0
     BNE GCO
     BSR draw_coin 
     
GCO  CMP.B   #'G',D0
     BNE Ctn0
     BSR draw_Gcoin
     
Ctn0 ADDQ #1,D6
     CMP #25,D6
     BNE Loop_draw_map
     ADDQ #1,D5
     CMP #21,D5
     BNE Draw_map
     BSR draw_Pacman
     BSR loop



;----------------------------------------------------------------Draw PACMAN---------------------------------------------------------------------------
    
draw_Pacman
     
     MOVE.B #80,D0
     Move.L PacManColor,D1                Draw player pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L PacManColor ,D1
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
     ror.b #1,d0
     Move.B d0,PACMAN_MOUTH      
     Btst #$0,d0
     BNE Draw_Pacman_Eyes
     Move.B PACMAN_DIRECTION,D0      CHECK PACMAN Direction
     
CHECK_DIRECTION_D
     CMP #'D',D0
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
     ;CMP.L #$20A0,A1
     ;BGT  Draw_Pacman_Eyes
     Add.L (A1)+,D1                   
     Add.L (A1)+,D2
     Add.L (A1)+,D3                 
     Add.L (A1),D4
     TRAP   #15
     RTS
     
Draw_Pacman_Eyes
     ;MOVE.B #88,D0                   draw pacman eyes
     ;MOVE.L #EYES,A1
     ;MOVE.L PACMAN_POSITION_X,D1                      
     ;MOVE.L PACMAN_POSITION_Y,D2
     ;MOVE.L PACMAN_POSITION_X,D3                       
     ;MOVE.L PACMAN_POSITION_Y,D4 
     ;Add.L (A1)+,D1                   
     ;Add.L (A1)+,D2
     ;Add.L (A1)+,D3                 
     ;Add.L (A1),D4
     ;TRAP   #15
     RTS

    
    
;----------------------------------------------------------------Game Loop-----------------------------------------------------------------------------
    
loop  
     BSR DRAW_SCORE
     Move.L #7,D0                             DELAY TIME
     BSR DELAY
     ;Move Ghost 
     BSR Draw_Time     
     MOVE.L PACMAN_POSITION_X,D1
     MOVE.L PACMAN_POSITION_Y,D2
     MOVE.L D1,NPACMAN_POSITION_X
     MOVE.L D2,NPACMAN_POSITION_Y     
     
     
     MOVE.B #19,D0     
     MOVE.L #'A'<<24+'S'<<16+'D'<<8+'W',D1      Check for keypress (a,s,d,w)
     TRAP   #15
     Move.l d1,d6
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
     

     
     BSR CHECK_G_COIN
     BSR CHECK_COIN
     JSR clr_pacman                            Clear Pacman
     BSR CHECK_P_BLOCK
     BSR CHECK_EXIT 

SKIP jsr draw_Pacman
     jsr Draw_Ghost
     BRA loop

 
;----------------------------------------------------------------CHECK Block---------------------------------------------------------------------------
CHECK_EXIT
    CMP.L #800,PACMAN_POSITION_X
    BLT LC
    MOVE.L PACMAN_POSITION_X,D5
    SUB.L #672,PACMAN_POSITION_X
    MOVE.L PACMAN_POSITION_X,D5              ;??? BRA DR
LC  CMP.L #128,PACMAN_POSITION_X
    BGT DR
    MOVE.L PACMAN_POSITION_X,D5
    ADD.L #672,PACMAN_POSITION_X
    MOVE.L PACMAN_POSITION_X,D5              ;???
DR  RTS 

CHECK_P_BLOCK

    MOVE.L #83,D0
    MOVE.L NPACMAN_POSITION_X,D1
    MOVE.L NPACMAN_POSITION_Y,D2
    TRAP #15
    
    CMP.L #BLUE,D0
    BEQ F
    
    MOVE.L D1,PACMAN_POSITION_X
    MOVE.L D2,PACMAN_POSITION_Y
F   RTS



    
DRAW_GHOST
    MOVE.L #83,D0
    MOVE.L NGHOST_POSITION_X,D1
    MOVE.L NGHOST_POSITION_Y,D2
    TRAP #15    
    CMP.L #BLUE,D0
    BEQ FF 
    
    BSR CHECK_GO_COIN
    MOVE.L NGHOST_POSITION_X,D1
    MOVE.L NGHOST_POSITION_Y,D2
    MOVE.L D1,GHOST_POSITION_X
    MOVE.L D2,GHOST_POSITION_Y   
FF  MOVE.L GHOST_POSITION_X,A2
    MOVE.L GHOST_POSITION_Y,A3
    BSR Draw_Ghost_On_Map
    BSR Draw_GHOST_Destails
    RTS




Check_Pacman
    MOVE.L #83,D0
    MOVE.L NPACMAN_POSITION_X,D1
    MOVE.L NPACMAN_POSITION_Y,D2
    ADD.L #12,D2
    ADD.L #12,D1
    TRAP #15
    

    CMP.L #PURPLE,PacManColor
    BNE yel
    ;Eat ghost and add score +50
yel CMP.L #YELLOW,PacManColor
    BNE eqq
    ;BSR LOSE THE GAME
eqq  RTS



CHECK_GHOST
    MOVE.L #83,D0
    MOVE.L NPACMAN_POSITION_X,D1
    MOVE.L NPACMAN_POSITION_Y,D2
    ADD.L #12,D2
    ADD.L #12,D1
    TRAP #15
    
    CMP.L #RED,D0
    BNE eq
    CMP.L #PURPLE,PacManColor
    BNE EAG
    ;Eat ghost and add score +50
    BRA e
EAG ;BSR LOSE THE GAME
e   RTS


CHECK_GO_COIN
    BSR Get_Ghost_Coordinates
    MULU #25,D1
    ADD.L D0,D1
    ADD.L D1,A0
    MOVE.L GHOST_POSITION_X,D3
    MOVE.L GHOST_POSITION_Y,D4
    CMP.B #'C',(A0)
    BNE GR
    BSR draw_coin
    
GR  CMP.B #'G',(A0)
    BEQ NC
    BSR draw_Gcoin
    
NC  RTS

;----------------------------------------------------------------DRAW GHOST---------------------------------------------------------------------------

Draw_Ghost_On_Map
     MOVE.B #80,D0
     Move.L #Red,D1                Black pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #Red,D1
     TRAP   #15
     Move.L A2,D5      ghost x position
     Move.L A3,D6      ghost y position
     MOVE.B #87,D0  
     MOVE.L D5,D1                       
     MOVE.L D6,D2
     Add.L #25,D5
     Add.L #25,D6
     MOVE.L D5,D3
     MOVE.L D6,D4
     TRAP   #15 
     RTS 
     
Draw_GHOST_Destails
     MOVE.B #80,D0
     Move.L #Black,D1                Black pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #Black,D1
     TRAP   #15

     MOVE.B #88,D0                   draw ghost 1 details 1ST LEG
     MOVE.L A2,D1                      
     MOVE.L A3,D2
     MOVE.L A2,D3                       
     MOVE.L A3,D4 
     Add.L #04,D1                   
     Add.L #17,D2
     Add.L #10,D3                 
     Add.L #27,D4
     TRAP   #15

     MOVE.B #88,D0                   draw ghost 1 details 2nd leg
     MOVE.L A2,D1                      
     MOVE.L A2,D3                        
     Add.L #15,D1                   
     Add.L #21,D3                 
     TRAP   #15
     
     MOVE.B #88,D0                   draw ghost 1 details 1st eye
     MOVE.L A2,D1                      
     MOVE.L A3,D2
     MOVE.L A2,D3                       
     MOVE.L A3,D4 
     Add.L #2,D1                   
     Add.L #3,D2
     Add.L #10,D3                 
     Add.L #12,D4
     TRAP   #15
     
     MOVE.B #88,D0                   draw ghost 1 details 2nd eye
     MOVE.L A2,D1                      
     MOVE.L A2,D3                       
     Add.L #15,D1                   
     Add.L #23,D3                 
     TRAP   #15
     
          MOVE.B #80,D0
     Move.L #White,D1                Black pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #White,D1
     TRAP   #15
     
          MOVE.B #88,D0                   draw ghost 1 details 1st eye pupil
     MOVE.L A2,D1                      
     MOVE.L A3,D2
     MOVE.L A2,D3                       
     MOVE.L A3,D4 
     Add.L #5,D1                   
     Add.L #3,D2
     Add.L #7,D3                 
     Add.L #7,D4
     TRAP   #15


          MOVE.B #88,D0                   draw ghost 1 details 2nd eye pupil
     MOVE.L A2,D1                      
     MOVE.L A2,D3                        
     Add.L #18,D1                   
     Add.L #20,D3                 
     TRAP   #15
    RTS
    
;----------------------------------------------------------------CHECK Coin---------------------------------------------------------------------------

CHECK_COIN
    MOVE.L #83,D0
    MOVE.L NPACMAN_POSITION_X,D1
    MOVE.L NPACMAN_POSITION_Y,D2
    ADD.L #12,D2
    ADD.L #12,D1
    TRAP #15
    
    CMP.L #WHITE,D0
    BNE eq
    AddI.L #1,SCORE
    BSR DRAW_SCORE
    BSR Emptying_Ate_Coin
eq  RTS





  
;----------------------------------------------------------------CHECK G_Coin---------------------------------------------------------------------------
   
CHECK_G_COIN
    BSR Get_Time
    SUB.L BEGIN_G_TIME,D1
    CMP.B G_TIME,D1
    BNE SK
    MOVE.L #YELLOW,PacManColor
    
SK  MOVE.L #83,D0
    MOVE.L NPACMAN_POSITION_X,D1
    MOVE.L NPACMAN_POSITION_Y,D2
    ADD.L #12,D2
    ADD.L #12,D1
    TRAP #15
    CMP.L #GRAY,D0
    BNE COIN
    BSR Get_Time
    MOVE.L D1,BEGIN_G_TIME 
    AddI.L #10,SCORE
    BSR Emptying_Ate_Coin
    BSR DRAW_SCORE
    MOVE.L #PURPLE,PacManColor
COIN RTS
    
;----------------------------------------------------------------Draw Score---------------------------------------------------------------------------
    
DRAW_SCORE
     MOVE.B #80,D0
     Move.L Black,D1                Draw player pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L Black,D1
     TRAP   #15
    move.l		#11,d0			
	move.l		#$0001,d1			
	trap		#15
	lea		ScoreDisplay,a1
	move.l		#17,d0
	move.l		Score,d1
	trap		#15
    RTS 

;----------------------------------------------------------------Draw Time----------------------------------------------------------------------------
Get_Time
    MOVE.L #31,D0
    TRAP #15
	move.L #22,d0
	lsr.l d0,d1
    RTS
    
RESET_TIME
     BSR Get_Time
     Move.l D1,BEGIN_L_TIME
     RTS

Draw_Time
    BSR Get_Time
	SUB.l		BEGIN_L_TIME,D1
	MOVE.L D1,CURRENT_TIME
    move.l		#11,d0			
	move.l		#$0002,d1			
	trap		#15
	lea		    TimeDisplay,a1
	move.l		#17,d0
	MOVE.L CURRENT_TIME,D1
	trap		#15
    RTS 
    
;----------------------------------------------------------------Draw Level---------------------------------------------------------------------------
    
DRAW_LEVEL
    move.l		#11,d0			
	move.l		#$0000,d1			
	trap		#15
	lea		    LevelDisplay,a1
	move.l		#17,d0
	move.l		LEVEL,d1
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
     RTS

;----------------------------------------------------------------Draw Small Coin---------------------------------------------------------------------------

draw_coin     
     MOVE.B #80,D0
     Move.L #WHITE,D1                Draw coin pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #WHITE,D1
     TRAP   #15
     MOVE.B #88,D0
     ADD.L #11,D3
     ADD.L #11,D4
     Move.L D3,D1
     Move.L D4,D2
     
     ADD.L #13,D3
     ADD.L #13,D4
     TRAP   #15
     RTS
     
;----------------------------------------------------------------CLEAR G_COINS---------------------------------------------------------------------------

draw_Gcoin     
     MOVE.B #80,D0
     Move.L #GRAY,D1                Draw coin pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #GRAY,D1
     TRAP   #15
     MOVE.B #88,D0
     ADD.L #6,D3
     ADD.L #6,D4
     Move.L D3,D1
     Move.L D4,D2
     
     ADD.L #19,D3
     ADD.L #19,D4
     TRAP   #15
     RTS
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
    
;----------------------------------------------------------------EMPTYING ATE COINS IN MEMORY----------------------------------------------------------
    
Get_Pacman_Coordinates
   Move.L NPACMAN_POSITION_X,D0
   Move.L NPACMAN_POSITION_Y,D1
   SUB.L #3,D0
   DIVU #32,D0
   SUB.L #6,D1
   DIVU #32,D1
   RTS
   
Get_Ghost_Coordinates
   Move.L GHOST_POSITION_X,D0
   Move.L GHOST_POSITION_Y,D1
   SUB.L #3,D0
   DIVU #32,D0
   SUB.L #6,D1
   DIVU #32,D1
   RTS
   
   
Emptying_Ate_Coin
    MOVE.L LEVEL,D0
    SUB.L #1,D0
    Move.L #MAP,A0
    ADD.L D0,A0
    BSR Get_Pacman_Coordinates
    MULU #25,D1
    ADD.L D0,D1
    ADD.L D1,A0
    MOVE.B #'E',(A0)
    RTS
    
    
 ;----------------------------------------------------------------CONSTANTS---------------------------------------------------------------------------

    SIMHALT             ; halt simulator
* Put variables and constants here
 ORG $2000
PACMAN_POSITION_X DC.L 195
PACMAN_POSITION_Y DC.L 37
NPACMAN_POSITION_X DS.L 1
NPACMAN_POSITION_Y DS.L 1
PACMAN_MOUTH dc.b %11011011
PACMAN_DIRECTION dc.b 'D',0
LEFT_MOUTH dc.L -02,10,09,21     
RIGHT_MOUTH dc.L 16,09,28,21    
UP_MOUTH dc.L 07,-02,19,09
DOWN_MOUTH dc.L 07,15,19,26
EYES dc.L 11,10,15,14
PacManColor Dc.l YELLOW 

GHOST_POSITION_X DC.L 451
GHOST_POSITION_Y DC.L 291
NGHOST_POSITION_X DC.L 451
NGHOST_POSITION_Y DC.L 291



SCORE DC.L 0
LEVEL DC.L 1
BEGIN_L_TIME DS.L 1
CURRENT_TIME DS.L 1
BEGIN_G_TIME DS.L 1
G_TIME DC.B 5

ScoreDisplay	dc.b		'Current Score: ',0
LevelDisplay	dc.b		'Level: ',0
TimeDisplay	dc.b		'TIME: ',0


DX EQU 32
DY EQU 32

DPX EQU 25
DPY EQU 25

BX EQU 32
BY EQU 32
MAP 
     DC.B 'EEEEEBBBBBBBBBBBBBBBBBBBE'                01
     DC.B 'EEEEEBECCCCCCCBCCCCCCCCBE'                02
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
