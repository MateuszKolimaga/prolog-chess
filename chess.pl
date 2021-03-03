%Spis figur na planszy
  figura(skoczek,biale,a,6).
  figura(skoczek,biale,h,3).
  figura(goniec,biale,a,2).
  figura(goniec,biale,b,2).
  figura(wieza,biale,b,4).
  figura(wieza,biale,g,5).
  figura(hetman,biale,f,3).
  figura(krol,biale,g,6).
  figura(pion,czarne,d,5).
  figura(pion,czarne,d,6).
  figura(pion,czarne,d,7).
  figura(pion,czarne,e,2).
  figura(pion,czarne,e,7).
  figura(pion,czarne,g,4).
  figura(skoczek,czarne,c,2).
  figura(goniec,czarne,a,8).
  figura(goniec,czarne,e,3).
  figura(wieza,czarne,c,4).
  figura(wieza,czarne,c,5).
  figura(hetman,czarne,f,1).
  figura(krol,czarne,e,6).
  
  
%Funkcje sprawdzajace mozliwe ruchy dla danego koloru gracza
wszystkie_pos_bialych(C ,X1, Y1, X2, Y2) :- ruchy(C, biale, X1, Y1, X2, Y2).
%Funkcja ruchy zwraca dla kazdej figury danego koloru:
%Jej wspolrzedne x,y oraz kazda potencjalna pozycje x2,y2
wszystkie_pos_czarnych(C, X1, Y1, X2, Y2) :- ruchy(C, czarne, X1, Y1, X2, Y2).

% Funkcja pos przyjmuje wspolrzedne figury i docelowe
% wspolrzedne. Zwraca prawde jesli figura o wspolrzednych (x1,y1)
% istnieje, jesli istnieje wspolrzedna (x2,y2) na planszy, oraz gdy ruch
% miedzy tymi punktami jest mozliwy
pos(X1, Y1, X2, Y2) :- litery(L), nalezy(X2, L), Y2 < 9, Y2 > 0,
    figura(C, K, X1, Y1), ruch(C, K, X1, Y1, X2, Y2).

% Funkcja potrzebna do sprawdzania czy figura dana figura istnieje
kombPionki(X, Y):- pionek(X), kolor(Y).
% Funkcja potrzebna do sprawdzania czy dana wspolrzedna istnieje
kombLitNum(X, Y) :- litera(X), numer(Y).

% Funkcja zwraca wspolrzedne figury (jesli istnieje)
mozliwePozycje(P, R) :-  kombPionki(C, K), figura(C, K, P, R).

% Funkcja ruchy zwraca wszystkie mozliwe ruchy, dla wszystkich figur o
% kolorze K. Funkcja odwoluje sie do kazdej figury
ruchy(C, K, X1, Y1, X2, Y2) :-  mozliwePozycje(X1, Y1), figura(C, K, X1, Y1), kombLitNum(X2, Y2), pos(X1, Y1, X2, Y2).

% Funkcja ruchyBezKrola zwraca wszystkie mozliwe ruchy dla figur,
% ktore nie sa krolem
ruchyBezKrola(C, K, X1, Y1, X2, Y2) :-  mozliwePozycje(X1, Y1), figura(C, K, X1, Y1), C \== krol, kombLitNum(X2, Y2), pos(X1, Y1, X2, Y2).

%Funkcje zwracaja prawde gdy blisko krola istnieje inny krol.

%Funkcja sprawdzajaca czy inny krol jest blisko po skosie:
czyKrolBlisko(K,X,Y) :- figura(krol,K1,X2,Y2), litery(L), K1 \== K,
    elemIndeks(L,X,I), elemIndeks(L, X2, I2), odejmij(Y2, Y, WY),
    odejmij(I2, I, WI), abs(WI) =:= abs(WY), abs(WI) =:= 1.

%czy krol jest blisko w pionie
czyKrolBlisko(K,X,Y) :- figura(krol,K1,X2,Y2), litery(L), K1 \== K,
    elemIndeks(L,X,I), elemIndeks(L, X2, I2), odejmij(Y2, Y, WY),
    odejmij(I2, I, WI), abs(WI) =:= 0, abs(WY) =:= 1.

%czy krol jest blisko w poziomie
czyKrolBlisko(K,X,Y) :- figura(krol,K1,X2,Y2), litery(L), K1 \== K,
    elemIndeks(L,X,I), elemIndeks(L, X2, I2), odejmij(Y2, Y, WY),
    odejmij(I2, I, WI), abs(WI) =:= 1, abs(WY) =:= 0.

