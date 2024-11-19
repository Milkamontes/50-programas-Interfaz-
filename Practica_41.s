// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Convertir un número decimal a hexadecimal en ARM64
// Asciinema: https://asciinema.org/a/690683

    .section .data
num: .word 305419896              // Número decimal a convertir (ejemplo: 305419896, que es 0x12345678 en hexadecimal)
buffer: .space 9                  // Espacio para la cadena hexadecimal (8 dígitos + terminador nulo)
msg_resultado: .asciz "Representación hexadecimal: %s\n"

    .section .text
    .global _start

_start:
    // Cargar el número en un registro
    ldr x0, =num                  // Dirección del número
    ldr w0, [x0]                  // Cargar el número en w0
    ldr x1, =buffer + 8           // Apuntar al final del buffer (para escribir de derecha a izquierda)
    mov w2, #8                    // Número de dígitos en hexadecimal (32 bits = 8 dígitos hexadecimales)

convertir_loop:
    // Obtener el dígito menos significativo
    and w3, w0, #0xF              // Extraer los últimos 4 bits de w0 (dígito hexadecimal)
    
    // Convertir el dígito a su valor ASCII
    cmp w3, #9
    add w3, w3, #'0'              // Si w3 <= 9, conviértelo a '0' - '9'
    ble almacenar_digito
    add w3, w3, #('A' - '9' - 1)  // Si w3 > 9, conviértelo a 'A' - 'F'

almacenar_digito:
    strb w3, [x1, #-1]!           // Almacenar el dígito en el buffer y avanzar hacia atrás

    // Desplazar el número a la derecha en 4 bits (descartar el dígito menos significativo)
    lsr w0, w0, #4                // w0 = w0 >> 4

    // Decrementar el contador de dígitos
    subs w2, w2, #1               // Restar 1 de w2
    bne convertir_loop            // Si w2 no es cero, repetir el bucle

    // Preparación para imprimir la representación hexadecimal
    ldr x0, =msg_resultado        // Cargar el mensaje de resultado
    ldr x1, =buffer               // Cargar la dirección del buffer en x1 para printf

    // Llamada a printf para mostrar el resultado en hexadecimal
    bl printf                     // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93                   // Código de salida para syscall exit en ARM64
    mov x0, #0                    // Código de retorno 0
    svc #0                        // Llamada al sistema
