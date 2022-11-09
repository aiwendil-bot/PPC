function branch_and_bound!(liste_variables::Array{Variable, 1}, liste_contraintes::Array{Contrainte, 1})
    function inf_diff_card(left, right)
        left_var = liste_variables[left]
        right_var = liste_variables[right]
        return  left_var.card_max - length(left_var.min) <=
                right_var.card_max - length(right_var.min)
    end
    faisable = solver_generique!(liste_variables, liste_contraintes)
    if faisable
        liste_non_close = findall(var -> !verifie_close(var), liste_variables)
        if !isempty(liste_non_close) # condition d'arret
            # branchement sur le plus petit écart entre la taille des bornes (pour clore rapidement)
            sort!(liste_non_close, by = e -> liste_variables[e].card_max - length(liste_variables[e].min) )
            indice_branchement = liste_non_close[1]
            var = liste_variables[indice_branchement]
            candidat_ajout = collect(setdiff(var.max, var.min))
            n = length(candidat_ajout)
            indice_valeur = 1
            faisable_temp = false
            liste_variables_temp = []
            while indice_valeur <= n && !faisable_temp
                liste_variables_temp = deepcopy(liste_variables)
                valeur_ajout = candidat_ajout[indice_valeur]
                ajouter!(liste_variables_temp[indice_branchement], valeur_ajout)
                faisable_temp = branch_and_bound!(liste_variables_temp, liste_contraintes)
                indice_valeur += 1
                # On sait le problème infaisable avec, alors on le retire.
                if !faisable_temp
                    setdiff!(liste_variables[indice_branchement].max, valeur_ajout)
                end
            end
            if faisable_temp
                for i in 1:length(liste_variables) # assignation
                    liste_variables[i] = liste_variables_temp[i]
                end
            else
                faisable_temp = branch_and_bound!(liste_variables, liste_contraintes)
                faisable = faisable_temp # pas faisable
            end
        end
    end
    return faisable
end