% Funkcja zwraca wszystkie mozliwe ruchy piona po skosie (bicia), dla
% dowolnego koloru.
mozliweRuchyPion(K, XL, XP, Y2) :- figura(pion, K, X, Y), litery(L),
    elemIndeks(L, X, I), odejmij(I, 1, I2), dodaj(I,1,I3), elemIndeks(L, XL, I2),
    elemIndeks(L, XP, I3), ((K == biale, Y2 is Y - 1) ; (K == czarne, Y2 is Y + 1)).


% Funkcja szach zwraca prawde, gdy krol chce sie poruszyc do miejsca, do
% ktorego dostep ma jakakolwiek inna figura
szach(biale, X2, Y2) :- (ruchyBezKrola( P , czarne,_ ,_ , X2, Y2), P \== pion) ;
(mozliweRuchyPion(biale, _, X2, Y2) ; mozliweRuchyPion(biale, X2, _, Y2)).

szach(czarne, X2, Y2) :- (ruchyBezKrola( P, biale,_ ,_ , X2, Y2), P \== pion) ;
(mozliweRuchyPion(czarne, _, X2, Y2) ; mozliweRuchyPion(czarne, X2, _, Y2)).

% Funkcje sprawdzaja czy w miejscu docelowym nie jest blisko zaden krol
szach(biale, X2, Y2) :- czyKrolBlisko(biale, X2, Y2).

szach(czarne, X2, Y2) :- czyKrolBlisko(czarne, X2, Y2).

% Funkcja zwraca prawde gdy mozliwe jest bicie przez piona (po skosie),
% wtedy roznica pomiedzy wspolrzednymi X jest rowna 1 (Y nie jest
% sprawdzane)
biciePion(K, X1, _, X2, Y2):- figura(_,K2,X2,Y2), K \== K2,
    litery(L), elemIndeks(L, X1, I), elemIndeks(L, X2, I2),
    odejmij(I2,I,W), abs(W) =:= 1.



% Funkcja sprawdza czy ruch piona jest dozwolony w pionie. Jesli na
% docelowym miejscu jest wolne, i ruch odbywa sie o 1 pozycje w pionie
% ,wtedy ruch jest dozwolony (Funkcja zwraca prawde)
ruch(C, K, X1, Y1, X2, Y2) :- C == pion,
    czyWolne(X2, Y2, _), X1 == X2, odejmij(Y1, Y2, W),
    ((W == 1, K==czarne) ; (W == -1, K == biale)).

% Funkcja sprawdza czy pion ma wykonac bicie. Jesli tak to odwoluje
% sie do funkcji biciePion i ta sprawdza taka mozliwosc.
ruch(C, K, X1, Y1, X2, Y2) :- C == pion,
    czyWolne(X2,Y2,_), X1 \== X2, odejmij(Y1, Y2, W),
    (( W == 1, K == czarne) ; (W == -1, K == biale)), biciePion(K, X1, _, X2, Y2).

% Funkcja sprawdza czy ruch gonca, lub hetmana jest dozwolony po skosie.
% Wariant: pole docelowe jest wolne (Sprawdza to funkcja czyWolne)
ruch(C, K, X1, Y1, X2, Y2) :- (C == goniec ; C == hetman),
    czyWolne(X2, Y2, K),odejmij(Y2, Y1, W1),
    litery(L), elemIndeks(L, X1, I), elemIndeks(L,X2,I2),
    odejmij(I2, I,W2), abs(W2) =:= abs(W1), poSkosie(X1, Y1, X2, Y2, _, _).

% Wariant: pole docelowe nie jest wolne. Uzyta jest funkcja czyBicie,
% sprawdzajaca mozliwosc bicia.
ruch(C, K, X1, Y1, X2, Y2) :- (C == goniec ; C == hetman),
    not(czyWolne(X2,Y2, K)), czyBicie(X2,Y2,K), odejmij(Y2, Y1, W1),
    litery(L), elemIndeks(L, X1, I), elemIndeks(L,X2,I2), odejmij(I2, I,W2),
    abs(W2) =:= abs(W1), poSkosie(X1, Y1, X2, Y2, _, _).

% Funkcja sprawdza czy ruch skoczka jest dozwolony.
% Wariant: miejsce docelowe jest wolne.
ruch(C, K, X1, Y1, X2, Y2) :- C == skoczek,
    czyWolne(X2, Y2, K), odejmij(Y2, Y1,W1),
    litery(L), elemIndeks(L, X1, I), elemIndeks(L, X2, I2), odejmij(I2, I, W2),
    ((abs(W2) =:= 2, abs(W1) =:= 1) ; (abs(W2) =:= 1, abs(W1)=:= 2)).

% Wariant: miejsce docelowe jest zajete. Użyta jest funkcja czyBicie,
% sprawdzajaca mozliwosc bicia.
ruch(C, K, X1, Y1, X2, Y2) :- C == skoczek,
    not(czyWolne(X2, Y2, K)), czyBicie(X2, Y2, K), odejmij(Y2, Y1,W1),
    litery(L), elemIndeks(L, X1, I), elemIndeks(L, X2, I2), odejmij(I2, I, W2),
    ((abs(W2) =:= 2, abs(W1) =:= 1) ; (abs(W2) =:= 1, abs(W1)=:= 2)).

