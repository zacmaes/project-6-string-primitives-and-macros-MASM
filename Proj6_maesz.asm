TITLE Project Six: Using String Primitives & Macros     (Proj6_maesz.asm)

; Author: Zachary Maes
; Last Modified: August 13, 2022
; OSU email address: maesz@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6        Due Date: August 12, 2022
; Description: 
;			Very challanging assignment! Really fun to dive deep into the content though!
;			
;			Two macros (mGetString and mDisplayString) are implemented first and then tested inside main. These macros use ReadString to get input from 
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

;		"THE ONLY GOOD BUG IS A DEAD BUG!" 
;			-A2070: invalid instruction operands		
;			-A2081:	missing operand after unary operator
;			-A2009syntax error in expression
;			-A2032: invalid use of register
;			
;			
;			
;			
;			
;			
;			


INCLUDE Irvine32.inc
; (insert macro definitions here)
; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Displays the prompt input parameter to the user and collects their keyboard input into
;	a location in memory (the output). 
;
; Preconditions: prompt, emptyStr, and counter values must be established variables
;		within .data section and passed to this macro.
;
; Receives:
;		FOR READSTRING:
;		-address of buffer from stack
;		-sizeof buffer from stack
;
;
; returns: counter number of read strings, user inputted string (emptyString)
; ---------------------------------------------------------------------------------
mGetString MACRO prompt, emptyStr, counter	
	PUSH EDX
	PUSH ECX
	PUSH EAX

	MOV EDX, prompt
	CALL WriteString

	MOV EDX, emptyStr			; point to buffer
	MOV ECX, SIZEOF emptyStr	; specify max characters
	CALL ReadString				; input the string
	MOV counter, EAX			; number of characters read is saved


	POP EAX
	POP ECX
	POP EDX
	
ENDM



; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Prints the string that is stored in the passed memory location
;
; Preconditions: string_input must be defined string in .data section
;
; Receives:	string_input passed in parameter
;
;
; returns: Writes the string_input to the terminal.
; ---------------------------------------------------------------------------------
mDisplayString MACRO string_input
	PUSH EDX
	MOV EDX, OFFSET string_input
	CALL WriteString
	CALL CrLf
	POP EDX
ENDM

; (insert constant definitions here)

.data
; (insert variable definitions here)
introduction_1		 BYTE "Project Six: Using String Primitives & Macros :)",0
introduction_2		 BYTE "Written By: Zachary Maes",0

instruction_0		 BYTE "Please read the instructions carefully.",0
instruction_1		 BYTE "Please input 10 different signed decimal values into the terminal formatted with one or more of the following options:",0
instruction_2		 BYTE "		| 156 | +45 | -760 | 0 |",0
instruction_3		 BYTE "Requires that each number must fit within a 32 bit register (Dont make them too large!)",0
instruction_4		 BYTE "Invalid inputs will not be excepted. Would you kindly try again after the error message.",0
instruction_5		 BYTE "The only non number ASCII characters accepted by this program will be the (+) or (-) symbols.",0
instruction_6		 BYTE "After input, this program displays values like a list of your inputs, their sum, and their mean value (truncated).",0

user_prompt_1		 BYTE "Dobby asks user to please enter one of users chosen signed numbers: ",0
user_error_message	 BYTE "ERROR: Dobby does not mean to yell at user, but user has entered the wrong value! Only signed numbers please!",0
user_error_prompt	 BYTE "It's okay, Dolby believes that user CAN and WILL find success! Try again: ",0

display_message_1	 BYTE "Great care was taken to provide you with these sensitive values.",0 
display_message_2    BYTE "HERE are all the values!",0
list_display_message BYTE "Valid entered numbers are listed below!",0
sum_message			 BYTE "The sum of all values is: ",0
mean_message		 BYTE "The mean of all values (yes it is truncated!) is: ",0

farewell_message	 BYTE "Dobby is finally free! Master Potter has blessed Dobby with the most generous of gifts ... clothes!",0

collected_string	 BYTE 50 DUP(0)			; collected user string input buffer
string_byte_counter  DWORD ?				; holds counter

