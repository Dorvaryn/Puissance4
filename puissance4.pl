/* Paramètres : S sous-liste, L liste */
prefix(P,L):-append(P,_,L).
sublist(S,L):-prefix(S,L).
sublist(S,[_|T]):-sublist(S,T).

/* Paramètres : L liste, N longueur de la liste */
longueur([],0).
longueur([_|L],N):- longueur(L,N1),
					 N is N1+1.

/* Paramètres : N index de l'élement qu'on veut récupérer, L liste, X élément retourné */
nthElem(N, L, []):- longueur(L, N1), N1 < N.
nthElem(N, L, X):- nth1(N, L, X).				

/* Paramètres : N numéro de la colonne dans laquelle J joue, G grille, J joueur, G' nouvelle grille */		
enregistrerCoup(1, [L|G], J, [[J|L]|G]):- longueur(L,N), N < 6.
enregistrerCoup(N, [T|X], J, [T|G]):- 	N > 0,
										N1 is N-1,
										enregistrerCoup(N1, X, J, G).
										
/* Paramètres : G grille, J joueur */										
finJeuVert([L|_],J):- sublist([J,J,J,J], L),!.
finJeuVert([_|G],J):- finJeuVert(G,J).

/* Paramètres : N numéro de la ligne à partir duquel on traite, G grille, J joueur */
finJeuHor(N, G, J):- maplist(nthElem(N), G, L), 
					 sublist([J,J,J,J],L),!.
finJeuHor(N, G, J):- N > 0,
					 N1 is N-1,
					 finJeuHor(N1, G, J).

finJeuHor(G,J):- finJeuHor(6, G, J).				 

/* Paramètres : G grille, J joueur, P profondeur, A arbre obtenu */
tracerArbre(G, J, 0, A).