// Autor: Milka Guadalupe Montes Domínguez 
// Fecha: 10-11-24
// Descripción: Realizar desplazamientos a la izquierda y derecha en ARM64
// Asciinema: https://asciinema.org/a/690631

    .section .data
num: .word 8                       // Número inicial
msg_left_shift: .asciz "Desplazamiento a la izquierda (<<): %d\n"
msg_right_shift: .asciz "Desplazamiento a la derecha (>>): %d\n"

    .section .text
    .global _start

_start:
    // Cargar el número en un registro
    ldr x0, =num                   // Dirección del número
    ldr w0, [x0]                   // Cargar el número en w0

    // Realizar desplazamiento a la izquierda (<< 2 posiciones)
    lsl w1, w0, #2                 // w1 = w0 << 2
    // Preparación para imprimir el resultado del desplazamiento a la izquierda
    ldr x0, =msg_left_shift        // Cargar el mensaje de desplazamiento a la izquierda
    mov x1, xzr                    // Asegurar que x1 esté limpio
    uxtw x1, w1                    // Extender w1 (32 bits) a x1 (64 bits)
    bl printf                      // Llamada a printf para mostrar el resultado

    // Realizar desplazamiento a la derecha (>> 2 posiciones)
    lsr w1, w0, #2                 // w1 = w0 >> 2
    // Preparación para imprimir el resultado del desplazamiento a la derecha
    ldr x0, =msg_right_shift       // Cargar el mensaje de desplazamiento a la derecha
    mov x1, xzr                    // Asegurar que x1 esté limpio
    uxtw x1, w1                    // Extender w1 (32 bits) a x1 (64 bits)
    bl printf                      // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93                    // Código de salida para syscall exit en ARM64
    mov x0, #0                     // Código de retorno 0
    svc #0                         // Llamada al sistema
