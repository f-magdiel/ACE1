include P4mac.asm

StringToInt macro string
LOCAL Unidades,Decenas,salir, Centenas

	sizeNumberString string; en la variable bl me retorna la cantidad de digitos
	xor ax,ax
	xor cx,cx

	cmp bl,1
	je Unidades

	cmp bl,2
	je Decenas

	cmp bl,3
	je Centenas



	Unidades:
		mov al,string[0]
		SUB al,30h
		jmp salir

	Decenas:

		mov al,string[0]
		sub al,30h
		mov bl,10
		mul bl


		xor bx,bx
		mov bl,string[1]
		sub bl,30h

		add al,bl

		jmp salir

;bl 1111 1111 ->255
; 0 - 999 
; bx 1111 1111 1111 1111 -> 65535
	Centenas:
	    ;543
		mov al,string[0] ;[0] -> 53 -> 5 en ascii
		sub al,30h;  -> 53-48 = 5 => Ax=5 => Ax-Ah,Al
		mov bx,100;  -> bx = 100
		mul bx; -> ax*bx = 5*100 = 500
		mov cx,ax; cx = 500
		;dx = Centenas

		xor ax,ax ; ax = 0
		mov al,string[1] ;[1] -> 52 -> 4 en ascii
		sub al,30h ; -> 52-48 = 4 => Ax=4 => Ax-Ah,Al
		mov bx,10 ;  -> bx = 10
		mul bx ; -> ax*bx = 4*10 = 40

		xor bx,bx
		mov bl,string[2] ;[2] -> 51 -> 3 en ascii
		sub bl,30h ; -> 51-48 = 3 => Ax=3 => Ax-Ah,Al

		add ax,bx ; ax = 3 + 40
		add ax,cx ; ax = 43 + 500 = 543
		
		jmp salir

	salir:
	

endm

sizeNumberString macro string
LOCAL LeerNumero, endTexto
	xor si,si ; xor si,si =	mov si,0
	xor bx,bx

	LeerNumero:
		mov bl,string[si] ;mov destino, fuente
		cmp bl,24h ; ascii de signo dolar
		je endTexto
		inc si ; si = si + 1
		jmp LeerNumero

	endTexto:
		mov bx,si

endm
;-----------------------------------
IntToString macro num, number ; ax 1111 1111 1111 1111 -> 65535
LOCAL Inicio,Final,Mientras,MientrasN,Cero,InicioN
push si
push di
limpiar number,SIZEOF number,24h
mov ax,num ; ax = numero entero a convertir 23
cmp ax,0 
je Cero
xor di,di
xor si,si
jmp Inicio

;ax = 123

Inicio:
	
	cmp ax,0 ;ax = 0
	je Mientras
	mov dx,0 
	mov cx,10 
	div cx ; 1/10 = ax = 0 dx = 2
	mov bx,dx 
	add bx,30h ; 1 + 48 = ascii 
	push bx 
	inc di	; di = 3
	jmp Inicio

Mientras:
	;si = 0 , di = 3
	cmp si,di 
	je Final
	pop bx 
	mov number[si],bl 
	inc si 
	;si = 2 di = 3
	jmp Mientras

Cero:
 mov number[0],30h
 jmp Final

Final:
pop di
pop si


endm
;-------------------------------------













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
LOCAL izquierda,derecha,fin,validacion
mov al,com[0]
mov posicionInicial[0],al ; arreglo1[0] = comando[0]

mov al,com[1]
mov posicionInicial[1],al ; arreglo1[1] = comando[1]

mov al,com[3]
mov posicionFinal[0],al ;  arreglo2[0] = comando[3]

mov al,com[4]
mov posicionFinal[1],al ;  arreglo2[1] = comando[4]


ConversionCoordenadas posicionInicial ;convierte la coordenada y la guarda en al

xor bx,bx
mov bx,ax
mov aux1,bx
xor ax,ax

