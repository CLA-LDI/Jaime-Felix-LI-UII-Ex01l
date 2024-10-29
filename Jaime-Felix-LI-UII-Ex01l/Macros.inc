; Macros.inc
; Contiene las macros para convertir enteros a cadena y viceversa

; MacroEnteroACadena
; Esta macro convierte un entero de 64 bits con signo
; en su representación en cadena para su impresión posterior
; usando la función WriteConsoleW


MacroEnteroACadena	MACRO	Numero, Cadena, Contador
LOCAL	Inicio
LOCAL	Repetir
LOCAL	Sacar
			; Salvar todos los registros
			PUSH	RAX
			PUSH	RBX
			PUSH	RCX
			PUSH	RDX
			PUSH	RSI

			LEA	RSI, Cadena
			MOV	WORD PTR [RSI], 32	; Positivo, no lleva signo (espacio en blanco)
			MOV	RAX, Numero
			CMP	RAX, 0
			JGE	Inicio
			; Numero negativo
			; Poner signo e invertir
			MOV	WORD PTR [RSI], 45	; Negativo, signo de menos
			NEG	RAX

Inicio:
			ADD	RSI, 2			; Siguiente posición después del signo
			MOV	RCX, 0			; Contador de caracteres
			MOV	RBX, 10			; Dividir entre 10

Repetir:
			INC	RCX
			CQO				; RDX:RAX <- RAX
			DIV	RBX
			PUSH	RDX			; Residuo en la pila
			CMP	RAX, 0			; ¿Seguir dividiendo?
			JNE	Repetir

			; RCX tiene el total de caracteres
			MOV	Contador, RCX
			INC	Contador		; Por el signo

			; Sacar los residuos de la pila y convertirlos en caracteres
Sacar:
			POP	RDX
			OR	DL, 30H			; Convertir caractera a ASCII
			MOV	[RSI], DL
			ADD	RSI, 2
			LOOP	Sacar

			; Fin. Cadena tiene el número y Contador el total de caracteres
			; Recuperar todos los registros
			POP	RSI
			POP	RDX
			POP	RCX
			POP	RBX
			POP	RAX
			ENDM


MacroCadenaAEntero	MACRO	Cadena, Numero
LOCAL Saltar
LOCAL SiguienteEspacio
LOCAL VerificarSigno
LOCAL Empezar
LOCAL Terminar
LOCAL Salir
			;PUSHAD
			PUSH	RAX
			PUSH	RBX
			PUSH	RCX
			PUSH	RDX
			PUSH	RSI
			PUSH	RDI

			LEA	RSI, Cadena
			MOV	RAX, 0
			MOV	RBX, 10
			MOV	RDI, 0			; Positivo

			;Saltar blancos y tabuladores
Saltar:
			CMP	BYTE PTR [RSI], 32	; Espacio en blanco
			JE	SiguienteEspacio
			CMP	BYTE PTR [RSI], 9	; Tabulador
			JNE	VerificarSigno
SiguienteEspacio:
			ADD	RSI, 2
			JMP	Saltar

			;El signo solo puede ser el primer caracter
VerificarSigno:
			CMP	BYTE PTR [RSI], '-'
			JNE	Empezar
			MOV	RDI, 1			; Negativo
			ADD	RSI, 2

			; Convertir dígitos a números
			; Salir cuando no sea dígito
Empezar:
			CMP	BYTE PTR [RSI], '0'
			JB	Terminar		; Si es menor que 0
			CMP	BYTE PTR [RSI], '9'
			JA	Terminar		; Si es mayor que 0
			MUL	RBX
			MOV	DL, [RSI]
			AND	RDX, 0000000FH		; Convertir dígito a número
			ADD	RAX, RDX
			ADD	RSI, 2
			JMP	Empezar

			; Si tenía signo, negar el número
Terminar:		CMP	RDI, 0
			JE	Salir
			NEG	RAX

			; Dejarlo en número
Salir:			MOV	Numero, RAX
			;POPAD
			POP	RDI
			POP	RSI
			POP	RDX
			POP	RCX
			POP	RBX
			POP	RAX
			ENDM
