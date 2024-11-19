// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Contar los bits activados en un número en ARM64
// Asciinema: https://asciinema.org/a/690469

 .data
array:      .word 12, 35, 7, 23, 67, 87, 34, 86, 90, 14 // Arreglo de ejemplol
arr_len:    .word 10                                    // Longitud del arreglo
msg_result: .asciz "El valor máximo en el arreglo es: %d\n" // Mensaje para imprimir el resultado

    .text
    .global main

main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]!     // Reservar espacio en la pila
    mov x29, sp                  // Establecer el puntero de marco
    
    // Cargar la dirección y longitud del arreglo
    adrp x0, arr_len             // Cargar la página base de arr_len en x0
    add x0, x0, :lo12:arr_len    // Cargar el desplazamiento bajo de arr_len
    ldr w1, [x0]                 // Obtener la longitud del arreglo en w1
    adrp x2, array               // Cargar la página base de array en x2
    add x2, x2, :lo12:array      // Cargar el desplazamiento bajo de array

    // Inicializar el valor máximo
    ldr w3, [x2]                 // Cargar el primer elemento del arreglo en w3 como máximo inicial
    add x2, x2, #4               // Avanzar a la siguiente posición en el arreglo
    sub w1, w1, #1               // Decrementar el contador de elementos

loop:
    cbz w1, end_loop             // Si el contador llega a cero, salir del bucle
    ldr w4, [x2]                 // Cargar el siguiente elemento en w4
    cmp w3, w4                   // Comparar w3 (máximo actual) con w4 (nuevo valor)
    csel w3, w3, w4, gt          // Si w3 > w4, mantener w3; si no, actualizar w3 con w4
    add x2, x2, #4               // Avanzar a la siguiente posición en el arreglo
    sub w1, w1, #1               // Decrementar el contador de elementos
    b loop                       // Repetir el bucle

end_loop:
    // Imprimir el resultado
    adrp x0, msg_result          // Cargar la página base de msg_result en x0
    add x0, x0, :lo12:msg_result // Cargar el desplazamiento bajo de msg_result
    mov w1, w3                   // Mover el valor máximo a w1 para printf
    bl printf                    // Imprimir el valor máximo en el arreglo

    // Restaurar el puntero de pila y regresar
    ldp x29, x30, [sp], 16       // Restaurar el puntero de marco y el enlace de retorno
    ret                          // Regresar del programa
