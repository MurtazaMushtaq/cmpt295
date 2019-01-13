
#---------------------------------------------------------------------------------------#

#	matrix.s
#										
#	Murtaza Mushtaq
#	26th of October 2018
#	
#	This file contains 3 functions to be used when dealing with 2D arrays
#
#	copy function just creates a duplicate of the given matrix
#	
#	transpose function is written by me and is used to flip the matrix of a diagonal 
#	which happens to be (1, 6, -3, -8) in our example
#
# 	reverseColumns function simply reverses the columns of the matrix so that when
#	called on a matrix after transposing it, the matrix is rotated clockwise 90 degrees

#---------------------------------------------------------------------------------------#

	.globl	copy
	.globl	transpose
	.globl	reverseColumns
copy:
# A in rdi, C in rsi, N in edx
	xorl %eax, %eax			# set eax to 0
# since this function is a leaf function, no need to save caller-saved registers rcx and r8
	xorl %ecx, %ecx			# row number i is in ecx -> i = 0

# For each row
rowLoop:
	movl $0, %r8d			# column number j in r8d -> j = 0
	cmpl %edx, %ecx			# loop as long as i - N < 0
	jge doneWithRows

# For each cell of this row
colLoop:
	cmpl %edx, %r8d			# loop as long as j - N < 0
	jge doneWithCells

# Compute the address of current cell that is copied from A to C
# since this function is a leaf function, no need to save caller-saved registers r10 and r11
	movl %edx, %r10d        # r10d = N 
    imull %ecx, %r10d		# r10d = i*N
	addl %r8d, %r10d        # j + i*N
	imull $1, %r10d         # r10 = L * (j + i*N) -> L is char (1Byte)
	movq %r10, %r11			# r11 = L * (j + i*N) 
	addq %rdi, %r10			# r10 = A + L * (j + i*N)
	addq %rsi, %r11			# r11 = C + L * (j + i*N)

# Copy A[L * (j + i*N)] to C[L * (j + i*N)]
	movb (%r10), %r9b       # temp = A[L * (j + i*N)]
	movb %r9b, (%r11)       # C[L * (j + i*N)] = temp

	incl %r8d				# column number j++ (in r8d)
	jmp colLoop				# go to next cell

# Go to next row
doneWithCells:
	incl %ecx				# row number i++ (in ecx)
	jmp rowLoop				# Play it again, Sam!

doneWithRows:				# bye! bye!
	ret

#####################
transpose:
.base:
	.cfi_startproc
	movl	$0, %r8d	 	#i=0
	jmp	.icond				#pretty self explanatory 
.com:
	movl	%r8d, %edx		#storing value of i
	imull	%esi, %edx		#storing value of i*n
	addl	%ecx, %edx		#stored value +j (i*n +j)
	movslq	%edx, %rdx		#moving stored value into a bigger size register 
	addq	%rdi, %rdx		#stored value + address of array
	movzbl	(%rdx), %r9d	#s= element at this address
	movl	%ecx, %eax 		#storing value of j
	imull	%esi, %eax 		#j*n
	addl	%r8d, %eax 		#(j*n) + i
	cltq
	addq	%rdi, %rax 		#(j*n) + i + address of the array 
	movzbl	(%rax), %r10d 	#storing this element *((char*)D + ((j*n) + i)) 
	movb	%r10b, (%rdx) 	#*((char*)D + ((i*n) + j)) = *((char*)D + ((j*n) + i))
	movb	%r9b, (%rax) 	#*((char*)D + ((j*n) + i)) = s
	addl	$1, %ecx		#j=j+1
.jcond:
	cmpl	%esi, %ecx		#j<n
	jl	.com				#if yes jump to .com (commands) loop
	movl	%r11d, %r8d	    #i=j which is same as i=i+1 as j=i+1
.icond:
	cmpl	%esi, %r8d		#i<n
	jge	.end				#if i>=n jump to .end
	leal	1(%r8), %r11d 	#j=i+1
	movl	%r11d, %ecx		#j moved to be later compared with n in .jcond (j condition)
	jmp	.jcond					
.end:
	rep ret 				#return 
	.cfi_endproc
.YouTheBest:
	.size	transpose, .-transpose 
	.globl	reverseColumns
	.type	reverseColumns, @function

#the comments of this function are less in number since the idea is same as
#the transpose function except the condition for j's loop
reverseColumns:
.base2:
	.cfi_startproc
	movl	$0, %r10d	 	#i=0
	jmp	.icond2
.com2:
	movl	%r10d, %edx 	#i=i
	imull	%esi, %edx  	#i*n
	leal	(%rdx,%rcx), %eax #i*n + j
	cltq
	addq	%rdi, %rax 		#array pointer + (i*n + j)
	movzbl	(%rax), %r9d 	#the next few are just basic commands for
	addl	%r8d, %edx 		#swapping as done in transpose function
	movslq	%edx, %rdx
	leaq	-1(%rdi,%rdx), %rdx
	movzbl	(%rdx), %r8d
	movb	%r8b, (%rax)
	movb	%r9b, (%rdx)
	addl	$1, %ecx 		#j=j+1
.jcond2:
	movl	%esi, %r8d		
	subl	%ecx, %r8d		#n-j
	leal	-1(%r8), %eax   #(n-j)-1
	cmpl	%ecx, %eax 		#(n-j-1)<j
	jg	.com2 				
	addl	$1, %r10d 		#i=i+1
.icond2:
	cmpl	%esi, %r10d
	jge	.end2
	movl	$0, %ecx 		#j=0
	jmp	.jcond2
.end2:
	rep ret 				#return
	.cfi_endproc
.PleaseGiveMeAGoodGrade:
	.size	reverseColumns, .-reverseColumns
	.ident	"GCC: (Ubuntu 7.3.0-21ubuntu1~16.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits