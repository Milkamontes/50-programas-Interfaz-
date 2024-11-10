// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Calcular la longitud de una cadena en ARM64

    .section .data
cadena: .asciz "Hola, mundo!"     // Cadena cuya longitud queremos calcular
msg_resultado: .asciz "La longitud de la cadena es: %d\n"

    .section .text
    .global _start

_start:
    // Cargar la dirección de la cadena en x0
    ldr x0, =cadena           // x0 apunta al inicio de la cadena

    // Inicializar el contador de longitud en 0
    mov w1, #0                // w1 será el contador de caracteres

calcular_longitud:
    // Cargar el siguiente carácter en w2
    ldrb w2, [x0, w1]         // Cargar el byte en la posición actual
    cbz w2, imprimir_resultado // Si w2 es 0 (fin de cadena), salir del bucle

    // Incrementar el contador de longitud
    add w1, w1, #1            // Incrementar el contador de longitud

    // Repetir el bucle
    b calcular_longitud

imprimir_resultado:
    // Preparar el mensaje para imprimir la longitud
    ldr x0, =msg_resultado    // Cargar el mensaje de resultado
    mov x1, w1                // Mover la longitud calculada a x1 para imprimir

    // Llamada a printf para mostrar la longitud
    bl printf                 // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93               // Código de salida para syscall exit en ARM64
    mov x0, #0                // Código de retorno 0
    svc #0                    // Llamada al sistema