converted_int		 DWORD ?				; stores the converted int from ReadVal
store_array			 DWORD 10 DUP(?)		; stores all 10 converted ints

.code
main PROC
; (insert executable instructions here)

; PROGRAM INTRODUCTION
	PUSH OFFSET introduction_1				; push introduction and instruction strings to the stack for use in Introduction Proc
	PUSH OFFSET introduction_2
	PUSH OFFSET instruction_0
	PUSH OFFSET instruction_1
	PUSH OFFSET instruction_2
	PUSH OFFSET instruction_3
	PUSH OFFSET instruction_4
	PUSH OFFSET instruction_5
	PUSH OFFSET instruction_6
	Call Introduction

; ReadVal Procedure.....put a loop on it!
	MOV ECX, 10								;ReadVal loop counter
	MOV EDI, OFFSET store_array				; point edi to beginning of array...THIS IS NOT WORKING!!!!!
	
	; Thought process here:
	;	Push offset string variables for use in ReadVal loop
	;		-I am either doing something incorrectly here, in the macro def, or the macro call inside the procedure
	;	
	;
	;

	_10ReadValLoops:
		PUSH converted_int					; a place to store the converted ints
		PUSH OFFSET user_prompt_1			
		PUSH OFFSET collected_string		; inputted string
		PUSH string_byte_counter			; lenght of collected string
		PUSH OFFSET user_error_message
		PUSH OFFSET user_error_prompt
		Call ReadVal
		MOV [EDI], converted_int			; save in array...why does this not work!!!!!!!!!!!!!!!!!
		ADD EDI, 4							; increment array pointer

		LOOP _10ReadValLoops


