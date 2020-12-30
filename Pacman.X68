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

draw_blocks
     MOVE.B #80,D0
     Move.L #BLUE,D1                Draw player pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #BLUE,D1
     TRAP   #15
     Move.L #BLOCK_BEGIN_X,A0
     Move.L #BLOCK_BEGIN_Y,A1
     Move.L #$0,D7
Loop_draw_blocks
     Move.L #0,D5
     Move.L #0,D6
     Move.B (A0,D7.w),D5 
     Move.B (A1,D7.w),D6    
     MULU.W #BX,D5
     MULU.W #BY,D6
     MOVE.B #87,D0
     MOVE.L D5,D1        
     MOVE.L D6,D2
     Add.L #BX,D5
     Add.L #BY,D6
     MOVE.L D5,D3
     MOVE.L D6,D4
     TRAP   #15
     
     MOVE.B #87,D0
     Sub.L #BY,D6
     MOVE.L #512,D1
     Sub.L D5,D1
     MOVE.L D6,D2
     MOVE.L D1,D5
     MOVE.L D2,D6     
     Add.L #BX,D5
     Add.L #BY,D6
     MOVE.L D5,D3
     MOVE.L D6,D4
     TRAP   #15
        
     MOVE.L #512,D2
     MOVE.B #87,D0
     ;Sub.L D5,D1
     Sub.L D6,D2 
     MOVE.L D1,D5
     MOVE.L D2,D6     
     Add.L #BX,D5
     Add.L #BY,D6
     MOVE.L D5,D3
     MOVE.L D6,D4
     TRAP   #15
     
     Add.L #$1,D7
     CMP #79,D7
     BNE Loop_draw_blocks

draw_player
     MOVE.B #80,D0
     Move.L #YELLOW,D1                Draw player pen and fill color
     TRAP   #15
     MOVE.B #81,D0
     Move.L #YELLOW,D1
     TRAP   #15
     Move.L PACMAN_POSITION_X,D5      Player x position
     Move.L PACMAN_POSITION_Y,D6      Player y position
     MOVE.B #88,D0
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
     bra draw_blocks
     
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
PACMAN_POSITION_X DC.L 20
PACMAN_POSITION_Y DC.L 20
DX EQU 32
DY EQU 32

BX EQU 16
BY EQU 16
BLOCK_BEGIN_X DC.B 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,0,0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0,3,4,5,6,7,8,3,4,5,6,7,8,3,4,5,6,7,8,3,4,5,6,7,8,3,4,5,6,7,8,3,4,5,6,7,8, 3, 4, 5, 6, 7, 8, 3, 4, 5, 6, 7, 8
BLOCK_BEGIN_Y DC.B 0,0,0,0,0,0,0,0,0,0, 0, 0, 0, 0, 0, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,11,11,11,11,11,11,12,12,12,12,12,12
;BLOCK_END_X
;BLOCK_END_Y

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
