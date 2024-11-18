// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Encontrar el valor mínimo en un arreglo de enteros en ARM64
// Asciinema: https://asciinema.org/a/690479

 .section .data
arreglo: .word 10, 25, 3, 48, 5, 30      // Arreglo de números enteros
tamano: .word 6                          // Tamaño del arreglo
msg_resultado: .asciz "El valor mínimo es: %d\n"

.section .text
.global _start

_start:
    ldr x1, =tamano            // Dirección del tamaño
    ldr w1, [x1]               // Cargar el tamaño
    cbz w1, end_program        // Si el tamaño es 0, salir

    ldr x2, =arreglo           // Dirección del arreglo
    ldr w0, [x2]               // Inicializar el mínimo
    add x3, x2, #4             // Apuntar al segundo elemento
    sub w1, w1, #1             // Decrementar el contador

min_loop:
    cbz w1, print_resultado    // Si w1 es 0, terminar el bucle
    ldr w4, [x3]               // Cargar el siguiente elemento
    cmp w4, w0                 // Comparar
    bge skip_update            // Saltar si w4 >= w0
    mov w0, w4                 // Actualizar el mínimo
skip_update:
    add x3, x3, #4             // Avanzar al siguiente elemento
    sub w1, w1, #1             // Decrementar el contador
    b min_loop                 // Repetir

print_resultado:
    ldr x1, =msg_resultado     // Mensaje
    uxtw x2, w0                // Extender el mínimo a x2
    mov x0, x1                 // Mensaje en x0
    bl printf                  // Imprimir
end_program:
    mov x8, #93                // syscall exit
    mov x0, #0                 // Código de retorno
    svc #0                     // Salir
