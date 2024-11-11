// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Establecer, borrar y alternar bits en un número en ARM64

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

    // Establecer (Set) el tercer bit (de derecha a izquierda, comenzando en 0)
    // Usamos OR con un valor que tenga solo el tercer bit activado (0b00000100)
    orr w1, w0, #0b00000100       // w1 = w0 | (1 << 2), establece el tercer bit
    // Preparación para imprimir el resultado con el bit establecido
    ldr x0, =msg_set_bit          // Cargar el mensaje para el bit establecido
    mov x1, w1                    // Mover el resultado de set bit a x1 para imprimir
    bl printf                     // Llamada a printf para mostrar el resultado

    // Borrar (Clear) el tercer bit (de derecha a izquierda, comenzando en 0)
    // Usamos AND con un valor que tenga todos los bits activados excepto el tercer bit (0b11111011)
    bic w1, w0, #0b00000100       // w1 = w0 & ~(1 << 2), borra el tercer bit
    // Preparación para imprimir el resultado con el bit borrado
    ldr x0, =msg_clear_bit        // Cargar el mensaje para el bit borrado
    mov x1, w1                    // Mover el resultado de clear bit a x1 para imprimir
    bl printf                     // Llamada a printf para mostrar el resultado

    // Alternar (Toggle) el tercer bit (de derecha a izquierda, comenzando en 0)
    // Usamos XOR con un valor que tenga solo el tercer bit activado (0b00000100)
    eor w1, w0, #0b00000100       // w1 = w0 ^ (1 << 2), alterna el tercer bit
    // Preparación para imprimir el resultado con el bit alternado
    ldr x0, =msg_toggle_bit       // Cargar el mensaje para el bit alternado
    mov x1, w1                    // Mover el resultado de toggle bit a x1 para imprimir
    bl printf                     // Llamada a printf para mostrar el resultado

    // Salir del programa
    mov x8, #93                   // Código de salida para syscall exit en ARM64
    mov x0, #0                    // Código de retorno 0
    svc #0                        // Llamada al sistema
