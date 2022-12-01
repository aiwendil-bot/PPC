

function propagation!(liste_variables::Array{Variable, 1}, liste_contraintes::Array{Contrainte, 1})

    # tableau qui associe toutes les contraintes d'une variable à l'indice de cette dernière dans liste_variables
    array_contrainte_variable = [
        findall(ctr -> indice in ctr.liste_indices_variables, liste_contraintes)
        for indice in 1:length(liste_variables)
    ]

    liste_filtrage_restant = collect(length(liste_contraintes):-1:1)
    infaisable = false
    while !isempty(liste_filtrage_restant) && !infaisable
        
        #on dépile la première contrainte
        indice_ctr = pop!(liste_filtrage_restant)
        ctr = liste_contraintes[indice_ctr]
        
        #on copie les variables associées à la contrainte
        arguments = [deepcopy(liste_variables[i]) for i in ctr.liste_indices_variables]

        #on filtre les variables selon la contrainte
        filtrer!(ctr, liste_variables)
        
        #réveille les contraintes liées à la variable qui vient
        #d'être modifiée
        
        #pour chaque variable concernée par la contrainte
        for indice_var in ctr.liste_indices_variables
            var = liste_variables[indice_var]
            #s'il reste des valeurs possibles pour la variable
            if verifie_validite(var)
                #si la variable a changé
                if !(var in arguments)
                    for indice in array_contrainte_variable[indice_var]
                        #Ne pas mettre plusieurs fois la même contrainte en attente.
                        if !(indice in liste_filtrage_restant)
                            push!(liste_filtrage_restant, indice)
                        end
                    end
                end
            else
                infaisable = true
            end
        end
    end
    return !infaisable # retourne true si le solver a trouvé le problème faisable.
end