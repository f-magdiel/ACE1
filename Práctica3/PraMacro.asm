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