% Funkcja sprawdcza czy ruch wiezy, lub hetmana w pionie lub poziomie
% jest dozwolony.
% Wariant: miejsce docelowe jest wolne.
ruch(C, K, X1, Y1, X2, Y2) :- (C == wieza ; C == hetman),
    czyWolne(X2, Y2, K),odejmij(Y2, Y1, W1),
    litery(L), elemIndeks(L, X1, I), elemIndeks(L,X2,I2),
    odejmij(I2, I,W2), (abs(W2) =:= 0; abs(W1) =:= 0), poProstej(X1, Y1, X2, Y2, _).

% Wariant: miejsce docelowe jest zajete.
ruch(C, K, X1, Y1, X2, Y2) :- (C == wieza ; C == hetman),
    not(czyWolne(X2,Y2, K)), czyBicie(X2,Y2,K),
    odejmij(Y2, Y1, W1), litery(L), elemIndeks(L, X1, I), elemIndeks(L,X2,I2),
    odejmij(I2, I,W2), (abs(W2) =:= 0; abs(W1) =:=0), poProstej(X1, Y1, X2, Y2, _).

% Funkcja sprawdzajaca czy ruch krola jest dozwolony. Sprawdzane jest to
% czy w miejscu docelowym jest on szachowany i czy pozycja docelowa jest
% wolna. Wariant: Ruch w poziomie/pionie.
ruch(C, K, X1, Y1, X2, Y2) :- C == krol,
    not(szach(K, X2, Y2)), czyWolne(X2, Y2, K), odejmij(Y2, Y1, W1),
    litery(L), elemIndeks(L, X1, I), elemIndeks(L, X2, I2), odejmij(I2, I, W2),
    ((abs(W2) =:= 0, abs(W1) =:= 1) ; (abs(W2) =:= 1, abs(W1) =:= 0)),
     poProstej(X1, Y1, X2, Y2, _).

% Wariant: Ruch po skosie
ruch(C, K, X1, Y1, X2, Y2) :- C == krol,
    not(szach(K, X2, Y2)), czyWolne(X2, Y2, K), odejmij(Y2, Y1, W1),
    litery(L), elemIndeks(L, X1, I), elemIndeks(L, X2, I2), odejmij(I2, I, W2),
    abs(W2) =:= 1, abs(W2) =:= abs(W1), poSkosie(X1, Y1, X2, Y2, _, _).

% Funkcje sprawdzajace czy ruch jest wykonywany po skosie i czy nic nie
% stoi na przeszkodzie. Odleglosc pomiedzy punktami (x1,y1) a (x2,
% y2) jest wyrazona w wartosciach J i K. J to odleglosc w
% poziomie, a K w pionie. Wartosci sa dekrementowane z kazdym
% wywolaniem funkcji. Gdy jakakolwiek figura stoi na przeszkodzie
% wartosci J i K przyjmuja wartosci wieksze niz 1.

poSkosie(_, _, _, _, J, K):- J==1, K==1.

%Ruch w kierunku NE
poSkosie(X1, Y1, X2, Y2, _, _) :- litery(L), elemIndeks(L, X1, I1),
    elemIndeks(L,X2,I2), odejmij(I2, I1, WI), odejmij(Y2,Y1,W),
    WI > 0, W >0, odejmij(I2,1, I3), elemIndeks(L, X3, I3),odejmij(Y2,1,Y3),
    J is abs(W), K is abs(WI), (czyWolne(X3, Y3, _) ; (J == 1, K ==1)), poSkosie(X1, Y1, X3, Y3, J, K).

%SE
poSkosie(X1, Y1, X2, Y2, _, _) :- litery(L), elemIndeks(L, X1, I1),
    elemIndeks(L,X2,I2), odejmij(I2, I1, WI), odejmij(Y2,Y1,W),
    WI > 0, W <0, odejmij(I2,1,I3), elemIndeks(L, X3, I3), dodaj(Y2,1,Y3),
    J is abs(W), K is abs(WI), (czyWolne(X3, Y3, _) ; ( J == 1, K == 1)) , poSkosie(X1, Y1, X3, Y3, J, K).

%NW
poSkosie(X1, Y1, X2, Y2, _, _) :- litery(L), elemIndeks(L, X1, I1),
    elemIndeks(L,X2,I2), odejmij(I2, I1, WI), odejmij(Y2,Y1,W),
    WI < 0, W >0, dodaj(I2,1,I3), elemIndeks(L, X3, I3), odejmij(Y2,1,Y3),
    J is abs(W), K is abs(WI), (czyWolne(X3,Y3, _) ; (J == 1, K == 1)), poSkosie(X1, Y1, X3, Y3, J, K).

