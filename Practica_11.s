// ================================
// Programa: Verificación de palíndromo en ARM64
// Descripción: Este programa verifica si una cadena es un palíndromo.
// Autor: Milka Guadalupe Montes Dominguez 
// Fecha: 11-11-24
// https://asciinema.org/a/688917
// ================================

.section .data
cadena: .asciz "anilina"              // La cadena a verificar
resultado_palindromo: .asciz "Es un palíndromo\n"
resultado_no_palindromo: .asciz "No es un palíndromo\n"

.section .text
.global _start

_start:
    // Cargar la dirección de la cadena en x0
    ldr x0, =cadena
    
    // Inicializar punteros para inicio y fin de la cadena
    mov x1, x0                 // x1 apunta al inicio
    mov x2, x0                 // x2 también apunta al inicio, lo moveremos al final

buscar_fin:
    ldrb w3, [x2], #1          // Leer un byte y avanzar
    cmp w3, #0                 // Verificar si es el final de la cadena
    b.ne buscar_fin            // Si no es el final, seguir avanzando
    sub x2, x2, #2             // Retroceder para apuntar al último carácter válido

comparar:
    ldrb w4, [x1], #1          // Leer carácter desde el inicio
    ldrb w5, [x2], #-1         // Leer carácter desde el final
    cmp w4, w5                 // Comparar caracteres
    b.ne no_palindromo         // Si no son iguales, no es un palíndromo
    cmp x1, x2                 // Verificar si los punteros se cruzaron o tocaron
    b.lt comparar              // Si no se cruzaron, continuar comparando

    // Si llega aquí, es un palíndromo
    ldr x0, =resultado_palindromo
    bl imprimir
    b fin_programa

no_palindromo:
    // Si llega aquí, no es un palíndromo
    ldr x0, =resultado_no_palindromo
    bl imprimir

fin_programa:
    mov x8, #93                // syscall: exit
    mov x0, #0                 // Estado de salida 0
    svc #0                     // Llamada al sistema

imprimir:
    // Imprimir una cadena usando write (syscall número 64 en ARM64)
    mov x1, x0                 // x1 = dirección de la cadena
    mov x2, #20                // Tamaño máximo a imprimir
    mov x8, #64                // syscall: write
    mov x0, #1                 // 1 = salida estándar (stdout)
    svc #0                     // Llamada al sistema
    ret
