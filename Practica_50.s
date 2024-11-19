// Autor: Milka Guadalupe Montes Domínguez 
// Fecha: 19-11-24 
// Descripción: Programa en ensamblador ARM64 que lee una entrada desde el teclado
// y la escribe en un archivo.

.global _start

.section .bss
    buffer: .skip 128         // Reservar espacio para 128 bytes

.section .data
    filename: .asciz "output.txt"  // Nombre del archivo de salida

.section .text
_start:
    // sys_read (syscall número 0) para leer desde stdin
    mov x0, 0                // File descriptor 0 (stdin)
    ldr x1, =buffer          // Dirección del buffer donde leer
    mov x2, 128              // Número máximo de bytes a leer
    mov x8, 0                // Número de syscall para read
    svc 0                    // Hacer la llamada al sistema

    // sys_open (syscall número 56) para abrir el archivo en modo escritura
    ldr x0, =filename        // Dirección del nombre del archivo
    mov x1, 0101             // O_RDWR (Lectura y escritura)
    mov x2, 0644             // Permisos del archivo (rw-r--r--)
    mov x8, 56               // Número de syscall para open
    svc 0                    // Hacer la llamada al sistema
    mov x19, x0              // Guardar el file descriptor en x19

    // sys_write (syscall número 1) para escribir en el archivo
    mov x0, x19              // File descriptor del archivo
    ldr x1, =buffer          // Dirección del buffer con los datos leídos
    mov x2, 128              // Número de bytes a escribir
    mov x8, 1                // Número de syscall para write
    svc 0                    // Hacer la llamada al sistema

    // sys_close (syscall número 57) para cerrar el archivo
    mov x0, x19              // File descriptor del archivo
    mov x8, 57               // Número de syscall para close
    svc 0                    // Hacer la llamada al sistema

    // sys_exit (syscall número 60) para finalizar el programa
    mov x0, 0                // Código de salida
    mov x8, 93               // Número de syscall para exit
    svc 0                    // Hacer la llamada al sistema
