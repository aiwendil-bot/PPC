function solver_generique!(liste_variables::Array{Variable, 1}, liste_contraintes::Array{Contrainte, 1})
    # tableau qui associe toutes les contraintes d'une variable à l'indice de cet dernière dans liste_variables
    array_contrainte_variable = [
        findall(ctr -> indice in ctr.liste_indice_arguments, liste_contraintes)
        for indice in 1:length(liste_variables)
    ]

    liste_filtrage_restant = collect(length(liste_contraintes):-1:1)
    infaisable = false
    while !isempty(liste_filtrage_restant) && !infaisable
        indice_ctr = pop!(liste_filtrage_restant)
        ctr = liste_contraintes[indice_ctr]
        arguments = [deepcopy(liste_variables[i]) for i in ctr.liste_indice_arguments]
        filtrer!(ctr, liste_variables)
        for indice_var in ctr.liste_indice_arguments
            var = liste_variables[indice_var]
            if verifie_validite(var)
                if !(var in arguments) # A changer
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