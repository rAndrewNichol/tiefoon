import csv
import pandas as pd
import numpy as np

# APPARENTLY PANDAS HAS BUILT-IN CSV READER pandas.read_csv(). DARN
# Of course, these functions will work with numpy arrays and python lists as well as pd.DataFrames

# Assumes header, alter later?
def read_csv(file = "", pandas = True):
    cursor = open(file)
    reader_object = csv.reader(cursor)
    rownum = 1
    array = []
    for row in reader_object:
        if rownum == 1:
            header = row
        else:
            array.append(row)
        rownum +=1
    cursor.close()
    if pandas == True:
        df = pd.DataFrame(array)
        df.columns = header
        return df
    else:
        array.insert(0, header)
        return array

# Pandas also has pd.DataFrame.to_csv()  :P

def write_csv(file = "", array = []):
    if type(array) == pd.core.frame.DataFrame:
        header = list(array.columns)
        array = np.array(array)
        array = np.insert(array, 0, header, axis = 0)
    cursor = open(file = file, mode = 'w', newline= "")
    writer = csv.writer(cursor)
    for row in array:
        writer.writerow(row)


