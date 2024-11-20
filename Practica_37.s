// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Implementación de una pila básica utilizando un arreglo en ARM64. 
// Asciinema: https://asciinema.org/a/691053

.data
    msg_menu: .asciz "\nOperaciones de la pila:\n1. Push\n2. Pop\n3. Peek\n4. Mostrar pila\n5. Salir\nElija una opción: "
    msg_push: .asciz "Ingrese el elemento a agregar: "
    msg_pop: .asciz "Elemento removido: %ld\n"
    msg_peek: .asciz "Elemento superior: %ld\n"
    msg_empty: .asciz "La pila está vacía\n"
    msg_full: .asciz "La pila está llena\n"
    msg_stack: .asciz "Elementos de la pila (de arriba a abajo):\n"
    formato_in: .asciz "%ld"
    formato_out: .asciz "%ld "
    newline: .asciz "\n"

.text
.global main
.align 2

// Constantes
.equ STACK_SIZE, 10
.equ ELEMENT_SIZE, 8

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Reservar espacio para la pila
    sub sp, sp, #(STACK_SIZE * ELEMENT_SIZE)
    mov x19, sp  // x19 = dirección base de la pila
    mov x20, #0  // x20 = tope de la pila (índice)

menu_loop:
    // Mostrar menú
    adrp x0, msg_menu
    add x0, x0, :lo12:msg_menu
    bl printf

    // Leer opción
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf
    ldr x21, [sp]  // x21 = opción elegida
    add sp, sp, #16

    // Ejecutar opción elegida
    cmp x21, #1
    b.eq option_push
    cmp x21, #2
    b.eq option_pop
    cmp x21, #3
    b.eq option_peek
    cmp x21, #4
    b.eq option_display
    cmp x21, #5
    b.eq exit_program

    b menu_loop

option_push:
    // Verificar si la pila está llena
    cmp x20, #STACK_SIZE
    b.eq stack_full

    // Pedir elemento a agregar
    adrp x0, msg_push
    add x0, x0, :lo12:msg_push
    bl printf

    // Leer elemento
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf
    ldr x22, [sp]  // x22 = elemento a agregar
    add sp, sp, #16

    // Agregar elemento a la pila
    str x22, [x19, x20, lsl #3]
    add x20, x20, #1

    b menu_loop

option_pop:
    // Verificar si la pila está vacía
    cbz x20, stack_empty

    // Obtener elemento superior
    sub x20, x20, #1
    ldr x22, [x19, x20, lsl #3]

    // Mostrar elemento removido
    adrp x0, msg_pop
    add x0, x0, :lo12:msg_pop
    mov x1, x22
    bl printf

    b menu_loop

option_peek:
    // Verificar si la pila está vacía
    cbz x20, stack_empty

    // Obtener elemento superior sin removerlo
    sub x21, x20, #1
    ldr x22, [x19, x21, lsl #3]

    // Mostrar elemento superior
    adrp x0, msg_peek
    add x0, x0, :lo12:msg_peek
    mov x1, x22
    bl printf

    b menu_loop

option_display:
    // Verificar si la pila está vacía
    cbz x20, stack_empty

    // Mostrar mensaje de elementos de la pila
    adrp x0, msg_stack
    add x0, x0, :lo12:msg_stack
    bl printf

    // Mostrar elementos de la pila
    mov x21, x20  // x21 = índice temporal
display_loop:
    sub x21, x21, #1
    ldr x1, [x19, x21, lsl #3]
    adrp x0, formato_out
    add x0, x0, :lo12:formato_out
    bl printf

    cbnz x21, display_loop

    // Nueva línea al final
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf

    b menu_loop

stack_full:
    adrp x0, msg_full
    add x0, x0, :lo12:msg_full
    bl printf
    b menu_loop

stack_empty:
    adrp x0, msg_empty
    add x0, x0, :lo12:msg_empty
    bl printf
    b menu_loop

exit_program:
    // Liberar espacio de la pila
    add sp, sp, #(STACK_SIZE * ELEMENT_SIZE)

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
