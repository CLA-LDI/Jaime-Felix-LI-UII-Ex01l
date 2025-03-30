					TITLE	Examen Unidad II Tipo l
					PAGE	60, 132

; Incluir las macros
Include Macros.inc

; Prototipos de llamadas al sistema operativo
GetStdHandle	PROTO	:QWORD
ReadConsoleW	PROTO	:QWORD,	:QWORD, :QWORD, :QWORD, :QWORD
WriteConsoleW	PROTO	:QWORD,	:QWORD, :QWORD, :QWORD, :QWORD
ExitProcess		PROTO	CodigoSalida:QWORD

				.DATA
; Definir las variables A y Categoria así como los mensajes de entrada correspondientes y el mensaje de salida
A				QWORD	0
Categoria		WORD	?
MenEnt01		WORD	'P', 'r', 'o', 'p', 'o', 'r', 'c', 'i', 'o', 'n', 'e', ' ', 'e', 'l', ' ', 'v', 'a', 'l', 'o', 'r', ' ', 'd', 'e', ' ', 'A', ':', ' '
MenSal01		WORD	'L', 'a', ' ', 'c', 'a', 't', 'e', 'g', 'o', 'r', 'i', 'a', ' ', 'e', 's', ':', ' '

; Variables utilizadas por las llamadas al sistema
ManejadorE		QWORD	?
ManejadorS		QWORD	?
Caracteres		QWORD	?
Texto			WORD	13 DUP ( ? )				; Variable temporal para conversión Entero - Cadena, Cadena - Entero
SaltoLinea		WORD	13, 10
STD_INPUT		EQU	-10
STD_OUTPUT		EQU	-11

				.CODE
Principal			PROC

				; Alinear espacio en la pila
				SUB		RSP, 40

				; Obtener manejador estándar del teclado
				MOV		RCX, STD_INPUT
				CALL		GetStdHandle
				MOV		ManejadorE, RAX

				; Obtener manejador estándar de la consola
				MOV		RCX, STD_OUTPUT
				CALL		GetStdHandle
				MOV		ManejadorS, RAX

				; Solicitar la variable A
				MOV		RCX, ManejadorS				; Manejador de la consola donde se escribe
				LEA		RDX, MenEnt01				; Dirección de la cadena a escribir
				MOV		R8, LENGTHOF MenEnt01			; Número de caracteres a escribir
				LEA		R9, Caracteres				; Dirección de la variable donde se guarda el total de caracteres escrito
				CALL		WriteConsoleW

				MOV		RCX, ManejadorE				; Manejador del teclado donde se lee la cadena
				LEA		RDX, Texto				; Dirección de la cadena a leer
				MOV		R8, LENGTHOF Texto			; Número de caracteres máximo a leer
				LEA		R9, Caracteres				; Dirección de la variable donde se guarda el total de caracteres leídos
				CALL		ReadConsoleW
				MacroCadenaAEntero	Texto, A

				; Evaluar la categoria según la siguiente tabla
				;	CATEGORIA		CONDICION
				;		A			A % 5 == 0
				;		B			A % 5 == 1
				;		C			A % 5 == 2
				;		D			A % 5 == 3
				;		E			A % 5 == 4

				; Mostrar el mensaje de salida
				MOV		RCX, ManejadorS				; Manejador de la consola donde se escribe
				LEA		RDX, MenSal01				; Dirección de la cadena a escribir
				MOV		R8, LENGTHOF MenSal01			; Número de caracteres a escribir
				LEA		R9, Caracteres				; Dirección de la variable donde se guarda el total de caracteres escrito
				CALL		WriteConsoleW

				; Mostrar el valor de Categoria

				; Salto de línea
				MOV		RCX, ManejadorS				; Manejador de la consola donde se escribe
				LEA		RDX, SaltoLinea				; Dirección de la cadena a escribir
				MOV		R8, LENGTHOF SaltoLinea			; Número de caracteres a escribir
				LEA		R9, Caracteres				; Dirección de la variable donde se guarda el total de caracteres escrito
				CALL		WriteConsoleW

				; Salir al sistema operativo
				MOV		RCX, 0
				CALL		ExitProcess

Principal			ENDP
				END
