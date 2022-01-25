include PraMacro.asm
cerrar macro handler
	
	mov ah,3eh
	mov bx, handler
	int 21h
	
	mov handler,ax

endm

escribir macro handler, buffer, numbytes

	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	

endm

llenar macro buffer, buffere, numbytes
LOCAL Repetir,copiard,Salir
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
        mov al,buffere[di]
        cmp al,00h
        je copiard
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
        inc di
		Loop Repetir ;se va a repetir hasta que cx sea 0 

    copiard:
        xor di,di
        cmp cx,0
        je Salir
    
    Salir:
		mov al,00h
		mov buffer[si],al
    pop dx
    pop bx
    pop ax
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

agregarExtension macro buffer,bufferex,numbytes
LOCAL Repetir,copiard
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
        cmp al,00h
        je copiard
		mov buffer[si], al ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
		Loop Repetir ;se va a repetir hasta que cx sea 0 
    copiard:
        mov al,'.'
		mov buffer[si],al
        inc si
        mov al,'h'
        mov buffer[si],al
        inc si
        mov al,'t'
        mov buffer[si],al
        inc si
        mov al,'m'
        mov buffer[si],al
        inc si
        mov al,'l'
        mov buffer[si],al
		inc si
		mov al,00h
        mov buffer[si],al
    pop dx
    pop bx
    pop ax
	pop cx
	pop si
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

agregarInfo macro arreglo
	mov arreglo[0],60;<
    mov arreglo[1],104;h
    mov arreglo[2],116;t
    mov arreglo[3],109;m
    mov arreglo[4],108;l
    mov arreglo[5],62;>

endm

validacion_rep macro rep_s
LOCAL letrar,letrae,letrap,fin,limpiara,llenara,cerrara
mov al,rep_s[0]
cmp al,82
je letrar

jmp fin
letrar:
    mov al,rep_s[1]
    cmp al,69
    je letrae

    jmp fin
letrae:
    mov al,rep_s[2]
    cmp al,80
    je letrap

    jmp fin

letrap:
    print msgreporte
    
    jmp limpiara
    ;jmp fin
limpiara:
    limpiar bufferInformacion,SIZEOF bufferInformacion,24h
    agregarInfo bufferInformacion
    limpiar bufferExtension,SIZEOF bufferExtension,24h
    agregarExtension bufferExtension,bufferInformacion,SIZEOF bufferExtension
    jmp llenara
llenara:
    crear bufferExtension,handlerEntrada
    limpiar bufferInformacion,SIZEOF bufferInformacion,00h
    ;llenar bufferInformacion,bufferEntrada,
    escribir handlerEntrada,bufferInformacion,SIZEOF bufferInformacion
    jmp cerrara
cerrara:
    cerrar handlerEntrada
    jmp fin
fin:
    print msgreportefin

endm

validacion_negro macro com
LOCAL izquierda,derecha,fin
mov al,com[0]
mov posicionInicial[0],al ; arreglo1[0] = comando[0]

mov al,com[1]
mov posicionInicial[1],al ; arreglo1[1] = comando[1]

mov al,com[3]
mov posicionFinal[0],al ;  arreglo2[0] = comando[3]

mov al,com[4]
mov posicionFinal[1],al ;  arreglo2[1] = comando[4]




ConversionCoordenadas posicionInicial ;convierte la coordenada y la guarda en al


xor si,si ;si tiene el indicie inicial
mov si,ax

ConversionCoordenadas posicionFinal ;convierte la coordenada y la guarda en al

xor di,di ;di tiene el indice inicial
mov di,ax

;aqui van validaciones
xor ax,ax
xor bx,bx
xor cx,cx
;para la casilla cuando se izquierda dif 18
;fuente-destino = 18
mov ax,si
sub ax,di
cmp ax,14
je derecha

