// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa invierte los elementos en un arreglo in-place. 
// Asciinema:    https://asciinema.org/a/690662

.global _start

.section .data
arreglo:
    .word 1, 2, 3, 4, 5  // Ejemplo de arreglo con 5 elementos

.section .text
_start:
    // Inicializar dirección base del arreglo y tamaño
    ldr x0, =arreglo   // Dirección base del arreglo en x0
    mov x1, #5         // Número de elementos en el arreglo

    // Configuramos índices para invertir el arreglo
    mov x2, #0         // Índice inicial
    sub x3, x1, #1     // Índice final

invert_loop:
    cmp x2, x3         // Comparar índices inicial y final
    bge end_invert     // Si inicio >= fin, salir del bucle

    // Intercambiar elementos
    ldr w4, [x0, x2, LSL #2]   // Cargar arreglo[x2]
    ldr w5, [x0, x3, LSL #2]   // Cargar arreglo[x3]
    str w5, [x0, x2, LSL #2]   // Guardar w5 en arreglo[x2]
    str w4, [x0, x3, LSL #2]   // Guardar w4 en arreglo[x3]

    // Actualizar índices
    add x2, x2, #1    // Avanzar índice inicial
    sub x3, x3, #1    // Retroceder índice final
    b invert_loop     // Repetir bucle

end_invert:
    // Preparar para imprimir el arreglo
    mov x2, #0         // Índice inicial para impresión
    mov x3, x1         // Número de elementos a imprimir

print_loop:
    cmp x2, x3         // Comparar índice actual con el tamaño del arreglo
    bge end_program    // Si se imprimieron todos, terminar

    // Obtener el elemento actual
    ldr w4, [x0, x2, LSL #2]   // Cargar arreglo[x2]
    add x2, x2, #1             // Incrementar índice

    // Convertir entero a cadena
    bl print_int               // Llamar a la función para imprimir

    b print_loop               // Repetir para el siguiente elemento

end_program:
    mov w8, #93                // Código de salida del sistema (exit)
    svc #0                     // Terminar el programa

// Función para imprimir un número entero como texto
print_int:
    // Se espera que el número a imprimir esté en w4
    mov x1, sp                 // Usar la pila como buffer
    sub sp, sp, #16            // Reservar espacio en la pila
    mov x2, x1                 // Dirección del buffer
    add x2, x2, #15            // Apuntar al final del buffer
    mov w6, #0                 // Inicializar terminador nulo
    strb w6, [x2]              // Escribir el terminador nulo

    // Crear un registro con el divisor constante 10
    mov w7, #10                // Guardar 10 en w7 para usarlo como divisor

convert_loop:
    udiv w5, w4, w7            // w5 = w4 / 10 (cociente)
    msub w6, w5, w7, w4        // w6 = w4 - (w5 * 10) (resto)
    add w6, w6, #'0'           // Convertir dígito a ASCII
    sub x2, x2, #1             // Mover buffer hacia atrás
    strb w6, [x2]              // Escribir el dígito
    mov w4, w5                 // Actualizar el número (cociente)
    cbnz w4, convert_loop      // Repetir si hay más dígitos

    // Escribir el número en stdout
    mov x0, #1                 // File descriptor (stdout)
    mov x1, x2                 // Dirección del buffer
    mov x2, #16                // Longitud máxima (ajustada más adelante)
    mov x8, #64                // Código de llamada al sistema (write)
    svc #0                     // Llamada al sistema para escribir

    add sp, sp, #16            // Restaurar la pila
    ret                        // Regresar
