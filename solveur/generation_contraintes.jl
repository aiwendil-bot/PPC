
function genere_contrainte_SGP(w::Int, g::Int, p::Int)
    q = g * p # nombre de joueurs
    joueurs = Set(collect(1:q))
    liste_var = [ Variable(Set{Int64}([]), joueurs, p, p, joueurs) for i in 1:(w*g)]
    liste_ctr = Vector{Contrainte}(undef,Int(w*g*(g-1)/2 + g*g*w*(w-1)/2))
    k=1
    # Contrainte intersection vide
    for s in 1:w
        for i in 1:(g-1)
            for j in (i+1):g
                k1 = g*(s-1)+i
                k2 = g*(s-1)+j
                liste_ctr[k] = Contrainte([k1, k2], filtrage_intersection_vide!)
                k += 1
            end
        end
    end
    # Contrainte card(v1 inter v2) <= 1
    for s1 in 1:(w-1)
        for s2 in (s1+1):w
            for i in 1:g
                for j in 1:g
                    k1 = g*(s1-1)+i
                    k2 = g*(s2-1)+j
                    liste_ctr[k] = Contrainte([k1, k2], filtrage_card_intersection_inferieur_1!)
                    k += 1
                end
            end
        end
    end


    return liste_var, liste_ctr
end