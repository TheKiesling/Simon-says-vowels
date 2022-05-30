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

	ldr		r0,=bienvenida			// Mostrar mensaje de bienvenida
	bl 		puts
	
	mov 	r5, #9					// Indicar cantidad de pins

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

menu:
	ldr 	r0, =cls				// Limpiar la consola
	bl 		puts

	ldr 	r1, =pb					// Cargar puntuacion maxima
	ldr 	r1, [r1]				
	cmp		r1, #0					// Si ha jugado posteriormente, se enseña la puntuacion maxima
	ldrne 	r0, =maxPts
	blne 	printf

	ldr 	r1, =rec				// Cargar ultima puntuacion
	ldr 	r1, [r1]
	cmp		r1, #0					// Si ha jugado posteriormente, se enseña la ultima puntuacion
	ldrne 	r0, =reciente
	blne 	printf
	
	ldr 	r0, =menuMsg			// Imprimir menu de opciones
	bl 		puts
	ldr 	r0, =formatos			// Leer opcion del usuario
	ldr 	r1, =op
	bl 		scanf	

	cmp r0,#0						// Validar si el ingreso es valido
	beq Error		
	
	ldr 	r1, =op					// Cargar opcion a realizar
	ldrb 	r1, [r1]
	cmp 	r1, #113				// Si es q (113 - ASCII) sale del programa
	beq 	exit

	cmp 	r1, #120				// Si no es x (120 - ASCII) ha ingresado una opcion no valida
	bne		ErrorMenu

	mov 	r9,#0 					// Iguala r9 a 0 para iterar sobre el array
	mov 	r5,#7					// Indicar cantidad de pins


reset:
	ldr 	r4,=pinOutput			// carga el array de pines a r4
	ldr 	r0,[r4,r9]				// Accede al elemento con indice = r9 y lo carga a r0
	mov 	r1,#1 					// r1 = 0 para apagar el segmento conectado al pin
	bl 	    digitalWrite			// Apaga el valor del pin cargado en r0
	add 	r9,#4					// Agrega 4 a r9 para cambiar de posicion en el array
	subs 	r5,#1					// resta 1 a r5 y lo compara con 0 para determinar si ya se itero sobre el array	
	bne 	reset
	 					
	ldr 	r0, =cont				//	mostrar mensaje de solicitud en circuito fisico
	bl 		puts

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

	ldr 	r8,=vowels				// cargar el arreglo de vocales
	mov 	r11,r0					// obtener vocal generada aleatoriamente
	strb	r11,[r8,r7]            	// guarda en vocales la vocal generada en la posicion que corresponde por r7

	cmp 	r11,#'a'
	ldreq 	r4,=a                   // cargar el arreglo con los pines para generar 'a'
	cmp 	r11,#'e'
	ldreq 	r4,=e                   // cargar el arreglo con los pines para generar 'e'
	cmp 	r11,#'i'
	ldreq 	r4,=i                   // cargar el arreglo con los pines para generar 'i'
	cmp 	r11,#'o'
	ldreq 	r4,=o                  	// cargar el arreglo con los pines para generar 'o'
	cmp 	r11,#'u'
	ldreq 	r4,=u                   // cargar el arreglo con los pines para generar 'u'

	mov 	r9,#0					// Se resetea el valor de r9 para iterar en el loop

	change_display:
		ldr 	r0,[r4,r9] 			// Se carga el elemento del array con indice = r9 a r0
		mov 	r5,r0
		mov 	r1,#0 				// r1 = 0 para encender el segmento conectado al pin
		bl 	    digitalWrite		// Se llama la funcion para actualizar el pin cargado en r0

		cmp 	r5,#0
		addne 	r9,#4 				// Agrega 4 a r9 para cambiar de posicion en el array	
		bne 	change_display	

	ldr		r0,=delayMs 			// Se carga el valor del delay en la etiqueta
	ldr		r0,[r0]
	bl		delay  					// Se realiza el delay para poder visualizar el output
	
	mov 	r9, #0					// resetear r9 contador
	mov 	r5, #7					// asignar 7 a r5 contador
	
