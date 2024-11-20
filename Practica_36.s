// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa encuentra el segundo elemento más grande en un arreglo de enteros.
// Asciinema: https://asciinema.org/a/691051

.data
    msg_size: .asciz "Ingrese el tamaño del arreglo (mínimo 2): "
    msg_element: .asciz "Ingrese el elemento %d: "
    msg_result: .asciz "El segundo elemento más grande es: %ld\n"
    msg_error: .asciz "Error: El arreglo debe tener al menos 2 elementos.\n"
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

    // Verificar que el tamaño sea al menos 2
    cmp x19, #2
    b.lt error_size

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
    // Encontrar el segundo elemento más grande
    ldr x22, [x20]  // Inicializar el más grande con el primer elemento
    ldr x23, [x20, #8]  // Inicializar el segundo más grande con el segundo elemento

    // Asegurar que x22 >= x23
    cmp x22, x23
    b.ge continuar_busqueda
    mov x24, x22
    mov x22, x23
    mov x23, x24

continuar_busqueda:
    mov x21, #2  // Comenzar desde el tercer elemento
buscar_segundo:
    cmp x21, x19
    b.ge fin_busqueda

    ldr x24, [x20, x21, lsl #3]  // Cargar elemento actual

    // Comparar con el más grande
    cmp x24, x22
    b.le comparar_segundo
    mov x23, x22  // El más grande actual pasa a ser el segundo más grande
    mov x22, x24  // Actualizar el más grande
    b siguiente_elemento

comparar_segundo:
    cmp x24, x23
    b.le siguiente_elemento
    mov x23, x24  // Actualizar el segundo más grande

siguiente_elemento:
    add x21, x21, #1
    b buscar_segundo

fin_busqueda:
    // Imprimir el resultado
    adrp x0, msg_result
    add x0, x0, :lo12:msg_result
    mov x1, x23
    bl printf

    // Liberar espacio del arreglo
    add sp, sp, x19, lsl #3

    b exit_program

error_size:
    // Imprimir mensaje de error
    adrp x0, msg_error
    add x0, x0, :lo12:msg_error
    bl printf

exit_program:
    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
