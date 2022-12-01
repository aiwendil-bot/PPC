include("../utils/contrainte.jl")
include("../utils/filtrage.jl")

function branch_and_bound!(liste_variables::Array{Variable, 1}, liste_contraintes::Array{Contrainte, 1})

    faisable = propagation!(liste_variables, liste_contraintes)
    if faisable
        #liste des variables non closes
        liste_non_close = findall(var -> !verifie_close(var), liste_variables)
        if !isempty(liste_non_close) # condition d'arrêt
            # Stratégie 1 : brancher sur la variable la plus proche d'être close
            #sort!(liste_non_close, by = e -> liste_variables[e].card_max - length(liste_variables[e].min), )

            # Stratégie 2 : brancher sur la variable qui touche le plus de contraintes
            sort!(liste_non_close, by = e -> nb_occurences_contraintes(e,liste_variables,liste_contraintes),rev=true)
            
            indice_branchement = liste_non_close[1]
            var = liste_variables[indice_branchement]

            #liste des candidats = différence entre max et min
            candidat_ajout = collect(setdiff(var.max, var.min))
            
            n = length(candidat_ajout)
            indice_valeur = 1
            faisable_temp = false
            liste_variables_temp = []

            #tant qu'on n'a pas tout testé pour cette variable & que c'est infaisable
            while indice_valeur <= n && !faisable_temp
                
                #on fait une copie des variables à ce branchement 
                liste_variables_temp = deepcopy(liste_variables)
                valeur_ajout = candidat_ajout[indice_valeur]

                #on ajoute la var candidate au min de la variable
                ajouter!(liste_variables_temp[indice_branchement], valeur_ajout)
                faisable_temp = branch_and_bound!(liste_variables_temp, liste_contraintes)
                indice_valeur += 1

                # On sait le problème infaisable avec, alors on le retire.
                if !faisable_temp
                    setdiff!(liste_variables[indice_branchement].max, valeur_ajout)
                end
            end
            #si c'est faisable, on assigne les variables
            if faisable_temp
                for i in 1:length(liste_variables) # assignation
                    liste_variables[i] = liste_variables_temp[i]
                end
            else
                #sinon, on continue
                faisable_temp = propagation!(liste_variables, liste_contraintes)
                faisable = faisable_temp # pas faisable
            end
        end
    end
    return faisable
end

function nb_occurences_contraintes(indice::Int64,liste_variables::Array{Variable, 1},liste_contraintes::Array{Contrainte, 1})::Int64
    compteur = 0
    for contrainte in liste_contraintes
        if indice in contrainte.liste_indices_variables
            compteur += 1
        end
    end
    return compteur
end