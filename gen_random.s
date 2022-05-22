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
* Genera numeros random dependiendo del intervalo que se requiera
 -------------------------------------------------------------------------------------- */

.global _rnd
_rnd:
    mov r6,#1000                //Establece el intervalo en donde se desean los numeros
    push {lr}	
    MOV R0, #0                  //Setea 0 en R0
    BL time                     //Obtiene el tiempo de la computadora (inicia desde el 01/01/1970)
    MOV R1, R0                  //Asigna a r1 la semilla
    BL srand                    //Genera la funcion random
    randomgen:       
        BL rand                 //Obtiene el random
        cmp r0,r6               //Compara si esta dentro del intervalo que se desea
        bgt randomgen           //De no estarlo, vuelve a generar otro      
    pop {pc}    
