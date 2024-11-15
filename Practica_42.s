// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Convertir un número hexadecimal (cadena) a decimal en ARM64

    .section .data
hexadecimal: .asciz "1A3F"         // Cadena hexadecimal a convertir (1A3F en decimal es 6719)
msg_resultado: .asciz "Número decimal: %d\n"

    .section .text
    .global _start

_start:
    // Cargar la dirección de la cadena hexadecimal
    ldr x0, =hexadecimal           // x0 apunta al inicio de la cadena hexadecimal

    // Inicializar el valor decimal en 0
    mov w1, #0                     // w1 será el acumulador para el número decimal

convertir_loop:
    // Cargar el siguiente carácter de la cadena hexadecimal
    ldrb w2, [x0], #1              // Cargar el byte actual en w2 y avanzar puntero x0
    cbz w2, imprimir_resultado      // Si encontramos el fin de cadena (byte 0), terminamos

    // Desplazar el acumulador a la izquierda 4 bits (multiplicar por 16)
    lsl w1, w1, #4                 // w1 = w1 * 16

    // Convertir el carácter a su valor numérico
    cmp w2, #'0'
    blt convertir_loop             // Ignorar si no es un dígito hexadecimal válido
    cmp w2, #'9'
    ble es_digito                  // Si está entre '0' y '9', es un dígito

    cmp w2, #'A'
    blt convertir_loop             // Ignorar si no es un carácter válido
    cmp w2, #'F'
    ble es_letra                   // Si está entre 'A' y 'F', es una letra hexadecimal

    b convertir_loop               // Saltar si no es un carácter válido

es_digito:
    sub w2, w2, #'0'               // Convertir '0'-'9' a 0-9
    b almacenar_valor

es_letra:
    sub w2, w2, #'A'               // Convertir 'A'-'F' a 10-15
    add w2, w2, #10

almacenar_valor:
    add w1, w1, w2                 // Sumar el valor convertido al acumulador

    // Repetimos el bucle para el siguiente dígito hexadecimal
    b convertir_loop

imprimir_resultado:
    // Preparación para imprimir el resultado
    ldr x0, =msg_resultado         // Cargar el mensaje de resultado
    mov x1, w1                     // Mover el número decimal convertido a x1

    // Llamada a printf para mostrar el número decimal
    bl printf                      // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93                    // Código de salida para syscall exit en ARM64
    mov x0, #0                     // Código de retorno 0
    svc #0                         // Llamada al sistema
