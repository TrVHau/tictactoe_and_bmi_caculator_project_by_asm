include 'emu8086.inc'
;khai bao thu vien de su dung marco gotoxy va clear_screen 

;GOTOXY col, row - macro co 2 tham so cot va dong, thiet lap vi tri con tro
;CLEAR_SCREEN - xoa man hinh bang cach cuon man hinh va dat con tro len vi tri tren cung

.model small
.stack 100h
.data
    ;chao mung den voi tic tac toe 
    ; in ra dong chu tic tac toe
    wc0 db 'WELCOME TO$' 
    wc1 db 2,2,2,2,2,32,2,32,32,2,2,2,32,32,2,2,2,2,2,32,32,2,2,32,32,32,2,2,2,32,32,2,2,2,2,2,32,32,2,2,32,32,2,2,2,2,'$'
    wc2 db 32,32,2,32,32,32,32,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,'$'
    wc3 db 32,32,2,32,32,32,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,2,2,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,2,2,2,'$'
    wc4 db 32,32,2,32,32,32,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,32,32,32,32,32,32,32,2,32,32,32,2,32,32,2,32,2,'$'
    wc5 db 32,32,2,32,32,32,2,32,32,2,2,2,32,32,32,32,2,32,32,32,2,32,32,2,32,32,2,2,2,32,32,32,32,2,32,32,32,32,2,2,32,32,2,2,2,2,'$'
    ;in ra thong tin nhom cung giang vien
    wc6 db 'Nhom 4$'
    wc7 db 'Giang vien: Dang Hoang Long$'
    wc8 db 'Bam nut bat ki de tiep tuc...$'
    
    ;trang thai cua cac o tren bang
    cell db '0123456789','$'  
    
    ;ki tu nguoi choi
    inforPlayer1 db 'Nguoi choi 1 : (X) $'
    inforPlayer2 db 'Nguoi choi 2 : (O) $'
    
    ;tao bang
    
    line1 db  '|-----------|$'
    line2 db  '|   |   |   |$'
    line3 db  '| 1 | 2 | 3 |$'
    line4 db  '|   |   |   |$'
    line5 db  '|-----------|$'
    line6 db  '|   |   |   |$'
    line7 db  '| 4 | 5 | 6 |$'
    line8 db  '|   |   |   |$'
    line9 db  '|-----------|$'
    line10 db '|   |   |   |$'
    line11 db '| 7 | 8 | 9 |$'
    line12 db '|   |   |   |$'
    line13 db '|-----------|$'
    
    player db '1$'      ;ki tu nguoi choi thu 1,2
    currentMark db 'X$' ;ki tu o danh dau cua nguoi choi
    moves db 0          ; so lan di chuyen
    doneStatus db 0     ;da hoan thanh tran dau
    drawStatus db 0     ;trang thai hoa  
    tryAgainStatus db 0 ;trang thai ban co muon choi lai khong
    
    ;hien ra ket qua tran dau
    win1 db 'Nguoi choi $'
    win2 db ' chien thang $'
    drw db 'Tran dau hoa!                  $'  
    
    ;nhap o muon chon
    inp db 'nhap o muon chon. $'
    wasTaken db 'O da duoc chon. Moi ban chon lai.   $'
    
    ;nhap khi choi lai
    try db 'ban co muon choi lai khong?(y/n): $'
    wronginput db 'khong dung ki tu, moi ban nhap lai. $'
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    call WELCOME              ;goi phan loi chao
    beginGame:
    call BOARD                ;tao bang 
    call INIT                 ;khoi tao lai tat ca cac gia tri 
    game:
    call INPUT                ;nhap o muon chon trong luot choi
    call CHECK                ;kiem tra chien thang hoac hoa
    
    cmp doneStatus,1          ;kiem tra trang thai chien thang
    je callVictory            ;nhay den cho goi ham in ra chien thang
    
    cmp drawStatus,1          ;kiem tra trang thai hoa
    je callDraw               ;nhay den cho goi ham in ra hoa
    
    jmp game
    
    callVictory:              ;
    call VICTORY              ;goi ham in ra chien thang
    call TRYAGAIN             ;goi ham hoi xem nguoi choi co muon choi lai
    cmp tryAgainStatus,1      ;kiem tra nguoi choi co muon choi lai
    je callTryAgain           ;nhay den goi ham choi lai
    
    jmp EXIT                  ;nguoi choi khong muon choi lai nen thoat chuong trinh
    
    callDraw:                 ;
    call DRAW                 ;goi ham in ra kq hoa
    call TRYAGAIN             ;kiem tra nguoi choi co muon choi lai
    cmp tryAgainStatus,1      ;nhay den goi ham choi lai
    je callTryAgain
    
    jmp EXIT                  ;nguoi choi khong muon choi lai nen thoat chuong trinh
    
    callTryAgain:             ;choi lai
    jmp beginGame:            ;tro lai luc ban dau 
    
    EXIT:                     ;ket thuc chuong trinh
    mov ah,4ch
    int 21h
    
