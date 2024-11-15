// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Encontrar el prefijo común más largo entre dos cadenas en ARM64

    .section .data
cadena1: .asciz "programacion"
cadena2: .asciz "programa"
resultado: .space 256                // Espacio para almacenar el prefijo común
msg_resultado: .asciz "Prefijo común más largo: %s\n"

    .section .text
    .global _start

_start:
    // Cargar las direcciones de las cadenas
    ldr x0, =cadena1               // x0 apunta al inicio de la primera cadena
    ldr x1, =cadena2               // x1 apunta al inicio de la segunda cadena
    ldr x2, =resultado             // x2 apunta al buffer donde guardaremos el prefijo

    // Inicializar contador de longitud
    mov w3, #0                     // Contador de prefijo común en w3

compare_loop:
    ldrb w4, [x0, w3]              // Leer el carácter actual de la primera cadena
    ldrb w5, [x1, w3]              // Leer el carácter actual de la segunda cadena
    cbz w4, store_result           // Si encontramos fin de la primera cadena, terminar
    cbz w5, store_result           // Si encontramos fin de la segunda cadena, terminar
    cmp w4, w5                     // Comparar los caracteres actuales
    bne store_result               // Si no son iguales, terminar

    // Almacenar el carácter en el resultado
    strb w4, [x2, w3]              // Guardar el carácter en el buffer de resultado
    add w3, w3, #1                 // Incrementar el contador de prefijo
    b compare_loop                 // Repetir el bucle

store_result:
    strb wzr, [x2, w3]             // Almacenar el terminador nulo en el prefijo

    // Preparación para imprimir el resultado
    ldr x0, =msg_resultado         // Cargar el mensaje de resultado
    ldr x1, =resultado             // Cargar el prefijo común en x1
    bl printf                      // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93                    // Código de salida para syscall exit en ARM64
    mov x0, #0                     // Código de retorno 0
    svc #0                         // Llamada al sistema
