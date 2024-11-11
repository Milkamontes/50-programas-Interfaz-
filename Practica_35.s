// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa rota los elementos de un arreglo a la izquierda o a la derecha
//              un número específico de posiciones. La dirección base del arreglo debe estar en x0,
//              el número de elementos en x1, las posiciones a rotar en x2, y la dirección en x3 (0 = izquierda, 1 = derecha).
//              El resultado se almacena en el mismo arreglo.

.global _start            // Punto de entrada para el sistema operativo

_start:
    // Inicialización del arreglo, tamaño, posiciones a rotar y dirección (ejemplo)
    ldr x0, =arreglo      // Dirección base del arreglo en x0
    mov x1, #5            // Número de elementos en el arreglo
    mov x2, #2            // Número de posiciones a rotar
    mov x3, #1            // Dirección de rotación (0 = izquierda, 1 = derecha)

    // Normalizar el número de rotaciones para evitar rotaciones innecesarias
    urem x2, x2, x1       // x2 = x2 % x1 (modulo para evitar rotaciones mayores al tamaño)

    // Verificar la dirección de rotación
    cbz x3, rotate_left   // Si x3 es 0, rota a la izquierda
    b rotate_right        // Si x3 es 1, rota a la derecha

// Rotación hacia la izquierda
rotate_left:
    // Bucle para rotar a la izquierda x2 veces
1:
    // Guardamos el primer elemento temporalmente
    ldr w4, [x0]           // Carga arreglo[0] en w4
    
    // Mover todos los elementos a la izquierda
    mov x5, #1             // Contador para el bucle interno
2:
    cmp x5, x1
    bge 3f                 // Si el contador alcanza el tamaño, fin del bucle interno
    ldr w6, [x0, x5, LSL #2]  // Carga arreglo[x5] en w6
    str w6, [x0, x5, LSL #2, #-4] // Guarda w6 en arreglo[x5-1]
    add x5, x5, #1         // Incrementa el contador
    b 2b                   // Repetir bucle interno

3:
    // Colocar el primer elemento al final
    str w4, [x0, x1, LSL #2, #-4] // Coloca w4 en arreglo[x1-1]

    // Decrementamos el número de rotaciones y repetimos
    sub x2, x2, #1
    cbnz x2, 1b            // Si hay rotaciones pendientes, repetir

    b end_rotation         // Fin de la rotación

// Rotación hacia la derecha
rotate_right:
    // Bucle para rotar a la derecha x2 veces
4:
    // Guardamos el último elemento temporalmente
    ldr w4, [x0, x1, LSL #2, #-4] // Carga arreglo[x1-1] en w4
    
    // Mover todos los elementos a la derecha
    mov x5, x1
5:
    sub x5, x5, #1         // Decrementa el contador
    cbz x5, 6f             // Si contador llega a 0, fin del bucle interno
    ldr w6, [x0, x5, LSL #2, #-4] // Carga arreglo[x5-1] en w6
    str w6, [x0, x5, LSL #2] // Guarda w6 en arreglo[x5]
    b 5b                   // Repetir bucle interno

6:
    // Colocar el último elemento al inicio
    str w4, [x0]           // Coloca w4 en arreglo[0]

    // Decrementamos el número de rotaciones y repetimos
    sub x2, x2, #1
    cbnz x2, 4b            // Si hay rotaciones pendientes, repetir

end_rotation:
    // Fin del programa
    mov w8, #93            // Código de salida del sistema para "exit" en Linux
    svc #0                 // Llamada al sistema para finalizar el programa

// Datos del arreglo (ejemplo)
.section .data
arreglo:
    .word 1, 2, 3, 4, 5    // Ejemplo de arreglo con 5 elementos