%SW
poSkosie(X1, Y1, X2, Y2, _, _) :- litery(L), elemIndeks(L, X1, I1),
    elemIndeks(L,X2,I2), odejmij(I2, I1, WI), odejmij(Y2,Y1,W),
    WI < 0, W <0, dodaj(I2,1,I3), elemIndeks(L, X3, I3), dodaj(Y2,1,Y3),
    J is abs(W), K is abs(WI), (czyWolne(X3, Y3, _) ; (J == 1, K == 1)), poSkosie(X1, Y1, X3, Y3, J, K).

% Funkcje sprawdzajace czy ruch jest wykonywany po prostej
% i czy nic nie stoi na przeszkodzie. Odleglosc pomiedzy (x1,y1) a
% (x2,y2) jest wyrazona przez wartosc J. Wartosc ta jest dekrementowana
% z kazdym wywolaniem funkcji. Gdy okaze sie ze dowolna figura stoi na
% przeszkodzie, J > 1.

poProstej(_, _, _, _, J) :- J==1.

%W pionie (WI == 0), w gore (Y2 > Y1)
poProstej(X1, Y1, X2, Y2, _) :- litery(L), elemIndeks(L,X1,I1),
    elemIndeks(L, X2, I2), odejmij(I2,I1,WI), odejmij(Y2,Y1,W),
    WI == 0, Y2 > Y1, odejmij(Y2,1,Y3), J is abs(W), (czyWolne(X2, Y3, _) ; J == 1), poProstej(X1, Y1, X1, Y3, J).

%W pionie (WI == 0), w dol (Y2 < Y1)
poProstej(X1, Y1, X2, Y2, _) :- litery(L), elemIndeks(L,X1,I1),
    elemIndeks(L, X2, I2), odejmij(I2,I1,WI), odejmij(Y2,Y1,W),
    WI == 0, Y2 < Y1, dodaj(Y2,1,Y3), J is abs(W), (czyWolne(X2, Y3, _) ; J == 1), poProstej(X1, Y1, X1, Y3, J).

%W poziomie (W == 0), w prawo (I2 > I1)
poProstej(X1, Y1, X2, Y2, _) :- litery(L), elemIndeks(L,X1,I1),
    elemIndeks(L, X2, I2), odejmij(I2,I1,WI), odejmij(Y2,Y1,W),
    W == 0, I2 > I1, odejmij(I2,1,I3), elemIndeks(L, X3, I3), J is abs(WI), (czyWolne(X3, Y1, _) ; J == 1), poProstej(X1, Y1, X3, Y1, J).

%W poziomie (W == 0), w lewo (I2 < I1)
poProstej(X1, Y1, X2, Y2, _) :- litery(L), elemIndeks(L,X1,I1),
    elemIndeks(L, X2, I2), odejmij(I2,I1,WI), odejmij(Y2,Y1,W),
    W == 0, I2 < I1, dodaj(I2,1,I3), elemIndeks(L, X3, I3), J is abs(WI), (czyWolne(X3, Y1, _) ; J == 1), poProstej(X1, Y1, X3, Y1, J).


%Zmienne potrzebne do przeszukiwania planszy
litery([a,b,c,d,e,f,g,h]).

litera(a).
litera(b).
litera(c).
litera(d).
litera(e).
litera(f).
litera(g).
litera(h).

numer(1).
numer(2).
numer(3).
numer(4).
numer(5).
numer(6).
numer(7).
numer(8).

pionek(pion).
pionek(goniec).
pionek(skoczek).
pionek(wieza).
pionek(hetman).
pionek(krol).

kolor(biale).
kolor(czarne).

% Funkcja sprawdzajaca czy w danym miejscu nie ma juz pionka tego samego
% koloru
czyWolne(X, Y, K) :- not(figura(_,K,X,Y)).
% Funkcja sprawdzajaca czy w danym miejscu moze wystepowac bicie.
% Do tej funkcji odwoluja sie funkcje ruch w wariancie bicia.
czyBicie(X, Y, K) :- figura(_,K1,X,Y), K1 \== K.

%Sprawdzanie czy element nalezy do listy
nalezy(G,[G|_]).
nalezy(G,[_|T]) :- nalezy(G,T).

%Funkcje ulatwiajace czytelnosc
dodaj(X, Y, Z) :- Z is X+Y.
odejmij(X, Y, Z) :- Z is X-Y.

%Funkcja zwracajaca indeks elementu w liscie
elemIndeks([E|_], E, 0).
elemIndeks([_|O], E, Indeks) :- elemIndeks(O, E, Indeks2), Indeks is Indeks2 +1.
