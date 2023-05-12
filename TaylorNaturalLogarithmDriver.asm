#Final Project: This will be our driver to test inputs and outputs for our taylor logarithm approximation.
.data
input_prompt: .asciiz "What value do you want to find the natural log of (between -1 and 1): "
output_prompt: .asciiz "The natural log of your input is: "
.text
#Print input prompt + get integer from user.
li $v0, 4
la $a0, input_prompt
syscall
li $v0, 6 #syscall that asks for a floating point number.
syscall
mov.s $f8, $f0 #move current used float value to $f8 for later use.
jal taylor_logarithm #call our taylor series approximation of a logarithm function.
li $v0, 4
la $a0, output_prompt
syscall 
li $v0, 2
mov.s $f12, $f8
syscall
#Ends the program.
li $v0, 10
syscall 