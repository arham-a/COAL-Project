TITLE COAL_PROJECT
include irvine32.inc

.data
welcomePrompt byte "Welcome to the Typing Master Game.", 0
chooseDifficulty byte "Choose any difficulty level to Start:", 0
difficultyLevels byte "0. Start again   1. Easy mode   2.Hard mode    3. Exit", 0
invalidPrompt byte "Invalid Prompt!!!"
easyPrompt byte "You have entered the easy mode", 0
mediumPrompt byte "You have entered the medium mode", 0
hardPrompt byte "You have entered the hard mode", 0
stringPrompt byte "Write the below string:", 0


userInput DWORD 500 DUP(0)       ; Buffer for user input
selectedString DWORD ?           ; Address of the selected string
stringLength DWORD ?             ; Length of the selected string
accuracyReal DWORD ?             ; Store accuracy result
typedCharacters DWORD 0          ; Characters Typed by the User

easyString1 byte "The fox jumps over lazy dog.", 0 
easyString2 byte "Typing is fun and easy.", 0 
easyString3 byte "Hello world!", 0
easyString4 byte "Learning new skills is great.", 0 
easyString5 byte "Keep calm and code on.", 0
easyStringArray DWORD OFFSET easyString1, OFFSET easyString2, OFFSET easyString3, OFFSET easyString4, OFFSET easyString5


hardString1 byte "Success is not final, failure is not fatal: It is the courage to continue that counts.", 0 
hardString2 byte "In the end, we will remember not the words of our enemies, but the silence of our friends.", 0 
hardString3 byte "Good things come to those who wait, but better things come to those who work for it.", 0
hardString4 byte "The only limit to our realization of tomorrow is our doubts of today.", 0 
hardString5 byte "Understanding is deeper than knowledge; there are many who know but few who understand.", 0
hardStringArray DWORD OFFSET hardString1, OFFSET hardString2, OFFSET hardString3, OFFSET hardString4, OFFSET hardString5


endMsg BYTE "Calculating your typing speed...", 0
completedTime BYTE "You completed it in (seconds:): ", 0 
resultCharacters BYTE "You typed (Characters count):", 0
resultMsg BYTE "Your typing speed is (Characters Per Second): ", 0
errorMsg BYTE "Finish Time too small!", 0
promptText BYTE "Type the following paragraph as quickly as you can:", 0
typeAgain byte "You have entered the wrong string!!!",0

.code
main proc
    call Welcome
    exit
main endp

Welcome proc
    mov edx, offset welcomePrompt
    call WriteString
    call crlf
    mov edx, offset chooseDifficulty
    call WriteString
    call crlf
    mov edx, offset difficultyLevels
    call WriteString
    call crlf
    call ReadInt
    cmp eax, 3
    je exitGame
    cmp eax, 0
    je GameAgain
    cmp eax, 1
    je callEasy
    cmp eax, 2
    je callHard
    cmp eax, 3
    ja StartAgain
    cmp eax, 0
    jl StartAgain

    callEasy:
        push offset Welcome
        call easyLevel       

    callHard:
        push offset Welcome
        call hardLevel

    GameAgain:
        call Welcome

    StartAgain:
        mov edx, offset invalidPrompt
        call WriteString
        call Crlf
        jmp Welcome

    exitGame:
        ret
Welcome endp

easyLevel proc
    mov edx, offset easyPrompt
    call WriteString
    call crlf
Again:
    mov edx, offset stringPrompt
    call WriteString
    call crlf

    call GetMseconds    ;  function to get milliseconds       
    mov eax, edx                 
    call Randomize               

    ; Generate Random Number
    mov eax, 5                   
    call RandomRange             
    mov ecx, eax                 

    ; Get Selected String
    mov ebx, OFFSET easyStringArray  
    mov eax, [ebx + ecx*4]       
    mov selectedString, eax      

    ; Calculate the length of the selected string
    mov edx, eax                 
    call Str_length              
    mov stringLength, eax        

    ; Display the random string
    mov edx, selectedString      
    call WriteString             
    call Crlf                    

    ; Prompt user to input their version of the string
    call Crlf
    mov edx, OFFSET userInput
    call WriteString

     ; Get the current system time (start time)
    call GetMSeconds  ;  function to get milliseconds 
    mov esi, eax      

    ; Read user input string
    mov edx, offset userInput   
    mov ecx, 500               
    call ReadString            
    mov ecx, eax             
    mov typedCharacters, eax

    ;finding length
    mov edx, offset userInput
    mov ecx, 0
    findlength:
        cmp byte ptr [edx + ecx], 0
        je endlength
        inc ecx
        jmp findlength
    endlength:
        mov stringLength, ecx


    pushad
    mov eax, stringLength
   
    ; Comparing the strings
    lea edi, userInput      
    mov esi, selectedString 
    mov ecx, stringLength
    repe cmpsb          
    
    popad                
    
    
    jne notEqual              
    jmp ContinueProcedure
    