main endp    

;hien ra phan chao
; OOOOO O   OOO  OOOOO  OO   OOO  OOOOO  OO  OOOO
;   O      O       O   O  O O       O   O  O O
;   O   O  O       O   OOOO O       O   O  O OOOO
;   O   O  O       O   O  O O       O   O  O O
;   O   O   OOO    O   O  O  OOO    O    OO  OOOO

WELCOME proc
    call CLEAR_SCREEN 
    mov ah,9
    GOTOXY 32,3
    lea dx,wc0
    int 21h 
    GOTOXY 15,5
    lea dx, wc1
    int 21h
    GOTOXY 15,6
    lea dx, wc2
    int 21h
    GOTOXY 15,7
    lea dx, wc3
    int 21h
    GOTOXY 15,8
    lea dx, wc4
    int 21h
    GOTOXY 15,9
    lea dx, wc5
    int 21h
    GOTOXY 35,12
    lea dx,wc6
    int 21h
    GOTOXY 28,13
    lea dx,wc7
    int 21h
    GOTOXY 23,14
    lea dx,wc8
    int 21h
    
    mov ah,7
    int 21h
ret    
WELCOME endp    

;hien thi bang hien tai 
;|-----------|$'
;|   |   |   |$'
;| 1 | 2 | 3 |$'
;|   |   |   |$'
;|-----------|$'
;|   |   |   |$'
;| 4 | 5 | 6 |$'
;|   |   |   |$'
;|-----------|$'
;|   |   |   |$'
;| 7 | 8 | 9 |$'
;|   |   |   |$'
;|-----------|$'
BOARD proc
    call CLEAR_SCREEN
    
    GOTOXY 2,3
    mov ah,9
    lea dx,inforPlayer1
    int 21h
    
    GOTOXY 2,4
    mov ah,9
    lea dx,inforPlayer2
    int 21h

    GOTOXY 30,2     ;dua con tro den cot 30 dong 2
    mov ah,9
    lea dx,line1
    int 21h
    
    GOTOXY 30,3     ;dua con tro den cot 30 dong 3
    mov ah,9
    lea dx,line2
    int 21h
    
    GOTOXY 30,4     ;dua con tro den cot 30 dong 4
    mov ah,9
    lea dx,line3
    int 21h
    
    GOTOXY 30,5     ;dua con tro den cot 30 dong 5
    mov ah,9
    lea dx,line4
    int 21h
    
    GOTOXY 30,6     ;dua con tro den cot 30 dong 6
    mov ah,9
    lea dx,line5
    int 21h
    
    GOTOXY 30,7     ;dua con tro den cot 30 dong 7
    mov ah,9
    lea dx,line6
    int 21h
    
    GOTOXY 30,8     ;dua con tro den cot 30 dong 8
    mov ah,9
    lea dx,line7
    int 21h
    
    GOTOXY 30,9     ;dua con tro den cot 30 dong 9
    mov ah,9
    lea dx,line8
    int 21h
    
    GOTOXY 30,10     ;dua con tro den cot 30 dong 10
    mov ah,9
    lea dx,line9
    int 21h
    
    GOTOXY 30,11     ;dua con tro den cot 30 dong 11
    mov ah,9
    lea dx,line10
    int 21h
    
    GOTOXY 30,12     ;dua con tro den cot 30 dong 12
    mov ah,9
    lea dx,line11
    int 21h
    
    GOTOXY 30,13     ;dua con tro den cot 30 dong 13
    mov ah,9
    lea dx,line12
    int 21h
    
    GOTOXY 30,14     ;dua con tro den cot 30 dong 14
    mov ah,9
    lea dx,line13
    int 21h
    
