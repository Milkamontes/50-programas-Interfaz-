// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa calcula el Máximo Común Divisor (MCD) de dos números
//              utilizando el Algoritmo de Euclides en ARM64 ensamblador. Los números
//              de entrada deben estar en los registros x0 y x1, y el MCD se almacenará en x0.
// Asciinema: https://asciinema.org/a/690638

.section .data
msg: .asciz "MCD: %d\n"

.section .text
.global _start

_start:
    mov x0, #56                   // Primer número
    mov x1, #98                   // Segundo número

mcd_loop:
    cmp x1, #0                    // Compara x1 con 0
    beq end_mcd                   // Si x1 es 0, terminamos

    udiv x2, x0, x1               // División entera
    msub x2, x2, x1, x0           // Resto

    mov x0, x1                    // Intercambiar valores
    mov x1, x2                    // x1 = resto
    b mcd_loop                    // Repetir

end_mcd:
    ldr x0, =msg                  // Mensaje
    mov x1, x0                    // MCD en x0
    bl printf                     // Llamar a printf

    mov x8, #93                   // Syscall exit
    svc #0