ConversionCoordenadas posicionFinal ;convierte la coordenada y la guarda en al

xor cx,cx
mov cx,ax
mov aux2,cx

xor ax,ax
xor bx,bx

mov ax,aux2
mov bx,aux1
sub ax,bx ; se realiza la suma y ax lo guarda
mov aux3,ax ; se mueve el valor de ax a aux3 para guardarlo

xor ax,ax
xor bx,bx

mov bx,aux3 ; se mueve el valor de aux3 a ax para realizar la comparacion
mov ax,18

cmp ax,bx ;valida si la dif 18 = 18
je izquierda
jne validacion


    izquierda:
        ;restarle 9 para obtener casilla a borrar
        print msjizquierda
        xor ax,ax
        xor bx,bx
        xor di,di
        xor si,si

        mov ax,aux1;posicion inicial
        mov bx,aux1;posicion inicial
        add bx,9    ;pos incial mas 9
        mov si,ax
        mov di,bx
        
        mov tablero[di],95
        mov tablero[si],95 ;arreglo[si] = '_'
        ;aumentar punteo
        add punto_negro,1
        jmp fin
        ;restar 7 al ax 
    derecha:
        ;restarle 7 para obtener casilla a borrar
        print msjderecha
        xor ax,ax
        xor bx,bx
        xor di,di
        xor si,si

        mov ax,aux1;posicion inicial
        mov bx,aux1;posicion inicial
        add bx,7
        mov si,ax
        mov di,bx
        
        mov tablero[di],95
        mov tablero[si],95 ;arreglo[si] = '_'
        ;aumentar punteo
        add punto_negro,1
        
        jmp fin
    validacion:
        xor ax,ax
        xor bx,bx
        mov ax,14
        mov bx,aux3

        cmp ax,bx;si es 14 = 14
        je derecha
        jne fin

    fin:

endm
;VALIDACION BLANCO .......................................
validacion_blanco macro com
LOCAL izquierda,derecha,fin,validacion
mov al,com[0]
mov posicionInicial[0],al ; arreglo1[0] = comando[0]
mov al,com[1]
mov posicionInicial[1],al ; arreglo1[1] = comando[1]
mov al,com[3]
mov posicionFinal[0],al ;  arreglo2[0] = comando[3]
mov al,com[4]
mov posicionFinal[1],al ;  arreglo2[1] = comando[4]


ConversionCoordenadas posicionInicial ;convierte la coordenada y la guarda en al
xor bx,bx
mov bx,ax
mov aux1,bx
xor ax,ax


ConversionCoordenadas posicionFinal ;convierte la coordenada y la guarda en al
xor cx,cx
mov cx,ax
mov aux2,cx

xor ax,ax
xor bx,bx

mov ax,aux1
mov bx,aux2
sub ax,bx ; se realiza la resta y ax lo guarda
mov aux3,ax ; se mueve el valor de ax a aux3 para guardarlo


xor ax,ax
xor bx,bx

mov bx,aux3 ; se mueve el valor de aux3 a ax para realizar la comparacion
mov ax,18

cmp ax,bx ;valida si la dif 18 = 18
je izquierda
jne validacion

;la resta entre posicion inicial y final

    izquierda:
        ;sumarle 9 para obtener casilla a borrar
        print msjizquierda
        xor ax,ax
        xor bx,bx
        xor di,di
        xor si,si

        mov ax,aux1;posicion inicial
        mov bx,aux2;posicion final
        add bx,9
        mov si,ax
        mov di,bx
        
        mov tablero[di],95
        mov tablero[si],95 ;arreglo[si] = '_'
        ;aumentar punteo
        add punto_blanco,1
        
        jmp fin
         
    derecha:
        ;restarle 7 para obtener casilla a borrar
        print msjderecha
        xor ax,ax
        xor bx,bx
        xor di,di
        xor si,si

        mov ax,aux1;posicion inicial
        mov bx,aux2;posicion final
        add bx,7
        mov si,ax
        mov di,bx
        
        mov tablero[di],95
        mov tablero[si],95 ;arreglo[si] = '_'
        ;aumentar punteo
        add punto_blanco,1
        jmp fin

    validacion:
        xor ax,ax
        xor bx,bx
        mov ax,14
        mov bx,aux3

        cmp ax,bx;14 = 14
        je derecha
        jne fin

        
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
menuprincipal db 0ah, 0dh,'Universidad San Carlos De Guatemala', 0ah, 0dh, 'Arquitectura y Ensambladores 1',0ah, 0dh, 'Francisco Magdiel Asicona Mateo 201801449',0ah,0dh,'PRACTICA 4 ','$'
salto db 0ah, 0dh,' ', '$'