notEqual:
    mov edx, offset typeAgain 
    call WriteString
    call Crlf
    mov userInput, 0 
    jmp Again                    ; Retry

ContinueProcedure:
    ; Get the current time (end time in milisecond)
    call GetMSeconds  
    mov edi, eax     

    ; Calculate finish time in milliseconds
    sub edi, esi      ; End time - Start time
    mov eax, edi
    cdq              
    mov ecx, 1000     
    div ecx      
    mov edi, eax

    ; Display Time Taken 
    mov edx, OFFSET completedTime
    call writeString
    call writedec 
    call crlf

    ; Check if finish time is less than 1 second
    cmp edi, 1
    jl too_small_time

    ; Calculate typing speed (characters per second)
    mov edx, OFFSET resultCharacters
    call writeString
    mov eax,  typedCharacters   
    call writedec
    call crlf
    cdq              
    div edi          
    mov ecx, edx      


    ; Display the result
    mov edx, offset endMsg
    call WriteString
    call crlf
    mov edx, offset resultMsg
    call WriteString
    call WriteDec    
    mov al, "."
    call WriteChar
     ; Calculate and display the first digit after the decimal point
    mov eax, ecx      
    imul eax, 10      
    xor edx, edx      
    div edi           
    call WriteDec    
    call Crlf
    jmp program_exit  

    too_small_time:
        ; Handle finish time too small
        mov edx, offset errorMsg
        call WriteString
        call crlf
		jmp Again

    program_exit:
    pop eax
    call eax
    ret
easyLevel endp


hardLevel proc
    mov edx, offset hardPrompt
    call WriteString
    call crlf
Again:
    mov edx, offset stringPrompt
    call WriteString
    call crlf
    call GetMseconds            
    mov eax, edx                
    call Randomize          

    mov eax, 5         
    call RandomRange     
    mov ecx, eax        

    mov ebx, OFFSET hardStringArray
    mov eax, [ebx + ecx*4]   
    mov selectedString, eax  

    ; Calculate the length of the selected string
    mov edx, eax            
    call Str_length         
    mov stringLength, eax   

    ; Display the random string
    mov edx, selectedString   
    call WriteString         
    call Crlf               

    ; Prompt user to input their version of the string
    call Crlf
    mov edx, OFFSET userInput
    call WriteString

     ; Get the current  time (in ms)
    call GetMSeconds  
    mov esi, eax     

    ; Read user input string
    mov edx, offset userInput  
    mov ecx, 500             
    call ReadString          
    mov ecx, eax            
    mov typedCharacters, eax

    ;finding length
    mov edx, offset userInput
    mov ecx, 0
    findlength:
        cmp byte ptr [edx + ecx], 0
        je endlength
        inc ecx
        jmp findlength
    endlength:
        mov stringLength, ecx

    ; comparing strings
    pushad

    mov eax, stringLength
    
    ; Comparing the strings
    lea edi, userInput           
    mov esi, selectedString     
    mov ecx, stringLength
    repe cmpsb                
    
    popad                      
    
    
    jne notEqual                 
    jmp ContinueProcedure
    
notEqual:
    mov edx, offset typeAgain   
    call WriteString
    call Crlf
    mov userInput, 0 
    jmp Again                    ; Retry

ContinueProcedure:
    call GetMSeconds  
    mov edi, eax 

    ; Calculate finish time in milliseconds
    sub edi, esi      ; End time - Start time
    mov eax, edi
    cdq              
    mov ecx, 1000  
    div ecx      
    mov edi, eax

    ; Display Time Taken 
    mov edx, OFFSET completedTime
    call writeString
    call writedec 
    call crlf

    ; Check if finish time is less than 1 second
    cmp edi, 1
    jl too_small_time  

    ; Calculate typing speed (characters per second)
    mov edx, OFFSET resultCharacters
    call writeString
    mov eax,  typedCharacters  
    call writedec
    call crlf
    cdq              
    div edi           
    mov ecx, edx       


    ; Display the result
    mov edx, offset endMsg
    call WriteString
    call crlf
    mov edx, offset resultMsg
    call WriteString
    call WriteDec    
    mov al, "."
    call WriteChar

     ; Calculate and display the first digit after the decimal point
    mov eax, ecx      
    imul eax, 10      
    xor edx, edx     
    div edi          
    call WriteDec    
    call Crlf
    jmp program_exit

   
    too_small_time:
        ; Handle elapsed time too small
        mov edx, offset errorMsg
        call WriteString
        call crlf
		jmp Again


    program_exit:
    pop eax
    call eax
    ret
hardLevel endp
end main