mov ax,0
;para la casilla cuando se derecha dif 14
;fuente - destino = 14
mov ax,si
sub ax,di
cmp ax,18
je izquierda

    izquierda:
        ;restarle 9 para obtener casilla a borrar
        print msjizquierda
        sub di,9 
        mov tablero[di],95 ;arreglo[si] = '_'
        add punto_negro,1

        jmp fin
        ;restar 7 al ax 
    derecha:
        ;restarle 7 para obtener casilla a borrar
        print msjderecha
        sub di,7
        mov tablero[di],95 ;arreglo[di] = '_'
        add punto_negro,1

        jmp fin
    fin:

endm
validacion_blanco macro com
LOCAL izquierda,derecha,fin
mov al,com[0]
mov posicionInicial[0],al ; arreglo1[0] = comando[0]

mov al,com[1]
mov posicionInicial[1],al ; arreglo1[1] = comando[1]

mov al,com[3]
mov posicionFinal[0],al ;  arreglo2[0] = comando[3]

mov al,com[4]
mov posicionFinal[1],al ;  arreglo2[1] = comando[4]




ConversionCoordenadas posicionInicial ;convierte la coordenada y la guarda en al


xor si,si ;si tiene el indicie inicial
mov si,ax

ConversionCoordenadas posicionFinal ;convierte la coordenada y la guarda en al

xor di,di ;di tiene el indice inicial
mov di,ax

;aqui van validaciones
xor ax,ax
xor bx,bx
xor cx,cx
;para la casilla cuando se izquierda dif 18
;fuente-destino = 18
mov ax,si
sub ax,di
cmp ax,18
je izquierda

mov ax,0
;para la casilla cuando se derecha dif 14
;fuente - destino = 14
mov ax,si
sub ax,di
cmp ax,14
je derecha

    izquierda:
        ;restarle 9 para obtener casilla a borrar
        print msjizquierda
        add di,9 
        mov tablero[di],95 ;arreglo[si] = '_'
        ;aumentar punteo
        add punto_blanco,1
       
       
        jmp fin
        ;restar 7 al ax 
    derecha:
        ;restarle 7 para obtener casilla a borrar
        print msjderecha
        add di,7
        mov tablero[di],95 ;arreglo[di] = '_'
        ;aumentar punteo
        add punto_blanco,1
        
        
        jmp fin
    fin:

endm

ImprimirTablero macro arreglo 
LOCAL Mientras, FinMientras, ImprimirSalto,filauno,filados,filatres,filacuatro,filacinco,filaseis,filasiete,filaocho
push si
push di
push cx

