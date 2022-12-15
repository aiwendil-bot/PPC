include("branchandprune.jl")
include("propagation.jl")

# w : nombre de semaine, g : nombre de groupe, p : nombre de joueur/groupe

function genere_contraintes_SGP(p::Int, g::Int, w::Int)
    q = g * p # nombre de joueurs
    joueurs = Set(collect(1:q))
    #variables = groupes
    liste_var = [ Variable(Set{Int64}([]), joueurs, p, p, joueurs) for i in 1:(w*g)]
    liste_ctr = Array{Contrainte, 1}()
    # Contrainte intersection vide
    for s in 1:w
        for i in 1:(g-1)
            for j in (i+1):g
                k1 = g*(s-1)+i
                k2 = g*(s-1)+j
                push!(liste_ctr, Contrainte([k1, k2], filtrage_intersection_vide!))
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
                    push!(liste_ctr, Contrainte([k1, k2], filtrage_card_intersection_inferieur_1!))
                end
            end
        end
    end

    return liste_var, liste_ctr
end

#fixe la première semaines, les premiers joueurs des p premiers groupes de chaque semaine

function fixer_variables!(liste_var::Array{Variable, 1}, p::Int, g::Int, w::Int)

    # première semaine

    for i in 1:g
        for j in 1:p
            ajouter!(liste_var[i],p*(i-1)+j)
        end
    end 
    
    #premier groupe 2e semaine
    if w > 1
        for j in 1:p
            ajouter!(liste_var[g+1],1+p*(j-1))
        end
        
        # derniers groupes 2e semaine
        k = g*p-p+1
        for i in g-p+1:g
            ajouter!(liste_var[g+i],k)
            k += 1
            #println(g*(p-1)+i)
            
        end    
        
        # p premiers groupes de chaque semaine à partir de la 2e

        for ww in 2:w
            for i in 1:p
                ajouter!(liste_var[(ww-1)*g+i],i)
            end
        end        

    end



end

# w : nombre de semaine, g : nombre de groupe, p : nombre de joueur
function solve_SGP(p::Int, g::Int,w::Int,symetries_on::Bool)

    @assert g >= p "g doit être >= p"

    println("")
    liste_var, liste_ctr = genere_contraintes_SGP(p, g, w)
    if symetries_on
        fixer_variables!(liste_var, p, g,w)
    end
    println("branch_and_prune")
    faisable = branch_and_prune!(liste_var, liste_ctr)
    println(faisable ? "faisable" : "infaisable")
    if faisable
        #println(liste_var)
        matrice = listes_variables_vers_matrice(liste_var, p, g,w)
        beau_print_res(matrice)
    end
    return faisable
end

function listes_variables_vers_matrice(liste_var::Array{Variable, 1}, p::Int, g::Int, w::Int)
    mat = Array{Array{Int, 1}, 2}(undef, (w, g))
    for semaine in 1:w
        for groupe in 1:g
            indice = g*(semaine-1)+groupe
            mat[semaine, groupe] = collect(liste_var[indice].min)
        end
    end
    return mat
end

function beau_print_res(matrice::Array{Array{Int, 1}, 2})
    w, g = size(matrice)
    for semaine in 1:w
        println("Semaine ", semaine)
        for groupe in 1:g
            println("   groupe ", groupe, " : ", sort(matrice[semaine, groupe]))
        end
    end
end


function main(args)

    p = parse(Int64,args[1])
    g = parse(Int64,args[2])
    w = parse(Int64,args[3])
    symetries_on = parse(Bool,args[4])

    @time solve_SGP(p,g,w,symetries_on)
    
end


main(ARGS)

#=
for p in 2:5
    for g in p:6
        for w in 2:5
            if !([p,g,w] in [[3,3,5],[3,4,5],[3,5,4],[3,5,5],[3,6,5],[4,5,4],[4,5,5],[4,6,2],[4,6,3],[4,6,4],[4,6,5]])
            time_sans = @elapsed solve_SGP(p,g,w, false)
            time_avec = @elapsed solve_SGP(p,g,w, true)
            if solve_SGP(p,g,w,true)
                println("$p & $g & $w & $time_sans & $time_avec" )
            end
        end
        end
        
    end
end            
=#
#=
for param in [[3,4,2],[3,4,3],[3,4,4],[3,5,2],[3,5,3],[4,5,2],[4,5,3],[4,6,2],[5,5,2],[5,5,3],[5,5,4],[5,5,5],[5,5,6]]
        time_sans = @elapsed solve_SGP(param[1], param[2],param[3], false)
        time_avec = @elapsed solve_SGP(param[1], param[2],param[3], true)
        if solve_SGP(param[1], param[2],param[3],true)
            println("$(param[1]) & $(param[2]) & $(param[3]) & $time_sans & $time_avec" )
        end
end   
=#
