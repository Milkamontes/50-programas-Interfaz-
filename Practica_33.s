// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripci; ón: Este programa calcula la suma de los elementos en un arreglo. 
// Ascinnema: https://asciinema.org/a/690658

.global _start

.section .data
arr:    .quad 1, 2, 3, 4, 5        // Definir un arreglo de 5 elementos (de tipo long, 64 bits)
arr_len: .quad 5                   // Longitud del arreglo
out_msg: .asciz "La suma es: "      // Mensaje a imprimir antes de la suma

.section .bss
buffer: .skip 16                   // Reservar espacio para el número sumado (hasta 16 bytes)

.section .text
_start:
    // Inicializar registros
    mov x0, 0                      // x0 es la variable acumuladora (suma = 0)
    ldr x1, =arr                   // Cargar la dirección base del arreglo en x1
    ldr x2, =arr_len               // Cargar la longitud del arreglo en x2
    ldr x2, [x2]                   // Desreferenciar para obtener el valor (longitud real)

sum_loop:
    cmp x2, 0                       // Verificar si hemos recorrido todos los elementos
    beq print_result                // Si x2 == 0, terminar el ciclo

    ldr x3, [x1], 8                 // Cargar el siguiente elemento del arreglo (cada elemento es de 8 bytes) y avanzar el puntero
    add x0, x0, x3                  // Acumular el valor en x0

    sub x2, x2, 1                   // Decrementar el contador (longitud del arreglo)
    b sum_loop                      // Volver al inicio del ciclo

print_result:
    // Imprimir mensaje "La suma es: "
    ldr x1, =out_msg                // Cargar la dirección del mensaje
    mov x2, 12                      // Longitud del mensaje
    mov x8, 64                      // Número de sistema para write
    mov x0, 1                       // File descriptor 1 (stdout)
    svc 0                            // Llamada al sistema para imprimir el mensaje

    // Convertir la suma a cadena y almacenarla en el buffer
    mov x1, x0                      // Mover la suma a x1
    ldr x2, =buffer                 // Dirección del buffer
    bl int_to_str                   // Llamada a la función para convertir entero a cadena

    // Imprimir la suma
    mov x8, 64                      // Llamada al sistema para write
    mov x0, 1                       // File descriptor 1 (stdout)
    mov x2, 16                      // Longitud máxima del buffer
    svc 0                            // Llamada al sistema para imprimir el número

    // Terminar el programa
    mov x8, 93                      // Número de sistema para salir (exit)
    mov x0, 0                       // Código de salida
    svc 0                            // Llamada al sistema
     
// Función para convertir un número entero a cadena (decimal)
int_to_str:
    mov x3, 10                      // Divisor (base 10)
    mov x4, x2                      // Dirección de memoria del buffer
    add x4, x4, 15                  // Apuntar al final del buffer (espacio para 16 caracteres)
    strb wzr, [x4]                  // Almacenar el valor 0 (terminador nulo) en el final del buffer

reverse_loop:
    sub x4, x4, 1                   // Retroceder una posición en el buffer
    udiv x5, x1, x3                 // Dividir x1 entre 10 (cociente en x5)
    msub x6, x5, x3, x1             // x6 = x1 % 10 (resto de la división)
    add x6, x6, '0'                 // Convertir el dígito a su valor ASCII
    strb w6, [x4]                   // Guardar el dígito en el buffer
    mov x1, x5                      // Actualizar x1 con el cociente
    cmp x1, 0                       // Verificar si hemos procesado todos los dígitos
    bne reverse_loop                // Si no, continuar el ciclo

    mov x2, x4                      // x2 es la dirección del inicio del número
    ret
