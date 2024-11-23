import random
import math

def gen(frac=0.3, N=70_000):
    if not (0 < frac <= 1):
        raise ValueError("frac must be between 0 and 1 (exclusive).")
    if N <= 0:
        raise ValueError("N must be a positive integer.")

    p = list(range(1, N + 1))
    random.shuffle(p)
    
    outvec = p[:]
    
    while len(p) > 1:

        new_size = math.floor(frac * len(p))
        p = p[:new_size]
        outvec = p + outvec

    random.shuffle(outvec)
    return outvec