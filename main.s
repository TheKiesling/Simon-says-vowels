/* --------------------------------------------------------------------------------------
* UNIVERSIDAD DEL VALLE DE GUATEMALA 
* Organizacion de computadoras y Assembler
* Ciclo 1 - 2022
* -------------------------------
* Adrian Ricardo Flores Trujillo 21500
* Andrea Ximena Ramirez Recinos 21874
* Jose Pablo Kiesling Lange 21581
* -------------------------------
* Main.s
* Controla las acciones principales del juego y las subrutinas de otros programas
 -------------------------------------------------------------------------------------- */

/* --------------------------------------- TEXT --------------------------------------- */
.text
.global 	main
.extern 	printf
.extern 	wiringPiSetupPhys
.extern 	pinMode
.extern 	digitalWrite
.extern 	delay

main:   
	push 	{ip, lr}	
	
	mov 	r5, #7					// Indicar cantidad de pins
	mov 	r6,#5					// Indicar la cantidad de vocales
	mov 	r7,#1

	bl		wiringPiSetupPhys		// Inicializar librería wiringpi
	mov		r1,#-1					// -1 representa un código de error
	cmp		r0, r1					// verifica si se retornó cod error en r0
	bne		config					// NO error, entonces iniciar programa
	ldr		r0, =ErrMsg				// SI error, 
	bl		printf					// imprimir mensaje y					
	b		exit					// salir del programa

config:
	ldr		r4, =pin				// coloca el #pin wiringpi a r4
	ldr		r0, [r4,r9]				// carga el valor del pin que corresponde
	mov		r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl		pinMode					// llama funcion wiringpi para configurar
	add 	r9, #4					// Añade 4 bytes 
	subs 	r5,#1					// resta 1 y lo guarda en bandera
	bne 	config 					// regresar a etiqueta

	mov 	r9,#0
	mov 	r5,#7

reset:
	ldr 	r4,=pin
	ldr 	r0,[r4,r9]
	mov 	r1,#0
	bl 	    digitalWrite			
	add 	r9,#4
	subs 	r5,#1						
	bne 	reset 			

print_vowels:
	cmp 	r6,#5
	ldreq 	r4,=a
	moveq 	r5,#6

	cmp 	r6,#4
	ldreq 	r4,=e
	moveq 	r5,#5

	cmp 	r6,#3
	ldreq 	r4,=i
	moveq 	r5,#2

	cmp 	r6,#2
	ldreq 	r4,=o
	moveq 	r5,#6

	cmp 	r6,#1
	ldreq 	r4,=u
	moveq 	r5,#5

	mov 	r9,#0

	change_display:
		ldr 	r0,[r4,r9]
		mov 	r1,#1
		bl 	    digitalWrite			
		add 	r9,#4
		subs 	r5,#1					
		bne 	change_display 			

	ldr		r0,=delayMs
	ldr		r0,[r0]
	bl		delay 

	mov		r9,#0
	mov 	r5,#7
	subs 	r6,#1
	bne 	reset

final_reset:
	ldr 	r4,=pin
	ldr 	r0,[r4,r9]
	mov 	r1,#0
	bl 	    digitalWrite			
	add 	r9,#4
	subs 	r5,#1					
	bne 	final_reset 			

exit:
	pop 	{ip, pc}

/* --------------------------------------- DATA --------------------------------------- */
.data
.balign 4

/* --- Variables --- */
a: 			.word 	29,31,33,36,37,38
e: 			.word 	29,35,36,37,38
i: 			.word 	36,37
o: 			.word 	29,31,33,35,36,37
u: 			.word 	31,33,35,36,37
pin:		.word 	29,31,33,35,36,37,38
delayMs:	.int	1000
OUTPUT		=		1	

/* --- Mensajes --- */
ErrMsg:	 .asciz	"Setup didn't work... Aborting...\n"
