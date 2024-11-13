// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 05-11-2024
// Descripción: Cálculo del factorial de un número en ARM64. El programa calcula el factorial de un número entero positivo
// utilizando un bucle para realizar la multiplicación acumulativa. El resultado se imprime en pantalla.

    .section .data
result_msg: .asciz "El factorial es: "    // Mensaje fijo para el resultado
newline: .asciz "\n"                      // Salto de línea

    .section .bss
buffer: .space 20                         // Buffer para almacenar el resultado como texto

    .section .text
    .global _start

_start:
    // Definimos el valor de N para calcular su factorial
    mov x0, #5              // N = 5 (por ejemplo, queremos calcular 5!)
    
    // Inicializamos los registros
    mov x1, x0              // Guardamos el valor original de N en x1 para su uso posterior
    mov x2, #1              // x2 será el acumulador para el factorial, inicializado en 1
    mov x3, #1              // x3 será el contador para el bucle, iniciando en 1

factorial_loop:
    cmp x3, x0              // Comparar contador con N
    bgt end_factorial       // Si x3 > N, terminamos el bucle

    mul x2, x2, x3          // Acumulador = acumulador * contador (x2 = x2 * x3)
    add x3, x3, #1          // Incrementamos el contador en 1 (x3 = x3 + 1)
    b factorial_loop        // Repetimos el bucle

end_factorial:
    // Mostrar el mensaje fijo "El factorial es: "
    adr x0, result_msg      // Cargar la dirección del mensaje en x0
    mov x1, #1              // Descriptor de archivo 1 (stdout)
    mov x2, #17             // Longitud del mensaje
    mov x8, #64             // syscall write
    svc #0                  // Llamada al sistema para mostrar el mensaje

    // Convertir el resultado en x2 a una cadena en el buffer para mostrarlo
    mov x0, x2              // Movemos el valor del factorial a x0 para la conversión
    bl int_to_string        // Llamada a la subrutina para convertir el entero a cadena

    // Mostrar el resultado convertido en cadena
    mov x1, x0              // Puntero al inicio de la cadena en x1
    mov x2, #20             // Longitud máxima del buffer
    mov x8, #64             // syscall write
    svc #0                  // Llamada al sistema para mostrar el factorial

    // Salto de línea
    adr x0, newline         // Cargar el salto de línea
    mov x1, #1              // Descriptor de archivo 1 (stdout)
    mov x2, #1              // Longitud del salto de línea
    mov x8, #64             // syscall write
    svc #0                  // Llamada al sistema para nueva línea

    // Salir del programa
    mov x8, #93             // Código de salida para syscall exit en ARM64
    mov x0, #0              // Código de retorno 0
    svc #0                  // Llamada al sistema para salir

// Subrutina: int_to_string
// Convierte el entero en x0 a una cadena en el buffer para su impresión
int_to_string:
    mov x1, #10             // Divisor para obtener dígitos en base 10
    ldr x2, =buffer + 19    // Apunta al final del buffer para llenar la cadena de atrás hacia adelante
    mov x3, #0x30           // Offset para convertir número a ASCII

convert_loop:
    udiv x4, x0, x1         // Divide x0 entre 10 y coloca el cociente en x4
    msub x5, x4, x1, x0     // Calcula el residuo (x0 % 10) y lo guarda en x5
    add x5, x5, x3          // Convierte el residuo a su valor ASCII
    strb w5, [x2, #-1]!     // Almacena el carácter en el buffer, avanzando hacia atrás
    mov x0, x4              // Actualiza x0 con el cociente
    cbz x0, end_convert     // Si x0 es 0, terminamos
    b convert_loop          // Repetimos el bucle hasta que x0 sea 0

end_convert:
    mov x0, x2              // Devuelve el puntero al inicio de la cadena
    ret                     // Regresa a la función principal
