from pysat.solvers import Glucose4
import numpy as np


# modèle simple, avec symétries


#@params

# q : nombre de golfeurs
# p : nb de golfeurs par groupe
# g : nb de groupes
# w : nb de semaines
def sat_model(q: int, p: int, g: int,w: int):
    model = Glucose4()

    Xlist = [i for i in range(1, q * p * g * w + 1)]

    X = np.asarray(Xlist, int).reshape((q, p, g, w))

    contrainte1 = []

    for i in range(q):
        for l in range(w):
            contrainte1.append([X[i, j, k, l].item() for j in range(p) for k in range(g)])
    #print(contrainte1)
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


    contraintes_socia = []

    for l in range(w):
        for k in range(g):
            for m in range(q):
                for n in range(m+1,q):
                    for kk in range(g):
                        for ll in range(l+1,w):
                            A = [X[m,j,k,l].item() for j in range(p)]
                            B = [X[n,j,k,l].item() for j in range(p)]
                            C = [X[m,j,kk,ll].item() for j in range(p)]
                            D = [X[n,j,kk,ll].item() for j in range(p)]

                            for a in range(p):
                                for b in range(p):
                                    for c in range(p):
                                        for d in range(p):
                                            contraintes_socia.append([-A[a],-B[b],-C[c],-D[d]])


    model.append_formula(contraintes_socia)
    print(model.solve())
    test = np.asarray(model.get_model(), int).reshape((q, p, g, w))
    indices = [(i,j,k,l) for i in range(q) for j in range(p) for k in range(g) for l in range(w) if test[i,j,k,l] >0]


    for l in range(w):
        print([[ elem[0] + 1 for elem in indices for j in range(p) if elem[1] == j and elem[2] == k and elem[3] == l ] for k in range(g)])



sat_model(12, 3, 4, 2)
