include 'emu8086.inc'
.model small
           ; Su dung mo hinh bo nho nho
.stack 100h            ; Khoi tao ngan xep voi kich thuoc 256 byte

.data                  ; Bat dau doan du lieu 
   
    line1 db '|', 77 dup('-'), '|', '$'
    line2 db '|', 77 dup(' '), '|', '$'
   
   
   x db ?;Toa do x cua vi tri con tro
   y db ?;Toa do y cua vi tri con tro
   1e1 dw 10           ; Hang so 10
   1e4 dw 10000        ; Hang so 10000
   chuso db ?          ; Bien tam luu tung chu so vua nhap
   weight dw ?         ; Can nang nguoi dung nhap (don vi: kg)
   height dw ?         ; Chieu cao nguoi dung nhap (don vi: cm)
   tittle db '=== BMI CACULATOR FOR HUMAN ===$'         ; Chuoi loi chao
   someword db 'MADE BY G4$'
   proceed db 'ENTER TO START...$'
   return db 'ENTER TO RETURN...$'
   xuong_dong db 10, 13, '$'; Ky tu xuong dong
   
   Hi dw 0                                              ; Phan cao cua tich 32 bit
   Lo dw 0                                              ; Phan thap cua tich 32 bit
   cham_phay db '.$'                                   ; Ky tu dau cham
   ans_nguyen dw 0                                      ; Phan nguyen cua BMI
   ans_du dw 0                                          ; Phan du sau khi chia
   ans_champhay dw 0                                    ; Phan thap phan cua BMI 
   
   loading dw 'LOADING....$'
   
   thank db 'THANK YOU SO MUCH$'
   ;MENU
   
   option1 dw '1. Caculate your bmi$'
   option2 dw '2. Show BMI (Body Mass Index) classification table$'
   option3 dw '3. Suggest ideal weight$'
   option4 dw '4. EXIT $'
   
   choice db 'Select an option: $'
   
   ;CACULATE
   
   yeu_cau_nhap_can_nang dw 'Please enter your weight(kg): $' ; Cau nhap can nang
   yeu_cau_nhap_chieu_cao dw 'Please enter your height(cm): $' ; Cau nhap chieu cao
   ketqua dw 'This is your BMI : $'           ; Chuoi hien thi ket qua BMI
   
   Error dw 'It seem that you made some mistakes ?$' ; Thong bao loi khi nhap sai
   estimate dw 'Your state is $'                     
   
   ; BMI (Body Mass Index) classification table
   ;Cac muc BMI
   tittle1 dw 'BMI (kg/m)$'
   tittle2 dw 'Category$'
   
   
   muc1 dw 160
   tb1.1 dw 'Below 16.0$'
   tb1 dw 'Severely underweight$'
   
   muc2 dw 170
   tb2.1 dw '16.0 - 16.9$'
   tb2 dw 'Moderately underweight$'
   
   muc3 dw 185
   tb3.1 dw '17.0 - 18.4$'
   tb3 dw 'Mildly underweight$'
   
   advice1 dw 'Eat more nutrient-rich meals and add strength training to build muscle.$' ;Advice for BMI < 18.5
   
   muc4 dw 250
   tb4.1 dw '18.5 - 24.9$'
   tb4 dw 'Normal weight$'
   
   advice2 dw 'Just Maintain a balanced diet and stay active to keep your weight stable.$' ;Advice for BMI < 25
   
   muc5 dw 300
   tb5.1 dw '25.0 - 29.9$'
   tb5 dw 'Overweight$'
   
   advice3 dw 'You should Focus on portion control and increase daily physical activity.$' ;Advice for BMI < 30
   
   muc6 dw 350
   tb6.1 dw '30.0 - 34.9$'
   tb6 dw 'Obesity Class I (Moderate)$'
   
   muc7 dw 400
   tb7.1 dw '35.0 - 39.9$'
   tb7 dw 'Obesity Class II (Severe)$'
   
   tb8.1 dw  '40.0 and above$'
   tb8 dw 'Obesity Class III (Very severe)$'
   
   advice4x1 dw 'You need to consult a healthcare provider for a personalized plan$' ;Advice for BMI >= 30
   advice4x2 dw 'And prioritize gradual lifestyle changes.$'
   ;Ideal Weight
   
   IBMI dw 22
   tb_Ideal_weight dw 'Your ideal weight is: $'

.code                   ; Bat dau doan ma chuong trinh

;Dat vi tri con tro o vi tri x, y
goto macro x, y
    mov ah, 2
    mov bh , 0
    mov dl, x
    mov dh, y        
    int 10h
        
endm
;In 1 chuoi
printf macro str
    mov ah, 9
    lea dx, str
    int 21h
    
endm

main proc
    mov ax, @data
    mov ds, ax          ; Khoi tao thanh ghi DS de truy xuat bien
    call Intro
