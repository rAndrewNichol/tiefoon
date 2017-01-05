import numpy as np


# input a matrix defined by a numpy array or a python list of lists (of appropriate numerical values and dimensions)
# add ncol instead of len(sorted[0])-1?
def ref(matrix = []):
    original = np.array(matrix)
    #print("original: ", original)
    #print( "original.shape: ", original.shape)
    # special case that the matrix is empty (should only occur if an empty matrix is passed)
    if original.shape == (0,) or original.shape == (1,0) or len(original.shape) == 1:
        print("base-case reached"); return matrix
    else:
        sorted = []
        # add an extra column with the index of the first nonzero value in each row
        for row in original:
            index = 0
            for x in row:
                if x == 0:
                    index += 1
                else: break
            row = np.hstack([row,index])
            sorted.append(row)
        sorted = np.array(sorted)
        # Sort matrix by last column (indexes of first non-zero entry)
        nrows = sorted.shape[0]
        ncols = sorted.shape[1]
        sorted = sorted[sorted[:, ncols - 1].argsort()]
        #print("indexed: ", sorted)
        # If we have reached one row of remainder, we are done.
        if nrows == 1:
            print("base-case reached")
            # reduce the last pivot column such that the pivot is 1
            if sorted[ 0 , sorted[0, ncols-1]] == 0 or sorted[ 0 , ncols-1] > ncols-2:
                return sorted[ 0 , :ncols-1]
            else:
                return sorted[ 0 , :ncols-1] / sorted[ 0 , sorted[0, ncols-1]]
        # Divide first pivot row by its pivot to create a 1.
        sorted[0, :ncols-1] = sorted[0, :ncols-1]/sorted[0 , sorted[0, ncols-1]]
        reduced = sorted[0]
        #print(sorted, "\n")
        # Reduce all entries below pivots.
        for row in sorted[1:,:]:
            if row[sorted[ 0 , ncols-1]] != 0:
                row = row - (row[sorted[ 0 , ncols-1]] * sorted[0])
                reduced = np.vstack([reduced,row])
            else: reduced = np.vstack([reduced,row])
        #print("reduced: ", reduced)
        # Recursively run the function on submatrices
        reduced[1: , :ncols-1] = ref(reduced[1: , :ncols-1])
        # Return our matrix without the index column
        return reduced[ : , :ncols-1]

# nrows and ncols as array.shape[0] and array.shape[1] ffs
def reduce_up(matrix = []):
    original = np.array(matrix)
    #print("original:", original)
    #print("original.shape: ", original.shape, "len: ", len(original.shape))
    if original.shape[0] == 1 or len(original.shape) == 1:
        print("base-case reached")
        return matrix
    # special case that the matrix is empty (should only occur if an empty matrix is passed)
    elif original.shape == (0,): print("base-case reached"); return matrix
    else:
        indexed = []
        for row in original:
            index = 0
            for x in row:
                if x == 0:
                    index += 1
                else:
                    break
            row = np.hstack([row, index])
            indexed.append(row)
        indexed = np.array(indexed)
        nrows = indexed.shape[0]
        ncols = indexed.shape[1]
        #print("indexed:", indexed)
        reduced = indexed[nrows-1]
        for row in reversed(indexed[ :nrows - 1, : ]):
            if indexed[nrows-1,ncols-1] > ncols-2 or row[indexed[nrows-1,ncols-1]] == 0:
                reduced = np.vstack([row, reduced])
            else:
                row = row - (row[indexed[nrows-1,ncols-1]] * indexed[nrows-1])
                reduced = np.vstack([row,reduced])
        #print("reduced:", reduced)
        reduced[ :nrows-1 , :ncols-1] = reduce_up(reduced[ :nrows-1,:ncols-1])
        return reduced[ :, :ncols-1]

def rref(matrix = []):
    reduced_down = ref(matrix)
    reduced_up = reduce_up(reduced_down)
    return reduced_up

