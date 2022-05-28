/* --------------------------------------------------------------------------------------
* UNIVERSIDAD DEL VALLE DE GUATEMALA 
* Organizacion de computadoras y Assembler
* Ciclo 1 - 2022
* -------------------------------
* Adrian Ricardo Flores Trujillo 21500
* Andrea Ximena Ramirez Recinos 21874
* Jose Pablo Kiesling Lange 21581
* -------------------------------
* gen_random.s
* Genera una vocal random y la retorna
 -------------------------------------------------------------------------------------- */

.global _rnd
/* rnd: genera una vocal random mediante el tiempo de la computadora
    - sin parametros -
    - salida: r0 (vocal)
*/
_rnd:
    push    {lr}	
    mov     r0, #0                      // Setea 0 en r0
    bl      time                        // Obtiene el tiempo de la computadora (inicia desde el 01/01/1970)
    mov     r6,r0                       // Se obtiene el tiempo
    mov     r2,#5                       // Se necesita el resto de 5, porque son 5 opciones

    mod:                                // Genera el resto
        sub     r6,r2
        cmp     r6,#5
        bge     mod                     // Si se puede seguir diviendo

    cmp     r6,#0           // Letra A
    moveq 	r0,#'a'					
    cmp 	r6,#1           // Letra E
    moveq 	r0,#'e'					
    cmp 	r6,#2    		// Letra I
    moveq 	r0,#'i'
    cmp 	r6,#3			// Letra O
    moveq 	r0,#'o'
    cmp 	r6,#4 			// Letra U
    moveq 	r0,#'u'

    pop {pc} 
