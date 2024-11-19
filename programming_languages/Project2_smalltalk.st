Object subclass: #Okrag
    instanceVariableNames: 'nazwa srodek promien'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'JezykiProgramowania'!

!Okrag methodsFor: 'initialize-release'!
initialize: x wsp2: y promien: p
    "Constructor for circle object"
    nazwa := 'Okrag'.
    srodek := x@y.
    promien := p.! !

!Okrag methodsFor: 'displaying'!
drukuj
    "Displays the name, center coordinates, and radius of the circle"

    Transcript show:  nazwa; cr.
    Transcript show: 'Wspolrzedne srodka: ', srodek printString; cr.
    Transcript show: 'Promien: ', promien printString; cr; cr; cr.! !
    
    
!Okrag methodsFor: 'transformations'!
wysrodkuj
    srodek:= 0@0.! !

"------------------------------------Wielokat-------------------------------------------------------------------------"
Object subclass: #Wielokat
	instanceVariableNames: 'wierzcholki nazwa '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!


!Wielokat methodsFor: 'initialize-release'!

initialize: liczbaWierzcholkow name: nowaNazwa
	"konstruktor obiektu - wielokata"

	nazwa:=nowaNazwa.
	wierzcholki:=Array new: liczbaWierzcholkow.
	wierzcholki at: 1 put: 0@0.! !

!Wielokat methodsFor: 'accessing'!

nazwa
	"podaje nazwe wielokata"

	^nazwa!

nazwa: nowa_nazwa
	"ustawia nowa nazwe wielokata"

	nazwa:=nowa_nazwa! !

!Wielokat methodsFor: 'displaying'!

drukuj
  "drukuje nazwe wielokata i jego wierzcholkow"


    Transcript show: 'Figura to: ', nazwa; cr.
    
  "sprawdza czy wielokat - jesli instancja jest od wielokata"
	(self checkIfWielokat: self) ifTrue: [
		Transcript show: 'Ta klasa jest wielokatem';cr;cr.
	] ifFalse: [
		Transcript show: 'Ta klasa nie jest wielokatem';cr;cr.
	].

"wyswietla wierzcholki wczesniej zainicjalizowane w tab wierzcholiki - obl w 4 , 6, lub O"
  Transcript show: 'Wierzcholki wielokata to: ';cr.
	1 to: wierzcholki size do: 
    [:i |
        Transcript show: (wierzcholki at: i) printString;cr.
    ].! !

"czy to aby na pewno wielokąt"
!Wielokat methodsFor: 'checking'!

checkIfWielokat: wielokat
	"sprawdza czy dany obiekt jest podklasa Wielokatu"

	^(wielokat isKindOf: Wielokat)! !




"------------------KWADRAT---------------------------------------------------------------------------------------------------"


Wielokat subclass: #Kwadrat
	instanceVariableNames: 'wpisany_okrag '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!


!Kwadrat methodsFor: 'arithmetic'!
+ figura
	"dodaj 2 figury w sensie pola"

    "jakby tworzennie zmiennej p do wyniku i drugie_pole to 2 figura "
	| p drugie_pole |
	(self checkIfWielokat: figura) ifTrue: [
		drugie_pole := figura pole.
	]
	ifFalse: [
		drugie_pole := figura
	].

	p:=self pole + drugie_pole.
	^(Kwadrat new) initialize: p sqrt! !


"metody jako displaying"
!Kwadrat methodsFor: 'displaying'!
drukuj
    "Drukuje nazwę wielokąta, jego pole, a jeśli istnieje, także informacje o wpisanym okręgu"

    super drukuj.
    Transcript cr;
        show: 'Pole kwadratu to: ';
        show: self pole printString; cr.
    
    wpisany_okrag ifNotNil: [
        Transcript show: 'Okrąg wpisany: '; cr.
        wpisany_okrag drukuj.
    ] ifNil: [
        Transcript show: 'Kwadrat nie ma wpisanego okręgu.'; cr; cr; cr; cr.
    ].
! !


!Kwadrat methodsFor: 'actions'!
utworzWpisanyOkrag
    "Tworzy okrąg wpisany w kwadrat i zapisuje go w zmiennej wpisany_okrag"

    | srodek promien |
    srodek := (((wierzcholki at: 1) x + (wierzcholki at: 3) x) / 2) @ 
          (((wierzcholki at: 1) y + (wierzcholki at: 3) y) / 2).
    promien := (wierzcholki at: 2) x / 2.
    wpisany_okrag := Okrag new initialize: srodek x wsp2: srodek y promien: promien.
    Transcript show: 'Wpisano okrag: '; cr.
    self drukuj. !
    
pole
	"licz pole kwadratu"

	^(wierzcholki at: 2) x squared! !
	

!Kwadrat methodsFor: 'initialize-release'!
initialize: bok
	"tworz kwadrat o podanym boku"

   "wysylanie do wielokat"
	super initialize: 4 name: 'Kwadrat'.
	
	wpisany_okrag:= nil.
	
	"ustawianie recznie wierzcholkow"
	wierzcholki at: 2 put: bok@0.   "(x@y)"
	wierzcholki at: 3 put: bok@bok.
	wierzcholki at: 4 put: 0@bok.! !
	
	
	
 "transformacja kwadratu"
!Kwadrat methodsFor: 'transformations'!
wysrodkuj
	"przesun srodek kwadratu do punktu (0,0)"

	| srodek |
	srodek:=((wierzcholki at: 1) x + ((wierzcholki at: 2) x / 2))@((wierzcholki at: 1) y + ((wierzcholki at: 3) y / 2)).
	wpisany_okrag ifNotNil: [
        wpisany_okrag wysrodkuj.
        ].
	1 to: wierzcholki size do: 
		[:i |
				wierzcholki at: i put: ((wierzcholki at: i) x - srodek x)@( (wierzcholki at: i) y - srodek y)
		].!
	!




"------------SZESCIOKAT-----------------------------------------------------------------------------------------------"


Wielokat subclass: #Szesciokat
  instanceVariableNames: 'bok srodek wpisany_okrag'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Szesciokat methodsFor: 'initialize-release'!

initialize: poczatkowyBok
	"tworzy szesciokat foremny o podanym boku"
	bok:=poczatkowyBok.
	super initialize: 6 name: 'Szesciokat foremny'.
	self oblicz_wierzcholki.! !


!Szesciokat methodsFor: 'calculations'!

oblicz_wierzcholki
    | pi |

    srodek := (bok/2) @ (bok * (3 sqrt / 2)).
    pi := Float pi.

    1 to: wierzcholki size do: [:i |
        | angle x y |
        angle := (i +3) * (pi / 3).
        
        "Obliczanie współrzędnych kolejnych wierzchołków"
        x := srodek x + (bok * angle cos).
        y := srodek y + (bok * angle sin).
        
        "Zaokrąglenie współrzędnych do dwóch miejsc po przecinku
        x := ((x * 100) rounded) / 100.
        y := ((y * 100) rounded) / 100."
        
        wierzcholki at: i put: (x@y).
    ].!
!


!Szesciokat methodsFor: 'transformations'!	

wysrodkuj
	"przesun srodek szesciokata do punktu (0,0), pierwszy pkt (-bok,0)"

	wierzcholki at: 1 put: (0 - bok)@(0).
	self oblicz_wierzcholki.
	wpisany_okrag ifNotNil: [
        wpisany_okrag wysrodkuj.
        ].
	! !

!Szesciokat methodsFor: 'actions'!

utworzWpisanyOkrag
    "Tworzy okrąg wpisany w kwadrat i zapisuje go w zmiennej wpisany_okrag"

    | promien |
    promien := (wierzcholki at: 5) y / 2.
    wpisany_okrag := Okrag new initialize: srodek x wsp2: srodek y promien: promien.
    Transcript show: 'Wpisano okrag: '; cr.
    self drukuj. !

