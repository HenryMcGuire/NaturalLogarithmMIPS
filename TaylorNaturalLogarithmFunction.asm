#Final Project: This will be our core business logic function for our natural logarithm approximations using Mercator Series.
#Here, the Mercator series is simply the Taylor series approximation of the natural logarithm.
.data
new_line: .asciiz "\n"
.text
.globl taylor_logarithm
taylor_logarithm: 
li $a2, 100 #$a2 will be our main loop counter for our Mercator series (ideally we should initialize close to infinity for infinite series).
li $a3, 0 #$a3 will be our total sum that will be the sum of all values within our Mercator series.
mercator_loop: 
	blez $a2, mercator_done
	mtc1 $a2, $f5 #moves the raw word value of $a2 to $f5.
	cvt.s.w $f5, $f5 #converts the raw word value to an actual floating point value withing $f5.
	b find_sign
	sign_found:
	div.s $f6, $f1, $f5 #divide our sign indicator(1 for positive, -1 for negative) by the main loop iterator, both as floats.
	b find_exponent
	exponent_found: 
	mul.s $f7, $f6, $f3 # multiplies ((-1)^n / n) * x^n. (i.e. $f7 = (-1)^n / n) and $f3 after subfunction is x^n).
	add.s $f8, $f8, $f7 #float sum of iterations += float of current iteration value.
	li $v0, 2
	mov.s $f12, $f6
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	addi $a2, $a2, -1 #decrement our main loop counter.
	b mercator_loop
mercator_done: 
jr $ra
find_sign: 
	li $t0, -1 #set our sign value (which will only ever be 1 or -1) to start off at -1.
	mtc1 $t0, $f1 #moves the raw word value of $t0 to $f1.
	cvt.s.w $f1, $f1 #converts the raw word value to an actual floating point value withing $f1.
	li $t1, -1 #have $t1 store the constant value of -1 so we can avoid -1*-1 keep it at 1, instead of the -1 we want.
	mtc1 $t1, $f2 #moves the raw word value of $t1 to $f2.
	cvt.s.w $f2, $f2 #converts the raw word value to an actual floating point value withing $f2.
	move $t2, $a2 #copy our current main loop iterator counter as the number of iterations we want to make.
	sign_loop: 
		blez $t2, sign_done
		mul.s $f1, $f1, $f2 #multiplies $f1 by -1 ($f1 * $f2 in floating point) to deal with altering value of $f1.
		addi $t2, $t2, -1 #decrement our local loop counter.
		b sign_loop
	sign_done: 
	b sign_found
find_exponent: 
	move $t2, $a2 #copy our current main loop iterator counter as the number of iterations we want to make.
	exponent_loop: 
		blez $t2, exponent_done
		mul.s $f3, $f8, $f8 #get the value of ($a1)^2 locally.
		addi $t2, $t2, -1 #decrement our local loop counter.
		b exponent_loop
	exponent_done:
	b exponent_found
