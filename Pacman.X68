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
     MOVE.L #2,D1        Set screen to 1024 x 768
     TRAP   #15
     
     MOVE.B #87,D0
     MOVE.L #50,D1        
     MOVE.L #50,D2
     MOVE.L #100,D3
     MOVE.L #100,D4
     TRAP   #15

    
     

    SIMHALT             ; halt simulator
* Put variables and constants here
BLACK equ $00000000 
MAROON equ $00000080 
GREEN equ $00008000 
OLIVE equ $00008080 
NAVY equ $00800000 
PURPLE equ $00800080 
TEAL equ $00808000 
GRAY equ $00808080 
RED equ $000000FF 
LIME equ $0000FF00 
YELLOW equ $0000FFFF 
BLUE equ $00FF0000 
FUCHSIA equ $00FF00FF 
AQUA equ $00FFFF00 
LTGRAY equ $00C0C0C0 
WHITE equ $00FFFFFF 
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
