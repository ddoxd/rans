; --- Interactive Windows Console Program (MASM Syntax) ---
; Description: Prompts user for input and echoes it back.
; To Assemble/Link (using Visual Studio Command Prompt - Adjust ml/ml64 as needed):
;   ml64 /c /Fo"console_io.obj" /W3 /Zi console_io.asm
;   link /SUBSYSTEM:CONSOLE /ENTRY:main /OUT:"console_io.exe" console_io.obj kernel32.lib user32.lib
; --------------------------------------------------------------------

.MODEL FLAT, STDCALL
.STACK 4096

; --- Declare Windows API Functions ---
ExitProcess PROTO, dwExitCode:DWORD
GetStdHandle PROTO, nStdHandle:DWORD           ; Gets input/output handles
WriteConsoleA PROTO, hConsoleOutput:HANDLE, lpBuffer:PTR BYTE, nNumberOfCharsToWrite:DWORD, lpNumberOfCharsWritten:PTR DWORD, lpReserved:DWORD ; Writes to console
ReadConsoleA PROTO, hConsoleInput:HANDLE, lpBuffer:PTR BYTE, nNumberOfCharsToRead:DWORD, lpNumberOfCharsRead:PTR DWORD, pInputControl:DWORD     ; Reads from console

; --- Constants for GetStdHandle ---
STD_INPUT_HANDLE  EQU -10
STD_OUTPUT_HANDLE EQU -11

; --- Data Section ---
.DATA
    hConsoleInput HANDLE ?        ; Variable to store the input handle
    hConsoleOutput HANDLE ?       ; Variable to store the output handle

    promptMsg   BYTE "Enter text: ", 0      ; Prompt message (null terminator optional for WriteConsoleA if length is known, but good practice)
    promptMsgLen EQU $ - promptMsg - 1      ; Calculate length excluding null

    resultMsg   BYTE "You entered: ", 0
    resultMsgLen EQU $ - resultMsg - 1

    inputBuffer BYTE 100 DUP(?)   ; Reserve 100 bytes for user input
    INPUT_BUFFER_SIZE EQU SIZEOF inputBuffer

    charsRead   DWORD ?           ; Variable to store the number of characters read by ReadConsoleA
    charsWritten DWORD ?          ; Variable to store the number of characters written by WriteConsoleA

; --- Code Section ---
.CODE
main PROC
    ; --- Get Console Handles ---
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE  ; Get the standard output handle
    MOV hConsoleOutput, EAX                 ; Store the handle (returned in EAX)

    INVOKE GetStdHandle, STD_INPUT_HANDLE   ; Get the standard input handle
    MOV hConsoleInput, EAX                  ; Store the handle

    ; --- Display Prompt Message ---
    INVOKE WriteConsoleA, \
           hConsoleOutput,          ; Handle to write to
           ADDR promptMsg,          ; Pointer to the message buffer
           promptMsgLen,            ; Number of characters to write
           ADDR charsWritten,       ; Pointer to variable to receive chars written count
           NULL                     ; Reserved, must be NULL

    ; --- Read User Input ---
    INVOKE ReadConsoleA, \
           hConsoleInput,           ; Handle to read from
           ADDR inputBuffer,        ; Pointer to buffer to receive input
           INPUT_BUFFER_SIZE,       ; Maximum number of characters to read into buffer
           ADDR charsRead,          ; Pointer to variable to receive chars read count
           NULL                     ; Reserved (must be NULL for ASCII ReadConsoleA)

    ; Note: ReadConsoleA typically reads the Enter key (\r\n) into the buffer as well.
    ; charsRead will include these. For simplicity, we'll print them too.

    ; --- Display Result Message ---
    INVOKE WriteConsoleA, \
           hConsoleOutput,          ; Handle to write to
           ADDR resultMsg,          ; Pointer to the message buffer
           resultMsgLen,            ; Number of characters to write
           ADDR charsWritten,       ; Pointer to variable to receive chars written count
           NULL                     ; Reserved

    ; --- Display User's Input ---
    ; We use the 'charsRead' value returned by ReadConsoleA to know how much to print
    INVOKE WriteConsoleA, \
           hConsoleOutput,          ; Handle to write to
           ADDR inputBuffer,        ; Pointer to the buffer containing user input
           charsRead,               ; Number of characters that were actually read
           ADDR charsWritten,       ; Pointer to variable to receive chars written count
           NULL                     ; Reserved

    ; --- Exit Program ---
    INVOKE ExitProcess, 0           ; Exit with code 0 (success)

main ENDP
END main
