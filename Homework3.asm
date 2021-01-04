# Homework 3
# Christy Jacob

.data
inputString: 	.space	100
inputPrompt:	.asciiz	"Enter some text: "
goodbyeMessage:	.asciiz	"Goodbye!"
wordMessage:	.asciiz	" words "
charMessage:	.asciiz	" characters\n"
charCount: 	.word	0
wordCount:	.word	0

.text
main:	
	li	$t2,  32	# register $t2 holds the ASCII address for space to check if there is a new word
	
	jal	loopInput	# calling the function
	
goodbyeExit:
	# printing out goodbye and exiting
	li	$v0, 59
	la	$a0, goodbyeMessage
	syscall

	li	$v0, 10
	syscall
	
loopInput:
	#reset word count
	li	$v1, 0
	sw	$v1, inputString	# clear input string

# displaying prompt and taking in string
	li 	$v0, 54
	la 	$a0, inputPrompt
	la	$a1, inputString	# loads address of buffer
	li	$a2, 100
	syscall
	
	# reset char count
	li $v0, 0
	
	la	$s1, inputString 	# loads address of input string into $t4
	
	lb	$t3, 0($s1)	# loads first character into $t3
	bne	$t3, $zero, countChar 	# if something is typed start counting chars and words
	jr 	$ra		# if nothing is entered, exit


countChar:

	beq	$t3, $zero, printSummary	# if current character is null terminator
	beq	$t3, $t2, ifWord	# if current character is a space
	
update:
	addiu	$v0, $v0, 1	# adds 1 to the char counter
	addiu	$s1, $s1, 1	# adds 1 to the address
	lb	$t3, 0($s1)	# loads the next char
	
	addi 	$sp, $sp, -8	# push
	sw	$ra, 4($sp)
	sw	$s1, 0($sp)	# saving $s1
	jal	countChar	# continue going through each char

	lw	$s1, 0($sp)	# restoring $s1
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8	# pop
	jr	$ra

ifWord:
	addiu	$v1, $v1, 1	# adds 1 to the word counter
	j 	update
	
printSummary:

	addi 	$v0, $v0, -1	# take into account null terminator
	addi	$v1, $v1, 1	# last word doesn't need space after so take that into account
	
	# printing the summary(siplaying results)
	sw	$v0, charCount
	sw	$v1, wordCount
	
	li	$v0, 4
	la	$a0, inputString
	syscall
	
	li	$v0, 1
	lw	$a0, wordCount
	syscall
	
	li	$v0, 4
	la	$a0, wordMessage
	syscall
	
	li	$v0, 1
	lw	$a0, charCount
	syscall
	
	li	$v0, 4
	la	$a0, charMessage
	syscall
	
	# keep looping
	j	 loopInput
	
