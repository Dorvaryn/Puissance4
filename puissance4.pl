max(X,Y,Y) :- Y>X, !.
max(X,Y,X). 

% Fonction qui renvoie une sous-liste à partir d'une liste L
% description...
/* Paramètres : S sous-liste, L liste */
prefix(P,L):-append(P,_,L).
sublist(S,L):-prefix(S,L).
sublist(S,[_|T]):-sublist(S,T).

% Fonction qui retourne la longueur d'une liste
/* Paramètres : L liste, N longueur de la liste */
longueur([],0).
longueur([_|L],N):- longueur(L,N1),
					 N is N1+1.

% Fonction qui renvoie le nième élément d'une liste 
/* Paramètres : N index de l'élement qu'on veut récupérer, L liste, X élément retourné */
nthElem(N, L, []):- longueur(L, N1), N1 < N.
nthElem(N, L, X):- nth1(N, L, X).				

% Fonction qui enregistre un coup joué dans la grille
/* Paramètres : N numéro de la colonne dans laquelle J joue, G grille, J joueur, G' nouvelle grille */		
enregistrerCoup(1, [L|G], a, _, I):- longueur(L,N), N >= 6, write('Coup Invalide\n'), jouerCoupA(I).
enregistrerCoup(1, [L|G], b, _, I):- longueur(L,N), N >= 6, write('Coup Invalide\n'), jouerCoupB(I).
enregistrerCoup(1, [L|G], J, [[J|L]|G], I):- longueur(L,N), N < 6.
enregistrerCoup(N, [T|X], J, [T|G], I):- 	N > 0,
										N1 is N-1,
										enregistrerCoup(N1, X, J, G, I).

% Condition de victoire verticale : 4 jetons les uns après les autres sur une même colonne
/* Paramètres : G grille, J joueur */										
finJeuVert([L|_],J):- sublist([J,J,J,J], L),!.
finJeuVert([_|G],J):- finJeuVert(G,J).

% Condition de victoire horizontale : 4 jetons les uns après les autres sur une même ligne
/* Paramètres : N numéro de la ligne à partir duquel on traite, G grille, J joueur */
finJeuHor(N, G, J):- maplist(nthElem(N), G, L), 
					 sublist([J,J,J,J],L),!.
finJeuHor(N, G, J):- N > 0,
					 N1 is N-1,
					 finJeuHor(N1, G, J).

finJeuHor(G,J):- finJeuHor(6, G, J).				 

% Définition et test des conditions de fin de jeu
/* Paramètres : G grille, J joueur */
finJeu(G, J):- finJeuVert(G,a), J=a.
finJeu(G, J):- finJeuVert(G,b), J=b.
finJeu(G, J):- finJeuHor(G,a), J=a.
finJeu(G, J):- finJeuHor(G,b), J=b.

% Affichage du gagnant
/* Paramètres : J joueur */
gagnant(J):-write('Le Joueur '), write(J), write(' a gagné !').


/* Paramètres : G grille*/
jouerCoupA(G):-finJeu(G,J), gagnant(J),!.
jouerCoupB(G):-finJeu(G,J), gagnant(J),!.
jouerCoupA(G):- write('Joueur A, entrez un numéro de colonne : '),
				read(N), enregistrerCoup(N,G, a, X, G),
				write(X),
				write('\n'),
				jouerCoupB(X).
jouerCoupB(G):- write('Joueur B, entrez un numéro de colonne : '),
				read(N), enregistrerCoup(N,G, b, X, G),
				write(X),
				write('\n'),
				jouerCoupA(X).

% Lancement du jeu : grille de départ de 6*7 (vide). C'est le joueur 'a' qui commence, suivi par b, jusqu'à ce que l'un des deux gagne [ou GRILLE PLEINE]
jouer:- jouerCoupA([[],[],[],[],[],[],[]]).

enregistrerCoupArbre(1, [L|G], J, [[J|L]|G]):- longueur(L,N), N < 6.
enregistrerCoupArbre(N, [T|X], J, [T|G]):- 	N > 0,
										N1 is N-1,
										enregistrerCoupArbre(N1, X, J, G).

% Evaluation de la grille de jeu
/* Paramètres : G grille, J joueur */
evalVert([], _, P, X):- X=P, write(fini).										
evalVert([L|G],J, P, X):- 	sublist([J,J,J,J], L),
							evalVert(G, J, P, 4, X).
evalVert([L|G],J, P, X):- 	sublist([J,J,J], L),
							evalVert(G, J, P, 3, X).
evalVert([L|G],J, P, X):- 	sublist([J,J], L),
							evalVert(G, J, P, 2, X).
evalVert([L|G],J, P, X):- evalVert(G, J, P, 1, X).
evalVert(G,J, P1, P2, X):- 	max(P1, P2, P),
							evalVert(G, J, P, X).
evalVert(G, J, X):- evalVert(G,J, 0, 1, X).

/* Paramètres : N numéro de la ligne à partir duquel on traite, G grille, J joueur */
evalHor(_,[],J,P):- write(fini).
evalHor(N, G, J, P):- maplist(nthElem(N), G, L), 
					 sublist([J,J,J,J],L),
					 evalHor(N, G, J, P, 4).
evalHor(N, G, J, P):- maplist(nthElem(N), G, L), 
					 sublist([J,J,J],L),
					 evalHor(N, G, J, P, 3).
evalHor(N, G, J, P):- maplist(nthElem(N), G, L), 
					 sublist([J,J],L),
					 evalHor(N, G, J, P, 2).
evalHor(N, G, J, P):- maplist(nthElem(N), G, L), 
					 sublist([J],L),
					 evalHor(N, G, J, P, 1).
evalHor(N, G, J, P1, P2):- N > 0,
					 N1 is N-1,
					 write(toto),
					 max(P1, P2, P),
					 evalHor(N1, G, J, P),
					 write(P).
evalHor(G,J,P):- evalHor(6, G, J, 0, 1).

evalGrille(G, J, X) :- evalHor(G,J,P1),
					evalVert(G, J, P2),	
					max(P1,P2, X).								
										
/* Paramètres : G grille, J joueur, P profondeur, A arbre obtenu */
tracerArbre(G, J, 0, A).
tracerArbre(G, J, P, A):- P > 0,
					      P1 is P-1,
						  tracerBranche(G, J, P1, A, 7).

tracerBranche(G, J, P, A, 1).						  
tracerBranche(G, a, P, A, N):- N > 0,
							   N1 is N-1,
							   enregistrerCoupArbre(N, G, a, X), 
							   tracerArbre(X, b, P, A),
							   tracerBranche(G, a, P, A, N1).			
tracerBranche(G, b, P, A, N):- N > 0,
							   N1 is N-1,
							   enregistrerCoupArbre(N, G, b, X), 
							   tracerArbre(X, a, P, A),
							   tracerBranche(G, b, P, A, N1).