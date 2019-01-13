#---------------------------------------------------------------------------------------#

#	matrix.s
#										
#	Murtaza Mushtaq
#	2nd of November 2018
#	
#	This file contains 5 functions to be used when dealing with 2D arrays
#
#   dotProduct function will have 5 arguments in order to calculate the dot product of a 
#   specific row and column of A and B and returns this value.
#   1- address of first element of the row of A whose dot product is to be calculated.
#   2- address of first element of the column of B whose dot product is to be calculated.
#   3- N which is the size of matrices. 4- the row of A whose dot product to be calculated. 
#   5- the column of B whose dot product is to be calculated. 
#
#   multiply function will have 4 arguments in order to calculate the product of 2
#   matrices by calculating and calling dot product of each row and column of A and B
#   1- address of matrix A/first element of matrix A
#   2- address of matrix B/first element of matrix B
#   3- address of matrix C which stores product of matrix A and B
#   4- N, which is size of the matrices
#
#	copy function just creates a duplicate of the given matrix
#	
#	transpose function is written by me and is used to flip the matrix of a diagonal 
#	which happens to be (1, 6, -3, -8) in our example
#
# 	reverseColumns function simply reverses the columns of the matrix so that when
#	called on a matrix after transposing it, the matrix is rotated clockwise 90 degrees

#---------------------------------------------------------------------------------------#

   .globl multiply
multiply:
# void multiply(void *A, void *B, void *C, int N);            
# A in rdi, B in rsi, C in rdx, N in ecx
        pushq   %rbp            
        movq    %rsp, %rbp
        movq    %rdi, -24(%rbp) #rbp-24 <- A
        movq    %rsi, -32(%rbp) #rbp-32 <- B
        movq    %rdx, -40(%rbp) #rbp-40 <- C
        movl    %ecx, -44(%rbp) #rbp-44 <- N
        movl    $0, -4(%rbp)    #rbp-24 <- 0 (i=0)
        jmp     .condcheckforiloop
.initiatej:
        movl    $0, -8(%rbp)    #j=0
        jmp     .jcondcheck
.insidejloop:
        movb    $0, -9(%rbp)    #sum=0
        movl    $0, -16(%rbp)   #k=0
        jmp     .kloopcondcheck
.insidekloop:
        movl    -4(%rbp), %eax  #storing current value of i
        imull   -44(%rbp), %eax #i*N
        movl    %eax, %edx      #storing this value of i*N
        movl    -16(%rbp), %eax #storing value of k
        addl    %edx, %eax      #i*n + k
        movslq  %eax, %rdx      #storing the value of i*n + k
        movq    -24(%rbp), %rax #storing address of A
        addq    %rdx, %rax      #A + (i*n + k)
        movzbl  (%rax), %eax    #retriving the dereferenced value at address (A + i*n + k)
        movl    %eax, %ecx      #storing this value
        movl    -16(%rbp), %eax #same will be repeated for B now
        imull   -44(%rbp), %eax
        movl    %eax, %edx
        movl    -8(%rbp), %eax
        addl    %edx, %eax
        movslq  %eax, %rdx
        movq    -32(%rbp), %rax
        addq    %rdx, %rax
        movzbl  (%rax), %eax    #retriving the dereferenced value at address (B + k*n + j)
        movl    %eax, %edx      #storing this value 
        movl    %ecx, %eax      #moving value of *(A + i*n + k)
        imull   %edx, %eax      #*(A + i*n + k) * *(B + k*n + j)
        movl    %eax, %edx      #stroing this value
        movzbl  -9(%rbp), %eax  #storing current value of sum
        addl    %edx, %eax      #sum + (*(A + i*n + k) * *(B + k*n + j))
        movb    %al, -9(%rbp)   #sum = this value
        addl    $1, -16(%rbp)   #k=k+1
.kloopcondcheck:
        movl    -16(%rbp), %eax  #storing value of k
        cmpl    -44(%rbp), %eax  #k<N
        jl      .insidekloop
        movl    -4(%rbp), %eax   #storing current value of i
        imull   -44(%rbp), %eax  #i*n
        movl    %eax, %edx       #storing value of i*n
        movl    -8(%rbp), %eax   #storing value of j
        addl    %edx, %eax       #i*n + j
        movslq  %eax, %rdx       #storing value of i*n + j
        movq    -40(%rbp), %rax  #storing address of C
        addq    %rax, %rdx       #C + (i*n + j)
        movzbl  -9(%rbp), %eax   #storing current value of sum
        movb    %al, (%rdx)      #*(C + i*n + j) = sum
        addl    $1, -8(%rbp)     #j=j+1
.jcondcheck:
        movl    -8(%rbp), %eax   #storing value of j
        cmpl    -44(%rbp), %eax  #j<N
        jl      .insidejloop
        addl    $1, -4(%rbp)     #i=i+1
.condcheckforiloop:
        movl    -4(%rbp), %eax   #storing value of i
        cmpl    -44(%rbp), %eax  #comparing if i<N
        jl      .initiatej
        nop
        popq    %rbp
        ret
#####################

    .globl dotProduct
dotProduct:               
# char dotProduct(void *A, void *B, int N, int i, int j);
# A in rdi, B in rsi, N in edx, i in ecx, j in r8d
        pushq   %rbp            
        movq    %rsp, %rbp      #stack poiner is moved to point to rbp
        movq    %rdi, -24(%rbp) #A moved to (rbp-24) position on stack
        movq    %rsi, -32(%rbp) #B moved to (rbp-32) position on stack
        movl    %edx, -36(%rbp) #N moved to (rbp-36) position on stack
        movl    %ecx, -40(%rbp) #i moved to (rbp-40) position on stack
        movl    %r8d, -44(%rbp) #j moved to (rbp-44) position on stack
        movl    $0, -8(%rbp)    #k=0
        jmp     .condloop       
.mainloop:
        movl    -40(%rbp), %eax #rax = i
        imull   -36(%rbp), %eax #i*n
        movl    %eax, %edx      
        movl    -8(%rbp), %eax  #i*n + k
        addl    %edx, %eax      
        movslq  %eax, %rdx      
        movq    -24(%rbp), %rax #i*n + k + A
        addq    %rdx, %rax
        movzbl  (%rax), %eax    #dereferencing address (A + i*n + k)
        movl    %eax, %ecx      
        movl    -8(%rbp), %eax  #i=k
        imull   -36(%rbp), %eax #i*n
        movl    %eax, %edx     
        movl    -44(%rbp), %eax
        addl    %edx, %eax      #i*n + j
        movslq  %eax, %rdx
        movq    -32(%rbp), %rax
        addq    %rdx, %rax      #i*n + j + B
        movzbl  (%rax), %eax    #deferencing address (i*n + j + B)
        movl    %eax, %edx
        movl    %ecx, %eax
        imull   %edx, %eax      #*(i*n + k + A) * *(k*n + j + B)
        movl    %eax, %edx      
        movzbl  -1(%rbp), %eax   
        addl    %edx, %eax      #sum = sum + *(i*n + k + A) * *(k*n + j + B)
        movb    %al, -1(%rbp)   
        addl    $1, -8(%rbp)    #k=k+1
.condloop:
        movl    -8(%rbp), %eax  #update value of k
        cmpl    -36(%rbp), %eax #check if k<n
        jl      .mainloop       #if cond. true then dont end loop and enter loop
        movzbl  -1(%rbp), %eax  #reaching this command means that k>=n so ending func.
        popq    %rbp
        ret
#####################	

	.globl	copy
copy:
# A in rdi, C in rsi, N in edx
	xorl %eax, %eax			# set eax to 0
# since this function is a leaf function, no need to save caller-saved registers rcx and r8
	xorl %ecx, %ecx			# row index i is in ecx -> i = 0

# For each row
rowLoopC:
	movl $0, %r8d			# column index j in r8d -> j = 0
	cmpl %edx, %ecx			# loop as long as i - N < 0
	jge doneWithRowsC

# For each cell of this row
colLoopC:
	cmpl %edx, %r8d			# loop as long as j - N < 0
	jge doneWithCellsC

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

	incl %r8d				# column index j++ (in r8d)
	jmp colLoopC			# go to next cell

# Go to next row
doneWithCellsC:
	incl %ecx				# row index i++ (in ecx)
	jmp rowLoopC			# Play it again, Sam!

doneWithRowsC:				# bye! bye!
	ret
#####################

    .globl  transpose
transpose:
# void transpose(void *, int ); transpose(C, N);
# C in rdi, N in esi

# This function is not a "caller" i.e., it does not call functions (it is a leaf function), 
# hence it does not have the responsibility of saving "caller-saved" registers 
# such as rax, rdi, rsi, rdx, rcx, r8, r9, r10 and r11.
# This signifies that it can use these registers without first saving their content.

# This function is a "callee" hence it does have the responsibility of saving callee-saved" registers 
# such as r12 before using it and the responsibility of restoring it before returning to "caller" (main).
    pushq %r12

# Set up registers
    xorl %eax, %eax         # set eax to 0
    xorl %ecx, %ecx         # i = 0 (row index i is in ecx)
 
    movl %esi, %edx         # save N (into %edx)
    decl %edx               # N-1 now in %edx

# For each row
rowLoopT:
    cmpl %edx, %ecx         # while i < N-1 (i - N-1 < 0)
    jge doneWithRowsT       

    leal 1(%ecx), %r8d      # j = i+1 (column index j in r8d)

# For each cell of this row
colLoopT:
    cmpl %esi, %r8d         # while j < N (j - N < 0)
    jge doneWithCellsT

