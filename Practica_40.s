// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Convertir un número binario (cadena) a decimal en ARM64
// Asciinema: https://asciinema.org/a/690680

    .section .data
binario: .asciz "11001"             // Número binario como cadena (25 en decimal)
msg_resultado: .asciz "Número decimal: %d\n"

    .section .text
    .global _start

_start:
    // Cargar la dirección de la cadena binaria
    ldr x0, =binario               // x0 apunta al inicio de la cadena binaria

    // Inicializar el valor decimal en 0
    mov w1, #0                     // w1 será el acumulador para el número decimal

convertir_loop:
    // Cargar el siguiente carácter de la cadena binaria
    ldrb w2, [x0], #1              // Cargar el byte actual en w2 y avanzar puntero x0
    cbz w2, imprimir_resultado      // Si encontramos el fin de cadena (byte 0), terminamos

    // Desplazar el acumulador a la izquierda (multiplicar por 2)
    lsl w1, w1, #1                 // w1 = w1 * 2

    // Verificar si el carácter actual es '1'
    cmp w2, #'1'
    bne convertir_loop             // Si es '0', saltamos y repetimos el bucle

    // Si es '1', sumamos 1 al acumulador
    add w1, w1, #1                 // w1 = w1 + 1

    // Repetimos el bucle para el siguiente bit
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
