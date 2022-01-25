close macro 

	mov ah, 4ch
	mov al, 0
	int 21h
endm

getChar macro
	
	mov ah,01h
	int 21h

endm

print macro texto

	mov ax, @data
	mov ds,ax
	mov ah, 09h
	mov dx, offset texto
	int 21h

endm



printp macro texto
		mov al,texto
		AAM                             ;desempaqueta lo que se encuentra en ax que es el resultado a demal
        MOV     bx, ax                  ;guarda en bx lo que esta en ax ya que se utilizara el registro ax para int21h
        MOV     ah, 02h                 ;salida de caracteres
        MOV     dl, bh                  ;pasa el numero mayor a dl, ya que lo que esta en dl es lo que va a salir
        ADD     dl, 30h                 ;le suma 30 ya que debe estar en ascii
        INT     21h                     ;llamda la int21h para ejecutar la funcion 02h para el primer digito
    
        MOV     ah, 02h                 ;realiza lo mismo con el segundo digito del resultado
        MOV     dl, bl                  ;el segundo digito se encuentra en el registro bl
        ADD     dl, 30h
        INT     21h 
endm

obtenerNombre macro arreglo
LOCAL ObtenerCaracter, Fin

xor si,si; mov si,0  si = 0

	ObtenerCaracter:
		getChar ;obtiene el caracter
		cmp al, 13 ;lo compara con el retorno de carro para el enter
		je Fin ;si es retorno de carro se agregar el $ al final del array

		mov arreglo[si], al;si no es retorno se agregar el caracter al arreglo
		inc si ;se incrementa el valor de si
		jmp ObtenerCaracter ;se vuelve a ejecutar obtener caracter

	Fin:
		mov al,36 ;al toma el $ para agregarlo al final del caracter
		mov arreglo[si],al;se agrega al arreglo

endm

;------------GENERAR EL HTML
obtenerRuta macro buffer
LOCAL ObtenerChar, endTexto
	xor si,si ; xor si,si =	mov si,0
	
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii de salto de linea en hexa
		je endTexto
		mov buffer[si],al ;mov destino, fuente
		inc si ; si = si + 1
		jmp ObtenerChar

	endTexto:
		mov al,00h ; asci del caracter nulo
		mov buffer[si], al  
endm

cerrar macro handler
	
	mov ah,3eh
	mov bx, handler
	int 21h
	
	mov handler,ax

endm


limpiar macro buffer, numbytes, caracter
LOCAL Repetir
	push si
	push cx
	xor si,si ; colocamos en 0 el contador si
	xor cx,cx ; colocamos en 0 el contador cx
	mov	cx,numbytes ;le pasamos a cx el tamaño del arreglo a limpiar 

	Repetir:
		mov buffer[si], caracter ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
		Loop Repetir ;se va a repetir hasta que cx sea 0 

	pop cx
	pop si
endm



crear macro buffer, handler
	
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	
	mov handler, ax

endm

escribir macro handler, buffer, numbytes

	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	

endm

agregarExtension macro buffer,bufferex,numbytes
LOCAL Repetir,Salir
    push si
	push cx
    push ax
    push bx
    push dx
	xor si,si ; colocamos en 0 el contador si
	xor cx,cx ; colocamos en 0 el contador cx
    xor ax,ax
	mov	cx,numbytes ;le pasamos a cx el tamaño del arreglo a limpiar 
    xor di,di
	Repetir:
        mov al,bufferex[si]
        cmp al,24h
        je Salir
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
		Loop Repetir ;se va a repetir hasta que cx sea 0 
    Salir:
		mov al,00h
		mov buffer[si],al
    pop dx
    pop bx
    pop ax
	pop cx
	pop si
endm

;-----------------------------------sinompun,nombre,sigmedio,punto,sigfinpun,fintabl1
llenar macro buffer, tabla1,tabla2,tabla3,iniciotablero,tablafinal1,tablafinal2,tablafinal3,tablafinal4,tablafinal5,tablafinal6,tablafinal7,tablafinal8,tbfin, numbytes
LOCAL vali,vali2,vali3,vali4,vali5,vali6,vali7,vali8,vali9,vali10,vali11,vali12,Repetir,Repetir2,Repetir3,Repetir4,Repetir5,Repetir6,Repetir7,Repetir8,Repetir9,Repetir10,Repetir11,Repetir12,Repetir13,Salir
	push si
	push cx
    push ax
    push bx
    push dx
	xor si,si ; colocamos en 0 el contador si
	xor cx,cx ; colocamos en 0 el contador cx
    xor ax,ax
	mov	cx,numbytes ;le pasamos a cx el tamaño del arreglo a limpiar 
    xor di,di
	Repetir:
        mov al,tabla1[di]
        cmp al,24h
        je vali
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir ;se va a repetir hasta que cx sea 0 
	vali:
        xor di,di
        cmp cx,0
        je Salir
	Repetir2:
		mov al,tabla2[di]
        cmp al,24h
        je vali2
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir2 ;se va a repetir hasta que cx sea 0
	vali2:
        xor di,di
        cmp cx,0
        je Salir
	Repetir3:
		mov al,tabla3[di]
        cmp al,24h
        je vali3
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir3 ;se va a repetir hasta que cx sea 0
	vali3:
		xor di,di
        cmp cx,0
        je Salir
	Repetir4:
		mov al,iniciotablero[di]
        cmp al,24h
        je vali4
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir4 ;se va a repetir hasta que cx sea 0
	vali4:
		xor di,di
        cmp cx,0
        je Salir
	Repetir5:
		mov al,tablafinal1[di]
        cmp al,24h
        je vali5
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir5 ;se va a repetir hasta que cx sea 0
	vali5:
		xor di,di
        cmp cx,0
        je Salir
	Repetir6:
		mov al,tablafinal2[di]
        cmp al,24h
        je vali6
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir6 ;se va a repetir hasta que cx sea 0
	vali6:
		xor di,di
        cmp cx,0
        je Salir
	Repetir7:
		mov al,tablafinal3[di]
        cmp al,24h
        je vali7
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir7 ;se va a repetir hasta que cx sea 0
	vali7:
		xor di,di
        cmp cx,0
        je Salir
	Repetir8:
		mov al,tablafinal4[di]
        cmp al,24h
        je vali8
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir8 ;se va a repetir hasta que cx sea 0
	vali8:
		xor di,di
        cmp cx,0
        je Salir
	Repetir9:
		mov al,tablafinal5[di]
        cmp al,24h
        je vali9
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir9 ;se va a repetir hasta que cx sea 0
	vali9:
		xor di,di
        cmp cx,0
        je Salir
	Repetir10:
		mov al,tablafinal6[di]
        cmp al,24h
        je vali10
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir10 ;se va a repetir hasta que cx sea 0
	vali10:
		xor di,di
        cmp cx,0
        je Salir
	Repetir11:
		mov al,tablafinal7[di]
        cmp al,24h
        je vali11
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir11 ;se va a repetir hasta que cx sea 0
	vali11:
		xor di,di
        cmp cx,0
        je Salir
	Repetir12:
		mov al,tablafinal8[di]
        cmp al,24h
        je vali12
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir12 ;se va a repetir hasta que cx sea 0
	vali12:
		xor di,di
        cmp cx,0
        je Salir
	Repetir13:
		mov al,tbfin[di]
        cmp al,24h
        je Salir
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir13 ;se va a repetir hasta que cx sea 0

    Salir:
		;mov al,00h
		;mov buffer[si], al
		

    pop dx
    pop bx
    pop ax
	pop cx
	pop si
