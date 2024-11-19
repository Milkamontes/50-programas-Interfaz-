// Autor: Milka Guadalupe Montes Domínguez 
// Fecha: 10-11-24
// Descripción: Establecer, borrar y alternar bits en un número en ARM64
// Asciinema: https://asciinema.org/a/690633

    .section .data
num: .word 0b00101100             // Número inicial en binario (44 en decimal)
msg_set_bit: .asciz "Resultado con bit establecido: %d\n"
msg_clear_bit: .asciz "Resultado con bit borrado: %d\n"
msg_toggle_bit: .asciz "Resultado con bit alternado: %d\n"

    .section .text
    .global _start

_start:
    // Cargar el número inicial en un registro
    ldr x0, =num                  // Dirección del número
    ldr w0, [x0]                  // Cargar el número en w0

    // Establecer (Set) el tercer bit
    orr w1, w0, #0b00000100       // w1 = w0 | (1 << 2)
    // Preparación para imprimir el resultado con el bit establecido
    ldr x0, =msg_set_bit          // Cargar el mensaje para el bit establecido
    uxtw x1, w1                   // Extender w1 a x1
    bl printf                     // Llamada a printf para mostrar el resultado

    // Borrar (Clear) el tercer bit
    bic w1, w0, #0b00000100       // w1 = w0 & ~(1 << 2)
    // Preparación para imprimir el resultado con el bit borrado
    ldr x0, =msg_clear_bit        // Cargar el mensaje para el bit borrado
    uxtw x1, w1                   // Extender w1 a x1
    bl printf                     // Llamada a printf para mostrar el resultado

    // Alternar (Toggle) el tercer bit
    eor w1, w0, #0b00000100       // w1 = w0 ^ (1 << 2)
    // Preparación para imprimir el resultado con el bit alternado
    ldr x0, =msg_toggle_bit       // Cargar el mensaje para el bit alternado
    uxtw x1, w1                   // Extender w1 a x1
    bl printf                     // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93                   // Código de salida para syscall exit en ARM64
    mov x0, #0                    // Código de retorno 0
    svc #0                        // Llamada al sistema
