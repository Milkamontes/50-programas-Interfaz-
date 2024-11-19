// Autor: Milka Guadalupe Montes Domínguez 
// Fecha: 19-11-24 
// Descripción: Programa en ensamblador ARM64 que lee una entrada desde el teclado
// y la imprime en la salida estándar (pantalla).

.global _start

.section .bss
    buffer: .skip 128         // Reservar espacio para 128 bytes

.section .text
_start:
    // sys_read (syscall número 0)
    mov x0, 0                // File descriptor 0 (stdin)
    ldr x1, =buffer          // Dirección del buffer donde leer
    mov x2, 128              // Número máximo de bytes a leer
    mov x8, 0                // Número de syscall para read
    svc 0                    // Hacer la llamada al sistema

    // sys_write (syscall número 1)
    mov x0, 1                // File descriptor 1 (stdout)
    ldr x1, =buffer          // Dirección del buffer con los datos leídos
    mov x2, 128              // Número de bytes a escribir
    mov x8, 1                // Número de syscall para write
    svc 0                    // Hacer la llamada al sistema

    // sys_exit (syscall número 60)
    mov x0, 0                // Código de salida
    mov x8, 93               // Número de syscall para exit
    svc 0                    // Hacer la llamada al sistema
