// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Búsqueda lineal de un número en un arreglo de enteros en ARM64
// Asciinema: https://asciinema.org/a/690483

    .section .data
arreglo: .word 10, 25, 3, 48, 5, 30     // Arreglo de números enteros
tamano: .word 6                         // Tamaño del arreglo
elemento: .word 48                      // Elemento que queremos buscar
msg_found: .asciz "Elemento encontrado en el índice: %d\n"
msg_not_found: .asciz "Elemento no encontrado\n"

.section .text
.global _start

_start:
    ldr x1, =tamano            // Dirección del tamaño
    ldr w1, [x1]               // Cargar tamaño
    cbz w1, not_found          // Si tamaño es 0, no se encontró

    ldr x4, =elemento          // Dirección del elemento a buscar
    ldr w4, [x4]               // Elemento en w4
    ldr x2, =arreglo           // Dirección del arreglo
    mov w5, #0                 // Índice inicial

search_loop:
    cmp w5, w1                 // Comparar índice con el tamaño
    beq not_found              // Si índice == tamaño, no encontrado

    uxtw x5, w5                // Extender índice w5 a 64 bits
    ldr w3, [x2, x5, LSL #2]   // Elemento arreglo[w5] en w3
    cmp w3, w4                 // Comparar con el buscado
    beq found                  // Si son iguales, saltar a "found"

    add w5, w5, #1             // Incrementar índice
    b search_loop              // Repetir bucle

not_found:
    ldr x0, =msg_not_found     // Cargar mensaje
    mov x1, #1                 // stdout
    mov x2, #22                // Longitud del mensaje
    mov x8, #64                // syscall write
    svc #0
    b end_program

found:
    ldr x0, =msg_found         // Mensaje
    uxtw x1, w5                // Extender índice a 64 bits
    bl printf                  // Imprimir

end_program:
    mov x8, #93                // syscall exit
    mov x0, #0                 // Código de retorno
    svc #0