ret   
BOARD endp

;khoi tao tat ca cac bien ve ban dau
INIT proc
    mov cell[1],'1'
    mov cell[2],'2'
    mov cell[3],'3'
    mov cell[4],'4'
    mov cell[5],'5'
    mov cell[6],'6'
    mov cell[7],'7'
    mov cell[8],'8'
    mov cell[9],'9'
    ;nguoi choi 1 la nguoi choi di truoc
    mov player,'1'
    mov currentMark,'X'
    mov moves,0
    mov doneStatus,0
    mov drawStatus,0
    mov tryAgainStatus,0 
ret    
INIT endp

; ham thay doi luot cua nguoi choi
PLAYERCHANGE proc
    cmp player,'1'      ;kiem tra nguoi choi la 1 de doi sang 2
    je changeToPlayer2
    jmp changeToPlayer1
    
    changeToPlayer1:    ;doi sang nguoi choi 1
    mov player,'1'
    mov currentMark,'X'
    ret
    
    changeToPlayer2:    ;doi sang nguoi choi 2
    mov player,'2'
    mov currentMark,'O'
ret    
PLAYERCHANGE endp

; ham kiem tra xem co cot hoac hang nao thang nhau dan den chien thang hoac hoa khi khong the di them nua
CHECK proc
   check1:              ;kiem tra hang 1 2 3
   mov al,cell[1]
   cmp al,cell[2]
   jne check2   
   cmp al,cell[3]
   jne check2
   
   mov doneStatus,1
   ret
     
   check2:              ;kiem tra hang 4 5 6
   mov al,cell[4]   
   cmp al,cell[5]
   jne check3   
   cmp al,cell[6]
   jne check3
   
   mov doneStatus,1
   ret
     
   check3:              ;kiem tra hang 7 8 9
   mov al,cell[7]  
   cmp al,cell[8]
   jne check4  
   cmp al,cell[9]
   jne check4
   
   mov doneStatus,1
   ret 
   
   check4:              ;kiem tra cot 1 4 7
   mov al,cell[1]  
   cmp al,cell[4]
   jne check5   
   cmp al,cell[7]
   jne check5
   
   mov doneStatus,1
   ret
   
   check5:              ;kiem tra cot 2 5 8
   mov al,cell[2]
   cmp al,cell[5]
   jne check6  
   cmp al,cell[8]
   jne check6
   
   mov doneStatus,1
   ret
   
   check6:              ;kiem tra cot 3 6 9
   mov al,cell[3]
   cmp al,cell[6]
   jne check7
   cmp al,cell[9]
   jne check7
   
   mov doneStatus,1
   ret
   
   check7:              ;kiem tra duong cheo chinh 1 5 9
   mov al,cell[1]
   cmp al,cell[5]
   jne check8   
   cmp al,cell[9]
   jne check8
   
   mov doneStatus,1
   ret 
   
   check8:              ;kiem tra duong cheo phu 3 5 7
   mov al,cell[3]
   cmp al,cell[5]
   jne checkdraw 
   cmp al,cell[7]
   jne checkdraw
   
   mov doneStatus,1
   ret 
   
   checkdraw:           ;kiem tra ket qua hoa
   mov al,moves         
   cmp al,9             ;so sanh so luong buoc di voi 9
   jl callPlayerChange  ;so luong buoc di nho hon 9 nen doi nguoi choi
   
   mov drawStatus,1     ;trang thai hoa la true
   ret
   
   callPlayerChange:
   call PLAYERCHANGE    ;goi ham doi luot choi
   ret