;menu del juego
nombre1 db 0ah, 0dh,'Ingrese nombre P1 : ','$'
nombre2 db 0ah, 0dh,'Ingrese nombre P2 : ','$'
nombre_blanco db 100 dup('$'),'$'
nombre_negro db 100 dup('$'),'$'

encabezadotabla db 0ah,0dh,'   A B C D E F G H ','$'
opciontexto db 5 dup('$'),'$'
opcionplay db 'PLAY','$'
opcionRep db 'REP','$'
noigual db 'NO ES','$'

tablero db 64 dup('$'),'$'
comando db 5 dup('$'),'$'
numero_b db 4 dup('$'), '$'
numero_n db 4 dup('$'),'$'
resultado db 2 dup('$'),'$'

posicionInicial db 2 dup('$'), '$'
posicionFinal db 2 dup('$'), '$'
valorInicial db 0, '$' 
valorFinal db 0, '$' 
aux db 0, '$' 

columna db 0, '$'
fila db 0, '$'

ficha_blanca db 0ah,0dh,'Ficha que controla: Rojo','$'
ficha_negra db 0ah,0dh,'Ficha que controla: Azul','$'

puntaje_blanca db 0ah,0dh,'Puntaje de Rojo: ','$'
puntaje_negra db 0ah,0dh,'Puntaje de Azul: ','$'

ingreso_comando db 0ah,0dh,'Ingrese la coordenada: ','$'

nombre_blanca db 0ah,0dh, 'Nombre del Jugador Rojo:','$'
nombre_negra db 0ah,0dh,'Nombre del Jugador de Azul:','$'

punto_blanco dw 0
punto_negro dw 0

msjderecha db 0ah,0dh,'mov derecha','$'
msjizquierda db 0ah,0dh,'mov izquierda','$'
msjreporte db 0ah,0dh,'Generar reporte: ','$'

msgreporte db 0ah,0dh,'Estamos en repo','$'
msgreportefin db 0ah,0dh,'FIn Reporte','$'
mjsazul db 0ah,0dh,'Turno Azul','$'
msjrojo db 0ah,0dh,'Turno Rojo','$'
rep_s db 4 dup('$'),'$' 

aux1 dw 0
aux2 dw 0
aux3 dw 0
aux4 dw 0

num1 dw 0
num2 dw 0

