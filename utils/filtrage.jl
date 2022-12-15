include("variable.jl")

function filtrer!(ctr::Contrainte, liste_variables::Vector{Variable})
    liste_arguments = [liste_variables[i] for i in ctr.liste_indices_variables]
    ctr.filtrage!(liste_arguments)

end

# Filtrages SGP

function filtrage_intersection_vide!(liste_Variable::Vector{Variable})
    var1, var2 = liste_Variable
        setdiff!(var1.max, var2.min)

        setdiff!(var2.max, var1.min)

    return nothing
end

function filtrage_card_intersection_inferieur_1!(liste_Variable::Vector{Variable})
    var1, var2 = liste_Variable
    inter = intersect(var1.min, var2.min)

    if !isempty(inter)
        valeur = pop!(inter)

        min_v1 = setdiff(var1.min, valeur)
        setdiff!(var2.max, min_v1)

        min_v2 = setdiff(var2.min, valeur)
        setdiff!(var1.max, min_v2)

    end
    return nothing
end













