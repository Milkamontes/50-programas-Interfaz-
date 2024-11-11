// Autor: Milka Guadalupe Montes Domínguez
// Fecha: 10-11-24
// Descripción: Encontrar el valor máximo en un arreglo y mostrarlo en ARM64

.section .data
arreglo: .word 10, 25, 3, 48, 5, 30      // Arreglo de números enteros
tamano: .word 6                          // Tamaño del arreglo
msg_resultado: .asciz "El valor máximo es: "  // Mensaje para imprimir
newline: .asciz "\n"                      // Nueva línea

.section .bss
buffer: .space 12                         // Espacio para el valor máximo convertido a texto

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo
    ldr x1, =tamano            // Dirección del tamaño
    ldr w1, [x1]               // Cargar el tamaño en w1 (número de elementos)
    
    // Cargar la dirección del arreglo
    ldr x2, =arreglo           // x2 apunta al inicio del arreglo

    // Inicializar el valor máximo con el primer elemento
    ldr w0, [x2]               // Cargar el primer elemento en w0 (valor máximo actual)
    add x3, x2, #4             // x3 apunta al segundo elemento (4 bytes por elemento)
    sub w1, w1, #1             // Decrementar el tamaño ya que tomamos el primer elemento

max_loop:
    // Verificar si hemos terminado de recorrer el arreglo
    cbz w1, print_resultado    // Si w1 es 0, terminamos el bucle

    // Cargar el siguiente elemento en el arreglo
    ldr w4, [x3]               // Cargar el valor actual en w4

    // Comparar el valor actual con el máximo
    cmp w4, w0                 // Comparar w4 (elemento actual) con w0 (máximo actual)
    ble skip_update            // Si w4 <= w0, saltar la actualización

    // Actualizar el valor máximo
    mov w0, w4                 // w0 toma el nuevo valor máximo

skip_update:
    // Avanzar al siguiente elemento
    add x3, x3, #4             // Avanzar al siguiente elemento (4 bytes)
    sub w1, w1, #1             // Decrementar el contador de elementos
    b max_loop                 // Repetir el bucle

print_resultado:
    // Preparación para imprimir el resultado

    // Imprimir el mensaje
    ldr x0, =msg_resultado     // Dirección del mensaje en x0
    mov x1, x0                 // Poner mensaje en x1
    mov x2, #20                // Tamaño estimado del mensaje
    mov x8, #64                // syscall: write
    svc #0                     // Llamada al sistema para imprimir el mensaje

    // Convertir el valor máximo en una cadena
    mov x0, w0                 // Valor máximo en x0
    ldr x1, =buffer            // Dirección del buffer donde se guardará el texto
    bl int_to_string           // Llamada a la subrutina de conversión

    // Imprimir el valor máximo convertido
    ldr x0, =buffer            // Dirección del buffer que contiene el valor máximo en texto
    mov x1, x0                 // Poner buffer en x1
    mov x2, #12                // Tamaño máximo del buffer
    mov x8, #64                // syscall: write
    svc #0                     // Llamada al sistema para imprimir el valor máximo

    // Imprimir nueva línea
    ldr x0, =newline           // Dirección del salto de línea en x0
    mov x1, x0                 // Poner newline en x1
    mov x2, #1                 // Tamaño del newline
    mov x8, #64                // syscall: write
    svc #0                     // Llamada al sistema para imprimir newline

    // Salir del programa
    mov x8, #93                // syscall: exit
    mov x0, #0                 // Código de retorno 0
    svc #0                     // Llamada al sistema

// Subrutina para convertir un número entero a una cadena en buffer
int_to_string:
    mov x2, #10                // Divisor para obtener dígitos decimales
    add x1, x1, #11            // Mover al final del buffer
    mov w3, #0                 // Contador de caracteres

convert_loop:
    udiv x4, x0, x2            // x4 = x0 / 10 (cociente)
    msub x5, x4, x2, x0        // x5 = x0 - (x4 * 10), obtiene el dígito menos significativo
    add x5, x5, #'0'           // Convertir dígito a ASCII
    sub x1, x1, #1             // Mover hacia atrás en el buffer
    strb w5, [x1]              // Almacenar el carácter ASCII en el buffer
    mov x0, x4                 // Actualizar x0 con el cociente
    add w3, w3, #1             // Incrementar contador de caracteres
    cbnz x0, convert_loop      // Si el cociente no es cero, continuar

    // Ajustar x1 para que apunte al inicio del número en el buffer
    ret