endm

;-----------------------macro para nombre y pts jugador
insercionNombre macro buffer,inicio,medio,fin,nombre,pt,numbytes
LOCAL Repetir,Repetir2,Repetir3,Repetir4,Repetir5,vali,vali2,vali3,vali4,Salir
	push si
	push cx
    push ax
    push bx
    push dx
	xor si,si ; colocamos en 0 el contador si
	xor cx,cx ; colocamos en 0 el contador cx
    xor ax,ax
	mov	cx,numbytes ;le pasamos a cx el tamaño del arreglo a limpiar 
    xor di,di
	Repetir:
        mov al,inicio[di]
        cmp al,24h
        je vali
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir ;se va a repetir hasta que cx sea 0 
	vali:
        xor di,di
        cmp cx,0
        je Salir
	Repetir2:
		mov al,nombre[di]
        cmp al,24h
        je vali2
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir2 ;se va a repetir hasta que cx sea 0
	vali2:
        xor di,di
        cmp cx,0
        je Salir
	Repetir3:
		mov al,medio[di]
        cmp al,24h
        je vali3
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir3 ;se va a repetir hasta que cx sea 0
	vali3:
        xor di,di
        cmp cx,0
        je Salir
	Repetir4:
		mov al,pt[di]
        cmp al,24h
        je vali4
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		jmp vali4 ;se va a repetir hasta que cx sea 0
	vali4:
        xor di,di
        cmp cx,0
        je Salir
	Repetir5:
		mov al,fin[di]
        cmp al,24h
        je Salir
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir5 ;se va a repetir hasta que cx sea 0
    Salir:
		;mov al,00h
		;mov buffer[si],al

    pop dx
    pop bx
    pop ax
	pop cx
	pop si


endm

cambio macro buffer,entrada,numbytes,num
LOCAL Repetir,Salir,Via
	push si
	push cx
    push ax
    push bx
    push dx
	xor si,si ; colocamos en 0 el contador si
	xor cx,cx ; colocamos en 0 el contador cx
    xor ax,ax
	mov	cx,numbytes ;le pasamos a cx el tamaño del arreglo a limpiar 
    xor di,di
	mov di,num
	Repetir:
        mov al,buffer[si]
        cmp al,42
		je Via

		cmp al,24h
		je Salir

		inc si ;incremento si
		Loop Repetir ;se va a repetir hasta que cx sea 0 
	Via:
		mov al,entrada[di]
		mov buffer[si],al
		inc si
		inc di
		jmp Repetir
	Salir:
		;mov al,00h
		;mov buffer[si],al
    pop dx
    pop bx
    pop ax
	pop cx
	pop si


endm

reseteo macro buffer,numbytes
LOCAL Repetir,Salir,lab,lan,lspace
	push si
	push cx
    push ax
    push bx
    push dx
	xor si,si ; colocamos en 0 el contador si
	xor cx,cx ; colocamos en 0 el contador cx
    xor ax,ax
	mov	cx,numbytes ;le pasamos a cx el tamaño del arreglo a limpiar 
    xor di,di
	Repetir:
        mov al,buffer[si]
        cmp al,95;-----> _
		je lspace

		cmp al,98;--->b
		je lab

		cmp al,110;------>n
		je lan

		cmp al,24h
		je Salir

		inc si ;incremento si
		Loop Repetir ;se va a repetir hasta que cx sea 0 
	lab:
		mov al,42
		mov buffer[si],al
		inc si
		jmp Repetir
	lan:
		mov al,42
		mov buffer[si],al
		inc si
		jmp Repetir
	lspace:
		mov al,42
		mov buffer[si],al
		inc si
		jmp Repetir
	Salir:
		;mov al,00h
		;mov buffer[si],al
    pop dx
    pop bx
    pop ax
	pop cx
	pop si


endm

;**********************************COSAS DEL MODO VIDEO****************************************
ModoVideo macro 
mov ah, 00h
mov al, 13h 
int 10h   
mov ax, 0A000h
mov ds, ax  ; DS = A000h (memoria de graficos).
endm 

ModoTexto macro  
mov ah, 00h 
mov al, 03h 
int 10h 
endm

PintarMargen macro color 
LOCAL primera,segunda ,tercera, cuarta, tablero, salir, tableroHorizontal,tableroVertical, lineaVertical, lineaHorizontal, pintarCuadroA2, pintarLineaA2
mov dl, color
;empieza en pixel (i,j) = (20, 0) aplicando el mapeo  20 * 320 + 0  = 6400
;barra horizontal superior 
    mov di, 6410 
