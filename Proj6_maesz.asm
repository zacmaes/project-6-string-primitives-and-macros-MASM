TITLE Project Six: Dolby Uses String Primitives & Macros     (Proj6_maesz.asm)

; Author: Zachary Maes
; Last Modified: August 12, 2022
; OSU email address: maesz@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: August 12, 2022
; Description: Two macros (mGetString and mDisplayString) are implemented first and then tested inside main. These macros use ReadString to get input from 
;		the user and Writestring to display the saved user inputted data. These macros are invoked within two procedures called ReadVal and WriteVal.
;		ReadVal converts the ASCII digit string data gathered by the mGetString macro to its SDWORD numeric value representation, validates that the data 
;       has no letters or symbols (only numbers) and then stores/returns the value in a memory variable. WriteVal serves to convert the numeric SDWORD value 
;		from ReadVal back to an ASCII digit string, and then print it by invoking the mDisplayString macro. Finally, test program exists within the main 
;		procedure that loops through ReadVal 10 times to collect 10 valid integer strings and store within an array. WriteVal will be used afterwards to
;		display the integers, and the test code will also display the sum and a trucated average (only integer, no decimal). 

;		Notes from Canvas:
;			-only non number ASCII chars allowed are ones that indicate sign (+ / -), everything else mus be a number
;			-ReadInt, ReadDec, WriteInt, WriteDec are NOT allowed.
;			-Conversion routines must LODSB and/or STOSB to handle strings
;			-STDCall parameter stack passing required
;			-Prompt strings must be passed by reference to macros (don't define the string within the macro i'm assuming)
;			-Don't forget to clean the stack frame with ret [num]
;			-MUST USE:
;				-register indirect addressing for integer SDWORD array elements.
;				-base+offest addressing for accessing parameters on the stack.
;			-procs may use local variables (read about these) and constants by name, but NOT data segment variables

;		OTHER NOTES:
;			-assume that the total sum of the valid ints will fit inside a 32 bit register
;			-testing with positive and negative values
;			-truncate (drop the decimal value) of the calculated average


INCLUDE Irvine32.inc

; (insert macro definitions here)
; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Displays the prompt input parameter to the user and collects their keyboard input into
;	a location in memory (the output). 
;
; Preconditions:
;
; Receives:
;
;
; returns: 
; ---------------------------------------------------------------------------------
;mGetString MACRO prompt



; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Description:
;
; Preconditions: 
;
; Receives:
;
;
; returns: 
; ---------------------------------------------------------------------------------
;mDisplayString MACRO prompt

; (insert constant definitions here)

.data
; (insert variable definitions here)
introduction_1		 BYTE "Project Six: Dolby Uses String Primitives & Macros :)",0
introduction_2		 BYTE "Written By: Zachary Maes		Starring: D.O.L.B.Y. Digit Only Looping Bot Yielder",0

instruction_0		 BYTE "Dolby kindly greets master and requests that they please read the instructions carefully.",0
instruction_1		 BYTE "Dolby would like master to please input 10 different signed decimal values into the terminal formatted with one or more of the following options:",0
instruction_2		 BYTE "		| 156 | +45 | -760 | 0 |",0
instruction_3		 BYTE "Dolby requires that each number must fit within a 32 bit register (Dolby begs master to not make them too large!)",0
instruction_4		 BYTE "Invalid inputs will not be excepted by Dolby and master will kindly need to try again after the error message.",0
instruction_5		 BYTE "The only non number ASCII characters accepted by Dolby will be the (+) or (-) symbols.",0
instruction_6		 BYTE "After input, Dolby, with masters permission, will use magic to display values like a list of your inputs, their sum, and their mean value (truncated).",0

user_prompt_1		 BYTE "Dolby asks master to please enter one of master's chosen signed numbers: ",0
user_error_message	 BYTE "ERROR: Dolby does not mean to yell at master, but master has entered the wrong value! Only signed numbers please!",0
user_error_prompt	 BYTE "It's okay, Dolby believes that master CAN and WILL find success! Try again: ",0

display_message_1	 BYTE "Great care was taken by Dolby to provide master with these sensitive values.",0 
display_message_2    BYTE "Dolby takes great pleasure in serving master! Dolby appreciates master for not striking him with the Nimbus 3000",0
list_display_message BYTE "Master's valid entered numbers are listed by Dolby below!",0
sum_message			 BYTE "The sum of all values is: ",0
mean_message		 BYTE "The mean of all values (yes it is truncated!) is: ",0

farewell_message	 BYTE "Dolby is finally free! Master has blessed Dolby with the most generous of gifts ... an old shirt from goodwill!",0


.code
main PROC
; (insert executable instructions here)

