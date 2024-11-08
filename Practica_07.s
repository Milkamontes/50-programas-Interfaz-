// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Cálculo del factorial de un número en ARM64

    .section .data
result_msg: .asciz "El factorial es: "    // Mensaje fijo para el resultado
newline: .asciz "\n"                      // Salto de línea

    .section .bss
buffer: .space 20                         // Buffer para almacenar el resultado como texto

    .section .text
    .global _start

_start:
    // Definimos el valor de N (el número al que queremos calcular el factorial)
    mov x0, #5              // N = 5 (por ejemplo, queremos calcular 5!)

    // Inicializamos los registros
    mov x1, x0              // Guardamos el valor de N en x1 para imprimirlo después
    mov x2, #1              // x2 será el acumulador para el factorial, iniciamos en 1
    mov x3, #1              // x3 será el contador, comenzando en 1

factorial_loop:
    // Verificamos si el contador ha llegado a N
    cmp x3, x0              // Comparamos x3 (contador) con x0 (N)
    bgt end_factorial       // Si x3 > N, salimos del bucle

    // Multiplicamos el acumulador por el contador
    mul x2, x2, x3          // x2 = x2 * x3, actualizamos el acumulador

    // Incrementamos el contador
    add x3, x3, #1          // x3 = x3 + 1

    // Repetimos el bucle
    b factorial_loop

end_factorial:
    // Mostrar el mensaje fijo
    ldr x0, =result_msg     // Mensaje de "El factorial es: "
    mov x1, #1              // Descriptor de archivo 1 (stdout)
    mov x2, #17             // Longitud del mensaje
    mov x8, #64             // syscall write
    svc #0                  // Llamada al sistema

    // Convertir el resultado (en x2) a una cadena para mostrar
    mov x0, x2              // Movemos el factorial a x0 para convertirlo
    bl int_to_string        // Llamada a la función para convertir el entero a cadena

    // Mostrar el resultado en cadena
    ldr x0, =buffer         // Cargar el buffer con el resultado como cadena
    mov x1, #1              // Descriptor de archivo 1 (stdout)
    mov x2, #20             // Longitud máxima del buffer
    mov x8, #64             // syscall write
    svc #0                  // Llamada al sistema

    // Salto de línea
    ldr x0, =newline        // Cargar el salto de línea
    mov x1, #1              // Descriptor de archivo 1 (stdout)
    mov x2, #1              // Longitud del salto de línea
    mov x8, #64             // syscall write
    svc #0                  // Llamada al sistema

    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema

// Subrutina: int_to_string
// Convierte el entero en x0 a una cadena en el buffer
int_to_string:
    mov x1, #10             // Divisor para obtener dígitos en base 10
    ldr x2, =buffer + 19    // Puntero al final del buffer
    mov w3, #0x30           // Offset para convertir dígito a ASCII

convert_loop:
    udiv x4, x0, x1         // Divide x0 entre 10
    msub x5, x4, x1, x0     // Calcula el residuo (x0 % 10)
    add x5, x5, w3          // Convierte el residuo a ASCII
    strb w5, [x2, #-1]!     // Almacena el carácter en el buffer (al revés)
    mov x0, x4              // Actualiza x0 con el cociente
    cbz x0, end_convert     // Si x0 es 0, terminamos
    b convert_loop          // Repetimos el bucle

end_convert:
    mov x0, x2              // Devolvemos el puntero al inicio de la cadena
    ret
