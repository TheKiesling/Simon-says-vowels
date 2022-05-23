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

	bl		wiringPiSetupPhys		// Inicializar librería wiringpi
	mov		r1,#-1					// -1 representa un código de error
	cmp		r0, r1					// verifica si se retornó cod error en r0
	bne		config					// NO error, entonces iniciar programa
	ldr		r0, =ErrMsg				// SI error, 
	bl		printf					// imprimir mensaje y					
	b		exit					// salir del programa

config:
	ldr		r4, =pinOutput			// coloca el #pin wiringpi a r4
	ldr		r0, [r4,r9]				// carga el valor del pin que corresponde
	mov		r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl		pinMode					// llama funcion wiringpi para configurar
	add 	r9, #4					// Añade 4 bytes 
	subs 	r5,#1					// resta 1 y lo guarda en bandera
	bne 	config 					// regresar a etiqueta

	mov 	r9,#0 					// Iguala r9 a 0 para iterar sobre el array
	mov		r10, #2					// Indicar cantidad de pins
	

configDeEntradas:
	ldr		r4, =pinInput			// coloca el #pin wiringpi a r4
	ldr		r0, [r4,r9]				// carga el valor del pin que corresponde
	mov		r1, #INPUT				// lo configura como entrada, r1 = 0
	bl		pinMode					// llama funcion wiringpi para configurar
	add 	r9, #4					// Añade 4 bytes 
	subs 	r10,#1					// resta 1 y lo guarda en bandera
	bne 	configDeEntradas		// regresar a etiqueta

	mov 	r9,#0 					// Iguala r9 a 0 para iterar sobre el array
	mov 	r5,#7					// Indicar cantidad de pins

reset:
	ldr 	r4,=pinOutput			// carga el array de pines a r4
	ldr 	r0,[r4,r9]				// Accede al elemento con indice = r9 y lo carga a r0
	mov 	r1,#1 					// r1 = 0 para apagar el segmento conectado al pin
	bl 	    digitalWrite			// Apaga el valor del pin cargado en r0
	add 	r9,#4					// Agrega 4 a r9 para cambiar de posicion en el array
	subs 	r5,#1					// resta 1 a r5 y lo compara con 0 para determinar si ya se iteró sobre el array	
	bne 	reset 					

