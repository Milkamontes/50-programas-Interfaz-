// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Este programa calcula el Mínimo Común Múltiplo (MCM) de dos números


.data
    msg_num1: .asciz "Ingrese el primer número: "
    msg_num2: .asciz "Ingrese el segundo número: "
    formato_in: .asciz "%ld"
    msg_resultado: .asciz "El MCM de %ld y %ld es: %ld\n"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Pedir primer número al usuario
    adrp x0, msg_num1
    add x0, x0, :lo12:msg_num1
    bl printf

    // Leer primer número
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar primer número
    ldr x19, [sp]
    add sp, sp, #16

    // Pedir segundo número al usuario
    adrp x0, msg_num2
    add x0, x0, :lo12:msg_num2
    bl printf

    // Leer segundo número
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf

    // Guardar segundo número
    ldr x20, [sp]
    add sp, sp, #16

    // Calcular MCM
    mov x0, x19
    mov x1, x20
    bl mcm

    // Guardar resultado
    mov x21, x0

    // Imprimir resultado
    adrp x0, msg_resultado
    add x0, x0, :lo12:msg_resultado
    mov x1, x19
    mov x2, x20
    mov x3, x21
    bl printf

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// Función para calcular el MCM
mcm:
    // x0: primer número (a)
    // x1: segundo número (b)
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Guardar a y b
    mov x19, x0
    mov x20, x1

    // Calcular MCD
    bl mcd

    // Guardar MCD en x21
    mov x21, x0

    // Calcular |a * b|
    mul x22, x19, x20
    cmp x22, #0
    cneg x22, x22, mi  // Si es negativo, lo convertimos a positivo

    // Calcular MCM = |a * b| / MCD
    udiv x0, x22, x21

    ldp x29, x30, [sp], #16
    ret

// Función para calcular el MCD usando el algoritmo de Euclides
mcd:
    // x0: primer número (a)
    // x1: segundo número (b)
loop_mcd:
    cbz x1, end_mcd   // Si b == 0, terminar
    udiv x2, x0, x1   // x2 = a / b
    msub x2, x2, x1, x0  // x2 = a - (a / b) * b (es decir, a % b)
    mov x0, x1        // a = b
    mov x1, x2        // b = a % b
    b loop_mcd

end_mcd:
    // El MCD está en x0
    ret
    cbnz x2, itoa_loop
    ret
