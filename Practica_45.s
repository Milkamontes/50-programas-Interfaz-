// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Verificar si un número es Armstrong en ARM64
// Asciinema: 

.data
    msg_input: .asciz "Ingrese un número positivo: "
    msg_debug_digits: .asciz "Número de dígitos: %d\n"
    formato_in: .asciz "%ld"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -32]!
    mov x29, sp

    // Pedir número
    adrp x0, msg_input
    add x0, x0, :lo12:msg_input
    bl printf

    // Leer número
    add x1, sp, 16
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    bl scanf
    ldr x19, [sp, 16]  // x19 = número ingresado

    // Contar dígitos
    mov x0, x19
    bl count_digits
    mov x20, x0  // x20 = número de dígitos

    // Imprimir número de dígitos
    adrp x0, msg_debug_digits
    add x0, x0, :lo12:msg_debug_digits
    mov x1, x20
    bl printf

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], 32
    ret

// Función para contar dígitos
count_digits:
    mov x1, #10
    mov x2, #0
count_loop:
    udiv x0, x0, x1
    add x2, x2, #1
    cbnz x0, count_loop
    mov x0, x2
    ret