xor si,si
mov si,1
xor di,di
xor cx,cx
mov cx,1
	Mientras:
        cmp si,1           ;para fila 1
        je filauno

        cmp si,9            ;para fila 2
        je filados

        cmp si,17       ;fila tres
        je filatres

        cmp si,25       ;fila cuatro
        je filacuatro

        cmp si,33       ;fila cinco
        je filacinco

        cmp si,41       ;fila seis
        je filaseis

        cmp si,49       ;fila siete
        je filasiete

        cmp si,57       ;filaocho
        je filaocho

		cmp si,65
		je FinMientras				; while(si<=64){}


			mov al, arreglo[si]
			mov aux, al 		   ; print(arreglo[si])
			print aux

			cmp di,7
			je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

            

			mov aux,32   		; else{print(" ")
			print aux
			

			inc di				;di++
			inc si   			; si++}
		jmp Mientras

	ImprimirSalto:
		xor di,di 			; di = 0
		print salto			;print("/n")
		inc si  			; si++
        inc cx
		jmp Mientras

    filauno:
        mov aux,49
        print aux
        mov aux,32   		; else{print(" ")
		print aux

		mov al, arreglo[si]
		mov aux, al 		   ; print(arreglo[si])
		print aux

		cmp di,7
		je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

		mov aux,32   		; else{print(" ")
		print aux
			
		inc di				;di++
		inc si   			; si++}
        jmp Mientras
    
    filados:
        mov aux,50
        print aux
        mov aux,32   		; else{print(" ")
		print aux

		mov al, arreglo[si]
		mov aux, al 		   ; print(arreglo[si])
		print aux

		cmp di,7
		je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

		mov aux,32   		; else{print(" ")
		print aux
			
		inc di				;di++
		inc si   			; si++}
        jmp Mientras

    filatres:
        mov aux,51
        print aux
        mov aux,32   		; else{print(" ")
		print aux

		mov al, arreglo[si]
		mov aux, al 		   ; print(arreglo[si])
		print aux

		cmp di,7
		je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

		mov aux,32   		; else{print(" ")
		print aux
			
		inc di				;di++
		inc si   			; si++}
        jmp Mientras

    filacuatro:
        mov aux,52
        print aux
        mov aux,32   		; else{print(" ")
		print aux

		mov al, arreglo[si]
		mov aux, al 		   ; print(arreglo[si])
		print aux

		cmp di,7
		je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

		mov aux,32   		; else{print(" ")
		print aux
			
		inc di				;di++
		inc si   			; si++}
        jmp Mientras    
    
    filacinco:
        mov aux,53
        print aux
        mov aux,32   		; else{print(" ")
		print aux

		mov al, arreglo[si]
		mov aux, al 		   ; print(arreglo[si])
		print aux

		cmp di,7
		je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

		mov aux,32   		; else{print(" ")
		print aux
			
		inc di				;di++
		inc si   			; si++}
        jmp Mientras

    filaseis:
        mov aux,54
        print aux
        mov aux,32   		; else{print(" ")
		print aux

		mov al, arreglo[si]
		mov aux, al 		   ; print(arreglo[si])
		print aux

		cmp di,7
		je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

		mov aux,32   		; else{print(" ")
		print aux
			
		inc di				;di++
		inc si   			; si++}
        jmp Mientras   

    filasiete:
        mov aux,55
        print aux
        mov aux,32   		; else{print(" ")
		print aux

		mov al, arreglo[si]
		mov aux, al 		   ; print(arreglo[si])
		print aux

		cmp di,7
		je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

		mov aux,32   		; else{print(" ")
		print aux
			
		inc di				;di++
		inc si   			; si++}
        jmp Mientras 
    
    filaocho:
        mov aux,56
        print aux
        mov aux,32   		; else{print(" ")
		print aux

		mov al, arreglo[si]
		mov aux, al 		   ; print(arreglo[si])
		print aux

		cmp di,7
		je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

		mov aux,32   		; else{print(" ")
		print aux
			
		inc di				;di++
		inc si   			; si++}
        jmp Mientras

	FinMientras:

pop cx
pop di
pop si
endm

AnalizarComando macro com ; A1:B2 arreglo1 = [A][1]; arreglo2 = [B][2]

mov al,com[0]
mov posicionInicial[0],al ; arreglo1[0] = comando[0]

mov al,com[1]
mov posicionInicial[1],al ; arreglo1[1] = comando[1]

mov al,com[3]
mov posicionFinal[0],al ;  arreglo2[0] = comando[3]

mov al,com[4]
mov posicionFinal[1],al ;  arreglo2[1] = comando[4]




ConversionCoordenadas posicionInicial ;convierte la coordenada y la guarda en al


xor si,si ;si tiene el indicie inicial
mov si,ax

ConversionCoordenadas posicionFinal ;convierte la coordenada y la guarda en al

xor di,di ;di tiene el indice inicial
mov di,ax


;aqui van validaciones

xor ax,ax

mov al, tablero[si] ;al = arreglo[si]
mov tablero[si],95 ;arreglo[si] = '_'

mov tablero[di],al ;arreglo[di] = arreglo[si]

endm


ConversionCoordenadas macro coordenada ; A1 -> 1 -> (columna) + (fila-1)*4
; ADD valor1, valor2 -> valor1 = valor1 + valor2
; MUL valor -> al = al * valor
; SUB valor1, valor2 -> valor1 = valor1 - valor2
; DIV valor -> al = al / valor -> ah tiene el residuo 

mov al, coordenada[0] ; al = A = 65
mov columna, al        ; columna = 65
ConversionColumna columna ; columna convertida

mov al, coordenada[1] ; al = 1 = 49
mov fila,al 		  ; fila =  49

ConversionFila fila

xor ax,ax
xor bx,bx

mov al,fila ;fila - 1
SUB al,1

mov bl,8
MUL bl  ; (fila-1)*8 -> al

xor bx,bx
mov bl,columna 

ADD al,bl ;(columna) + (fila-1)*8 = al

;la conversion del resultado se guarda en al 
;IntToString ax,numero
;print numero
;print salto

endm

ConversionColumna macro valor ; valor = valor - 64

mov al,valor ; al = valor
sub al,64   ; al = al - 64
mov valor,al ; valor = al

endm

ConversionFila macro valor ; valor = valor - 48

mov al,valor ; al = valor
sub al,48   ; al = al - 48
mov valor,al ; valor = al

endm

.model small

;----------------------------segmento de pila----------------------
.stack


;----------------------------segmento de datos--------------------
.data
;menu principal
menuprincipal db 0ah, 0dh,'Universidad San Carlos De Guatemala', 0ah, 0dh, 'Arquitectura y Ensambladores 1',0ah, 0dh, 'Francisco Magdiel Asicona Mateo 201801449',0ah,0dh,'Comandos : ',0ah,0dh,'* Jugar: Destino:Fuente',0ah,0dh,'* Reporte:REP','$'
opcion db 0ah, 0dh,'Ingrese un comando valido : ', '$'
salto db 0ah, 0dh,' ', '$'

;menu del juego
nombre1 db 0ah, 0dh,'Ingrese nombre P1 : ','$'
nombre2 db 0ah, 0dh,'Ingrese nombre P2 : ','$'

encabezadotabla db 0ah,0dh,'   A B C D E F G H ','$'
opciontexto db 5 dup('$'),'$'
opcionplay db 'PLAY','$'
opcionRep db 'REP','$'
noigual db 'NO ES','$'

tablero db 64 dup('$'),'$'
comando db 5 dup('$'),'$'
numero db 2 dup('$'), '$'
posicionInicial db 2 dup('$'), '$'
posicionFinal db 2 dup('$'), '$'
valorInicial db 0, '$' 
valorFinal db 0, '$' 
aux db 0, '$' 
resultado db 0, '$'
columna db 0, '$'
fila db 0, '$'

ficha_blanca db 0ah,0dh,'Ficha que controla: Blanca','$'
ficha_negra db 0ah,0dh,'Ficha que controla: Negra','$'

puntaje_blanca db 0ah,0dh,'Puntaje de Blancas: ','$'
puntaje_negra db 0ah,0dh,'Puntaje de Negras: ','$'

ingreso_comando db 0ah,0dh,'Ingrese la coordenada: ','$'

nombre_blanca db 0ah,0dh, 'Nombre del Jugador Blanco:','$'
nombre_negra db 0ah,0dh,'Nombre del Jugador de Negro:','$'

punto_blanco db 0
punto_negro db 0

msjderecha db 0ah,0dh,'mov derecha','$'
msjizquierda db 0ah,0dh,'mov izquierda','$'
msjreporte db 0ah,0dh,'Generar reporte: ','$'

msgreporte db 0ah,0dh,'Estamos en repo','$'
msgreportefin db 0ah,0dh,'FIn Reporte','$'
rep_s db 4 dup('$'),'$' 

bufferEntrada db 'R','E','P','$'
bufferExtension db 105 dup('$'),'$'
handlerEntrada dw ?
bufferInformacion db 1000 dup('$'),'$'

;--------------------------segmento de código--------------------
.code 

main proc

    menu:
        print salto
        mov tablero[0],0
        mov tablero[1],110
        mov tablero[2],95
        mov tablero[3],110
        mov tablero[4],95
        mov tablero[5],110
        mov tablero[6],95
        mov tablero[7],110
        mov tablero[8],95
        mov tablero[9],95
        mov tablero[10],110

        mov tablero[11],95
        mov tablero[12],110
        mov tablero[13],95
        mov tablero[14],110
        mov tablero[15],95
        mov tablero[16],110
        mov tablero[17],110
        mov tablero[18],95
        mov tablero[19],110
        mov tablero[20],95

        mov tablero[21],110
        mov tablero[22],95
        mov tablero[23],110
        mov tablero[24],95
        mov tablero[25],95
        mov tablero[26],95
        mov tablero[27],95
        mov tablero[28],95
        mov tablero[29],95
        mov tablero[30],95

        mov tablero[31],95
        mov tablero[32],95
        mov tablero[33],95
        mov tablero[34],95
        mov tablero[35],95
        mov tablero[36],95
        mov tablero[37],95
        mov tablero[38],95
        mov tablero[39],95
        mov tablero[40],95

        mov tablero[41],95
        mov tablero[42],98
        mov tablero[43],95
        mov tablero[44],98
        mov tablero[45],95
        mov tablero[46],98
        mov tablero[47],95
        mov tablero[48],98
        mov tablero[49],98
        mov tablero[50],95

        mov tablero[51],98
        mov tablero[52],95
        mov tablero[53],98
        mov tablero[54],95
        mov tablero[55],98
        mov tablero[56],95
        mov tablero[57],95
        mov tablero[58],98
        mov tablero[59],95
        mov tablero[60],98

        mov tablero[61],95
        mov tablero[62],98
        mov tablero[63],95
        mov tablero[64],98


        print salto
        print menuprincipal
        print salto
        print opcion
        print nombre1
        obtenerNombre nombre1
        print nombre2
        obtenerNombre nombre2
        print salto;salto
        
    juego:
        jugador1:
            print nombre_blanca
            print nombre1
            print ficha_blanca
            print puntaje_blanca
            printp punto_blanco
            print encabezadotabla
            print salto
            ImprimirTablero tablero
            print salto
            print ingreso_comando
            obtenerNombre comando
            AnalizarComando comando
            validacion_blanco comando
            print salto
            print msjreporte
            obtenerNombre rep_s
            ;validacion_rep rep_s
            mov al,rep_s[0]
            cmp al,82
            je val1

            jmp jugador2
        jugador2:
            print nombre_negra
            print nombre2
            print ficha_negra
            print puntaje_negra
            printp punto_negro
            print encabezadotabla
            print salto
            ImprimirTablero tablero
            print salto
            print ingreso_comando
            obtenerNombre comando
            AnalizarComando comando
            validacion_negro comando
            print salto
            jmp jugador1

        val1:
            mov al,rep_s[1]
            cmp al,69
            je val2

            jmp jugador2
        val2:
            mov al,rep_s[2]
            cmp al,80
            je val3

            jmp jugador2
        val3:
            print msgreporte
            
            limpiar bufferInformacion,SIZEOF bufferInformacion,24h
            agregarInfo bufferInformacion

            limpiar bufferExtension,SIZEOF bufferExtension,24h
            agregarExtension bufferExtension,rep_s,SIZEOF bufferExtension
            crear bufferExtension,handlerEntrada
            limpiar bufferInformacion,SIZEOF bufferInformacion,00h
            ;llenar bufferInformacion,bufferEntrada,
            escribir handlerEntrada,bufferInformacion,SIZEOF bufferInformacion
            cerrar handlerEntrada
            print msgreportefin
            jmp jugador2
    salir:
        close

main endp

end main