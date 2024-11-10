// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Búsqueda lineal de un número en un arreglo de enteros en ARM64

    .section .data
arreglo: .word 10, 25, 3, 48, 5, 30     // Arreglo de números enteros
tamano: .word 6                         // Tamaño del arreglo
elemento: .word 48                       // Elemento que queremos buscar
msg_found: .asciz "Elemento encontrado en el índice: %d\n"
msg_not_found: .asciz "Elemento no encontrado\n"

    .section .text
    .global _start

_start:
    // Cargar el tamaño del arreglo
    ldr x1, =tamano            // Dirección del tamaño
    ldr w1, [x1]               // Cargar el tamaño en w1 (número de elementos)

    // Cargar el elemento que queremos buscar
    ldr x4, =elemento          // Dirección del elemento a buscar
    ldr w4, [x4]               // Cargar el elemento en w4

    // Cargar la dirección del arreglo
    ldr x2, =arreglo           // x2 apunta al inicio del arreglo

    // Inicializar el índice
    mov w5, #0                 // Índice del arreglo

search_loop:
    // Verificar si hemos recorrido todo el arreglo
    cmp w5, w1                 // Comparar índice con el tamaño
    beq not_found              // Si w5 == w1, terminamos el bucle (no encontrado)

    // Cargar el elemento actual del arreglo
    ldr w3, [x2, w5, LSL #2]   // Cargar el elemento arreglo[w5] en w3

    // Comparar el elemento actual con el valor buscado
    cmp w3, w4                 // Comparar w3 (elemento actual) con w4 (elemento buscado)
    beq found                  // Si son iguales, saltamos a "found"

    // Incrementar el índice
    add w5, w5, #1             // Incrementar el índice
    b search_loop              // Repetir el bucle

not_found:
    // Preparación para imprimir "Elemento no encontrado"
    ldr x0, =msg_not_found     // Cargar mensaje de "Elemento no encontrado"
    mov x1, #1                 // Descriptor de archivo 1 (stdout)
    mov x2, #22                // Longitud del mensaje
    mov x8, #64                // syscall write
    svc #0                     // Llamada al sistema
    b end_program              // Saltar al final

found:
    // Preparación para imprimir "Elemento encontrado"
    ldr x0, =msg_found         // Cargar mensaje de "Elemento encontrado"
    mov x1, w5                 // Índice donde se encontró el elemento
    bl printf                  // Llamada a printf para mostrar el índice

end_program:
    // Salir del programa
    mov x8, #93                // Código de salida para syscall exit en ARM64
    mov x0, #0                 // Código de retorno 0
    svc #0                     // Llamada al sistema