contador dw 1
;---------------HTML-------------------
bufferentrada db 'practica3','$'
bufferExtension db 105 dup('$'),'$'
bufferDefecto db '<h2>Angel Lopez - 201807299</h2><h2>Juan Paxtor - 201700470</h2><h2>Danny Cuxum - 201709528</h2><h2>Magdiel Asicona - 201801449</h2>','$' 
handlerentrada dw ?
bufferInformacion db 2000 dup('$'),'$'
nombreReporte db 0ah,0dh,'Ingrese nombre archivo: ','$'
extension db 'reporte.html','$'
;------------------ESTRUCTURA-----------------------
tabla1 db '<html> <CENTER> <TABLE BORDER CELLPADDING = 10 CELLSPACING = 0 > <TR> <TD>NOMBRES</TD> <TD>PUNTOS</TD> </TR>','$'
inicioN db '<TR> <TD>','$'
medioN  db '</TD> <TD>','$'
finN    db '</TD> </TR>','$'
;nombre
;----------grafica de tablero-----------
iniciotablero db '</TABLE> </CENTER> <CENTER> <H1>TABLERO</H1> <TABLE BORDER> <TR> <TD> *</TD><TD>A</TD> <TD>B</TD> <TD>C</TD><TD>D</TD><TD>E</TD><TD>F</TD><TD>G</TD><TD>H</TD> </TR>','$'
tdinicio db '<TD>','$'
tdfin db '</TD>','$'
trinicio db '<TR>','$'
trfin db '</TR>','$'
fintablero db '</TABLE> </CENTER></html>','$'
graficatablero1 db '<TR><TD>1</TD> <TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD></TR>','$'
graficatablero2 db '<TR><TD>2</TD> <TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD></TR>','$'
graficatablero3 db '<TR><TD>3</TD> <TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD></TR>','$'
graficatablero4 db '<TR><TD>4</TD> <TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD></TR>','$'
graficatablero5 db '<TR><TD>5</TD> <TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD></TR>','$'
graficatablero6 db '<TR><TD>6</TD> <TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD></TR>','$'
graficatablero7 db '<TR><TD>7</TD> <TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD></TR>','$'
graficatablero8 db '<TR><TD>8</TD> <TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD><TD>*</TD> <TD>*</TD></TR>','$'
;........arrays auxes..........
arregloNombre1 db 500 dup('$'),'$'
arregloNombre2 db 500 dup('$'),'$'


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
        print nombre1
        obtenerNombre nombre_blanco
        print nombre2
        obtenerNombre nombre_negro
        print salto;salto
        
    juego:
        jugador1:
            ; print nombre_blanca
            ; print nombre_blanco
            ; print ficha_blanca
            ; print puntaje_blanca
            IntToString punto_blanco,numero_b
            ; print numero_b
            ; print encabezadotabla
            print salto
            llenado_pila tablero
            ;_________NOMBRE
            xor ax,ax
            mov al,nombre_blanco[6]
            push ax
            mov al,nombre_blanco[5]
            push ax
            mov al,nombre_blanco[4]
            push ax
            mov al,nombre_blanco[3]
            push ax
            mov al,nombre_blanco[2]
            push ax
            mov al,nombre_blanco[1]
            push ax
            mov al,nombre_blanco[0]
            push ax
            ;_________________PUNTO

            xor ax,ax
            mov al,numero_b[3]
            push ax
            mov al,numero_b[2]
            push ax
            mov al,numero_b[1]
            push ax
            mov al,numero_b[0]
            push ax

            ;_________________PORCENTAJE



            ;**********************entra modo video

            ModoVideo
            ;--------------------TITULOS----------------------
            posicionarCursor 0,0  ;posicionar cursors (y,x)
            imprimirVideo 'n' , 0100b
            posicionarCursor 0,1  ;posicionar cursors (y,x)
            imprimirVideo 'o' , 0100b
            posicionarCursor 0,2  ;posicionar cursors (y,x)
            imprimirVideo 'm' , 0100b
            posicionarCursor 0,3  ;posicionar cursors (y,x)
            imprimirVideo 'b' , 0100b
            posicionarCursor 0,4  ;posicionar cursors (y,x)
            imprimirVideo 'r' , 0100b
            posicionarCursor 0,5  ;posicionar cursors (y,x)
            imprimirVideo 'e' , 0100b
            posicionarCursor 0,6  ;posicionar cursors (y,x)
            imprimirVideo ':' , 0100b
            
            posicionarCursor 0,11  ;posicionar cursors (y,x)
            imprimirVideo 'c' , 0100b
            posicionarCursor 0,12  ;posicionar cursors (y,x)
            imprimirVideo 'o' , 0100b
            posicionarCursor 0,13  ;posicionar cursors (y,x)
            imprimirVideo 'l' , 0100b
            posicionarCursor 0,14  ;posicionar cursors (y,x)
            imprimirVideo 'o' , 0100b
            posicionarCursor 0,15  ;posicionar cursors (y,x)
            imprimirVideo 'r' , 0100b
            posicionarCursor 0,16  ;posicionar cursors (y,x)
            imprimirVideo ':' , 0100b
            
            posicionarCursor 0,22  ;posicionar cursors (y,x)
            imprimirVideo 'p' , 0100b
            posicionarCursor 0,23  ;posicionar cursors (y,x)
            imprimirVideo 'u' , 0100b
            posicionarCursor 0,24  ;posicionar cursors (y,x)
            imprimirVideo 'n' , 0100b
            posicionarCursor 0,25  ;posicionar cursors (y,x)
            imprimirVideo 't' , 0100b
            posicionarCursor 0,26  ;posicionar cursors (y,x)
            imprimirVideo 'e' , 0100b
            posicionarCursor 0,27  ;posicionar cursors (y,x)
            imprimirVideo 'o' , 0100b
            posicionarCursor 0,28  ;posicionar cursors (y,x)
            imprimirVideo ':' , 0100b
            
            posicionarCursor 0,33  ;posicionar cursors (y,x)
            imprimirVideo 'p' , 0100b
            posicionarCursor 0,34  ;posicionar cursors (y,x)
            imprimirVideo 'o' , 0100b
            posicionarCursor 0,35  ;posicionar cursors (y,x)
            imprimirVideo 'r' , 0100b
            posicionarCursor 0,36  ;posicionar cursors (y,x)
            imprimirVideo 'c' , 0100b
            posicionarCursor 0,37  ;posicionar cursors (y,x)
            imprimirVideo 'e' , 0100b
            posicionarCursor 0,38  ;posicionar cursors (y,x)
            imprimirVideo 'n' , 0100b
            posicionarCursor 0,39  ;posicionar cursors (y,x)
            imprimirVideo ':' , 0100b
            
            ;___________SETEO DE TITULOS-----------
            pop ax
            posicionarCursor 1,22 
            imprimirVideo al,0100b
            pop ax
            posicionarCursor 1,23 
            imprimirVideo al,0100b
            pop ax
            posicionarCursor 1,24 
            imprimirVideo al,0100b
            pop ax
            posicionarCursor 1,25 
            imprimirVideo al,0100b

            pop ax
            posicionarCursor 1,0 
            imprimirVideo al,0100b
            pop ax
            posicionarCursor 1,1 
            imprimirVideo al,0100b
            pop ax
            posicionarCursor 1,2 
            imprimirVideo al,0100b
            pop ax
            posicionarCursor 1,3 
            imprimirVideo al,0100b
            pop ax
            posicionarCursor 1,4 
            imprimirVideo al,0100b
            pop ax
            posicionarCursor 1,5 
            imprimirVideo al,0100b
            pop ax
            posicionarCursor 1,6 
            imprimirVideo al,0100b

            ;--------------------TITULOS----------------------
		    PintarMargen 1111b
		    pintar_tablero
            p_fichas;donde se ingresan las fichas en modo video
            getChar
		    ModoTexto
            ;***************sale modo video
            ;ImprimirTablero tablero
            print msjrojo
            print salto
            print ingreso_comando
            obtenerNombre comando
            AnalizarComando comando
            validacion_blanco comando
            print salto

            print msjreporte
            obtenerNombre rep_s
            mov al,rep_s[0]
            cmp al,82
            je val1
            jne jugador2

        jugador2:
            ; print nombre_negra
            ; print nombre2
            ; print ficha_negra
            ; print puntaje_negra
            IntToString punto_negro,numero_n
            ; print numero_n
            ; print encabezadotabla
            print salto
            ;ImprimirTablero tablero
            ; llenado_pila tablero
            ; ;_________NOMBRE
            ; xor ax,ax
            ; mov al,nombre_negra[6]
            ; push ax
            ; mov al,nombre_negra[5]
            ; push ax
            ; mov al,nombre_negra[4]
            ; push ax
            ; mov al,nombre_negra[3]
            ; push ax
            ; mov al,nombre_negra[2]
            ; push ax
            ; mov al,nombre_negra[1]
            ; push ax
            ; mov al,nombre_negra[0]
            ; push ax
            ; ;_________________PUNTO

            ; xor ax,ax
            ; mov al,numero_n[3]
            ; push ax
            ; mov al,numero_n[2]
            ; push ax
            ; mov al,numero_n[1]
            ; push ax
            ; mov al,numero_n[0]
            ; push ax

            ; ;_________________PORCENTAJE



            ; ;**********************entra modo video

            ; ModoVideo
            ; ;--------------------TITULOS----------------------
            ; posicionarCursor 0,0  ;posicionar cursors (y,x)
            ; imprimirVideo 'n' , 0001b
            ; posicionarCursor 0,1  ;posicionar cursors (y,x)
            ; imprimirVideo 'o' , 0001b
            ; posicionarCursor 0,2  ;posicionar cursors (y,x)
            ; imprimirVideo 'm' , 0001b
            ; posicionarCursor 0,3  ;posicionar cursors (y,x)
            ; imprimirVideo 'b' , 0001b
            ; posicionarCursor 0,4  ;posicionar cursors (y,x)
            ; imprimirVideo 'r' , 0001b
            ; posicionarCursor 0,5  ;posicionar cursors (y,x)
            ; imprimirVideo 'e' , 0001b
            ; posicionarCursor 0,6  ;posicionar cursors (y,x)
            ; imprimirVideo ':' , 0001b
            
            ; posicionarCursor 0,11  ;posicionar cursors (y,x)
            ; imprimirVideo 'c' , 0001b
            ; posicionarCursor 0,12  ;posicionar cursors (y,x)
            ; imprimirVideo 'o' , 0001b
            ; posicionarCursor 0,13  ;posicionar cursors (y,x)
            ; imprimirVideo 'l' , 0001b
            ; posicionarCursor 0,14  ;posicionar cursors (y,x)
            ; imprimirVideo 'o' , 0001b
            ; posicionarCursor 0,15  ;posicionar cursors (y,x)
            ; imprimirVideo 'r' , 0001b
            ; posicionarCursor 0,16  ;posicionar cursors (y,x)
            ; imprimirVideo ':' , 0001b
            
            ; posicionarCursor 0,22  ;posicionar cursors (y,x)
            ; imprimirVideo 'p' , 0001b
            ; posicionarCursor 0,23  ;posicionar cursors (y,x)
            ; imprimirVideo 'u' , 0001b
            ; posicionarCursor 0,24  ;posicionar cursors (y,x)
            ; imprimirVideo 'n' , 0001b
            ; posicionarCursor 0,25  ;posicionar cursors (y,x)
            ; imprimirVideo 't' , 0001b
            ; posicionarCursor 0,26  ;posicionar cursors (y,x)
            ; imprimirVideo 'e' , 0001b
            ; posicionarCursor 0,27  ;posicionar cursors (y,x)
            ; imprimirVideo 'o' , 0001b
            ; posicionarCursor 0,28  ;posicionar cursors (y,x)
            ; imprimirVideo ':' , 0001b
            
            ; posicionarCursor 0,33  ;posicionar cursors (y,x)
            ; imprimirVideo 'p' , 0001b
            ; posicionarCursor 0,34  ;posicionar cursors (y,x)
            ; imprimirVideo 'o' , 0001b
            ; posicionarCursor 0,35  ;posicionar cursors (y,x)
            ; imprimirVideo 'r' , 0001b
            ; posicionarCursor 0,36  ;posicionar cursors (y,x)
            ; imprimirVideo 'c' , 0001b
            ; posicionarCursor 0,37  ;posicionar cursors (y,x)
            ; imprimirVideo 'e' , 0001b
            ; posicionarCursor 0,38  ;posicionar cursors (y,x)
            ; imprimirVideo 'n' , 0001b
            ; posicionarCursor 0,39  ;posicionar cursors (y,x)
            ; imprimirVideo ':' , 0001b
            
            ; ;___________SETEO DE TITULOS-----------
            ; pop ax
            ; posicionarCursor 1,22 
            ; imprimirVideo al,0001b
            ; pop ax
            ; posicionarCursor 1,23 
            ; imprimirVideo al,0001b
            ; pop ax
            ; posicionarCursor 1,24 
            ; imprimirVideo al,0001b
            ; pop ax
            ; posicionarCursor 1,25 
            ; imprimirVideo al,0001b

            ; pop ax
            ; posicionarCursor 1,0 
            ; imprimirVideo al,0001b
            ; pop ax
            ; posicionarCursor 1,1 
            ; imprimirVideo al,0001b
            ; pop ax
            ; posicionarCursor 1,2 
            ; imprimirVideo al,0001b
            ; pop ax
            ; posicionarCursor 1,3 
            ; imprimirVideo al,0001b
            ; pop ax
            ; posicionarCursor 1,4 
            ; imprimirVideo al,0001b
            ; pop ax
            ; posicionarCursor 1,5 
            ; imprimirVideo al,0001b
            ; pop ax
            ; posicionarCursor 1,6 
            ; imprimirVideo al,0001b

            ; ;--------------------TITULOS----------------------
		    ; PintarMargen 1111b
		    ; pintar_tablero
            ; p_fichas;donde se ingresan las fichas en modo video
            ; getChar
		    ; ModoTexto
            ;***************sale modo video
            print mjsazul
            print salto
            print ingreso_comando
            obtenerNombre comando
            AnalizarComando comando
            validacion_negro comando
            print salto

            print msjreporte
            obtenerNombre rep_s
            mov al,rep_s[0]
            cmp al,82
            je sal1
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
            limpiar bufferentrada, SIZEOF bufferentrada,24h
            print nombreReporte
		    obtenerRuta bufferentrada
            
            limpiar bufferExtension,SIZEOF bufferExtension,24h
            agregarExtension bufferExtension,extension,SIZEOF bufferExtension

            crear bufferExtension, handlerentrada
            limpiar bufferInformacion,SIZEOF bufferInformacion,00h
            ;para blancos
            IntToString punto_blanco,numero_b
            ;para negros
            IntToString punto_negro,numero_n

            limpiar bufferentrada,SIZEOF bufferentrada,00h
            limpiar arregloNombre1,SIZEOF arregloNombre1,24h
            limpiar arregloNombre2,SIZEOF arregloNombre2,24h
            ;para blancos
            insercionNombre arregloNombre1,inicioN,medioN,finN,nombre_blanco,numero_b,SIZEOF arregloNombre1
            ;para negros 
            insercionNombre arregloNombre2,inicioN,medioN,finN,nombre_negro,numero_n,SIZEOF arregloNombre2
            ;para preparar todo el tablero
            cambio graficatablero1,tablero,SIZEOF graficatablero1,1
            cambio graficatablero2,tablero,SIZEOF graficatablero2,9
            cambio graficatablero3,tablero,SIZEOF graficatablero3,17
            cambio graficatablero4,tablero,SIZEOF graficatablero4,25
            cambio graficatablero5,tablero,SIZEOF graficatablero5,33
            cambio graficatablero6,tablero,SIZEOF graficatablero6,41
            cambio graficatablero7,tablero,SIZEOF graficatablero7,49
            cambio graficatablero8,tablero,SIZEOF graficatablero8,57

            ;solo es llenado
            llenar bufferInformacion,tabla1,arregloNombre1,arregloNombre2,iniciotablero,graficatablero1,graficatablero2,graficatablero3,graficatablero4,graficatablero5,graficatablero6,graficatablero7,graficatablero8,fintablero,SIZEOF bufferInformacion
            escribir  handlerentrada, bufferInformacion, SIZEOF bufferInformacion

            cerrar handlerentrada
            ;resetear todo el tablero
            reseteo graficatablero1,SIZEOF graficatablero1
            reseteo graficatablero2,SIZEOF graficatablero2
            reseteo graficatablero3,SIZEOF graficatablero3
            reseteo graficatablero4,SIZEOF graficatablero4
            reseteo graficatablero5,SIZEOF graficatablero5
            reseteo graficatablero6,SIZEOF graficatablero6
            reseteo graficatablero7,SIZEOF graficatablero7
            reseteo graficatablero8,SIZEOF graficatablero8

            ;limpiar reos
            limpiar rep_s,SIZEOF rep_s,24h
            print msgreportefin
            jmp jugador2
        sal1:
            mov al,rep_s[1]
            cmp al,69
            je sal2

            jmp jugador1

        sal2:
            mov al,rep_s[2]
            cmp al,80
            je sal3

            jmp jugador1

        sal3:   
            print msgreporte
            limpiar bufferentrada, SIZEOF bufferentrada,24h
            print nombreReporte
		    obtenerRuta bufferentrada
            
            limpiar bufferExtension,SIZEOF bufferExtension,24h
            agregarExtension bufferExtension,extension,SIZEOF bufferExtension

            crear bufferExtension, handlerentrada
            limpiar bufferInformacion,SIZEOF bufferInformacion,00h
            ;para blancos
            IntToString punto_blanco,numero_b
            ;para negros
            IntToString punto_negro,numero_n

            limpiar bufferentrada,SIZEOF bufferentrada,00h
            limpiar arregloNombre1,SIZEOF arregloNombre1,24h
            limpiar arregloNombre2,SIZEOF arregloNombre2,24h
            ;para blancos
            insercionNombre arregloNombre1,inicioN,medioN,finN,nombre_blanco,numero_b,SIZEOF arregloNombre1
            ;para negros 
            insercionNombre arregloNombre2,inicioN,medioN,finN,nombre_negro,numero_n,SIZEOF arregloNombre2
            ;para preparar todo el tablero
            cambio graficatablero1,tablero,SIZEOF graficatablero1,1
            cambio graficatablero2,tablero,SIZEOF graficatablero2,9
            cambio graficatablero3,tablero,SIZEOF graficatablero3,17
            cambio graficatablero4,tablero,SIZEOF graficatablero4,25
            cambio graficatablero5,tablero,SIZEOF graficatablero5,33
            cambio graficatablero6,tablero,SIZEOF graficatablero6,41
            cambio graficatablero7,tablero,SIZEOF graficatablero7,49
            cambio graficatablero8,tablero,SIZEOF graficatablero8,57

            ;solo es llenado
            llenar bufferInformacion,tabla1,arregloNombre1,arregloNombre2,iniciotablero,graficatablero1,graficatablero2,graficatablero3,graficatablero4,graficatablero5,graficatablero6,graficatablero7,graficatablero8,fintablero,SIZEOF bufferInformacion
            escribir  handlerentrada, bufferInformacion, SIZEOF bufferInformacion

            cerrar handlerentrada
            ;resetear todo el tablero
            reseteo graficatablero1,SIZEOF graficatablero1
            reseteo graficatablero2,SIZEOF graficatablero2
            reseteo graficatablero3,SIZEOF graficatablero3
            reseteo graficatablero4,SIZEOF graficatablero4
            reseteo graficatablero5,SIZEOF graficatablero5
            reseteo graficatablero6,SIZEOF graficatablero6
            reseteo graficatablero7,SIZEOF graficatablero7
            reseteo graficatablero8,SIZEOF graficatablero8

            ;limpiar reos
            limpiar rep_s,SIZEOF rep_s,24h
            print msgreportefin
            jmp jugador1
        
    salir:
        close

main endp

end main