Start:
  
    call CLEAR_SCREEN  ;Xoa man hinh
    
    call DRAW_BORDER   ;In vien
    
    call MENU          ;In menu
    
    cmp al, '1'  ;Chay chuong trinh tinhh bmi
    jne skip1
    call CACULATE
    jmp start
    
    skip1:
    cmp al, '2'  ;Chay chuong trinh in BMI TABLE
    jne skip2 
    call BMI_TABLE
    jmp start
    
    skip2:
    cmp al, '3'  ;Chay chuong trinh tinh can nang ly tuong
    jne skip3
    call IDEAL_WEIGHT
    jmp start
    
    skip3:
    cmp al,'4'
    jne start
    
    call CLEAR_SCREEN   ;Xoa man hinh
    
    mov x, 30
    mov y, 12
    goto x, y
    printf thank

    ; Ket thuc chuong trinh
    mov ah, 4Ch
    int 21h

main endp

;Chuong trinh tinh toan bmi
CACULATE proc
    call CLEAR_SCREEN
    call DRAW_BORDER
    
Input_Weight: ;Nhap can nang
    
    ; Hien thi thong bao nhap can nang  
    goto 2,2
    printf yeu_cau_nhap_can_nang
    
    ; Goi ham nhap so nguyen
    call read_num
    mov weight, ax      ; Luu gia tri nhap vao bien weight
    
    ; Neu weight = 0 thi nhap lai
    cmp weight, 0
    je Input_Weight

    ; Tinh tu so BMI = can nang * 10000
    mov ax, weight
    mul 1e4             ; AX * 10000 => ket qua 32 bit: DX:AX
    mov Hi, dx
    mov Lo, ax

Input_Height: ;Nhap chieu cao
    
    ; Hien thi thong bao nhap chieu cao 
    goto 2,4
    printf yeu_cau_nhap_chieu_cao

    call read_num
    mov height, ax      ; Luu vao bien height
    
    cmp height, 0
    je Input_Height

    ; Tinh height^2
    mov ax, height
    mul height
    mov cx, ax          ; cx = height^2

    mov height, cx      ; cap nhat height thanh height^2 de su dung sau

    ; BMI = (can nang * 10000) / (height^2)
    mov dx, Hi          ; phan cao cua so chia
    mov ax, Lo          ; phan thap
    div cx              ; ket qua chia 32-bit / 16-bit

    mov ans_nguyen, ax  ; phan nguyen cua BMI
    mov ans_du, dx      ; phan du
    
    ; In thong bao ket qua
    goto 2,6
    printf ketqua
    
    ; In phan nguyen cua BMI
    mov ax, ans_nguyen
    call print_num

    ; In dau cham
    printf cham_phay

    ; Tinh va in phan thap phan: (du * 10) / height^2
    mov ax, ans_du
    mul 1e1
    mov cx, height
    div cx
    mov ans_champhay, ax
    call print_num

    ; Goi ham phan loai BMI
    goto 2,10
    call phan_loai

    ;in ra return
    goto 2,15
    printf return    
    ; Nhan phim lua chon
    mov ah, 1
    int 21h
    
ret
CACULATE endp

;Chuong trinh hien bang bmi
BMI_TABLE proc
    call CLEAR_SCREEN     ;Xoa man hinh
    call DRAW_BORDER      ;In vien
    
    ;Set vi tri con tro va in thong tin 
    goto 0,3
    printf line1
    
    ;In title
    goto 2,2   
    printf tittle1
        
    goto 40,2    
    printf tittle2
    
    ;In muc 1
    goto 2,4    
    printf tb1.1
    goto 40,4   
    printf tb1
    
    ;In muc 2
    goto 2,6    
    printf tb2.1
    goto 40,6    
    printf tb2
    
    ;In muc 3
    goto 2,8   
    printf tb3.1
    goto 40,8    
    printf tb3
    
    ;In muc 4
    goto 2,10    
    printf tb4.1
    goto 40,10   
    printf tb4
    
    ;In muc 5
    goto 2,12    
    printf tb5.1
    goto 40,12    
    printf tb5
    
    ;In muc 6
    goto 2,14   
    printf tb6.1
    goto 40,14    
    printf tb6
    
    ;In muc 7
    goto 2,16   
    printf tb7.1
    goto 40,16    
    printf tb7
    
    ;In muc 8
    goto 2,18    
    printf tb8.1
    goto 40,18    
    printf tb8
    
    ;Quay tro lai menu
    goto 2,22
    printf return
    
    mov ah, 1  ;Enter to return
    int 21h
    
ret 
BMI_TABLE endp

;Chuong trinh tinh can nang ly tuong
IDEAL_WEIGHT proc
    call CLEAR_SCREEN  ;Xoa man hinh
    call DRAW_BORDER   ;In vien
    
    
    goto 1, 1  ;Dua con tro ve vi tri (1,1)
    ; Hien thi thong bao nhap chieu cao
    printf yeu_cau_nhap_chieu_cao

    call read_num
    mov height, ax      ; Luu vao bien height

    goto 1, 3  ;Dua con tro ve vi tri (1,3)
    
    printf tb_Ideal_weight
           
    mov ax, height
    mul height
    ;Ideal BMI = 22
    mul IBMI
    div 1e4  
  
    call print_num
    
    goto 1, 5  ;Dua con tro ve vi tri (1,5)
    
    printf return
    
    mov ah, 1   ;Enter to return
    int 21h
    
