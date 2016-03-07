#Convert the following to MIPS Assembly
#
#int main(){
#	int a = 2;
#	int max = 10;
#	int x[max];
#
#	for(int i = 0; i < max; i++){
#		x[i] = modifyIt(a);
#		cout << x[i] << endl;
#	}
#}
#
#
#
#int modifyIt(int arg){
#	int temp1;
#	int temp2;
#	int result;
#
#	temp1 = pow(arg, 2);
#	temp2 = pow(arg, 3);
#	result = pow(arg, 4);
#	result = result + temp1 + temp2 + 2;
#
#   //should be 30
#	return result;
#
#}
#
#int pow(int arg0, int arg1){
#	int product = 1;
#	for(int i = 0; i < arg1; i++){
#		product *= arg0;
#	}
#
#	return product;
#}
#
#	Expected output:
#30
#30
#30
#30
#30
#30
#30
#30
#30
#30



					#a 			$s0
					#max		$s1
					#i 			$s2
					#base		$t0
					#b+offst	$t1
					.data
endl:				.asciiz		"\n"
x:					.word		0:5
					.text
main:				la			$t0,x
					li			$s0,2			#a = 2
					li			$s1,10			#max = 10

					li			$s2,0			#(for i =0; i < max; i++)
loop:				sll			$t1,$s2,2		#shift memory to x[i]
					add			$t1,$t1,$t0		#add base to offset
					move		$a0,$s0			#x[i] = modifyit(a)
					jal			modit 			#
					sw			$v0,($t1)		#

					move		$t3,$v0			#store x[i]

					li			$v0,1			#cout << x[i] << endl;
					move		$a0,$t3			#
					syscall						#
					li			$v0,4			#
					la			$a0,endl		#
					syscall						#

					addi		$s2,$s2,1		#i++
					blt			$s2,$s1,loop	#

					li			$v0,10			#exit
					syscall

modit:				addi		$sp,$sp,-24		#allocate space on stack
					sw			$ra,20($sp)		
					sw			$s0,16($sp)
					sw			$s1,12($sp)
					sw			$s2,8($sp)
					sw			$t0,4($sp)
					sw			$t1,($sp)
					move		$s0,$a0 		#persist argument

					li			$a1,2			#temp1 = pow(arg,2);
					jal			pow				#
					move		$s1,$v0			#
					move		$a0,$s0			#put argument back

					li			$a1,3			#temp2 = pow(arg,3);
					jal			pow				#
					move		$s2,$v0			#
					move		$a0,$s0			#put argument back

					li			$a1,4			#result = pow(arg,4)
					jal			pow				#
					add 		$v0,$v0,$s1		#result = result+temp1+temp2+2
					add 		$v0,$v0,$s2		#
					addi		$v0,$v0,2		#

					lw			$ra,20($sp)		#get stored variables/sp/ra
					lw			$s0,16($sp)
					lw			$s1,12($sp)
					lw			$s2,8($sp)
					lw			$t0,4($sp)
					lw			$t1,($sp)
					addi		$sp,$sp,24		#de-allocate stack space

					jr			$ra				#return result

pow:				li 			$t0,1			#product = 1
					li			$t1,0			#i = 0
					bge			$t1,$a1,out		#for(i=0;i<arg1;i++)
loop2:				mul			$t0,$t0,$a0 	#product *= arg0;
					addi		$t1,$t1,1		#i++
					blt			$t1,$a1,loop2	#

out:				move		$v0,$t0			#return product
					jr			$ra				#