try:	
	ldr		r0, =delay2				// Se carga el valor del delay en la etiqueta
	ldr		r0, [r0]
	bl		delay					// Se realiza el delay para poder visualizar el output
	
	ldr		r0, =pinInput			// carga dirección de pin
	ldr		r0, [r0,#0]				// operaciones anteriores borraron valor de pin en r0
	bl 		digitalRead				// escribe 1 en pin para activar puerto GPIO
	
	cmp		r0,#0					// revisa si se presiona el boton
	beq		try	

print_vowels:
	bl 		_rnd					// llama a la subrutina 

	mov 	r9,#0					// Se resetea el valor de r9 para iterar en el loop
	ldr 	r8,=vowels				// cargar el arreglo de vocales

	cmp 	r0,#800 				// Revisa el valor de r0 para poder cargar la vocal adecuada
	movgt 	r1,#'a'					
	strgt 	r1,[r8,r7]				// guardar 'a' en el arreglo
	ldrgt 	r4,=a                   // cargar el arreglo con los pines para generar 'a'
	movgt 	r5,#6 					// Carga el tamaño del array de la vocal para iterar
	bgt 	change_display    		// ir a la subrutina de encendido

	cmp 	r0,#600        			// Revisa el valor de r0 para poder cargar la vocal adecuada 
	movgt 	r1,#'e'					
	strgt 	r1,[r8,r7]				// guardar 'e' en el arreglo
	ldrgt 	r4,=e   				// cargar el arreglo con los pines para generar 'e'
	movgt 	r5,#5 					// Carga el tamaño del array de la vocal para iterar
	bgt 	change_display 			// ir a la subrutina de encendido

	cmp 	r0,#400 				// Revisa el valor de r6 para poder cargar la vocal adecuada 
	movgt 	r1,#'i'
	strgt 	r1,[r8,r7]				// guardar 'i' en el arreglo
	ldrgt 	r4,=i 					// cargar el arreglo con los pines para generar 'i'
	movgt 	r5,#2 					// Carga el tamaño del array de la vocal para iterar
	bgt 	change_display			// ir a la subrutina de encendido

	cmp 	r0,#200					// Revisa el valor de r0 para poder cargar la vocal adecuada
	movgt 	r1,#'o'
	strgt 	r1,[r8,r7] 				// guardar 'o' en el arreglo
	ldrgt 	r4,=o 					// cargar el arreglo con los pines para generar 'o'
	movgt 	r5,#6  					// Carga el tamaño del array de la vocal para iterar
	bgt 	change_display			// ir a la subrutina de encendido

	cmp 	r0,#0 					// Revisa el valor de r0 para poder cargar la vocal adecuada
	movgt 	r1,#'u'
	strgt 	r1,[r8,r7]				// guardar 'u' en el arreglo
	ldrgt 	r4,=u 					// cargar el arreglo con los pines para generar 'u'
	movgt 	r5,#5 					// Carga el tamaño del array de la vocal para iterar
	bgt 	change_display			// ir a la subrutina de encendido

	change_display:
		ldr 	r0,[r4,r9] 			// Se carga el elemento del array con indice = r9 a r0
		mov 	r1,#0 				// r1 = 1 para encender el segmento conectado al pin
		bl 	    digitalWrite		// Se llama la funcion para actualizar el pin cargado en r0	
		add 	r9,#4 				// Agrega 4 a r9 para cambiar de posicion en el array
		subs 	r5,#1				// resta 1 a r5 y lo compara con 0 para determinar si ya se iteró sobre el array	
		bne 	change_display 			

	ldr		r0,=delayMs 			// Se carga el valor del delay en la etiqueta
	ldr		r0,[r0]
	bl		delay  					// Se realiza el delay para poder visualizar el output
	
	mov r9, #0						// Se resetea el valor de r9 para iterar en la impresion
	
	print:
		ldr		r8,=vowels			// cargar arreglo de vocales
		ldr 	r1,[r8,r9]			// cargar vocal correspondiente
		ldr 	r0,=formatoc		
		bl 		printf				// imprimir vocal
		add 	r9,#1				// incrementar la posicion en el arreglo
		cmp 	r9,r7				// compara si existen elementos siguientes en el arreglo
		ble 	print

	ldr r0, =newline				// impresion de nueva linea
	bl puts
		
	mov		r9,#0 					// prepara contador para reset
	mov 	r5,#7 					// prepara cantidad de pines para reset
	add 	r7,#1					// añade 1 a registro acumulador
	cmp 	r7,#15					// compara si ya se mostraron 15 letras
	bne 	reset                  	// de no hacerlo, puede generar mas

final_reset:
	ldr 	r4,=pinOutput 			// Se carga el array en la etiqueta pin
	ldr 	r0,[r4,r9] 				// Se carga el elemento del array con indice = r9 a r0
	mov 	r1,#1 					// r1 = 0 para apagar el segmento conectado al pin
	bl 	    digitalWrite			// Se llama la funcion para actualizar el pin cargado en r0
	add 	r9,#4 					// Agrega 4 a r9 para cambiar de posicion en el array
	subs 	r5,#1					// resta 1 a r5 y lo compara con 0 para determinar si ya se iteró sobre el array
	bne 	final_reset 
	
try2:

	mov 	r7, #0					// prepara acumulador para generar letras

	ldr		r0, =delay2				// Se carga el valor del delay en la etiqueta
	ldr		r0, [r0]
	bl		delay					// Se realiza el delay para poder visualizar el output
	
	ldr		r0, =pinInput			// carga dirección de pin
	ldr		r0, [r0,#4]				// operaciones anteriores borraron valor de pin en r0
	bl 		digitalRead				// escribe 1 en pin para activar puerto GPIO
	
	cmp	r0,#1						// compara para revisar si se inicio el sensor
	beq	try2						// no se ha activado
	movne r10, #0					// se activo: generar acumulador
	bne 	reset_array				// se activo: resetear arreglo

	reset_array:
		ldr 	r8,=vowels			// cargar arreglo de vocales
		mov 	r1,#' '				
		str 	r1,[r8,r10]			// setear espacios vacios en cada posicion del arreglo
		add 	r10,#1
		cmp 	r10,#15
		bne 	reset_array			// revisar si aun quedan elementos en el arreglo a resetear
		b 		try					// ya permite presionar el boton

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
pinOutput:	.word 	29,31,33,35,36,37,38
pinInput: 	.word 	16,18
delayMs:	.int	1000
delay2:		.int	100
OUTPUT		=		1	
INPUT		=		0
vowels:		.byte   ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '

/* --- Mensajes --- */
ErrMsg:	 .asciz	"Setup didn't work... Aborting...\n"
formatoc: .asciz " %c"
newline: .asciz "\n"