; PROGRAM INTRODUCTION
	PUSH OFFSET introduction_1
	PUSH OFFSET introduction_2
	PUSH OFFSET instruction_0
	PUSH OFFSET instruction_1
	PUSH OFFSET instruction_2
	PUSH OFFSET instruction_3
	PUSH OFFSET instruction_4
	PUSH OFFSET instruction_5
	PUSH OFFSET instruction_6
	Call Introduction

; ReadVal Procedure.....lloop it
	;PUSH OFFSET user_prompt_1
	;PUSH OFFSET user_error_message
	;PUSH OFFSET user_error_prompt
	;Call ReadVal

; WriteVal
	;Call WriteVal


; FAREWELL
MOV EDX, OFFSET farewell_message
CALL CrLf
CALL WriteString
CALL CrLf


; Write a test program in main which uses the ReadVal and WriteVal procedures

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

; ---------------------------------------------------------------------------------
; Name: Introduction
;
; Introduces the program and instructions to the user.
;
; Preconditions: Preconditions are conditions that need to be true for the
;     procedure to work, like the type of the input provided or the state a
;     certain register need to be in.
;
; Postconditions: Postconditions are any changes the procedure makes that are not
;     part of the returns. If any registers are changed and not restored, they
;     should be described here.
;
; Receives: 
;		[EBP+8]  = OFFSET instruction_6
;		[EBP+12] = OFFSET instruction_5
;		[EBP+16] = OFFSET instruction_4
;		[EBP+20] = OFFSET instruction_3
;		[EBP+24] = OFFSET instruction_2
;		[EBP+28] = OFFSET instruction_1
;		[EBP+32] = OFFSET instruction_0
;		[EBP+36] = OFFSET introduction_2
;		[EBP+40] = OFFSET introduction_1
;
; Returns: Returns is the output of the procedure. Because assembly procedures don’t
;     return data like high-level languages, returns should describe all the data
;     the procedure intended to change. Parameters and global variables that the
;     procedure altered should be described here. Registers should only be mentioned
;     if you are trying to pass data back in them.
; ---------------------------------------------------------------------------------
Introduction PROC
	PUSH EBP					; Base Pointer	
	MOV  EBP, ESP	
	PUSHAD						; Preserve all registers

	MOV ECX, 9					; set loop counter
	MOV EBX, 40					; set base offset

	_introLoop:
		MOV EDX, [EBP+EBX]
		CALL WriteString
		CALL CrLf
		CALL CrLf
		SUB EBX, 4
		LOOP _introLoop

	POPAD   
	POP EBP
	RET	36
Introduction ENDP

; ---------------------------------------------------------------------------------
; Name: ReadVal
;
; The description of the procedure should be like a section comment, summarizing
;     the overall goal of the blocks of code within the procedure.
;
; Preconditions: Preconditions are conditions that need to be true for the
;     procedure to work, like the type of the input provided or the state a
;     certain register need to be in.
;
; Postconditions: Postconditions are any changes the procedure makes that are not
;     part of the returns. If any registers are changed and not restored, they
;     should be described here.
;
; Receives: Receives is like the input of a procedure; it describes everything
;     the procedure is given to work. Parameters, registers, and global variables
;     the procedure takes as inputs should be described here.
;
; Returns: Returns is the output of the procedure. Because assembly procedures don’t
;     return data like high-level languages, returns should describe all the data
;     the procedure intended to change. Parameters and global variables that the
;     procedure altered should be described here. Registers should only be mentioned
;     if you are trying to pass data back in them.
; ---------------------------------------------------------------------------------
ReadVal PROC

RET
ReadVal ENDP




; ---------------------------------------------------------------------------------
; Name: WriteVal
;
; The description of the procedure should be like a section comment, summarizing
;     the overall goal of the blocks of code within the procedure.
;
; Preconditions: Preconditions are conditions that need to be true for the
;     procedure to work, like the type of the input provided or the state a
;     certain register need to be in.
;
; Postconditions: Postconditions are any changes the procedure makes that are not
;     part of the returns. If any registers are changed and not restored, they
;     should be described here.
;
; Receives: Receives is like the input of a procedure; it describes everything
;     the procedure is given to work. Parameters, registers, and global variables
;     the procedure takes as inputs should be described here.
;
; Returns: Returns is the output of the procedure. Because assembly procedures don’t
;     return data like high-level languages, returns should describe all the data
;     the procedure intended to change. Parameters and global variables that the
;     procedure altered should be described here. Registers should only be mentioned
;     if you are trying to pass data back in them.
; ---------------------------------------------------------------------------------
WriteVal PROC

RET
WriteVal ENDP

END main 
