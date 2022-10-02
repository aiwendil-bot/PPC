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
           forall(p1,p2 in PLAYERS, g1,g2 in NBGROUPS, w1,w2 in WEEKS)(
                 if p1 != p2 /\ (g1 != g2 \/ w1 != w2) /\ p1 in solution[g1,w1] /\ p2 in solution[g1,w1] /\ p1 in solution[g2,w2] then {p2} intersect solution[g2,w2] == {} endif );

solve satisfy;

output [ show(solution[i,j]) ++ " " ++
         if j == g then "\n" else "" endif |
         i in WEEKS, j in NBGROUPS ];
              