primera: 
    mov [di],dl    
    inc di ;para que pinte  a la derecha 
    cmp di, 6709 ; resultado de 20 * 320 + 319, el 319 significa que está en la última columna de la fila 
    jne primera


;barra horizontal inferior
; (i, j ) = (190, 0 )  => 180 * 320 + 0 = 57,600 
    mov di, 57610  ; se sumé 10 para el borde  
segunda: 
    mov [di],dl 
    inc di 
    cmp di, 57909 ; resultado de 180 * 320 + 319 = 57919 ,  le resté 10 por el borde
    jne segunda 

;barra vertical izq
    mov di , 6410  ; comenzamos en la primera posición de la barra horizontal superior
tercera: 
    mov [di],dl     
    add di, 320 ;ahora queremos pintar hacia abajo, por eso le sumamos los bytes de una fila, para que haga el cambio de fila 
    cmp di, 57610 ;terminamos en la primera posicion de la barra horizontal inferior   
    jne tercera 

;barra vertical derecha
    mov di , 6709 ; comenzamos en la ultima posicion de la barra horizontal superior
cuarta: 
    mov [di],dl     
    add di, 320 ;ahora queremos pintar hacia abajo, por eso le sumamos los bytes de una fila, para que haga el cambio de fila 
    cmp di, 57909 ;terminamos en la ultima posicion de la barra horizontal inferior 
    jne cuarta 

mov cx,8

mov ax,57610
mov bx,6410

;pinta las columnas del tablero
tableroVertical:

    mov di, bx
    lineaVertical: 
        mov [di],dl     
        add di, 320 
        cmp di, ax  
        jne lineaVertical

    add ax,37
    add bx,37

    loop tableroVertical


mov cx,8
mov ax,6709
mov bx,6410

;pinta las filas del tablero
tableroHorizontal:

    mov di, bx
    lineaHorizontal: 
        mov [di],dl     
        inc di 
        cmp di, ax  
        jne lineaHorizontal

    add ax,6400
    add bx,6400

    loop tableroHorizontal




salir:

endm 

;****************INICIO PINTANDO TABLERO*********************
pintar_tablero macro
LOCAL pCA2, pLA2,pCA4, pLA4,pCA6, pLA6,pCA8, pLA8,pCB1, pLB1,pCB3, pLB3,pCB5, pLB5,pCB7, pLB7,pCC2, pLC2,pCC4, pLC4,pCC6, pLC6,pCC8, pLC8,pCD1, pLD1,pCD3, pLD3,pCD5, pLD5,pCD7, pLD7,pCE2, pLE2,pCE4, pLE4,pCE6, pLE6,pCE8, pLE8,pCF1, pLF1,pCF3, pLF3,pCF5, pLF5,pCF7, pLF7
LOCAL pCG2, pLG2,pCG4, pLG4,pCG6, pLG6,pCG8, pLG8,pCH1, pLH1,pCH3, pLH3,pCH5, pLH5,pCH7, pLH7
;pintar las casillas del tablero 
;casilla A2
mov cx,36
mov ax,13131  ;320*20+0 = 6400
mov bx,19211

mov dl, 1111b
pCA2:

    mov di, ax
    pLA2:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLA2

    add ax,1
    add bx,1


loop pCA2

;casilla A4
mov cx,36
mov ax,25931 ;320*20+0 = 6400
mov bx,32011

mov dl, 1111b
pCA4:

    mov di, ax
    pLA4:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLA4

    add ax,1
    add bx,1


loop pCA4

;casilla A6
mov cx,36
mov ax,38731 ;320*2 = 640
mov bx,44811

mov dl, 1111b
pCA6:

    mov di, ax
    pLA6:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLA6

    add ax,1
    add bx,1


loop pCA6

;casilla A8
mov cx,36
mov ax,51531 ;320*2 = 640
mov bx,57611

mov dl, 1111b
pCA8:

    mov di, ax
    pLA8:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLA8

    add ax,1
    add bx,1


loop pCA8

;casilla B1
mov cx,36
mov ax,6768 ;320*2 = 640
mov bx,12848

mov dl, 1111b
pCB1:

    mov di, ax
    pLB1:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLB1

    add ax,1
    add bx,1


loop pCB1

;casilla B3
mov cx,36
mov ax,19568 ;320*2 = 640
mov bx,25648

mov dl, 1111b
pCB3:

    mov di, ax
    pLB3:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLB3

    add ax,1
    add bx,1


loop pCB3

;casilla B5
mov cx,36
mov ax,32368 ;320*2 = 640
mov bx,38448

mov dl, 1111b
pCB5:

    mov di, ax
    pLB5:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLB5

    add ax,1
    add bx,1


loop pCB5

;casilla B7
mov cx,36
mov ax,45168 ;320*2 = 640
mov bx,51248

mov dl, 1111b
pCB7:

    mov di, ax
    pLB7:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLB7

    add ax,1
    add bx,1


loop pCB7


;casilla C2
mov cx,36
mov ax,13205 ;320*21+96 = +320
mov bx,19285

mov dl, 1111b
pCC2:

    mov di, ax
    pLC2:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLC2

    add ax,1
    add bx,1


loop pCC2

;casilla C4
mov cx,36
mov ax,26005 ;320*21+96 = +320
mov bx,32085

mov dl, 1111b
pCC4:

    mov di, ax
    pLC4:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLC4

    add ax,1
    add bx,1


loop pCC4

;casilla C6
mov cx,36
mov ax,38805 ;320*21+96 = +320
mov bx,44885

mov dl, 1111b
pCC6:

    mov di, ax
    pLC6:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLC6

    add ax,1
    add bx,1


loop pCC6

;casilla C8
mov cx,36
mov ax,51605 ;320*21+96 = +320
mov bx,57685

mov dl, 1111b
pCC8:

    mov di, ax
    pLC8:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLC8

    add ax,1
    add bx,1


loop pCC8

;casilla D1
mov cx,36
mov ax,6842 ;320 o 640
mov bx,12922

