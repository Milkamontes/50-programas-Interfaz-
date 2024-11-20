// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Implementación de una cola básica utilizando un arreglo en ARM64.
// Asciinema: https://asciinema.org/a/691054

.data
    msg_menu: .asciz "\nOperaciones de la cola:\n1. Enqueue\n2. Dequeue\n3. Peek\n4. Mostrar cola\n5. Salir\nElija una opción: "
    msg_enqueue: .asciz "Ingrese el elemento a agregar: "
    msg_dequeue: .asciz "Elemento removido: %ld\n"
    msg_peek: .asciz "Elemento frontal: %ld\n"
    msg_empty: .asciz "La cola está vacía\n"
    msg_full: .asciz "La cola está llena\n"
    msg_queue: .asciz "Elementos de la cola (de frente a final):\n"
    formato_in: .asciz "%ld"
    formato_out: .asciz "%ld "
    newline: .asciz "\n"

.text
.global main
.align 2

// Constantes
.equ QUEUE_SIZE, 10
.equ ELEMENT_SIZE, 8

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Reservar espacio para la cola
    sub sp, sp, #(QUEUE_SIZE * ELEMENT_SIZE)
    mov x19, sp  // x19 = dirección base de la cola
    mov x20, #0  // x20 = frente de la cola
    mov x21, #0  // x21 = final de la cola
    mov x22, #0  // x22 = tamaño actual de la cola

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
    ldr x23, [sp]  // x23 = opción elegida
    add sp, sp, #16

    // Ejecutar opción elegida
    cmp x23, #1
    b.eq option_enqueue
    cmp x23, #2
    b.eq option_dequeue
    cmp x23, #3
    b.eq option_peek
    cmp x23, #4
    b.eq option_display
    cmp x23, #5
    b.eq exit_program

    b menu_loop

option_enqueue:
    // Verificar si la cola está llena
    cmp x22, #QUEUE_SIZE
    b.eq queue_full

    // Pedir elemento a agregar
    adrp x0, msg_enqueue
    add x0, x0, :lo12:msg_enqueue
    bl printf

    // Leer elemento
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf
    ldr x24, [sp]  // x24 = elemento a agregar
    add sp, sp, #16

    // Agregar elemento a la cola
    str x24, [x19, x21, lsl #3]
    add x21, x21, #1
    mov x25, #QUEUE_SIZE
    udiv x26, x21, x25
    msub x21, x26, x25, x21  // x21 = x21 % QUEUE_SIZE
    add x22, x22, #1

    b menu_loop

option_dequeue:
    // Verificar si la cola está vacía
    cbz x22, queue_empty

    // Obtener elemento frontal
    ldr x24, [x19, x20, lsl #3]
    add x20, x20, #1
    mov x25, #QUEUE_SIZE
    udiv x26, x20, x25
    msub x20, x26, x25, x20  // x20 = x20 % QUEUE_SIZE
    sub x22, x22, #1

    // Mostrar elemento removido
    adrp x0, msg_dequeue
    add x0, x0, :lo12:msg_dequeue
    mov x1, x24
    bl printf

    b menu_loop

option_peek:
    // Verificar si la cola está vacía
    cbz x22, queue_empty

    // Obtener elemento frontal sin removerlo
    ldr x24, [x19, x20, lsl #3]

    // Mostrar elemento frontal
    adrp x0, msg_peek
    add x0, x0, :lo12:msg_peek
    mov x1, x24
    bl printf

    b menu_loop

option_display:
    // Verificar si la cola está vacía
    cbz x22, queue_empty

    // Mostrar mensaje de elementos de la cola
    adrp x0, msg_queue
    add x0, x0, :lo12:msg_queue
    bl printf

    // Mostrar elementos de la cola
    mov x23, x20  // x23 = índice temporal
    mov x24, x22  // x24 = contador de elementos
display_loop:
    ldr x1, [x19, x23, lsl #3]
    adrp x0, formato_out
    add x0, x0, :lo12:formato_out
    bl printf

    add x23, x23, #1
    mov x25, #QUEUE_SIZE
    udiv x26, x23, x25
    msub x23, x26, x25, x23  // x23 = x23 % QUEUE_SIZE
    subs x24, x24, #1
    b.ne display_loop

    // Nueva línea al final
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf

    b menu_loop

queue_full:
    adrp x0, msg_full
    add x0, x0, :lo12:msg_full
    bl printf
    b menu_loop

queue_empty:
    adrp x0, msg_empty
    add x0, x0, :lo12:msg_empty
    bl printf
    b menu_loop

exit_program:
    // Liberar espacio de la cola
    add sp, sp, #(QUEUE_SIZE * ELEMENT_SIZE)

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
    
