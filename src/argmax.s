.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0
    li t2, 1
    addi t3, a0, 4          # t3 = pointer to the second element (move pointer by 4 bytes)

loop_start:
    # Check if the end of the array is reached
    bge t2, a1, finish      # If t2 >= a1, exit the loop

    # Load the current value into t4
    lw t4, 0(t3)            # t4 = current element (using t3 as the pointer)
    addi t3, t3, 4          # Move the pointer to the next element

    # Compare current value with max value
    ble t4, t0, skip_update # If t4 <= t0, skip updating max value and index

    # Update max value and its index (use basic RV32I instructions)
    add t0, t4, x0          # t0 = t4 (update max value)
    add t1, t2, x0          # t1 = t2 (update index of max value)

skip_update:
    addi t2, t2, 1          # Increment the index
    j loop_start            # Jump back to loop_start

finish:
    add a0, t1, x0          # Store the index of the max value in a0
    ret                     # Return to caller

handle_error:
    li a0, 36               # Error code 36
    j exit                  # Exit the program