mov dl, 1111b
pCD1:

    mov di, ax
    pLD1:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLD1

    add ax,1
    add bx,1


loop pCD1

;casilla D3
mov cx,36
mov ax,19642 ;320 o 640
mov bx,25722

mov dl, 1111b
pCD3:

    mov di, ax
    pLD3:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLD3

    add ax,1
    add bx,1


loop pCD3

;casilla D5
mov cx,36
mov ax,32442 ;320 o 640
mov bx,38522

mov dl, 1111b
pCD5:

    mov di, ax
    pLD5:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLD5

    add ax,1
    add bx,1


loop pCD5

;casilla D7
mov cx,36
mov ax,45242 ;320 o 640
mov bx,51322

mov dl, 1111b
pCD7:

    mov di, ax
    pLD7:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLD7

    add ax,1
    add bx,1


loop pCD7
;********************COLUMNA E********************
;casilla E2
mov cx,36
mov ax,13279 ;320 o 640
mov bx,19359

mov dl, 1111b
pCE2:

    mov di, ax
    pLE2:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLE2

    add ax,1
    add bx,1


loop pCE2

;casilla E4
mov cx,36
mov ax,26079 ;320 o 640
mov bx,32159

mov dl, 1111b
pCE4:

    mov di, ax
    pLE4:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLE4

    add ax,1
    add bx,1


loop pCE4

;casilla E6
mov cx,36
mov ax,38879 ;320 o 640
mov bx,44959

mov dl, 1111b
pCE6:

    mov di, ax
    pLE6:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLE6

    add ax,1
    add bx,1


loop pCE6

;casilla E8
mov cx,36
mov ax,51679 ;320 o 640
mov bx,57759

mov dl, 1111b
pCE8:

    mov di, ax
    pLE8:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLE8

    add ax,1
    add bx,1


loop pCE8
;***********************COLUMNA F*****************
;casilla F1
mov cx,36
mov ax,6916 ;320 o 640
mov bx,12996

mov dl, 1111b
pCF1:

    mov di, ax
    pLF1:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLF1

    add ax,1
    add bx,1


loop pCF1

;casilla F3
mov cx,36
mov ax,19716 ;320 o 640
mov bx,25796

mov dl, 1111b
pCF3:

    mov di, ax
    pLF3:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLF3

    add ax,1
    add bx,1


loop pCF3

;casilla F5
mov cx,36
mov ax,32516 ;320 o 640
mov bx,38596

mov dl, 1111b
pCF5:

    mov di, ax
    pLF5:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLF5

    add ax,1
    add bx,1


loop pCF5

;casilla F7
mov cx,36
mov ax,45316 ;320 o 640
mov bx,51396


mov dl, 1111b
pCF7:

    mov di, ax
    pLF7:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLF7

    add ax,1
    add bx,1


loop pCF7

;*********************COLUMNA G******************
;casilla G2
mov cx,36
mov ax,13353 ;320 o 640
mov bx,19433

mov dl, 1111b
pCG2:

    mov di, ax
    pLG2:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLG2

    add ax,1
    add bx,1


loop pCG2

;casilla G4
mov cx,36
mov ax,26153 ;320 o 640
mov bx,32233

mov dl, 1111b
pCG4:

    mov di, ax
    pLG4:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLG4

    add ax,1
    add bx,1


loop pCG4

;casilla G6
mov cx,36
mov ax,38953 ;320 o 640
mov bx,45033

mov dl, 1111b
pCG6:

    mov di, ax
    pLG6:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLG6

    add ax,1
    add bx,1


loop pCG6

;casilla G8
mov cx,36
mov ax,51753 ;320 o 640
mov bx,57833

mov dl, 1111b
pCG8:

    mov di, ax
    pLG8:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLG8

    add ax,1
    add bx,1


loop pCG8
;******************COLUMNA h******************
;casilla H1
mov cx,39
mov ax,6990 ;320 o 640
mov bx,13070

mov dl, 1111b
pCH1:

    mov di, ax
    pLH1:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLH1

    add ax,1
    add bx,1


loop pCH1

;casilla H3
mov cx,39
mov ax,19790 ;320 o 640
mov bx,25870

mov dl, 1111b
pCH3:

    mov di, ax
    pLH3:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLH3

    add ax,1
    add bx,1


loop pCH3

;casilla H5
mov cx,39
mov ax,32590 ;320 o 640
mov bx,38670

mov dl, 1111b
pCH5:

    mov di, ax
    pLH5:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLH5

    add ax,1
    add bx,1


loop pCH5

;casilla H7
mov cx,39
mov ax,45390 ;320 o 640
mov bx,51470

mov dl, 1111b
pCH7:

    mov di, ax
    pLH7:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLH7

    add ax,1
    add bx,1


loop pCH7


endm

pintar_azul macro inicio,fin
LOCAL pCAzul,pLAzul
;casilla H7
mov cx,10
mov ax,inicio ;320 o 640
mov bx,fin

mov dl, 0001b
pCAzul:

    mov di, ax
    pLAzul:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLAzul

    add ax,1
    add bx,1


loop pCAzul

endm

pintar_rojo macro inicio,fin
LOCAL pCRojo,pLRojo
;casilla H7
mov cx,10
mov ax,inicio ;320 o 640
mov bx,fin

mov dl, 0100b
pCRojo:

    mov di, ax
    pLRojo:
        mov [di],dl     
        add di, 320 
        cmp di, bx  
        jne pLRojo

    add ax,1
    add bx,1


loop pCRojo

endm
;************************FIN PINTANDO TABLERO

PintarCuadrado macro posicion , color 
    push dx
    mov di, posicion    
    mov dl, color 
;pintamos los 3 bytes de la primera fila 
    mov [di], dl   ; estamos pasando el color 
    mov [di+1], dl   ; estamos pasando el color 
    mov [di+2], dl   ; estamos pasando el color 
;pintamos la siguiente fila, esas 3 casillas 
    mov [di+320], dl
    mov [di+321], dl
    mov [di+322], dl
