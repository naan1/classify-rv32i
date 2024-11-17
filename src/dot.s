.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            # product
    li t1, 0            # loop counter
    li t2, 0            # Initialize index0 = 0
    li t3, 0            # Initialize index1 = 0

loop_start:
    bge t1, a2, loop_end

    # Calculate addresses for arr0 and arr1
    slli t4, t2, 2      # t4 = index0 * 4 (byte offset for arr0)
    add t5, a0, t4      # t5 = address of arr0[index0]
    lw t4, 0(t5)        # Load arr0[index0] into t4 (reuse t4)

    slli t5, t3, 2      # t5 = index1 * 4 (byte offset for arr1)
    add t6, a1, t5      # t6 = address of arr1[index1]
    lw t5, 0(t6)        # Load arr1[index1] into t5 (reuse t5)
    
    addi sp, sp, -4      # Decrement stack pointer
    sw t1, 0(sp)         # Save t1 to stack

    # Perform multiplication without 'mul'
    li t6, 0            # t6 = result (product)

multiply_loop:
    beqz t5, multiply_end   # If multiplier is zero, end multiplication
    andi t1, t5, 1          # Check if LSB of multiplier is 1
    beqz t1, skip_add
    add t6, t6, t4          # result += multiplicand
skip_add:
    slli t4, t4, 1          # multiplicand <<= 1
    srli t5, t5, 1          # multiplier >>= 1
    j multiply_loop
multiply_end:
    lw t1, 0(sp)            # Restore t1
    addi sp, sp, 4          # Increment stack pointer
    # Accumulate the product into sum
    add t0, t0, t6

    # Increment indices by strides
    add t2, t2, a3          # index0 += stride0
    add t3, t3, a4          # index1 += stride1

    # Increment loop counter
    addi t1, t1, 1
    j loop_start

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit

