// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Realizar operaciones AND, OR, XOR a nivel de bits en ARM64

    .section .data
num1: .word 0x3C                // Primer número (hexadecimal 3C = 60 en decimal)
num2: .word 0x0F                // Segundo número (hexadecimal 0F = 15 en decimal)
msg_and: .asciz "Resultado AND: %d\n"
msg_or: .asciz "Resultado OR: %d\n"
msg_xor: .asciz "Resultado XOR: %d\n"

    .section .text
    .global _start

_start:
    // Cargar los números en registros
    ldr x0, =num1               // Dirección del primer número
    ldr w0, [x0]                // Cargar el primer número en w0

    ldr x1, =num2               // Dirección del segundo número
    ldr w1, [x1]                // Cargar el segundo número en w1

    // Realizar operación AND
    and w2, w0, w1              // w2 = w0 AND w1
    // Preparación para imprimir el resultado AND
    ldr x0, =msg_and            // Cargar el mensaje de AND
    mov x1, w2                  // Mover el resultado de AND a x1 para imprimir
    bl printf                   // Llamada a printf para mostrar el resultado de AND

    // Realizar operación OR
    orr w2, w0, w1              // w2 = w0 OR w1
    // Preparación para imprimir el resultado OR
    ldr x0, =msg_or             // Cargar el mensaje de OR
    mov x1, w2                  // Mover el resultado de OR a x1 para imprimir
    bl printf                   // Llamada a printf para mostrar el resultado de OR

    // Realizar operación XOR
    eor w2, w0, w1              // w2 = w0 XOR w1
    // Preparación para imprimir el resultado XOR
    ldr x0, =msg_xor            // Cargar el mensaje de XOR
    mov x1, w2                  // Mover el resultado de XOR a x1 para imprimir
    bl printf                   // Llamada a printf para mostrar el resultado de XOR

    // Salir del programa
    mov x8, #93                 // Código de salida para syscall exit en ARM64
    mov x0, #0                  // Código de retorno 0
    svc #0                      // Llamada al sistema
