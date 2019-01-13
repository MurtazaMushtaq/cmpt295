
#---------------------------------------------------------------------------------------#

#	calculator.s
#										
#	Murtaza Mushtaq
#	25th of October 2018
#	
#	This file contains assembly code for four functions (lt, plus, minus and mul). 	
#
#	The lt function checks if the first argument is less than the second argument by 
# 	simply comparing them using cmp* function
#
# 	The plus function is used to add the first & second arguments by using lea* function 
#	instead of the add* function
#
#	The minus function is used to subtract two arguments without using the sub* function
# 	by negating the second argument and adding it to first argument using lea* function
#
#	The mul function is written by me and is used to multiply first & second argument 
#	without using the mul* function in assembly language recursively. This function
# 	was first written in C and then changed to assembly. This is what the C version looks
# 	like:
#
#	int mul(int x, int y){
#		if(x==0 || y==0){
#			return 0;
#		}
#		if(y<0){
#			return -x + mul(x, y+1);
#		}
#		else{
#			return x + mul(x, y-1);
#		}
#	}

#---------------------------------------------------------------------------------------#
	.globl	lt
	.globl	plus
	.globl	minus
	.globl	mul

# x in edi, y in esi

lt:
	xorl	%eax, %eax	
	cmpl	%esi, %edi
	setl	%al
	ret

plus:
# cannot use add* instruction
	leal	(%edi,%esi), %eax
	ret

minus:
# cannot use sub* instruction
	movl	%esi, %eax
	negl	%eax
	leal	(%edi,%eax), %eax	
	ret

mul:   #unsigned multiplication
# x in edi and y in esi
# returning integer in eax
.base:
	.cfi_startproc
	testl	%edi, %edi 	 # checks if x=0 and sets flag to 1 in next step if it is
	sete	%dl
	testl	%esi, %esi	 # checks if y=0 and sets flag to 1 in nect step if it is
	sete	%al
	orb	%al, %dl			
	jne	.CNM		 # jumps to .CNM (Condition Not Met) if x or y is equal to 0
	pushq	%rbx		 
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edi, %ebx	 # x moved to a new register for future addition
	testl	%esi, %esi	 # checking if y<0
	js	.NY				 # if yes jumps to .NY (Negative Y)
	subl	$1, %esi	 # y=y-1
	call	mul 		 # calling the function again with new value of y
	addl	%ebx, %eax	 # value to be returned = current value + x
.ending:
	popq	%rbx		 # recursive calls are over and function is now going to return
	.cfi_remember_state	 # a value 
	.cfi_def_cfa_offset 8
	ret
.NY:
	.cfi_restore_state 	
	addl	$1, %esi 	# y=y+1
	call	mul 	 	# calling function again but with new value of y
	subl	%ebx, %eax 	# return integer returned from calling mul again - x
	jmp	.ending
.CNM:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	movl	$0, %eax  	# if any of x or y was 0, return value if set to 0 
	ret  				# and returned
	.cfi_endproc
.LFE2:
	.size	mul, .-mul
	.ident	"GCC: (Ubuntu 7.3.0-21ubuntu1~16.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits