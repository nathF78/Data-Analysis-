clear variables;clc
% tolerance relative minimum pour l'ecart entre deux iteration successives 
% de la suite tendant vers la valeur propre dominante 
% (si |lambda-lambda_old|/|lambda_old|<eps, l'algo a converge)
eps = 1e-8;
% nombre d iterations max pour atteindre la convergence 
% (si i > kmax, l'algo finit)
imax = 5000; 

% Generation d une matrice rectangulaire aleatoire A de taille n x p.
% On cherche le vecteur propre et la valeur propre dominants de AA^T puis
% de A^TA
n = 1500; p = 500;
A = 5*randn(n,p);

% AAt, AtA sont deux matrices carrees de tailles respectives (n x n) et 
% (p x p). Elles sont appelees "equations normales" de la matrice A
AAt = A*A'; AtA = A'*A;

start1 = cputime;
%% Methode de la puissance iteree pour la matrice AAt de taille nxn
% Point de depart de l'algorithme de la puissance iteree : un vecteur
% aleatoire, normalise
x = ones(n,1); x = x/norm(x);

cv = false;
iv1 = 0;        % pour compter le nombre d'iterations effectuees
t_v1 = cputime; % pour calculer le temps d execution de l'algo
err1 = 0;       % indication que le calcul est satisfaisant
                % on stoppe quand err1 < eps 
disp('** 1er **')
lambda1 = x'*AAt*x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODER L'ALGORITHME DE LA PUISSANCE ITEREE POUR LA MATRICE AAt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while(~cv)
   mu = lambda1;
   x = AAt*x;
   x = x/norm(x);
   lambda1 = x'*AAt*x;
   iv1 = iv1 + 1;
   cv = or(abs(lambda1 - mu)/abs(mu) <= eps, iv1 >= imax); 
   end
t_v1 = cputime-t_v1; % t_version1 : temps d execution de l algo de la 
                     % puissance iteree pour la matrice AAt
err1 = abs(mu-lambda1)/abs(mu);

stop1 = cputime-start1;
start2 = cputime;

%% Methode de la puissance iteree pour la matrice AtA de taille pxp
% Point de depart de l'algorithme de la puissance iteree : un vecteur
% aleatoire, normalise
y = ones(p,1); 
y = y/norm(y);

cv = false;
iv2 = 0;        % pour compter le nombre d iterations effectuees
t_v2 = cputime; % pour calculer le temps d execution de l'algo
err2 = 0;       % indication que le calcul est satisfaisant
                % on stoppe quand err2 < eps 
disp('** 2eme **')
lambda2 = y'*AtA*y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODER L ALGORITHME DE LA PUISSANCE ITEREE POUR LA MATRICE AtA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while(~cv)
   mu = lambda2;
   y = AtA*y;
   y = y/norm(y);
   lambda2 = y'*AtA*y;
   iv2 = iv2 + 1;
   cv = or(abs(lambda2 - mu)/abs(mu) <= eps, iv2 >= imax); 
end
t_v2 = cputime-t_v2;
err2 = abs(mu-lambda2)/abs(mu);
stop2 = cputime-start2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APRES VOUS ETRE ASSURE DE LA CONVERGENCE DES DEUX METHODES, AFFICHER 
% L'ECART RELATIF ENTRE LES DEUX VALEURS PROPRES TROUVEES, ET LE TEMPS
% MOYEN PAR ITERATION POUR CHACUNE DES DEUX METHODES. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ecart = abs(lambda1-lambda2)/abs(lambda1);

fprintf('Erreur pour la methode avec la grande matrice = %0.3e\n', err1);
fprintf('Erreur pour la methode avec la petite matrice = %0.3e\n', err2);
fprintf('Ecart relatif entre les deux valeurs propres trouvees = %1.2e\n',ecart)
fprintf('Temps pour une ite avec la grande matrice = %0.3e\n', t_v1/iv1);
fprintf('Temps pour une ite avec la petite matrice = %0.3e\n', t_v2/iv2);

start3 = cputime;
D = eig(AAt);
D = sort(D, 'descend');
stop3 = cputime - start3;

fprintf('\nValeur propre dominante (methode avec la grande matrice) = %0.3e\n', lambda1);
fprintf('Valeur propre dominante (methode avec la petite matrice) = %0.3e\n', lambda2);
fprintf('Valeur propre dominante (fonction eig) = %0.3e\n', D(1));

fprintf('Temps avec la grande matrice en secondes = %0.3e\n', stop1);
fprintf('Temps avec la petite matrice en secondes = %0.3e\n', stop2);
fprintf('Temps avec eig en secondes = %0.3e\n', stop3);

