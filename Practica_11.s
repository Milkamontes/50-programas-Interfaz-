// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Verificar si una cadena es un palíndromo en ARM64

    .section .data
cadena: .asciz "anilina"         // Cadena para verificar
msg_palindrome: .asciz "Es un palindromo\n"
msg_not_palindrome: .asciz "No es un palindromo\n"

    .section .text
    .global _start

_start:
    // Cargar la dirección de la cadena en x0
    ldr x0, =cadena              // x0 apunta al inicio de la cadena

    // Calcular la longitud de la cadena
    mov x1, #0                   // x1 actuará como contador de longitud

strlen_loop:
    ldrb w2, [x0, x1]            // Cargar el byte en la posición actual
    cbz w2, check_palindrome     // Si encontramos el fin de cadena (byte 0), saltamos a verificar
    add x1, x1, #1               // Incrementar el contador de longitud
    b strlen_loop                // Repetir el bucle

check_palindrome:
    // Inicializar punteros de inicio y fin
    sub x1, x1, #1               // Ajustar x1 para que apunte al último carácter válido
    mov x2, #0                   // Puntero al inicio de la cadena
    add x3, x0, x1               // x3 apunta al último carácter de la cadena

palindrome_loop:
    // Verificar si hemos cruzado los punteros
    cmp x2, x1                   // Comparar punteros de inicio y fin
    bge is_palindrome            // Si x2 >= x1, terminamos el bucle y es palíndromo

    // Comparar caracteres en los extremos
    ldrb w4, [x0, x2]            // Cargar el byte en el inicio (w4)
    ldrb w5, [x3]                // Cargar el byte en el fin (w5)
    cmp w4, w5                   // Comparar los bytes
    bne not_palindrome           // Si son diferentes, no es palíndromo

    // Mover los punteros hacia el centro
    add x2, x2, #1               // Avanzar el puntero de inicio
    sub x3, x3, #1               // Retroceder el puntero de fin
    b palindrome_loop            // Repetir el bucle

is_palindrome:
    // Preparación para imprimir "Es un palíndromo"
    ldr x0, =msg_palindrome      // Cargar mensaje de palíndromo
    mov x1, #1                   // Descriptor de archivo 1 (stdout)
    mov x2, #18                  // Longitud del mensaje
    mov x8, #64                  // syscall write
    svc #0                       // Llamada al sistema
    b end_program                // Saltar al final

not_palindrome:
    // Preparación para imprimir "No es un palíndromo"
    ldr x0, =msg_not_palindrome  // Cargar mensaje de no palíndromo
    mov x1, #1                   // Descriptor de archivo 1 (stdout)
    mov x2, #20                  // Longitud del mensaje
    mov x8, #64                  // syscall write
    svc #0                       // Llamada al sistema

end_program:
    // Salir del programa
    mov x8, #93                  // Código de salida para syscall exit en ARM64
    mov x0, #0                   // Código de retorno 0
    svc #0                       // Llamada al sistema
