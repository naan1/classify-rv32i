# Assignment 2: Classify
## function  
## Part A      
### Task : Absolute Value 
this part is a walkthrough to make sure the value is positive
```asm
# ...
sub  t0, x0, t0  
sw   t0 0(a0)
# ...
```
- - - - - 



### Task 1: ReLU        
#### Conceptual Overview: ReLU
> ReLU (Rectified Linear Unit) is an activation function used in neural networks.
> It outputs the input directly if it is positive, otherwise returns zero.
> mathematical formula:
$\text{ReLU}(x) = \max(0, x)$

#### Code   
```assembly
.globl relu

.text
# ...
loop_start:
    bge t1, a1, loop_end        
    lw t3, 0(t2)               
    blt t3, zero, set_zero      
    j loop_continue             

set_zero:
    sw zero, 0(t2)          

loop_continue:
    addi t1, t1, 1             
    addi t2, t2, 4
    j loop_start             
# ...
```


* **Load Element (`lw t3, 0(t2)`)**  
   Reads the current array element into the register `t3`.

* **Check Negative (`blt t3, zero, set_zero`)**  
   If the value in `t3` is less than 0, jumps to `set_zero`.

* **Set Zero (`sw zero, 0(t2)`)**  
   Writes `0` back to the array at the address in `t2` if the value is negative.

 
* **Positive Values Skip (`j loop_continue`)**  
   Skips the `set_zero` step for positive values, keeping them unchanged.


---

### Task 2: Argmax         

#### Conceptual Overview: Argmax  
>The Argmax function finds the index of the maximum value in an array. If there are multiple maximum values, it returns the index of the first occurrence. This is particularly useful in applications like classification problems where the position of the highest probability (argmax) indicates the predicted class.

#### Code  
```assembly
#....
#....
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

#...
#...

```
* **Setup (`lw t0, 0(a0)`, `li t1, 0`)**  
   - `t0`: Holds the current maximum value (initialized with the first element).  
   - `t1`: Stores the index of the current maximum value.

* **Pointer Management (`addi t3, a0, 4`)**  
   `t3` is set to point to the second element of the array.

* **Loop Condition (`bge t2, a1, finish`)**  
   Iterates over the array until the end is reached (`t2 >= a1`).

* **Comparison (`lw t4, 0(t3)`, `ble t4, t0, skip_update`)**  
   - Loads the current element into `t4`.  
   - Compares `t4` with the current maximum value `t0`. If `t4 <= t0`, skips the update.

* **Update Maximum Value (`add t0, t4, x0`, `add t1, t2, x0`)**  
   If a new maximum is found, updates `t0` to hold the new maximum and `t1` with its index.

* **Index Increment (`addi t2, t2, 1`)**  
   Moves to the next element by incrementing the index (`t2`) and pointer (`t3`).

* **Return Value (`add a0, t1, x0`)**  
   Stores the index of the maximum value in `a0` and exits via `ret`.
---

### Task 3.1: Dot Product
#### Conceptual Overview: Dot Product  
>The dot product is a mathematical operation that multiplies corresponding elements of two arrays and sums the results. This function calculates the dot product with a stride, meaning it skips elements in each array by a specified number of positions (stride0 and stride1) during the computation.

#### Code  
```assembly
#...
#...
loop_start:
    bge t1, a2, loop_end

  
    slli t4, t2, 2      
    add t5, a0, t4      
    lw t4, 0(t5)        

    slli t5, t3, 2      
    add t6, a1, t5      
    lw t5, 0(t6)      
    
    addi sp, sp, -4      # Decrement stack pointer
    sw t1, 0(sp)         # Save t1 to stack

    # Perform multiplication without 'mul'
    li t6, 0          

multiply_loop:
    beqz t5, multiply_end   
    andi t1, t5, 1       
    beqz t1, skip_add
    add t6, t6, t4          
skip_add:
    slli t4, t4, 1         
    srli t5, t5, 1         
    j multiply_loop
multiply_end:
    lw t1, 0(sp)            # Restore t1
    addi sp, sp, 4          # Increment stack pointer
 
    add t0, t0, t6

    # Increment indices by strides
    add t2, t2, a3          
    add t3, t3, a4          

    # Increment loop counter
    addi t1, t1, 1
    j loop_start

#...
#...
```