; WriteVal
	PUSH OFFSET store_array
	PUSH OFFSET collected_string
	Call WriteVal
	CALL CrLf

	MOV EDX, OFFSET display_message_1		  ; Write out the final collected values here
	CALL CrLf
	CALL WriteString
	CALL CrLf
	
	MOV EDX, OFFSET display_message_2
	CALL CrLf
	CALL WriteString
	CALL CrLf
	
	MOV EDX, OFFSET list_display_message
	CALL CrLf
	CALL WriteString
	CALL CrLf

	MOV ECX, 10									; loop through string, print, and calculate values
	MOV EAX, 0									; set up accumulator
	loopingLooper:
		MOV EDX, OFFSET store_array
		CALL WriteString
		ADD EAX, EDX							; accumulate sum
	LOOP loopingLooper

	MOV EDX, OFFSET sum_message
	CALL CrLf
	CALL WriteString
	CALL CrLf

	CALL WriteDec								; EAX already holds sum here, print eax sum
	
	MOV EDX, OFFSET mean_message
	CALL CrLf
	CALL WriteString
	CALL CrLf

	MOV EBX, 10									; set up divisor as 10
	IDIV EBX									; divide EAX sum value by 10 to get the mean
			 

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
; Preconditions: all introduction strings must be defined in data and pushed to stack.
;
; Postconditions: N/A
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
; Returns: Writes strings to the terminal.
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
; ReadVal invokes the mGetString macro to get a string from the user. It then validates 
;		if the string input can be converted to a number. If not, it asks the user to 
;		input a new number string.
;
; Preconditions: areas in memory where string will be saved are initialized.
;		prompts are initialized in data, string_byte_counter initialized.
;
; Postconditions: N/A
;
; Receives: 
;		[EBP+28] = converted_int
;		[EBP+24] = OFFSET user_prompt_1
;		[EBP+20] = OFFSET collected_string
;		[EBP+16] = string_byte_counter
;		[EBP+12] = OFFSET user_error_message
;		[EBP+8] = OFFSET user_error_prompt
;		Call ReadVal
;
; Returns: returns the converted sdword number
; ---------------------------------------------------------------------------------
ReadVal PROC
	PUSH EBP
	MOV  EBP, ESP
	PUSHAD

	_getString:
		; Things I tried:
		;	-Current - broken
		;	mGetString [EBP+24], [EBP+20], [EBP+16].....
		;		-pull from stack with bass offset
		
		;	-other option- broken
		;    MOV EAX, [EBP+24]			; offset user_prompt_1, 
		;	 MOV EDX, [EBP+20]			; offset collected_string, 
		;	 MOV ECX, [EBP+16]			; string_byte_counter
				;----later
		;	 mGetString EAX, EDX, ECX.....
		;		-I also tried this and directly inputting register in macro call
		;		-saw this method from a post on gradescope, but possibly implemented it wrongly?

		;	-other option- works kindof...but against rubric
		;	 mGetString user_prompt_1, collected_string, string_byte_counter.....
		;		-direct from .data variables 
		;		-see first submission for this one...
		;		
		
		
	mGetString [EBP+24], [EBP+20], [EBP+16]					; offset user_prompt_1, offset collected_string, string_byte_counter

		_errorStart:
			MOV ESI, [EBP+20]								; reference to start of string
			MOV ECX, [EBP+16]								; set counter
			MOV EAX, 0										; clear eax for al use
			MOV EDX, 0										; set up where to save int
	
	_validateString:
														; convert the string to sdword 
		CLD												; clear direction flag and run LODSB
		LODSB	

		CMP	AL, 45							; catch (+) 43 or (-) 45
		JE  _minus

		_minus:
			; something something sign flag?
			; ...


		CMP	AL, 43							; catch (+) 43 or (-) 45
		JE _plus

		_plus:
	
		CMP AL, 48
		JL	_errorGetString					; check for 0

		CMP AL, 57
		JG _errorGetString					; check for 9

		SUB AL, 48				
		ADD EAX, EDX						; add edx (old mul 10 value, set to 0 initially) to eax (current pull)

		CMP ECX, 1							; check if a next number happens with exc counter
		JG _anotherVal	
		JE _lastVal

		_anotherVal:		
			MOV EBX, 10						; add 10 to ebx for use in MUL instruction
			MUL EBX							; multiply EAX by EBX(10)
			MOV EDX, EAX					; saved answer in eax moved to edx for later use
			DEC ECX							; decrement counter
			JMP _validateString				; go up and find next val

	_errorGetString:
		MOV EDX, [EBP+12]					; user_error_message
		CALL WriteString
		CALL CrLf
		CALL CrLf

		MOV EAX, [EBP+8]					; OFFSET user_error_prompt 
		MOV EDX, [EBP+20]					; offset collected_string, 
		MOV ECX, [EBP+16]					; string_byte_counter
		

		mGetString EAX, EDX, ECX			; OFFSET user_error_prompt, offset collected_string, string_byte_counter
		

		JMP _errorStart						; jump back up and move on withe the validation process

	_lastVal:
		MOV [EBP+28], EAX					; why is this not working!!!!!!!!
		

	POPAD
	POP EBP
	RET 24
ReadVal ENDP

; ---------------------------------------------------------------------------------
; Name: WriteVal
;
; Converts the inputted sdword numeric values to ascii digits and displays them with 
;the mDisplayString macro, while also saving them in data.
;
; Preconditions: inputted strings by user, the store_array is also referenced
;
; Postconditions: stores the ascii strings in an array to be used for data display
;
; Receives: 
;			+12 PUSH OFFSET store_array
;			+8 PUSH OFFSET collected_string
;			+4 Call WriteVal
;
; Returns: returns a Writestring instruction and store_array
; ---------------------------------------------------------------------------------
WriteVal PROC
	PUSH EBP
	MOV  EBP, ESP
	PUSHAD

	MOV ESI, [EBP+12]								; reference to start of string store array
	MOV ECX, 10										; set counter
	MOV EAX, 0										; clear eax for al use
	MOV EDX, 0										; set up where to save int
	
	; Do Conversion back to acsii
	_convertBack:
		CLD
		LODSB

		CWD
		MOV EBX, 10									; set up divisor 10
		IDIV EBX									; divide EAX by 10
		
		ADD EAX, 48									; convert back to ascii

		MOV [ESI], EAX								; move string back into place in the store array

		mDisplayString EAX							; print macro

		LOOP _convertBack

	POPAD
	POP EBP
	RET 8
WriteVal ENDP

END main 


; YAY FOR SPAGHETTI CODE!
; Enjoy the month off!
; TAs thanks for all the hard work in the ed and on teams!