// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa calcula el Mínimo Común Múltiplo (MCM) de dos números
//              utilizando la relación MCM(a, b) = (a * b) / MCD(a, b). Los números de entrada 
//              deben estar en los registros x0 y x1, y el resultado se almacenará en x0.

.section .data
msg: .asciz "MCM: %d\n"
buffer: .space 16                  // Espacio para el número convertido

.section .text
.global _start

_start:
    mov x0, #15
    mov x1, #20

    mov x2, x0
    mov x3, x1

    bl mcd

    mul x1, x2, x3
    udiv x0, x1, x0

    mov x2, buffer                 // Dirección del buffer
    mov x1, x0                     // Número a convertir
    bl itoa                        // Convierte a texto

    mov x0, 1                      // stdout
    ldr x1, =msg                   // Mensaje base
    mov x2, buffer                 // Número convertido
    mov x8, #64                    // Syscall write
    svc #0                         // Llama a write

    mov w8, #93                    // Syscall exit
    svc #0

mcd:
    cmp x1, #0
    beq end_mcd
    udiv x2, x0, x1
    msub x2, x2, x1, x0
    mov x0, x1
    mov x1, x2
    b mcd
end_mcd:
    ret

itoa:                              // Convierte número en x1 a texto en buffer
    mov x2, x1                     // Número
    mov x3, #10                    // Base decimal
itoa_loop:
    udiv x4, x2, x3
    msub x5, x4, x3, x2
    add x5, x5, #'0'
    strb w5, [x0], #1
    mov x2, x4
    cbnz x2, itoa_loop
    ret
