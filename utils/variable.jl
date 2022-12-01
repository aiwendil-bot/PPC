#diapo 13 set constraint modelling

mutable struct Variable
    min::Set{Int64}
    max::Set{Int64}
    card_min::Int64
    card_max::Int64

    univers::Set{Int64}

    est_close::Bool

    Variable(min::Set{Int64}, max::Set{Int64},
        card_min::Int64, card_max::Int64,
        univers::Set{Int64},
        est_close::Bool=false) = new(
        Set{Int64}(min),
        Set{Int64}(max),
        card_min,
        card_max,
        univers,
        est_close,
    )
end

# Fait l'intersection la plus large des variables
function intersection(var1::Variable, var2::Variable)::Variable
    min = intersect(var1.min, var2.min)
    max = intersect(var1.max, var2.max) # On ne peut pas trouver moins large
    card_min = length(min)
    card_max = length(max)
    univers = intersect(var1.univers, var2.univers)
    return Variable(min, max, card_min, card_max, univers)
end

# Génère une variable vide
generer_Variable_Vide()::Variable = Variable(Set{Int64}(), Set{Int64}(), 0, 0, true)

function generer_Variable_fixe(valeur::Set{Int})::Variable
    n = length(valeur)
    return Variable(valeur, valeur, n, n, true)
end

# Fixe une variable à une valeur.
function fixer!(var::Variable, valeur::Set{Int})::Variable
    var.min = valeur
    var.max = valeur
    var.card_min = length(valeur)
    var.card_max = var.card_min
    var.est_close = true
    return var
end

# Ajoute une valeur au set min
function ajouter!(var::Variable, valeur::Int)
    push!(var.min, valeur)
    filtrage_individuel!(var)
end

# On modifie le print lors d'un print(var::Variable) ou d'un println(var::Variable)
function Base.show(io::IO, var::Variable)
    compact = get(io, :compact, false)
    sep = ", "
    if !compact
        println(io, "Variable :")
        println(io, "\tmin : ", var.min)
        println(io, "\tmax : ", var.max)
        println(io, "\t", var.card_min, " <= Cardinal <= ", var.card_max)
    else
        print(io, "Variable(")
        print(io, "min:")
        show(io, var.min)
        print(io, sep)
        print(io, "max:")
        show(io, var.max)
        print(io, sep)
        show(io, var.card_min)
        print(io, " <= Cardinal <= ")
        show(io, var.card_max)
    end
end

# Surcharge l'opérateur == pour faire var1 == var2
function Base.:(==)(var1::Variable, var2::Variable)::Bool
    egalite_min = (var1.min == var2.min)
    egalite_max = (var1.max == var2.max)
    egalite_card_min = (var1.card_min == var2.card_min)
    egalite_card_max = (var1.card_max == var2.card_max)
    return egalite_min && egalite_max && egalite_card_min && egalite_card_max
end

# Vérifie si la variable reste valide, ie qu'il n'y a pas de contradiction
function verifie_validite(var::Variable)::Bool
    valide = true
    valide = valide && intersect(var.min, var.max) == var.min
    valide = valide && length(var.max) >= var.card_min
    valide = valide && length(var.min) <= var.card_max
    valide = valide && var.card_min <= var.card_max
    return valide
end

# Vérifie si la variable est close.
# si max = min ou si #min = card_max
function verifie_close(var::Variable)::Bool
    close = false
    close = close || var.min == var.max
    close = close || length(var.min) == var.card_max
    var.est_close = close
    return close
end

# Vérifie si la variable est vide.
function est_vide(var::Variable)::Bool
    vide = false
    if length(var.max) == 0
        vide = true
    end
    if var.car_max == 0
        vide = true
    end
    return vide
end