ret 
IDEAL_WEIGHT endp

;Chuong trinh in Menu
MENU proc
    ;Dua con tro ve vi tri (x, y) va in option
    ;option 1
    goto 2,2          
    printf option1
    
    ;option 2
    goto 2,4
    printf option2
    
    ;option 3
    goto 2,6    
    printf option3
    
    ;option 4
    goto 2,8   
    printf option4
      
    ;Nhap select option 
Make_choice:
    goto 2,10
    
    mov ah, 9
    lea dx, choice
    int 21h
    
    mov ah, 1        ;nhao ki tu muon chon
    int 21h
    cmp al, '4'      ;Neu option > 4 thi nhap lai
    jg Make_choice
    
    cmp al, '1'      ;Neu option < 1 thi nhap lai
    jl Make_choice
                  
ret
MENU endp    

;chuong trinh in vien
DRAW_BORDER proc
    ;In chuoi loading 
    goto 35,12     
    printf loading
    
    ;Dat vi tri con tro bat dau la (0, 0)
    goto 0,0                             
    printf line1
    printf xuong_dong
    mov cx,22
    in_canh:
    printf line2
    printf xuong_dong
    loop in_canh
    printf line1
    
ret 
DRAW_BORDER endp
;In Intro
Intro proc
    
    call DRAW_BORDER 
    
    ;Di chuyen vi tri con tro va in
    goto 24, 2
    printf tittle     
    
    goto 33,4
    printf someword     

    goto 31,12    
    printf proceed     
    
    mov ah, 1 ;ENTER TO START
    int 21h
ret
Intro endp
; === Ham danh gia BMI dua tren ket qua tinh duoc ===
phan_loai proc
    printf estimate
    ; Tinh BMI * 10 de so sanh so nguyen
    mov ax, ans_nguyen
    mul 1e1
    add ax, ans_champhay

    ; So sanh theo nguong BMI va in ra advice
    cmp ax, muc1
    jl Muc_1
    cmp ax, muc2
    jl Muc_2
    cmp ax, muc3
    jl Muc_3
    cmp ax, muc4
    jl Muc_4
    cmp ax, muc5
    jl Muc_5
    cmp ax, muc6
    jl Muc_6
    cmp ax, muc7
    jl Muc_7
    jmp Muc_8

Muc_1:
    printf tb1
    
    goto 2,12
    printf advice1
    ret
Muc_2:
    printf tb2
    
    goto 2,12
    printf advice1    
    ret
Muc_3:
    printf tb3
    
    goto 2,12
    printf advice1    
    ret
Muc_4:
    printf tb4
    
    goto 2,12
    printf advice2    
    ret
Muc_5:
    printf tb5
    
    goto 2,12
    printf advice3
    ret
Muc_6:
    printf tb6
    
    goto 2,12
    printf advice4x1
    goto 2,13
    printf advice4x2    
    ret
Muc_7:
    printf tb7
    
    goto 2,12
    printf advice4x1
    goto 2,13
    printf advice4x2    
    ret
Muc_8:
    printf tb8
    
    goto 2,12
    printf advice4x1
    goto 2,13
    printf advice4x2
    ret
phan_loai endp

; === Ham nhap so nguyen tu ban phim ===
read_num proc
    mov ax, 0
    mov bx, 0
read_loop:
    mov ah, 1
    int 21h            ; Nhan mot ky tu
    cmp al, 13
    je read_done       ; Neu enter thi ket thuc

    cmp al, '9'
    jg read_again      ; Neu khong phai chu so thi bao loi
    
    cmp al, '0'
    jl read_again      ; Neu khong phai chu so thi bao loi
    
    sub al, '0'        ; Chuyen ky tu ve dang so
    mov chuso, al
    mov ax, bx
    mul 1e1            ; Nhan 10 de dich trai so
    mov bx, ax
    add bl, chuso      ; Cong chu so moi
    mov ax, bx
    jmp read_loop

read_done:
    mov ax, bx
    mov weight, ax
    ret

read_again:    
    printf error
    
    mov ax, 0
ret
read_num endp

; === Ham in so nguyen ra man hinh ===
print_num proc
    mov cx, 0
Lappush:
    mov dx, 0
    div 1e1            ; Tach lay tung chu so
    add dx, '0'        ; Chuyen thanh ky tu
    push dx            ; Day vao ngan xep
    inc cx
    cmp ax, 0
    jne Lappush
Hienthi:
    pop dx             ; Lay chu so ra
    mov ah, 2
    int 21h
    loop Hienthi
ret
print_num endp

DEFINE_CLEAR_SCREEN
end main