ret   
CHECK endp

;ham xuat ket qua chien thang
VICTORY proc
    GOTOXY 26,19    ;dua con tro den cot 26 dong 19
    mov ah,9
    lea dx,win1     ;in ra "nguoi choi"
    int 21h
    
    lea dx,player   ;in ra nguoi choi chien thang
    int 21h
    
    lea dx,win2     ;in ra "chien thang"
    int 21h
    
    GOTOXY 22,20    ;dua con tro den cot 22 dong 20
    mov ah,9
    lea dx,wc8
    int 21h
    
    mov ah,7        ;bam nut bat ki
    int 21h
ret       
VICTORY endp

; ham xuat ket qua hoa
DRAW proc
    GOTOXY 26,19    ;dua con tro den cot 26 dong 19
    mov ah,9
    lea dx,drw      ;in ra ket qua hoa
    int 21h
    
    GOTOXY 22,20    ;dua con tro den cot 22 dong 20
    mov ah,9
    lea dx,wc8      ;in ra dong chu bam nut bat ki de tiep tuc
    int 21h
    
    mov ah,7        ;bam nut bat ki
    int 21h
    
ret
DRAW endp 


; kiem tra nguoi choi co muon choi lai khong
TRYAGAIN proc   
    call CLEAR_SCREEN
    ag:                 ; dung de khi nguoi choi nhap sai thi se quay lai
    GOTOXY 24,10        ;in ra ban co muon choi lai
    mov ah,9
    lea dx,try
    int 21h
    
    mov ah,1
    int 21h
    
    cmp al,'y'          ;so sanh y la yes
    je callYES          ;nhay den callYes
    cmp al,'Y'
    je callYES
    
    cmp al,'n'          ;so sanh n la no
    je callNO           ;nhay den callno
    cmp al,'N'
    je callNO
                        
    ;nhap sai ki tu y hoac n
    GOTOXY 24,9
    mov ah,9
    lea dx,wronginput   ;in ra viec nguoi choi nhap sai 
    int 21h
    jmp ag              ;nhay den again 
    
    callYES:
    mov tryAgainStatus,1; thay doi trang thai choi lai la true
    ret
    
    callNO:             ; nguoi choi khong muon choi lai
    ret
ret    
TRYAGAIN endp

