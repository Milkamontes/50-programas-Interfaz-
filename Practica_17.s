// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Ordenamiento por selección de un arreglo de enteros en ARM64

    .section .data
arreglo: .word 25, 10, 48, 3, 5, 30      // Arreglo desordenado de números enteros
tamano: .word 6                          // Tamaño del arreglo
msg_resultado: .asciz "Arreglo ordenado: %d %d %d %d %d %d\n"

    .section .text
    .global _start

_start:
    // Cargar el tamaño del arreglo
    ldr x1, =tamano            // Dirección del tamaño
    ldr w1, [x1]               // Cargar el tamaño en w1 (número de elementos)

    // Cargar la dirección del arreglo
    ldr x2, =arreglo           // x2 apunta al inicio del arreglo

selection_sort:
    // Bucle externo: selecciona cada posición para colocar el menor elemento
    mov w3, #0                 // Índice de inicio del bucle externo

outer_loop:
    cmp w3, w1                 // Comparar índice actual con el tamaño
    bge print_resultado        // Si hemos recorrido todo el arreglo, salimos

    // Inicializar el mínimo como el primer elemento sin ordenar
    mov w4, w3                 // Índice del valor mínimo
    ldr w5, [x2, w3, LSL #2]   // Cargar el valor de arreglo[w3] en w5

    // Bucle interno: busca el menor elemento en la parte no ordenada del arreglo
    mov w6, w3                 // Inicializar el índice del bucle interno
    add w6, w6, #1             // Comienza desde el siguiente elemento

inner_loop:
    cmp w6, w1                 // Comparar índice interno con el tamaño
    bge swap_min               // Si hemos llegado al final, intercambiamos

    // Cargar el siguiente elemento para comparar
    ldr w7, [x2, w6, LSL #2]   // Cargar arreglo[w6] en w7

    // Si encontramos un elemento menor, actualizamos el índice mínimo
    cmp w7, w5                 // Comparar arreglo[w6] con el valor mínimo actual
    bge skip_update            // Si arreglo[w6] >= w5, saltar la actualización

    // Actualizar el índice y valor mínimo
    mov w4, w6                 // Índice mínimo actualizado
    mov w5, w7                 // Valor mínimo actualizado

skip_update:
    add w6, w6, #1             // Incrementar el índice del bucle interno
    b inner_loop               // Repetir el bucle interno

swap_min:
    // Intercambiar el valor mínimo encontrado con el primer elemento de la parte no ordenada
    cmp w4, w3                 // Si el índice mínimo es el mismo, no necesitamos intercambiar
    beq skip_swap

    ldr w8, [x2, w3, LSL #2]   // Cargar arreglo[w3] en w8 (valor a intercambiar)
    str w5, [x2, w3, LSL #2]   // Guardar el valor mínimo en arreglo[w3]
    str w8, [x2, w4, LSL #2]   // Guardar el valor original de arreglo[w3] en arreglo[w4]

skip_swap:
    add w3, w3, #1             // Incrementar el índice para la siguiente posición en el bucle externo
    b outer_loop               // Repetir el bucle externo

print_resultado:
    // Preparación para imprimir el arreglo ordenado
    ldr x0, =msg_resultado     // Cargar el mensaje del arreglo ordenado
    ldr w1, [x2]               // Cargar arreglo[0] en w1
    ldr w2, [x2, #4]           // Cargar arreglo[1] en w2
    ldr w3, [x2, #8]           // Cargar arreglo[2] en w3
    ldr w4, [x2, #12]          // Cargar arreglo[3] en w4
    ldr w5, [x2, #16]          // Cargar arreglo[4] en w5
    ldr w6, [x2, #20]          // Cargar arreglo[5] en w6

    // Llamada a printf para mostrar el arreglo ordenado
    bl printf                  // Llamada a printf para mostrar el arreglo

    // Salir del programa
    mov x8, #93                // Código de salida para syscall exit en ARM64
    mov x0, #0                 // Código de retorno 0
    svc #0                     // Llamada al sistema