;pintamos la siguiente fila, esas 3 casillas 
    mov [di+640], dl
    mov [di+641], dl
    mov [di+642], dl

    mov [di+960], dl
    mov [di+961], dl
    mov [di+962], dl
    pop dx
endm

delay macro param   ;numero que queremos que se tarde
		push ax
		push bx
		xor ax, ax
		xor bx, bx
		;se asigna a ax y  comienza un ciclo
		;el ciclo solo se hace para perder tiempo
        mov ax,param
        ret2:
			dec ax  ;se decrementa ax de manera que llegue a 0 
			jz finRet
			mov bx, param  ;mientras  ax no sea 0, se asigna el parametro a bx 
			ret1:
				dec bx
			jnz ret1
		jmp ret2                
        finRet:
        pop bx
		pop ax
    endm 

imprimirVideo macro caracter, color
    mov ah, 09h
    mov al, caracter ;al guarda el valor que vamos a escribir
    mov bh, 0
    mov bl, color
    mov cx,1
    int 10h
endm


posicionarCursor macro y,x
    mov ah,02h
    mov dh,y
    mov dl,x
    mov bh,0
    int 10h
endm

p_fichas macro 
; LOCAL Ficha1,Ficha2,Ficha3,Ficha4,Ficha5,Ficha6,Ficha7,Ficha8,Ficha9,Ficha10,Ficha11,Ficha12,Ficha13,Ficha14,Ficha15,Ficha16,Ficha17,Ficha18,Ficha19,Ficha20
; LOCAL Ficha21,Ficha22,Ficha23,Ficha24,Ficha25,Ficha26,Ficha27,Ficha28,Ficha29,Ficha30,Ficha31,Ficha32,Ficha33,Ficha34,Ficha35,Ficha36,Ficha37,Ficha38,Ficha39,Ficha40
; LOCAL Ficha41,Ficha42,Ficha43,Ficha44,Ficha45,Ficha46,Ficha47,Ficha48,Ficha49,Ficha50,Ficha51,Ficha52,Ficha53,Ficha54,Ficha55,Ficha56,Ficha57,Ficha58,Ficha59,Ficha60
; LOCAL Ficha61,Ficha62,Ficha63,Ficha64,Salir