- **`slli t4, t2, 2`**  
  Converts the index into a byte offset for array 0.
- **`add t5, a0, t4`**  
  Gets the address of `arr0[index0]`.
- Loads the values of the current elements from `arr0` and `arr1` into registers `t4` and `t5`.
- Implements multiplication using addition and bitwise shifts.
- Checks each bit of the multiplier (`t5`) and conditionally adds the multiplicand (`t4`) to the product result (`t6`).
- Adds the computed product of the current pair to the cumulative dot product stored in `t0`.
- Stride Addition (`add t2, t2, a3`, `add t3, t3, a4`)
- Loop Counter Increment (`addi t1, t1, 1`)



--- 
### Task 3.2: Matrix Multiplication
#### Conceptual Overview: Matrix Multiplication
>The matrix multiplication function computes the resulting matrix C (with dimensions n×k) from two input matrices A (dimensions n×m) and B (dimensions m×k).
#### Code
```asm
#...
#...
inner_loop_end:
    # TODO: Add your own implementation
    addi    s0, s0, 1
    mv      t3, a2          # multiplicand = cols0
    mv      t4, s0
    li      t5, 0           # result = 0

multiply_loop:
    beqz    t3, end_multiply_loop 
    andi    t0, t3, 1                 
    beqz    t0, skip_add_a
    add     t5, t5, t4              
skip_add_a:
    slli    t4, t4, 1                 
    srli    t3, t3, 1                 
    j       multiply_loop
end_multiply_loop:
    
    slli t5,t5,2
    add s3, a0, t5
    j outer_loop_start

outer_loop_end:
    lw  ra, 0(sp)         
    lw  s0, 4(sp)         
    lw  s1, 8(sp)         
    lw  s2, 12(sp)        
    lw  s3, 16(sp)      
    lw  s4, 20(sp)        
    lw  s5, 24(sp)        
    addi  sp, sp, 28        
    jr  ra                
#...
#...
```

--- 

## Part B
### Task 1: Read Matrix
>This section replaces the mul instruction with a loop-based implementation that calculates the product of t1 (rows) and t2 (columns)
#### Code 
```asm
#...
#...
# mul s1, t1, t2   # s1 is number of elements
# FIXME: Replace 'mul' with your own implementation
    li      s1, 0 
multiply_loop:
    beqz    t2, mul_done  
    andi    t0, t2, 1          
    beqz    t0, skip_add       
    add     s1, s1, t1         
skip_add:
    slli    t1, t1, 1          
    srli    t2, t2, 1          
    j       multiply_loop      

mul_done:
#...
#...
#...
```
* Because most of code were done by instructor, thus, use the same way to replace instruction of `mul` as we applied on part a.

### Task 2: Write Matrix
#### Code 
```asm
    li      s4, 0           # Initialize result s4 = 0
mul_loop:
    beqz    s3, mul_done     # If multiplier (s3) is 0, multiplication is complete
    andi    t0, s3, 1        # Check if LSB of multiplier is 1
    beqz    t0, skip_add     # If LSB is 0, skip addition
    add     s4, s4, s2       # s4 += multiplicand (s2)
skip_add:
    slli    s2, s2, 1        # multiplicand <<= 1 (shift left)
    srli    s3, s3, 1        # multiplier >>= 1 (shift right)
    j       mul_loop         # Repeat loop
mul_done:
```
* Because most of code were done by instructor, thus, use the same way to replace instruction of `mul` as we applied on part a.

### Task 3: Classification
#### Code 
```asm
#....
#....
#....
    # mul a0, t0, t1 # FIXME: Replace 'mul' with your own implementation
    li      a0, 0           # result = 0
multiply_loop1:
    beqz    t1, end_multiply_loop1 # If multiplier is zero, end multiplication
    andi    t2, t1, 1             # Check if LSB of multiplier is 1
    beqz    t2, skip_add_a1
    add     a0, a0, t0            # result += multiplicand
skip_add_a1:
    slli    t0, t0, 1             # multiplicand <<= 1
    srli    t1, t1, 1             # multiplier >>= 1
    j       multiply_loop1
end_multiply_loop1:
#....
#....
#....
#....
#....
#....
```
* Because most of code were done by instructor, thus, use the same way to replace instruction of `mul` as we applied on part a.
* There are 4 `mul` need to fix.

--- 

## Result of test all 

