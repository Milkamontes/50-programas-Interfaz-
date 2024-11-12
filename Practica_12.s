// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Contar los bits activados en un número en ARM64

    .section .data
num: .word 0b10101100             // Número inicial en binario (172 en decimal)
msg_resultado: .asciz "Bits activados: %d\n"

    .section .text
    .global _start

_start:
    // Cargar el número inicial en un registro
    ldr x0, =num                  // Dirección del número
    ldr w0, [x0]                  // Cargar el número en w0

    // Inicializar el contador de bits activados en 0
    mov w1, #0                    // w1 será el contador de bits en 1

count_bits:
    // Verificar si el bit menos significativo está activado
    and w2, w0, #1                // w2 = w0 & 1, obtiene el bit menos significativo
    add w1, w1, w2                // Incrementar el contador si el bit es 1

    // Desplazar el número a la derecha en 1 posición
    lsr w0, w0, #1                // w0 = w0 >> 1, para revisar el siguiente bit

    // Verificar si quedan bits por procesar
    cbnz w0, count_bits           // Si w0 no es cero, repetir el bucle

    // Preparación para imprimir el resultado
    ldr x0, =msg_resultado        // Cargar el mensaje de resultado
    mov x1, w1                    // Mover el contador de bits activados a x1

    // Llamada a printf para mostrar el número de bits activados
    bl printf                     // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93                   // Código de salida para syscall exit en ARM64
    mov x0, #0                    // Código de retorno 0
    svc #0                        // Llamada al sistema

    cbnz x0, convert_loop      // Si el cociente no es cero, continuar

    // Ajustar x1 para que apunte al inicio del número en el buffer
    ret