; LOCAL cas1n,cas2n,cas3n,cas4n,cas5n,cas6n,cas7n,cas8n,cas1b,cas2b,cas3b,cas4b,cas5b,cas6b,cas7b,cas8b
; LOCAL cas9n,cas10n,cas11n,cas12n,cas13n,cas14n,cas15n,cas16n,cas9b,cas10b,cas11b,cas12b,cas13b,cas14b,cas15b,cas16b
; LOCAL cas17n,cas18n,cas19n,cas20n,cas21n,cas22n,cas23n,cas24n,cas17b,cas18b,cas19b,cas20b,cas21b,cas22b,cas23b,cas24b
; LOCAL cas25n,cas26n,cas27n,cas28n,cas29n,cas30n,cas31n,cas32n,cas25b,cas26b,cas27b,cas28b,cas29b,cas30b,cas31b,cas32b
; LOCAL cas33n,cas34n,cas35n,cas36n,cas37n,cas38n,cas39n,cas40n,cas33b,cas34b,cas35b,cas36b,cas37b,cas38b,cas39b,cas40b
; LOCAL cas41n,cas42n,cas43n,cas44n,cas45n,cas46n,cas47n,cas48n,cas41b,cas42b,cas43b,cas44b,cas45b,cas46b,cas47b,cas48b
; LOCAL cas49n,cas50n,cas51n,cas52n,cas53n,cas54n,cas55n,cas56n,cas49b,cas50b,cas51b,cas52b,cas53b,cas54b,cas55b,cas56b
; LOCAL cas57n,cas58n,cas59n,cas60n,cas61n,cas62n,cas63n,cas94n,cas57b,cas58b,cas59b,cas60b,cas61b,cas62b,cas63b,cas64b



	Ficha1:
        pop dx ; A1
		cmp dl,98;--->b
		je cas1b
        cmp dl,110;--->n
        je cas1n

        jmp Ficha2
        cas1b:
            pintar_rojo 8342,11542
            jmp Ficha2
        cas1n:
            pintar_azul 8342,11542
            jmp Ficha2
    Ficha2:
        pop dx ; B1
		cmp dl,98;--->b
		je cas2b

        cmp dl,110;--->n
        je cas2n

        jmp Ficha3
        cas2b:
            pintar_rojo 8379,11579
            jmp Ficha3
        cas2n:
            pintar_azul 8379,11579
            jmp Ficha3
    
    Ficha3:
        pop dx ; C1
		cmp dl,98;--->b
		je cas3b
        cmp dl,110;--->n
        je cas3n

        jmp Ficha4
        cas3b:
            pintar_rojo 8416,11616
            jmp Ficha4
        cas3n:
            pintar_azul 8416,11616
            jmp Ficha4

    Ficha4:
        pop dx ;D1
		cmp dl,98;--->b
		je cas4b
        cmp dl,110;--->n
        je cas4n

        jmp Ficha5
        cas4b:
            pintar_rojo 8453,11653
            jmp Ficha5
        cas4n:
            pintar_azul 8453,11653
            jmp Ficha5

    Ficha5:
        pop dx  ;E1
	 	cmp dl,98;--->b
	  	je cas5b

        cmp dl,110;--->n
        je cas5n

        jmp Ficha6
        cas5b:
            pintar_rojo 8490,11690
            jmp Ficha6
        cas5n:
            pintar_azul 8490,11690
            jmp Ficha6

    Ficha6:
        pop dx  ;F1
		cmp dl,98;--->b
		je cas6b
        cmp dl,110;--->n
        je cas6n

        jmp Ficha7
        cas6b:
            pintar_rojo 8527,11727
            jmp Ficha7
        cas6n:
            pintar_azul 8527,11727
            jmp Ficha7

    Ficha7:
        pop dx  ;G1
		cmp dl,98;--->b
		je cas7b
        cmp dl,110;--->n
        je cas7n

        jmp Ficha8
        cas7b:
            pintar_rojo 8564,11764
            jmp Ficha8
        cas7n:
            pintar_azul 8564,11764
            jmp Ficha8

    Ficha8:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas8b
        cmp dl,110;--->n
        je cas8n

        jmp Ficha9
        cas8b:
            pintar_rojo 8601,11801
            jmp Ficha9
        cas8n:
            pintar_azul 8601,11801
            jmp Ficha9

    Ficha9:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas9b
        cmp dl,110;--->n
        je cas9n

        jmp Ficha10
        cas9b:
            pintar_rojo 14422,17622 ;si jala**************************************************
            jmp Ficha10
        cas9n:
            pintar_azul 14422,17622
            jmp Ficha10

    Ficha10:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas10b
        cmp dl,110;--->n
        je cas10n

        jmp Ficha11
        cas10b:
            pintar_rojo 14459,17659
            jmp Ficha11
        cas10n:
            pintar_azul 14459,17659
            jmp Ficha11
    
    Ficha11:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas11b
        cmp dl,110;--->n
        je cas11n

        jmp Ficha12
        cas11b:
            pintar_rojo 14496,17696
            jmp Ficha12
        cas11n:
            pintar_azul 14496,17696
            jmp Ficha12

    Ficha12:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas12b
        cmp dl,110;--->n
        je cas12n

        jmp Ficha13
        cas12b:
            pintar_rojo 14533,17733
            jmp Ficha13
        cas12n:
            pintar_azul 14533,17733
            jmp Ficha13

    Ficha13:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas13b
        cmp dl,110;--->n
        je cas13n

        jmp Ficha14
        cas13b:
            pintar_rojo 14570,17770
            jmp Ficha14
        cas13n:
            pintar_azul 14570,17770
            jmp Ficha14
    
    Ficha14:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas14b
        cmp dl,110;--->n
        je cas14n

        jmp Ficha15
        cas14b:
            pintar_rojo 14607,17807
            jmp Ficha15
        cas14n:
            pintar_azul 14607,17807
            jmp Ficha15

    Ficha15:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas15b
        cmp dl,110;--->n
        je cas15n

        jmp Ficha16
        cas15b:
            pintar_rojo 14644,17844
            jmp Ficha16
        cas15n:
            pintar_azul 14644,17844
            jmp Ficha16
    
    Ficha16:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas16b
        cmp dl,110;--->n
        je cas16n

        jmp Ficha17
        cas16b:
            pintar_rojo 14681,17881
            jmp Ficha17
        cas16n:
            pintar_azul 14681,17881
            jmp Ficha17
    
    Ficha17:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas17b
        cmp dl,110;--->n
        je cas17n

        jmp Ficha18
        cas17b:
            pintar_rojo 20502,23702 ;si jala**************************************************
            jmp Ficha18
        cas17n:
            pintar_azul 20502,23702
            jmp Ficha18

    Ficha18:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas18b
        cmp dl,110;--->n
        je cas18n

        jmp Ficha19
        cas18b:
            pintar_rojo 20539,23739
            jmp Ficha19
        cas18n:
            pintar_azul 20539,23739
            jmp Ficha19
    
    Ficha19:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas19b
        cmp dl,110;--->n
        je cas19n

        jmp Ficha20
        cas19b:
            pintar_rojo 20576,23776
            jmp Ficha20
        cas19n:
            pintar_azul 20576,23776
            jmp Ficha20

    Ficha20:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas20b
        cmp dl,110;--->n
        je cas20n

        jmp Ficha21
        cas20b:
            pintar_rojo 20613,23813
            jmp Ficha21
        cas20n:
            pintar_azul 20613,23813
            jmp Ficha21

    Ficha21:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas21b
        cmp dl,110;--->n
        je cas21n

        jmp Ficha22
        cas21b:
            pintar_rojo 20650,23850
            jmp Ficha22
        cas21n:
            pintar_azul 20650,23850
            jmp Ficha22
    
    Ficha22:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas22b
        cmp dl,110;--->n
        je cas22n

        jmp Ficha23
        cas22b:
            pintar_rojo 20687,23887
            jmp Ficha23
        cas22n:
            pintar_azul 20687,23887
            jmp Ficha23

    Ficha23:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas23b
        cmp dl,110;--->n
        je cas23n

        jmp Ficha24
        cas23b:
            pintar_rojo 20724,23924
            jmp Ficha24
        cas23n:
            pintar_azul 20724,23924
            jmp Ficha24
    
    Ficha24:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas24b
        cmp dl,110;--->n
        je cas24n

        jmp Ficha25
        cas24b:
            pintar_rojo 20761,23961
            jmp Ficha25
        cas24n:
            pintar_azul 20761,23961
            jmp Ficha25

    Ficha25:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas25b
        cmp dl,110;--->n
        je cas25n

        jmp Ficha26
        cas25b:
            pintar_rojo 27222,30422 ;si jala**************************************************
            jmp Ficha26
        cas25n:
            pintar_azul 27222,30422
            jmp Ficha26

    Ficha26:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas26b
        cmp dl,110;--->n
        je cas26n

        jmp Ficha27
        cas26b:
            pintar_rojo 27259,30459
            jmp Ficha27
        cas26n:
            pintar_azul 27259,30459
            jmp Ficha27
    
    Ficha27:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas27b
        cmp dl,110;--->n
        je cas27n

        jmp Ficha28
        cas27b:
            pintar_rojo 27296,30496
            jmp Ficha28
        cas27n:
            pintar_azul 27296,30496
            jmp Ficha28

    Ficha28:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas28b
        cmp dl,110;--->n
        je cas28n

        jmp Ficha29
        cas28b:
            pintar_rojo 27333,30533
            jmp Ficha29
        cas28n:
            pintar_azul 27333,30533
            jmp Ficha29

    Ficha29:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas29b
        cmp dl,110;--->n
        je cas29n

        jmp Ficha30
        cas29b:
            pintar_rojo 27370,30570
            jmp Ficha30
        cas29n:
            pintar_azul 27370,30570
            jmp Ficha30
    
    Ficha30:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas30b
        cmp dl,110;--->n
        je cas30n

        jmp Ficha31
        cas30b:
            pintar_rojo 27407,30607
            jmp Ficha31
        cas30n:
            pintar_azul 27407,30607
            jmp Ficha31

    Ficha31:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas31b
        cmp dl,110;--->n
        je cas31n

        jmp Ficha32
        cas31b:
            pintar_rojo 27444,30644
            jmp Ficha32
        cas31n:
            pintar_azul 27444,30644
            jmp Ficha32
    
    Ficha32:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas32b
        cmp dl,110;--->n
        je cas32n

        jmp Ficha33
        cas32b:
            pintar_rojo 27481,30681
            jmp Ficha33
        cas32n:
            pintar_azul 27481,30681
            jmp Ficha33

    Ficha33:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas33b
        cmp dl,110;--->n
        je cas33n

        jmp Ficha34
        cas33b:
            pintar_rojo 33942,37142 ;si jala**************************************************
            jmp Ficha34
        cas33n:
            pintar_azul 33942,37142
            jmp Ficha34

    Ficha34:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas34b
        cmp dl,110;--->n
        je cas34n

        jmp Ficha35
        cas34b:
            pintar_rojo 33979,37179
            jmp Ficha35
        cas34n:
            pintar_azul 33979,37179
            jmp Ficha35
    
    Ficha35:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas35b
        cmp dl,110;--->n
        je cas35n

        jmp Ficha36
        cas35b:
            pintar_rojo 34016,37216
            jmp Ficha36
        cas35n:
            pintar_azul 34016,37216
            jmp Ficha36

    Ficha36:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas36b
        cmp dl,110;--->n
        je cas36n

        jmp Ficha37
        cas36b:
            pintar_rojo 34053,37253
            jmp Ficha37
        cas36n:
            pintar_azul 34053,37253
            jmp Ficha37

    Ficha37:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas37b
        cmp dl,110;--->n
        je cas37n

        jmp Ficha38
        cas37b:
            pintar_rojo 34090,37290
            jmp Ficha38
        cas37n:
            pintar_azul 34090,37290
            jmp Ficha38
    
    Ficha38:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas38b
        cmp dl,110;--->n
        je cas38n

        jmp Ficha39
        cas38b:
            pintar_rojo 34127,37327
            jmp Ficha39
        cas38n:
            pintar_azul 34127,37327
            jmp Ficha39

    Ficha39:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas39b
        cmp dl,110;--->n
        je cas39n

        jmp Ficha40
        cas39b:
            pintar_rojo 34164,37364
            jmp Ficha40
        cas39n:
            pintar_azul 34164,37364
            jmp Ficha40
    
    Ficha40:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas40b
        cmp dl,110;--->n
        je cas40n

        jmp Ficha41
        cas40b:
            pintar_rojo 34201,37401
            jmp Ficha41
        cas40n:
            pintar_azul 34201,37401
            jmp Ficha41
    
    Ficha41:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas41b
        cmp dl,110;--->n
        je cas41n

        jmp Ficha42
        cas41b:
            pintar_rojo 40662,43862 ;si jala**************************************************
            jmp Ficha42
        cas41n:
            pintar_azul 40662,43862
            jmp Ficha42

    Ficha42:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas42b
        cmp dl,110;--->n
        je cas42n

        jmp Ficha43
        cas42b:
            pintar_rojo 40699,43899
            jmp Ficha43
        cas42n:
            pintar_azul 40699,43899
            jmp Ficha43
    
    Ficha43:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas43b
        cmp dl,110;--->n
        je cas43n

        jmp Ficha44
        cas43b:
            pintar_rojo 40736,43936
            jmp Ficha44
        cas43n:
            pintar_azul 40736,43936
            jmp Ficha44

    Ficha44:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas44b
        cmp dl,110;--->n
        je cas44n

        jmp Ficha45
        cas44b:
            pintar_rojo 40773,43973
            jmp Ficha45
        cas44n:
            pintar_azul 40773,43973
            jmp Ficha45

    Ficha45:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas45b
        cmp dl,110;--->n
        je cas45n

        jmp Ficha46
        cas45b:
            pintar_rojo 40810,44010
            jmp Ficha46
        cas45n:
            pintar_azul 40810,44010
            jmp Ficha46
    
    Ficha46:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas46b
        cmp dl,110;--->n
        je cas46n

        jmp Ficha47
        cas46b:
            pintar_rojo 40847,44047
            jmp Ficha47
        cas46n:
            pintar_azul 40847,44047
            jmp Ficha47

    Ficha47:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas47b
        cmp dl,110;--->n
        je cas47n

        jmp Ficha48
        cas47b:
            pintar_rojo 40884,44084
            jmp Ficha48
        cas47n:
            pintar_azul 40884,44084
            jmp Ficha48
    
    Ficha48:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas48b
        cmp dl,110;--->n
        je cas48n

        jmp Ficha49
        cas48b:
            pintar_rojo 40921,44121
            jmp Ficha49
        cas48n:
            pintar_azul 40921,44121
            jmp Ficha49

    Ficha49:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas49b
        cmp dl,110;--->n
        je cas49n

        jmp Ficha50
        cas49b:
            pintar_rojo 46742,49942 ;si jala**************************************************
            jmp Ficha50
        cas49n:
            pintar_azul 46742,49942
            jmp Ficha50

    Ficha50:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas50b
        cmp dl,110;--->n
        je cas50n

        jmp Ficha51
        cas50b:
            pintar_rojo 46779,49979
            jmp Ficha51
        cas50n:
            pintar_azul 46779,49979
            jmp Ficha51
    
    Ficha51:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas51b
        cmp dl,110;--->n
        je cas51n

        jmp Ficha52
        cas51b:
            pintar_rojo 46816,50016
            jmp Ficha52
        cas51n:
            pintar_azul 46816,50016
            jmp Ficha52

    Ficha52:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas52b
        cmp dl,110;--->n
        je cas52n

        jmp Ficha53
        cas52b:
            pintar_rojo 46853,50053
            jmp Ficha53
        cas52n:
            pintar_azul 46853,50053
            jmp Ficha53

    Ficha53:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas53b
        cmp dl,110;--->n
        je cas53n

        jmp Ficha54
        cas53b:
            pintar_rojo 46890,50090
            jmp Ficha54
        cas53n:
            pintar_azul 46890,50090
            jmp Ficha54
    
    Ficha54:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas54b
        cmp dl,110;--->n
        je cas54n

        jmp Ficha55
        cas54b:
            pintar_rojo 46927,50127
            jmp Ficha55
        cas54n:
            pintar_azul 46927,50127
            jmp Ficha55

    Ficha55:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas55b
        cmp dl,110;--->n
        je cas55n

        jmp Ficha56
        cas55b:
            pintar_rojo 46964,50164
            jmp Ficha56
        cas55n:
            pintar_azul 46964,50164
            jmp Ficha56
    
    Ficha56:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas56b
        cmp dl,110;--->n
        je cas56n

        jmp Ficha57
        cas56b:
            pintar_rojo 47001,50201
            jmp Ficha57
        cas56n:
            pintar_azul 47001,50201
            jmp Ficha57

    Ficha57:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas57b
        cmp dl,110;--->n
        je cas57n

        jmp Ficha58
        cas57b:
            pintar_rojo 53462,56662 ;si jala**************************************************
            jmp Ficha58
        cas57n:
            pintar_azul 53462,56662
            jmp Ficha58

    Ficha58:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas58b
        cmp dl,110;--->n
        je cas58n

        jmp Ficha59
        cas58b:
            pintar_rojo 53499,56699
            jmp Ficha59
        cas58n:
            pintar_azul 53499,56699
            jmp Ficha59
    
    Ficha59:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas59b
        cmp dl,110;--->n
        je cas59n

        jmp Ficha60
        cas59b:
            pintar_rojo 53536,56736
            jmp Ficha60
        cas59n:
            pintar_azul 53536,56736
            jmp Ficha60

    Ficha60:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas60b
        cmp dl,110;--->n
        je cas60n

        jmp Ficha61
        cas60b:
            pintar_rojo 53573,56773
            jmp Ficha61
        cas60n:
            pintar_azul 53573,56773
            jmp Ficha61

    Ficha61:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas61b
        cmp dl,110;--->n
        je cas61n

        jmp Ficha62
        cas61b:
            pintar_rojo 53610,56810
            jmp Ficha62
        cas61n:
            pintar_azul 53610,56810
            jmp Ficha62
    
    Ficha62:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas62b
        cmp dl,110;--->n
        je cas62n

        jmp Ficha63
        cas62b:
            pintar_rojo 53647,56847
            jmp Ficha63
        cas62n:
            pintar_azul 53647,56847
            jmp Ficha63

    Ficha63:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas63b
        cmp dl,110;--->n
        je cas63n

        jmp Ficha64
        cas63b:
            pintar_rojo 53684,56884
            jmp Ficha64
        cas63n:
            pintar_azul 53684,56884
            jmp Ficha64
    
    Ficha64:
        pop dx  ;H1
		cmp dl,98;--->b
		je cas64b
        cmp dl,110;--->n
        je cas64n

        jmp salirse
        cas64b:
            pintar_rojo 53721,56921
            jmp salirse
        cas64n:
            pintar_azul 53721,56921
            jmp salirse

    salirse:


