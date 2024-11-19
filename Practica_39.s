// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Convertir un número decimal a binario en ARM64
// Asciinema: https://asciinema.org/a/690674

    .section .data
num: .word 25                       // Número decimal a convertir (ejemplo: 25)
buffer: .space 33                   // Espacio para la cadena binaria (32 bits + nulo)
msg_resultado: .asciz "Representación binaria: %s\n"

    .section .text
    .global _start

_start:
    // Cargar el número en el registro
    ldr x0, =num                   // Dirección del número
    ldr w0, [x0]                   // Cargar el número en w0
    ldr x1, =buffer + 32           // Apuntar al final del buffer
    mov w2, #32                    // Número de bits (32)

convertir_loop:
    // Verificar el bit más significativo y almacenar '0' o '1' en el buffer
    and w3, w0, #0x80000000        // Extraer el bit más significativo
    cbz w3, es_cero                // Si el bit es 0, saltar a es_cero
    mov w4, #'1'                   // Si el bit es 1, almacenar '1'
    b almacenar_bit

es_cero:
    mov w4, #'0'                   // Almacenar '0' si el bit es 0

almacenar_bit:
    strb w4, [x1, #-1]!            // Almacenar el bit en el buffer y avanzar hacia atrás
    lsl w0, w0, #1                 // Desplazar el número a la izquierda (siguiente bit)
    subs w2, w2, #1                // Decrementar el contador de bits
    bne convertir_loop             // Repetir hasta que w2 sea 0

    // Preparación para imprimir la representación binaria
    ldr x0, =msg_resultado         // Cargar el mensaje de resultado
    ldr x1, =buffer                // Cargar el inicio del buffer en x1 para printf

    // Llamada a printf para mostrar el resultado en binario
    bl printf                      // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93                    // Código de salida para syscall exit en ARM64
    mov x0, #0                     // Código de retorno 0
    svc #0                         // Llamada al sistema
