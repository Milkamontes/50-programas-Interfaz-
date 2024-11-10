// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Conversión de una cadena ASCII a un entero en ARM64

    .section .data
numero_ascii: .asciz "1234"       // Número en ASCII que queremos convertir
msg_resultado: .asciz "El número entero es: %d\n"

    .section .text
    .global _start

_start:
    // Cargar la dirección del número ASCII
    ldr x0, =numero_ascii       // x0 apunta al inicio de la cadena ASCII

    // Inicializar el valor entero en 0
    mov w1, #0                  // w1 será el acumulador para el número entero
    mov w2, #10                 // w2 será el multiplicador para aritmética en base 10

convertir_loop:
    // Cargar el carácter actual
    ldrb w3, [x0], #1           // Cargar el siguiente byte en w3 y avanzar el puntero x0
    cbz w3, imprimir_resultado  // Si w3 es 0 (fin de cadena), salir del bucle

    // Convertir el carácter ASCII a su valor numérico
    sub w3, w3, #'0'            // w3 = w3 - '0', convierte de ASCII a número (ej. '3' -> 3)

    // Actualizar el número acumulado
    mul w1, w1, w2              // w1 = w1 * 10, desplazar el número actual a la izquierda
    add w1, w1, w3              // w1 = w1 + w3, agregar el nuevo dígito

    // Repetir el bucle
    b convertir_loop

imprimir_resultado:
    // Preparación para imprimir el número entero convertido
    ldr x0, =msg_resultado      // Cargar el mensaje de resultado
    mov x1, w1                  // Mover el número convertido a x1 para imprimir

    // Llamada a printf para mostrar el número entero
    bl printf                   // Llamada a printf para mostrar el número

    // Salir del programa
    mov x8, #93                 // Código de salida para syscall exit en ARM64
    mov x0, #0                  // Código de retorno 0
    svc #0                      // Llamada al sistema
