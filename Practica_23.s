// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Conversión de un entero a cadena ASCII en ARM64

    .section .data
msg_resultado: .asciz "El número en ASCII es: %s\n"
buffer: .space 20               // Buffer para almacenar el número convertido en ASCII

    .section .text
    .global _start

_start:
    // Definir el número que queremos convertir
    mov x0, #1234               // Número a convertir en ASCII (ejemplo: 1234)
    ldr x1, =buffer + 19        // Apuntar al final del buffer
    mov w2, #10                 // Base 10 para la conversión

convertir_loop:
    // Obtener el último dígito
    udiv x3, x0, x2             // x3 = x0 / 10 (cociente)
    msub x4, x3, x2, x0         // x4 = x0 - (x3 * 10), residuo (último dígito)

    // Convertir el dígito a ASCII y almacenar en el buffer
    add x4, x4, #'0'            // Convertir el dígito a ASCII (0 -> '0', 1 -> '1', etc.)
    strb w4, [x1], #-1          // Almacenar en el buffer y mover el puntero hacia atrás

    // Actualizar x0 con el cociente para procesar el siguiente dígito
    mov x0, x3
    cbz x0, imprimir_resultado  // Si x0 es 0, terminamos la conversión

    // Repetir el bucle
    b convertir_loop

imprimir_resultado:
    // Preparar el mensaje de resultado
    ldr x0, =msg_resultado      // Mensaje para imprimir
    add x1, x1, #1              // Ajustar x1 al inicio de la cadena en el buffer
    mov x2, x1                  // Apuntar x2 a la cadena en el buffer

    // Llamada a printf para mostrar el número en ASCII
    bl printf                   // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93                 // Código de salida para syscall exit en ARM64
    mov x0, #0                  // Código de retorno 0
    svc #0                      // Llamada al sistema