reset2:
	ldr 	r4,=pinOutput			// carga el array de pines a r4
	ldr 	r0,[r4,r9]				// Accede al elemento con indice = r9 y lo carga a r0
	mov 	r1,#1 					// r1 = 1 para apagar el segmento conectado al pin
	bl 	    digitalWrite			// Apaga el valor del pin cargado en r0
	add 	r9,#4					// Agrega 4 a r9 para cambiar de posicion en el array
	subs 	r5,#1					// resta 1 a r5 y lo compara con 0 para determinar si ya se iteró sobre el array	
	bne 	reset2 

	mov 	r9, #0					// resetear r9 contador

	ldr 	r0, =cls				// Limpiar la consola
	bl 		puts
	
	cmp 	r7, #0					// Evaluar si es la primera ronda (para impresion de mensaje)
	movne 	r1, r7
	ldrne 	r0, =pts
	blne	printf
	
	ldr 	r0, =ingreso			// mensaje de ingreso
	bl 		puts
	
	ldr 	r0, =formatos			// leer cadena de caracteres que el usuario cree correctas
	ldr 	r1, =vowels2
	bl 		scanf

	cmp		r0,#0					// Validar si el ingreso es valido
	beq 	Error
	
entrada:
	ldr 	r8, =vowels				// carga arreglo de vocales
	ldrb 	r4, [r8, r9]			// carga vocal correspondiente del arreglo a evaluar

	ldr 	r1, =vowels2			// carga cadena de caracteres ingresada por el usuario
	ldrb 	r11, [r1,r9]			// carga vocal correspondiente de la cadena a evaular
	cmp 	r11, r4					// compara si ambas vocales son iguales
	movne 	r0, #15					// mover led rojo (partida perdida)
	movne 	r1, #1					// encender led rojo
	blne 	digitalWrite
	bne 	fin						// salto a fin
	
	cmp 	r9,r7					// comparar si se necesita evaluar mas vocales
	addne 	r9,#1					// modificar r9 contador
	bne 	entrada					// seguir evaluando 

	mov 	r0, #13					// mover led verde (ronda ganada)
	mov 	r1, #1					// encender led verde
	bl 		digitalWrite
	
	ldr		r0,=delayMs 			// Se carga el valor del delay en la etiqueta
	ldr		r0,[r0]					
	bl		delay  					// Se realiza el delay para poder visualizar el output
	
	mov 	r0, #13					// mover led verde (ronda ganada)
	mov 	r1, #0					// apagar led verde
	bl 		digitalWrite

	mov		r9,#0 					// prepara contador para reset
	mov 	r5,#7 					// prepara cantidad de pines para reset
	add 	r7,#1					// añade 1 a registro acumulador
	cmp 	r7,#15					// compara si ya se mostraron 15 letras
	bne 	reset                  	// de no hacerlo, puede generar mas

fin:

	ldr		r0,=delayMs 			// Se carga el valor del delay en la etiqueta
	ldr		r0,[r0]
	bl		delay  					// Se realiza el delay para poder visualizar el output
	
	mov 	r0, #15					// mover led rojo (partida perdida)
	mov 	r1, #0					// apagar led rojo
	bl 		digitalWrite

	mov 	r9, #0					// resetear r9 contador
	mov 	r5, #7					// asignar 7 a r5 contador

final_reset:

	ldr 	r4,=pinOutput 			// Se carga el array en la etiqueta pin
	ldr 	r0,[r4,r9] 				// Se carga el elemento del array con indice = r9 a r0
	mov 	r1,#1 					// r1 = 0 para apagar el segmento conectado al pin
	bl 	    digitalWrite			// Se llama la funcion para actualizar el pin cargado en r0
	add 	r9,#4 					// Agrega 4 a r9 para cambiar de posicion en el array
	subs 	r5,#1					// resta 1 a r5 y lo compara con 0 para determinar si ya se iteró sobre el array
	bne 	final_reset 

	ldr 	r1, =rec				// cargar puntuacion reciente
	str		r7, [r1]				// guardar en memoria la puntuacion reciente

	cmp 	r7, #15					// si se llego a las 15 rondas, gano, sino perdio
	ldrne 	r0, =resetMsg
	ldreq 	r0, =winMsg
	bl 		puts					// impresion de mensaje correspondiente

	ldr 	r2, =pb					// cargar puntuacion maxima
	ldr 	r2, [r2]				
	cmp 	r2, r7					// comparar si la puntuacion actual es mayor que la reciente
	ldrlt 	r1, =pb					// cargar la puntuacion maxima
	strlt 	r7, [r1]				// guardar en memoria la puntuacion maxima

	ldr 	r0, =ptsFinal			// mostrar mensaje de la puntuacion final
	mov 	r1, r7
	bl 		printf
	
	ldr 	r0, =cont2				// mensaje de solicitud fisica
	bl 		puts
	
