@ ---------------------------------------
@ Main
@ ---------------------------------------
@ ---------------------------------------
@	Data Section
@ ---------------------------------------
	 .data
	 .balign 4
ErrMsg:	 .asciz	"Setup didn't work... Aborting...\n"
pin:	 .word 29,31,33,35,36,37,38
formato: .asciz " %d"

@ ---------------------------------------
@	Code Section
@ ---------------------------------------	
.text
.global main
.extern printf
.extern wiringPiSetup
.extern delay
.extern digitalWrite
.extern pinMode

main:   push 	{ip, lr}	@ push return address + dummy register
				@ for alignment
	
	mov r5, #7

	bl	wiringPiSetupPhys			// Inicializar librería wiringpi
	mov	r1,#-1					// -1 representa un código de error
	cmp	r0, r1					// verifica si se retornó cod error en r0
	bne	config					// NO error, entonces iniciar programa
	ldr	r0, =ErrMsg				// SI error, 
	bl	printf					// imprimir mensaje y					// salir del programa

config:
	ldr	r4, =pin				// coloca el #pin wiringpi a r0
	ldr	r0, [r4,r9]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode	
	add 	r9, #4
	subs 	r5,#1
	bne 	config 
	
	pop 	{ip, pc}


