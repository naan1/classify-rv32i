.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             # index
    mv t2, a0                   
loop_start:
    # Loop termination condition
    bge t1, a1, loop_end        # If index >= size, exit loop
    lw t3, 0(t2)                # Load element value into t3
    blt t3, zero, set_zero      # If value < 0, go to set_zero
    j loop_continue             # Otherwise, skip to next element

set_zero:
    sw zero, 0(t2)              # Set element to 0 if it was negative

loop_continue:
    addi t1, t1, 1              # Increment index
    addi t2, t2, 4
    j loop_start                # Repeat loop
     

error:
    li a0, 36          
    j exit          
loop_end :
   jr ra