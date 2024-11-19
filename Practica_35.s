// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa rota los elementos de un arreglo a la izquierda o a la derecha


.data
    msg_size: .asciz "Ingrese el tamaño del arreglo: "
    msg_element: .asciz "Ingrese el elemento %d: "
    msg_direction: .asciz "Ingrese la dirección de rotación (0 para izquierda, 1 para derecha): "
    msg_positions: .asciz "Ingrese el número de posiciones a rotar: "
    msg_original: .asciz "\nArreglo original:\n"
    msg_rotated: .asciz "\nArreglo rotado:\n"
    formato_in: .asciz "%ld"
    formato_out: .asciz "%ld "
    newline: .asciz "\n"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Pedir el tamaño del arreglo
    adrp x0, msg_size
    add x0, x0, :lo12:msg_size
    bl printf

    // Leer el tamaño
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar el tamaño en x19
    ldr x19, [sp]
    add sp, sp, #16

    // Reservar espacio para el arreglo en el stack
    sub sp, sp, x19, lsl #3  // Multiplicar x19 por 8 (tamaño de cada elemento)
    mov x20, sp  // Guardar la dirección base del arreglo en x20

    // Leer los elementos del arreglo
    mov x21, #0  // Índice del elemento actual
leer_elementos:
    cmp x21, x19
    b.ge fin_lectura

    // Imprimir mensaje para ingresar elemento
    adrp x0, msg_element
    add x0, x0, :lo12:msg_element
    add x1, x21, #1  // Número de elemento (índice + 1)
    bl printf

    // Leer elemento
    add x2, x20, x21, lsl #3  // Calcular dirección del elemento actual
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    add x21, x21, #1
    b leer_elementos

fin_lectura:
    // Pedir dirección de rotación
    adrp x0, msg_direction
    add x0, x0, :lo12:msg_direction
    bl printf

    // Leer dirección
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar dirección en x22
    ldr x22, [sp]
    add sp, sp, #16

    // Pedir número de posiciones a rotar
    adrp x0, msg_positions
    add x0, x0, :lo12:msg_positions
    bl printf

    // Leer número de posiciones
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar número de posiciones en x23
    ldr x23, [sp]
    add sp, sp, #16

    // Ajustar el número de posiciones si es mayor que el tamaño del arreglo
    udiv x24, x23, x19
    msub x23, x24, x19, x23

    // Imprimir arreglo original
    adrp x0, msg_original
    add x0, x0, :lo12:msg_original
    bl printf

    bl imprimir_arreglo

    // Rotar el arreglo
    cmp x22, #0
    b.eq rotar_izquierda
    b rotar_derecha

rotar_izquierda:
    mov x0, x20  // Dirección base del arreglo
    mov x1, x19  // Tamaño del arreglo
    mov x2, x23  // Número de posiciones a rotar
    bl rotate_left
    b fin_rotacion

rotar_derecha:
    mov x0, x20  // Dirección base del arreglo
    mov x1, x19  // Tamaño del arreglo
    mov x2, x23  // Número de posiciones a rotar
    bl rotate_right

fin_rotacion:
    // Imprimir arreglo rotado
    adrp x0, msg_rotated
    add x0, x0, :lo12:msg_rotated
    bl printf

    bl imprimir_arreglo

    // Liberar espacio del arreglo
    add sp, sp, x19, lsl #3

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// Función para imprimir el arreglo
imprimir_arreglo:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov x21, #0  // Índice
imprimir_loop:
    cmp x21, x19
    b.ge fin_imprimir

    ldr x1, [x20, x21, lsl #3]  // Cargar elemento actual
    adrp x0, formato_out
    add x0, x0, :lo12:formato_out
    bl printf

    add x21, x21, #1
    b imprimir_loop

fin_imprimir:
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf

    ldp x29, x30, [sp], #16
    ret

// Función para rotar a la izquierda
// x0: dirección base del arreglo
// x1: tamaño del arreglo
// x2: número de posiciones a rotar
rotate_left:
    stp x29, x30, [sp, -32]!
    mov x29, sp

    // Guardar parámetros
    str x0, [sp, #16]  // Dirección base
    str x1, [sp, #24]  // Tamaño

    // Revertir todo el arreglo
    mov x1, x1
    bl reverse_array

    // Revertir la primera parte (n-d elementos)
    ldr x0, [sp, #16]
    ldr x1, [sp, #24]
    sub x1, x1, x2
    bl reverse_array

    // Revertir la segunda parte (d elementos)
    ldr x0, [sp, #16]
    ldr x1, [sp, #24]
    sub x1, x1, x2
    lsl x1, x1, #3
    add x0, x0, x1
    mov x1, x2
    bl reverse_array

    ldp x29, x30, [sp], #32
    ret

// Función para rotar a la derecha
// x0: dirección base del arreglo
// x1: tamaño del arreglo
// x2: número de posiciones a rotar
rotate_right:
    stp x29, x30, [sp, -32]!
    mov x29, sp

    // Guardar parámetros
    str x0, [sp, #16]  // Dirección base
    str x1, [sp, #24]  // Tamaño

    // Revertir todo el arreglo
    mov x1, x1
    bl reverse_array

    // Revertir la primera parte (d elementos)
    ldr x0, [sp, #16]
    mov x1, x2
    bl reverse_array

    // Revertir la segunda parte (n-d elementos)
    ldr x0, [sp, #16]
    ldr x1, [sp, #24]
    lsl x2, x2, #3
    add x0, x0, x2
    sub x1, x1, x2
    lsr x1, x1, #3
    bl reverse_array

    ldp x29, x30, [sp], #32
    ret

// Función para revertir un arreglo
// x0: dirección base del arreglo
// x1: tamaño del arreglo
reverse_array:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov x2, #0  // Índice inicial
    sub x3, x1, #1  // Índice final
    lsl x3, x3, #3  // Multiplicar por 8 para obtener el offset en bytes

reverse_loop:
    cmp x2, x3
    b.ge end_reverse

    // Intercambiar elementos
    ldr x4, [x0, x2]
    ldr x5, [x0, x3]
    str x5, [x0, x2]
    str x4, [x0, x3]

    add x2, x2, #8
    sub x3, x3, #8
    b reverse_loop

end_reverse:
    ldp x29, x30, [sp], #16
    ret
