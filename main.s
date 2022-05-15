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

	mov 	r9,#0 					// Iguala r9 a 0 para iterar sobre el array
	mov 	r5,#7

reset:
	ldr 	r4,=pin 				// carga el array de pines a r4
	ldr 	r0,[r4,r9]				// Accede al elemento con indice = r9 y lo carga a r0
	mov 	r1,#0 					// r1 = 0 para apagar el segmento conectado al pin
	bl 	    digitalWrite			// Apaga el valor del pin cargado en r0
	add 	r9,#4					// Agrega 4 a r9 para cambiar de posicion en el array
	subs 	r5,#1					// resta 1 a r5 y lo compara con 0 para determinar si ya se iteró sobre el array	
	bne 	reset 			

print_vowels:
	cmp 	r6,#5 					// Revisa el valor de r6 para poder cargar la vocal adecuada 
	ldreq 	r4,=a                   // 5 = a
	moveq 	r5,#6     				// Carga el tamaño del array de la vocal para iterar

	cmp 	r6,#4         			// Revisa el valor de r6 para poder cargar la vocal adecuada 
	ldreq 	r4,=e   				// 4 = e
	moveq 	r5,#5 					// Carga el tamaño del array de la vocal para iterar

	cmp 	r6,#3 					// Revisa el valor de r6 para poder cargar la vocal adecuada 
	ldreq 	r4,=i 					// 3 = i
	moveq 	r5,#2 					// Carga el tamaño del array de la vocal para iterar

	cmp 	r6,#2 					// Revisa el valor de r6 para poder cargar la vocal adecuada 
	ldreq 	r4,=o 					// 2 = o
	moveq 	r5,#6  					// Carga el tamaño del array de la vocal para iterar

	cmp 	r6,#1 					// Revisa el valor de r6 para poder cargar la vocal adecuada
	ldreq 	r4,=u 					// 1 = u
	moveq 	r5,#5 					// Carga el tamaño del array de la vocal para iterar

	mov 	r9,#0 					// Se resetea el valor de r9 para iterar en el loop

	change_display:
		ldr 	r0,[r4,r9] 			// Se carga el elemento del array con indice = r9 a r0
		mov 	r1,#1 				// r1 = 1 para encender el segmento conectado al pin
		bl 	    digitalWrite		// Se llama la funcion para actualizar el pin cargado en r0	
		add 	r9,#4 				// Agrega 4 a r9 para cambiar de posicion en el array
		subs 	r5,#1				// resta 1 a r5 y lo compara con 0 para determinar si ya se iteró sobre el array	
		bne 	change_display 			

	ldr		r0,=delayMs 			// Se carga el valor del delay en la etiqueta
	ldr		r0,[r0]
	bl		delay  					// Se realiza el delay para poder visualizar el output

	mov		r9,#0 					
	mov 	r5,#7 					// Se cargan los valores necesarios en r9 y r5 para poder realizar el reset
	subs 	r6,#1 				    // Si r6 != 0, se hace un reset. De lo contrario, se continua a final_reset
	bne 	reset

final_reset:
	ldr 	r4,=pin 				// Se carga el array en la etiqueta pin
	ldr 	r0,[r4,r9] 				// Se carga el elemento del array con indice = r9 a r0
	mov 	r1,#0 					// r1 = 0 para apagar el segmento conectado al pin
	bl 	    digitalWrite			// Se llama la funcion para actualizar el pin cargado en r0
	add 	r9,#4 					// Agrega 4 a r9 para cambiar de posicion en el array
	subs 	r5,#1					// resta 1 a r5 y lo compara con 0 para determinar si ya se iteró sobre el array
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