# Transpose (swap) cell C + L(j + i*N) with  C + L(i + j*N)
# Compute the address of cell 1 -> C + L(j + i*N) 
    movl %esi, %r9d        # temp (r9d) = N 
    imull %ecx, %r9d       # temp (r9d) = i*N
    addl %r8d, %r9d        # temp (r9d) = j + i*N
#   imull $1, %r9d         # temp (r9d) = L(j + i*N) - no need to do this since L=1 (char=1B)
    addq %rdi, %r9         # temp (r9) = C + L(j + i*N)

# Save cell 1 to temp (r10b)
    movb (%r9), %r10b    

# Compute the address of cell 2 (the transpose) -> C + L(i + j*N)
    movl %esi, %r11d        # temp (r11d) = N 
    imull %r8d, %r11d       # temp (r11d) = j*N
    addl %ecx, %r11d        # temp (r11d) = i + j*N
#   imull $1, %r11d         # temp (r11d) = L(i + j*N) - no need to do this since L=1 -> char = 1B
    addq %rdi, %r11         # temp (r11) = C + L(i + j*N)

# Save cell 2 to temp (r12b)
    movb (%r11), %r12b      

# Copy temp (r10b) to cell 2 (the transpose) -> C + L(i + j*N)
    movb %r10b, (%r11)       

# Copy temp (r12b) to cell 1 -> C + L(j + i*N)
    movb %r12b, (%r9)      

    incl %r8d               # j++ (column index in r8d)
    jmp colLoopT            # go to next cell

# Go to next row
doneWithCellsT:
    incl %ecx               # i++ (row index in ecx)
    jmp rowLoopT            # go to next row

doneWithRowsT:
# Stack clean up
    popq %r12               # restore "callee-saved" register before returning to "caller" (main)
    ret


#####################

    .globl  reverseColumns
# ***** Version 2 *****
reverseColumns:
# void reverseColumns(void *, int n); reverseColumns(C, N);
# C in rdi, N in esi

# This function is not a "caller" i.e., it does not call functions (it is a leaf function), 
# hence it does not have the responsibility of saving "caller-saved" registers 
# such as rax, rdi, rsi, rdx, rcx, r8, r9, r10 and r11.
# This signifies that it can use these registers without first saving their content.

# This function is a "callee" hence it does have the responsibility of saving callee-saved" registers 
# such as r12 and r13 before using it and the responsibility of restoring it before returning to "caller" (main).
    pushq %r12
    pushq %r13

# Set up registers
    xorl %eax, %eax         # set eax to 0
 
    movl %esi, %edx         # save N into %edx
    decl %edx               # N-1 now in %edx
    movl %esi, %r13d        # save N into %r13d
    shrl $1, %r13d          # N/2 now in %r13d

    xorl %r8d, %r8d         # j = 0 (column index j in r8d)

# For each column
nextColumnPairLoop:
    cmpl %r13d, %r8d        # while j < floor(N/2) (i - floor(N/2) < 0)
    jge doneReversing

# Set up loop variable i
    xorl %ecx, %ecx         # i = 0 (row index i is in ecx)

# Reverse the cells of this row
# Compute the address of cell 1 -> C + j 
    movl %r8d, %r9d         # temp (r9d) = j
    addq %rdi, %r9          # temp (r9) = C + L(j + i*N), but L=1 and i=0       

# Compute the address of cell 2 (the reverse) -> C + (N-1-j)
    movl %edx, %r11d        # temp (r11d) = N-1
    subl %r8d, %r11d        # temp (r11d) = N-1-j 
    addq %rdi, %r11         # temp (r11) = C + L((i*N) + (N-1-j)), but L=1 and i=0

# Swap each cell in these 2 columns
nextElementPairLoop:
    cmpl %esi, %ecx         # while i < N (i - N < 0)
    jge doneWithColumnPair

# Save cell 1 to temp (r10b)
    movb (%r9), %r10b
# Save cell 2 to temp (r12b) 
    movb (%r11), %r12b  
# Copy temp (r10b) to C+ L((i*N) + (N-1-j))
    movb %r10b, (%r11)  
# Copy temp (r12b) to C + L(j + i*N)
    movb %r12b, (%r9)      

# Go to next element in both columns ...
    leaq (%rsi, %r9), %r9   # ... by adding N to address of current element of column
    leaq (%rsi, %r11), %r11 # ... by adding N to address of current element of column   

    incl %ecx               # i++
    jmp nextElementPairLoop # go to next element

# Go to next row
doneWithColumnPair:
    incl %r8d               # j++ 
    jmp nextColumnPairLoop  # go to next row

doneReversing:              
# Stack clean up - reverse order
    popq %r13               # restore "callee-saved" register before returning to "caller" (main)
    popq %r12
    ret