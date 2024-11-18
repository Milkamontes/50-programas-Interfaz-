// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Contar los bits activados en un número en ARM64
// Asciinema: https://asciinema.org/a/690469

   .section .data
num: .word 0b10101100             // Número inicial en binario (172 en decimal)
msg_resultado: .asciz "Bits activados: %d\n"

.section .text
.global _start

_start:
    ldr x0, =num                  // Dirección del número
    ldr w0, [x0]                  // Cargar el número en w0
    mov w1, #0                    // Inicializar el contador de bits activados

count_bits:
    and w2, w0, #1                // Verificar si el bit menos significativo está activado
    add w1, w1, w2                // Incrementar el contador si el bit es 1
    lsr w0, w0, #1                // Desplazar el número a la derecha en 1 posición
    cbnz w0, count_bits           // Si quedan bits, repetir

    ldr x0, =msg_resultado        // Cargar el mensaje de resultado
    uxtw x1, w1                   // Extender w1 a x1 para printf
    bl printf                     // Llamar a printf

    mov x8, #93                   // Código de salida para syscall exit en ARM64
    mov x0, #0                    // Código de retorno 0
    svc #0                        // Llamada al sistema
