

function main()

    w::Int64 = 2 #nb semaines
    g::Int64 = 4 #nb groupe par semaine
    p::Int64 = 3 #nb golfeurs par groupes
    q::Int64 = g*p

    #Initialisation de la structure de données pour une solution
    solution::Vector{Vector{Vector{Int64}}} = Vector{Vector{Vector{Int64}}}(undef,w)
        solution[i] = Vector{Vector{Int64}}(undef,g)
        for j = 1:g
            solution[i][j] = Vector{Int64}(undef,p)
        end
    end
    
    



    
    #unite de test 
    solution = [[[1,2,3],[4,5,6],[7,8,9],[10,11,12]],[[1,2,3],[4,5,6],[7,8,9],[10,11,12]]]
    println("contrainte 2 : ",contrainte_2(solution,w,g,p))
    println("contrainte 3 : ",contrainte_3(solution,w,g,p))

    #println(solution)
    display(solution,w,g,p)

    #Vecteur de pointeur vers les ensembles constituant les groupes de joueurs dans chaques semaines
    ensembles::Vector{Vector{Int64}} = Vector{Vector{Int64}}(undef,0)
    for i = 1:w
        append!(ensembles,solution[i])
    end

    

end

function display(sol,w,g,p)
    for i = 1:w
        print("week ",i," : | ")
        for j = 1:g
            for k = 1:p
                print(sol[i][j][k]," ")
            end
            print("| ")
        end
        println("")
    end
end

#contrainte_1 : vérifiée par la taille du vecteur

function contrainte_2(sol,w,g,p) #

    q = g * p

    satisfaite = true
    for i = 1:w
        players_in_week::Vector{Int64} = Vector{Int64}(undef,q)
        for j = 1:g
            append!(players_in_week,sol[i][j])
        end
        #println(players_in_week)
    end

    return satisfaite
end

function contrainte_3(sol,w,g,p) #redondant avec le allDiff

    q = g * p
    players_in_weeks::Vector{Vector{Int64}} = Vector{Vector{Int64}}(undef,w)
    
    for i = 1:w
        players_in_weeks[i] = Vector{Int64}(undef,0)
    end
    for i = 1:w
        for j = 1:g
            append!(players_in_weeks[i],sol[i][j])
        end
    end

    satisfait = true

    for i = 1:w
        for player = 1:q
            if !(player in players_in_weeks[i])
                satisfait = false
            end
        end
    end

    return satisfait

end

function contrainte_4(sol,w,g,p)

    q = g*p

    satisfait = true

    #ouai

    return satisfait

end

function allDiff(vect)
    satisfait = true
    present::Vector{Int64} = Vector{Int64}(undef,0)
    i = 1
    while i <= length(vect) && satisfait
        #println(vect[i]," /// ",present)
        if vect[i] in present
            satisfait = false
        end
        append!(present,vect[i])
        i += 1
    end
    return satisfait
end


main()