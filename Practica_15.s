// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Búsqueda binaria de un número en un arreglo ordenado de enteros en ARM64

    .section .data
arreglo: .word 3, 10, 15, 20, 25, 30, 35, 40  // Arreglo ordenado de números enteros
tamano: .word 8                               // Tamaño del arreglo
elemento: .word 25                            // Elemento que queremos buscar
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

    // Inicializar los límites del arreglo
    mov w5, #0                 // Límite inferior (inicio del arreglo)
    sub w6, w1, #1             // Límite superior (fin del arreglo), w6 = w1 - 1

binary_search:
    // Verificar si el límite inferior es mayor que el límite superior
    cmp w5, w6                 // Comparar límite inferior con límite superior
    bgt not_found              // Si w5 > w6, el elemento no está en el arreglo

    // Calcular el índice medio: mid = (low + high) / 2
    add w7, w5, w6             // w7 = low + high
    lsr w7, w7, #1             // Dividimos por 2 (desplazamiento a la derecha)

    // Cargar el elemento en el índice medio
    ldr w3, [x2, w7, LSL #2]   // Cargar el valor en arreglo[mid] en w3

    // Comparar el elemento en el índice medio con el elemento buscado
    cmp w3, w4                 // Comparar w3 (elemento en medio) con w4 (elemento buscado)
    beq found                  // Si son iguales, el elemento ha sido encontrado

    // Ajustar los límites según el valor del elemento medio
    blt adjust_upper           // Si w3 < w4, buscamos en la mitad superior
    mov w6, w7                 // Si w3 > w4, ajustamos el límite superior a mid - 1
    sub w6, w6, #1
    b binary_search            // Repetir el bucle

adjust_upper:
    mov w5, w7                 // Ajustamos el límite inferior a mid + 1
    add w5, w5, #1
    b binary_search            // Repetir el bucle

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
    mov x1, w7                 // Índice donde se encontró el elemento
    bl printf                  // Llamada a printf para mostrar el índice

end_program:
    // Salir del programa
    mov x8, #93                // Código de salida para syscall exit en ARM64
    mov x0, #0                 // Código de retorno 0
    svc #0                     // Llamada al sistema