;ham nhap o nguoi choi muon dien vao
INPUT proc
    startInput:         ;
    GOTOXY 20,16        ;di chuyen con tro den vi tri de in ra thong bao moi nguoi choi lua chon o
    
    cmp player,'1'      ;so sanh nguoi choi thu 1
    je take1           ;nhay den phan xu ly nguoi choi thu 1 neu dung
                        
    ;xu ly nguoi choi thu 2                    
    mov ah,9
    lea dx,inforPlayer2 ; in ra nguoi choi thu 2
    int 21h
    jmp takeinput
    
    take1:
    mov ah,9
    lea dx,inforPlayer1 ;in ra nguoi choi thu 1
    int 21h
    
    takeinput:
    mov ah,9
    lea dx,inp          ;in ra nguoi choi chon o muon chon
    int 21h
    
    mov ah,1            ;nhap 1 ki tu
    int 21h
    
    inc moves           ;tang so lan choi len 1
    mov bl,al
    sub bl,'0'
    
    mov cl,currentMark  ;chuyen ki tu nguoi choi thu 1 hoac 2 vao thanh ghi cl
    ;nhap dung ki tu
    cmp bl,1
    je checkCell1
    cmp bl,2
    je checkCell2
    cmp bl,3
    je checkCell3
    cmp bl,4
    je checkCell4
    cmp bl,5
    je checkCell5
    cmp bl,6
    je checkCell6
    cmp bl,7
    je checkCell7
    cmp bl,8
    je checkCell8
    cmp bl,9
    je checkCell9
    
    ;nhap sai ki tu
    dec moves           ;giam so lan choi xuong 1
    GOTOXY 20,16
    mov ah,9
    lea dx,wronginput   ;in ra nhap sai ki tu
    int 21h
    
    mov ah,7
    int 21h
    jmp startInput     ;nhap lai 
    
    ;kiem tra o duoc chon
    checkcell1:
    cmp cell[1],'O'
    je taken
    cmp cell[1],'X'
    je taken
    mov cell[1],cl
    GOTOXY 32,4         ;chuyen con tro vao vi tri o thu 1
    mov ah,9
    lea dx,currentMark  ;ghi de ki tu nguoi choi vao o 1
    int 21h
    ret
    
    checkcell2:
    cmp cell[2],'O'
    je taken
    cmp cell[2],'X'
    je taken
    mov cell[2],cl
    GOTOXY 36,4         ;chuyen con tro vao vi tri o thu 2
    mov ah,9
    lea dx,currentMark  ;ghi de ki tu nguoi choi vao so 2
    int 21h
    ret
    
    checkcell3:
    cmp cell[3],'O'
    je taken
    cmp cell[3],'X'
    je taken
    mov cell[3],cl
    GOTOXY 40,4         ;chuyen con tro vao vi tri o thu 3
    mov ah,9
    lea dx,currentMark  ;ghi de ki tu nguoi choi vao o 3
    int 21h
    ret
    
    checkcell4:
    cmp cell[4],'O'
    je taken
    cmp cell[4],'X'
    je taken
    mov cell[4],cl
    GOTOXY 32,8         ;chuyen con tro vao vi tri o thu 4
    mov ah,9            
    lea dx,currentMark  ;ghi de ki tu nguoi choi vao o 4
    int 21h
    ret
    
    checkcell5:
    cmp cell[5],'O'
    je taken
    cmp cell[5],'X'
    je taken
    mov cell[5],cl
    GOTOXY 36,8         ;chuyen ki tu con tro vao o thu 5
    mov ah,9
    lea dx,currentMark  ;chuyen ki tu nguoi choi vao o 5
    int 21h
    ret
    
    checkcell6:
    cmp cell[6],'O'
    je taken
    cmp cell[6],'X'
    je taken
    mov cell[6],cl      
    GOTOXY 40,8         ;chuyen ki tu con tro vao o thu 6
    mov ah,9
    lea dx,currentMark  ;ghi de ki tu nguoi choi vao o 6
    int 21h
    ret
    
    checkcell7:
    cmp cell[7],'O'
    je taken
    cmp cell[7],'X'
    je taken
    mov cell[7],cl
    GOTOXY 32,12        ;chuyen ki tu con tro vao o thu 7  
    mov ah,9
    lea dx,currentMark  ;ghi de ki tu nguoi choi vao o 7  
    int 21h
    ret
    
    checkcell8:
    cmp cell[8],'O'
    je taken
    cmp cell[8],'X'
    je taken
    mov cell[8],cl
    GOTOXY 36,12        ;chuyen ki tu con tro vao o thu 8
    mov ah,9
    lea dx,currentMark  ;ghi de ki tu nguoi choi vao o 8
    int 21h
    ret
    
    checkcell9:
    cmp cell[9],'O'
    je taken
    cmp cell[9],'X'
    je taken            
    mov cell[9],cl
    GOTOXY 40,12        ;chuyen ki tu con tro vao o thu 9
    mov ah,9
    lea dx,currentMark  ;ghi de ki tu nguoi choi vao o 9
    int 21h
    ret
    
    ;o da duoc chon
    taken:
    dec moves
    GOTOXY 20,16
    mov ah,9
    lea dx,wasTaken     ;in ra o da duoc chon
    int 21h
    
    mov ah,7
    int 21h
    jmp startInput     ;nhap lai
ret    
INPUT endp

DEFINE_CLEAR_SCREEN

end main