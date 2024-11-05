// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Invertir una cadena de texto en ARM64

    .section .data
original_str: .asciz "Hola, mundo!"      // Cadena original
msg_result: .asciz "Cadena invertida: %s\n"

    .section .text
    .global _start

_start:
    // Cargar la dirección de la cadena en x0
    ldr x0, =original_str                // x0 apunta al inicio de la cadena
    mov x1, x0                           // Guardamos el inicio de la cadena en x1 para imprimir después

    // Calcular la longitud de la cadena
    mov x2, #0                           // x2 actuará como contador de longitud

strlen_loop:
    ldrb w3, [x0, x2]                    // Cargar el byte en la posición actual
    cbz w3, reverse_string               // Si encontramos el fin de cadena (byte 0), saltamos a invertir
    add x2, x2, #1                       // Incrementar el contador de longitud
    b strlen_loop                        // Repetir el bucle

reverse_string:
    // Inicializar punteros de inicio y fin
    sub x2, x2, #1                       // x2 apunta al último índice de la cadena
    add x3, x1, x2                       // x3 apunta al final de la cadena

reverse_loop:
    // Verificar si hemos cruzado los punteros
    cmp x1, x3                           // Comparar punteros de inicio y fin
    bge print_result                     // Si x1 >= x3, terminamos la inversión

    // Intercambiar caracteres
    ldrb w4, [x1]                        // Cargar el byte en x1 (inicio)
    ldrb w5, [x3]                        // Cargar el byte en x3 (fin)
    strb w5, [x1]                        // Guardar el byte en x1 (inicio)
    strb w4, [x3]                        // Guardar el byte en x3 (fin)

    // Mover los punteros hacia el centro
    add x1, x1, #1                       // Avanzar el puntero de inicio
    sub x3, x3, #1                       // Retroceder el puntero de fin
    b reverse_loop                       // Repetir el bucle

print_result:
    // Preparación para imprimir la cadena invertida
    ldr x0, =msg_result                  // Mensaje de resultado
    ldr x1, =original_str                // Cadena invertida
    bl printf                            // Llamamos a printf para mostrar la cadena

    // Salir del programa
    mov x8, #93                          // Código de salida para syscall exit en ARM64
    mov x0, #0                           // Código de retorno 0
    svc #0                               // Llamada al sistema
