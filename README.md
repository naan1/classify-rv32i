# Assignment 2: Classify
## function  
## Part A      
### Task 1: Absolute Value 
this part is a walkthrough to make sure the value is positive
```asm
# ...
sub  t0, x0, t0  
sw   t0 0(a0)
# ...
```
- - - - - 



### Task 2: ReLU        
#### Conceptual Overview: ReLU
> ReLU (Rectified Linear Unit) is an activation function used in neural networks.
> It outputs the input directly if it is positive, otherwise returns zero.
> mathematical formula:
$\text{ReLU}(x) = \max(0, x)$

#### code   
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

### Task 3: Argmax         

#### Conceptual Overview: Argmax  
>The Argmax function finds the index of the maximum value in an array. If there are multiple maximum values, it returns the index of the first occurrence. This is particularly useful in applications like classification problems where the position of the highest probability (argmax) indicates the predicted class.

#### code  
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

### Task 4: Dot Product
#### Conceptual Overview: Dot Product  
>The dot product is a mathematical operation that multiplies corresponding elements of two arrays and sums the results. This function calculates the dot product with a stride, meaning it skips elements in each array by a specified number of positions (stride0 and stride1) during the computation.

#### code  
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
--- 

## Part B
### Task 1: Read Matrix
#### code 

### Task 2: Write Matrix
#### code 

### Task 3: Classification
#### code 

---
--- 

## result of test all 