endm

llenado_pila macro arreglo
    mov al,tablero[64]
    push ax
    mov al,tablero[63]
    push ax
    mov al,tablero[62]
    push ax
    mov al,tablero[61]
    push ax
    mov al,tablero[60]
    push ax
    mov al,tablero[59]
    push ax
    mov al,tablero[58]
    push ax
    mov al,tablero[57]
    push ax
    mov al,tablero[56]
    push ax
    mov al,tablero[55]
    push ax
    mov al,tablero[54]
    push ax
    mov al,tablero[53]
    push ax
    mov al,tablero[52]
    push ax
    mov al,tablero[51]
    push ax
    mov al,tablero[50]
    push ax
    mov al,tablero[49]
    push ax
    mov al,tablero[48]
    push ax
    mov al,tablero[47]
    push ax
    mov al,tablero[46]
    push ax
    mov al,tablero[45]
    push ax
    mov al,tablero[44]
    push ax
    mov al,tablero[43]
    push ax
    mov al,tablero[42]
    push ax
    mov al,tablero[41]
    push ax
    mov al,tablero[40]
    push ax
    mov al,tablero[39]
    push ax
    mov al,tablero[38]
    push ax
    mov al,tablero[37]
    push ax
    mov al,tablero[36]
    push ax
    mov al,tablero[35]
    push ax
    mov al,tablero[34]
    push ax
    mov al,tablero[33]
    push ax
    mov al,tablero[32]
    push ax
    mov al,tablero[31]
    push ax
    mov al,tablero[30]
    push ax
    mov al,tablero[29]
    push ax
    mov al,tablero[28]
    push ax
    mov al,tablero[27]
    push ax
    mov al,tablero[26]
    push ax
    mov al,tablero[25]
    push ax
    mov al,tablero[24]
    push ax
    mov al,tablero[23]
    push ax
    mov al,tablero[22]
    push ax
    mov al,tablero[21]
    push ax
    mov al,tablero[20]
    push ax
    mov al,tablero[19]
    push ax
    mov al,tablero[18]
    push ax
    mov al,tablero[17]
    push ax
    mov al,tablero[16]
    push ax
    mov al,tablero[15]
    push ax
    mov al,tablero[14]
    push ax
    mov al,tablero[13]
    push ax
    mov al,tablero[12]
    push ax
    mov al,tablero[11]
    push ax
    mov al,tablero[10]
    push ax
    mov al,tablero[9]
    push ax
    mov al,tablero[8]
    push ax
    mov al,tablero[7]
    push ax
    mov al,tablero[6]
    push ax
    mov al,tablero[5]
    push ax
    mov al,tablero[4]
    push ax
    mov al,tablero[3]
    push ax
    mov al,tablero[2]
    push ax
    mov al,tablero[1]
    push ax
endm