pole
"bok^2 * pierwsiatek 3 *3 /2"
    | wynik |
        wynik := (((bok squared) * (3 sqrt) * 3) / 2).
    ^wynik.! !

!Szesciokat methodsFor: 'arithmetic'!
+ figura
	"dodaj 2 figury w sensie pola"

	| p nowyBok drugie_pole |
	(self checkIfWielokat: figura) ifTrue: [
		drugie_pole := figura pole.
	]
	ifFalse: [
		drugie_pole := figura
	].

	p:=self pole + drugie_pole.
	"obl. boku gdy dodajemy pola 2 szescianow"
	nowyBok:=((p * 2 / 3) * (1 / (3 sqrt))) sqrt.
	^(Szesciokat new) initialize: nowyBok! !


!Szesciokat methodsFor: 'displaying'!

drukuj
  "drukuje nazwe wielokata i jego wierzcholkow"

  super drukuj.
  Transcript cr;
	show: 'Pole szesciokata to: ';
  show: self pole printString; cr; cr.
  
      wpisany_okrag ifNotNil: [
        Transcript show: 'Okrąg wpisany: '; cr.
        wpisany_okrag drukuj.
    ] ifNil: [
        Transcript show: 'Sześciokąt nie ma wpisanego okręgu.'; cr; cr; cr; cr.
    ].!
    !
  
  
  
  
  
  
  
  "----------INPUT------------------------------------------------------------------------------------------------"


"rozmier boku :"
szesciokat_1 := Szesciokat new initialize: 2.
szesciokat_2 := Szesciokat new initialize: 3.
kwadrat_1 := Kwadrat new initialize: 4.
okrag := Okrag new initialize: 2 wsp2: 2 promien: 4.


okrag drukuj.

Transcript show: 'Dane są wielokaty:'; cr; cr.
szesciokat_1 drukuj.
szesciokat_1 utworzWpisanyOkrag.
szesciokat_2 drukuj.
szesciokat_2 utworzWpisanyOkrag.
kwadrat_1 drukuj.
kwadrat_1 utworzWpisanyOkrag.

Transcript cr; show: 'szesciokat_1 + szesciokat_2';cr.
szesciokat_3 := szesciokat_1 + szesciokat_2.
szesciokat_3 drukuj.

Transcript cr; show: 'szesciokat_1 + kwadrat_1';cr.
szesciokat_4 := szesciokat_1 + kwadrat_1.
szesciokat_4 drukuj.

Transcript cr; show: 'kwadrat_1 + szesciokat_2';cr.
kwadrat_2 := kwadrat_1 + szesciokat_2.
kwadrat_2 drukuj.
kwadrat_2 utworzWpisanyOkrag.

Transcript cr; show: 'wysrodkuj szesciokat_1';cr.
szesciokat_1 wysrodkuj.
szesciokat_1 drukuj.

Transcript cr; show: 'wysrodkuj kwadrat_1';cr.
kwadrat_1 wysrodkuj.
kwadrat_1 drukuj.

Transcript cr; show: 'Sprawdz czy kwadrat_1 jest wielokatem';cr.
Transcript show: (kwadrat_1 checkIfWielokat: kwadrat_1) printString.

wielokat_1 := Wielokat new initialize: 3 name: 'Wielokat'.
Transcript cr; show: 'Sprawdz czy nowy wielokat_1 jest wielokatem';cr.
Transcript show: (wielokat_1 checkIfWielokat: wielokat_1) printString.

Transcript cr; show: 'Wydrkuj wielokat';cr.
wielokat_1 drukuj.

kwadrat_1 := kwadrat_1 + 12.
Transcript cr; show: 'Dodaj do kwadratu_1 liczbe 12';cr.
kwadrat_1 drukuj.

szesciokat_1 drukuj.
Transcript cr; show: 'Dodaj do szesciokat_1 liczbe 10';cr.
szesciokat_1 := szesciokat_1 + 10.
szesciokat_1 drukuj.
