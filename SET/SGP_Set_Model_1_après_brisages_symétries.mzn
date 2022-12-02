include "partition_set.mzn";


% Constantes

int: w; %nb semaines
int: g; %nb groupes
int: p; %nb de joueurs par groupe
int: q = g*p; %nb total de joueurs

% Variables

set of int: PLAYERS = 1..q;
set of int: WEEKS = 1..w;
set of int: NBGROUPS = 1..g;
set of int: SIZEGROUPS = 1..p;
array[WEEKS,NBGROUPS] of var set of PLAYERS: solution;

% Contraintes (ordre de la feuille)

constraint forall(i in WEEKS, j in NBGROUPS)(card(solution[i,j]) = p) 
           /\
           forall(i in WEEKS)(partition_set([solution[i,j] | j in NBGROUPS],PLAYERS))
           /\
           forall (i in 1..w-1, j in i+1..w) (
              forall (k,l in NBGROUPS) (
            card(solution[i,k] intersect solution[j,l]) <= 1
        ));

%Contraintes brisage symétries (ordre feuille)

% première contrainte : on ne peut pas ordonner un set dans minizinc

%fixer la 1ère semaine: 

constraint forall(i in NBGROUPS, j in SIZEGROUPS) (((i-1)*p + j) in solution[1,i]);

% premier groupe 2e semaine
constraint forall(j in SIZEGROUPS) ((1 + p*(j-1)) in solution[2,1]);

% p derniers groupes 2e semaine

constraint forall(j in (g-p+1)..g) ( g*(p-1) + j in solution[2,j]);

% p premiers groupe de chaque semaine >=2

constraint forall(i in 2..w, j in SIZEGROUPS) (j in solution[i,j]);

solve satisfy;

output [ show(solution[i,j]) ++ " " ++
         if j == g then "\n" else "" endif |
         i in WEEKS, j in NBGROUPS ];
              