try2:

	mov 	r7, #0					// prepara acumulador para generar letras

	ldr		r0, =delay2				// Se carga el valor del delay en la etiqueta
	ldr		r0, [r0]
	bl		delay					// Se realiza el delay para poder visualizar el output
	
	ldr		r0, =pinInput			// carga dirección de pin
	ldr		r0, [r0,#4]				// operaciones anteriores borraron valor de pin en r0
	bl 		digitalRead				// escribe 1 en pin para activar puerto GPIO
	
	cmp		r0,#1					// compara para revisar si se inicio el sensor
	beq		try2					// no se ha activado
	movne 	r10, #0					// se activo: generar acumulador
	bne 	reset_array				// se activo: resetear arreglo

	reset_array:
		mov 	r11,#0
		ldr 	r8,=vowels			// cargar arreglo de vocales
		mov 	r1,#' '				
		str 	r1,[r8,r10]			// setear espacios vacios en cada posicion del arreglo
		add 	r10,#1
		cmp 	r10,#15
		bne 	reset_array			// revisar si aun quedan elementos en el arreglo a resetear
		b 		menu				// ya permite presionar el boton

Error:
	ldr r0,=ErrInput				// Imprimir mensaje de error de ingreso
	bl puts

ErrorMenu:
	ldr r0,=ErrMenu					// Imprimir mensaje de error de menu
    bl puts
	ldr		r0,=delayMs 			// Se carga el valor del delay en la etiqueta
	ldr		r0,[r0]
	bl		delay  					// Se realiza el delay para poder visualizar el output
    b menu

exit:	
	ldr 	r0,=salida				// Mostrar mensaje de despedida
	bl puts
	pop 	{ip, pc}

/* --------------------------------------- DATA --------------------------------------- */
.data
.balign 4

/* --- Variables --- */
a: 			.word 	29,31,33,36,37,38,0 			// Pines para generar A
e: 			.word 	29,35,36,37,38,0				// Pines para generar E
i: 			.word 	36,37,0							// Pines para generar I
o: 			.word 	29,31,33,35,36,37,0				// Pines para generar O
u: 			.word 	31,33,35,36,37,0				// Pines para generar U
pinOutput:	.word 	29,31,33,35,36,37,38,13,15		// Pines de salida
pinInput: 	.word 	16,18							// Pines de entrada
pb:			.word	0								// Puntuacion maxima
rec:		.word	0								// Puntuacion minima
op:			.asciz	" "								// Opcion a realizar
delayMs:	.int	1000							// Delay de 1 seg
delay2:		.int	100								// Delay de 0.1 seg
OUTPUT		=		1								
INPUT		=		0
vowels:		.asciz  "             	 "				// Arreglo de vocales generadas random
vowels2:	.asciz  "             	 "				// Secuencia de vocales ingresadas por el usuario

/* --- Mensajes --- */
ErrMsg:	 	.asciz	"Setup didn't work... Aborting...\n"
ErrInput:	.asciz  "Asegurese de ingresar caracteres."
ErrMenu: 	.asciz 	"Ingrese una opcion valida"
resetMsg:	.asciz	"\nPerdiste :(\n"
winMsg:	 	.asciz	"¡Ganaste!\n"
formatod: 	.asciz "%d"
formatos: 	.asciz "%s"
ptsFinal:	.asciz "Puntuacion final: %d\n"
pts:	  	.asciz "¡Sigue asi! Puntuacion Actual: %d\n"
ingreso:	.asciz "\nIngresa la secuencia mostrada hasta el momento: "
cls:		.asciz "\x1B[1J\x1B[H"
cont:		.asciz "\nPresiona el boton para mostrar la siguiente letra... "
cont2:		.asciz "Activa el sensor para regresar al menu... "
maxPts:		.asciz "Puntuacion mas alta: %d\n"
reciente:	.asciz "Intento anterior: %d\n"
menuMsg: 	.asciz "\n--------------MENU--------------\nx) Jugar :D\nq) Salir\n\nIngrese una opcion: "
bienvenida:	.asciz "Hola! Bienvenido a Simon Dice de vocales. \nSe presentara en un display una secuencia de letras y deberas de ingresarla \n Buena suerte"
salida:		.asciz "Hasta la proxima"
