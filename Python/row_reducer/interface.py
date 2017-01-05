import ref_functions as ref
import numpy as np
import pandas as pd
import re

# to take a user input of rows and create a matrix
print("Please note that if you do not correctly input the correct number of rows and a consistent"
      " number of columns, the program may not work as intended.")

rows = int(input("Number of Rows: "))
raw_strings = []
# function input_rows?
for i in range(rows):
    raw_strings.append(input("Row %d (Separated by spaces): " %i))

array = []

# put this function in a separate 'functions' file?
# functions strings_to_array?
for row in raw_strings:
    temp_list = []
    while re.search('^\s*[0-9]+',row) != None:
        new_entry = int(re.search('^\s*[0-9]+', row).group())
        row = re.sub('^\s*[0-9]+', "", row)
        temp_list.append(new_entry)
    array.append(temp_list)

matrix = np.array(array)
# print('\n')
# print(array)
# print('\n')
# print(matrix)
# print('\n')
for row in array: print(row)

print(ref.ref(array))
print(ref.rref(array))

# (bvector boolean arg? reduced arg?(probly not, keep it simple), include determinant?)
