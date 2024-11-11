// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa invierte los elementos en un arreglo in-place. 
//              La dirección base del arreglo debe estar en x0 y el número de elementos en x1.
//              El arreglo estará invertido en la misma ubicación de memoria.

.global _start         // Punto de entrada para el sistema operativo

_start:
    // Inicialización del arreglo y tamaño (solo para este ejemplo)
    ldr x0, =arreglo   // Dirección base del arreglo en x0
    mov x1, #5         // Número de elementos en el arreglo (ejemplo: 5)

    // Configuramos los índices para el inicio y fin del arreglo
    mov x2, #0         // Índice inicial (x2)
    sub x3, x1, #1     // Índice final (x3) = número de elementos - 1

invert_loop:
    // Verificamos si el índice inicial ha alcanzado o sobrepasado al índice final
    cmp x2, x3
    bge end_invert     // Si inicio >= fin, terminamos

    // Cargamos los elementos de los extremos en registros temporales
    ldr w4, [x0, x2, LSL #2]   // Carga arreglo[x2] en w4
    ldr w5, [x0, x3, LSL #2]   // Carga arreglo[x3] en w5

    // Intercambiamos los elementos
    str w5, [x0, x2, LSL #2]   // Guarda w5 en arreglo[x2]
    str w4, [x0, x3, LSL #2]   // Guarda w4 en arreglo[x3]

    // Actualizamos los índices
    add x2, x2, #1    // Avanza el índice inicial
    sub x3, x3, #1    // Retrocede el índice final
    b invert_loop     // Repetimos el bucle

end_invert:
    // Fin del programa
    mov w8, #93       // Código de salida del sistema para "exit" en Linux
    svc #0            // Llamada al sistema para finalizar el programa

// Datos del arreglo (ejemplo)
.section .data
arreglo:
    .word 1, 2, 3, 4, 5 // Ejemplo de arreglo con 5 elementos
