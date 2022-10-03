from pysat.solvers import Glucose4
from pysat.formula import CNF
import numpy as np


# modèle simple, avec symétries

def sat_model(q: int, w: int, g: int, p: int):
    model = Glucose4()

    Xlist = [i for i in range(1, q * p * g * w + 1)]

    X = np.asarray(Xlist, int).reshape((q, p, g, w))

    print(X[0,0,0,0].item())
    contrainte1 = []

    for i in range(q):
        for l in range(w):
            contrainte1.append([X[i, j, k, l].item() for j in range(p) for k in range(g)])

    model.append_formula(contrainte1)

    contrainte2 = []

    for i in range(q):
        for l in range(w):
            for j in range(p - 1):
                for k in range(g):
                    for m in range(j + 1, p):
                        contrainte2.append([-X[i, j, k, l].item(), -X[i, m, k, l].item()])

    model.append_formula(contrainte2)

    contrainte3a = []

    for i in range(q):
        for l in range(w):
            for j in range(p):
                for k in range(g - 1):
                    for m in range(k + 1, g):
                        for n in range(p):
                            contrainte3a.append([-X[i, j, k, l].item(), -X[i, n, m, l].item()])

    model.append_formula(contrainte3a)

    contrainte3b = []

    for l in range(w):
        for k in range(g):
            for j in range(p):
                contrainte3b.append([X[i, j, k, l].item() for i in range(q)])

    model.append_formula(contrainte3b)

    contrainte3c = []

    for l in range(w):
        for k in range(g):
            for j in range(p):
                for i in range(q - 1):
                    for m in range(i + 1, q):
                        contrainte3c.append([-X[i, j, k, l].item(), -X[m, j, k, l].item()])

    model.append_formula(contrainte3c)

    #reste sociabilisation

    contraintes_socia = []

    for l in range(w-1):
        for k in range(p):
            for m in range(q-1):
                for n in range(m+1,q):
                    for kk in range(g):
                        for ll in range(l+1,w):
                            temp = CNF(from_clauses=[[X[m,j,k,l].item() for j in range(p)], [X[n,j,k,l].item() for j in range(p)],
                                                     [X[m,j,kk,ll].item() for j in range(p)], [X[n,j,k,l].item() for j in range(p)]])
                            neg = temp.negate()
                            model.append_formula(neg.clauses)

    print(model.solve())
    print(model.get_model())


sat_model(12, 4, 3, 2)
