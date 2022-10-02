from pysat.solvers import Glucose4
import numpy as np


# modèle simple, avec symétries

def sat_model(q: int, w: int, g: int, p: int):
    g = Glucose4()

    Xlist = [i for i in range(1, q * p * g * w + 1)]

    X = np.asarray(Xlist).reshape((q, p, g, w))

    contrainte1 = []

    for i in range(q):
        for l in range(w):
            contrainte1.append([X[i, j, k, l] for j in range(p) for k in range(g)])

    g.append_formula(contrainte1)

    contrainte2 = []

    for i in range(q):
        for l in range(w):
            for j in range(p - 1):
                for k in range(g):
                    for m in range(j + 1, p):
                        contrainte2.append([-X[i, j, k, l], -X[i, m, k, l]])

    g.append_formula(contrainte2)

    contrainte3a = []

    for i in range(q):
        for l in range(w):
            for j in range(p):
                for k in range(g - 1):
                    for m in range(k + 1, g):
                        for n in range(p):
                            contrainte3a.append([-X[i, j, k, l], -X[i, n, m, l]])

    g.append_formula(contrainte3a)

    contrainte3b = []

    for l in range(w):
        for k in range(g):
            for j in range(p):
                contrainte3b.append([X[i, j, k, l] for i in range(q)])

    g.append_formula(contrainte3b)

    contrainte3c = []

    for l in range(w):
        for k in range(g):
            for j in range(p):
                for i in range(q - 1):
                    for m in range(i + 1, q):
                        contrainte3c.append([-X[i, j, k, l], -X[m, j, k, l]])

    g.append_formula(contrainte3c)

    #reste sociabilisation

sat_model(6, 2, 3, 3)
