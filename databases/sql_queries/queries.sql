--1.     Podaj jaki wynik uzyskał zawodnik o numerze pesel 91020255555 w wyścigu o nazwie "finał Mężczyzn Jedynki" w kategorii M1x
SELECT WYSCIG.opis, WYNIKI.miejsce, WYNIKI.czas
FROM WYSCIG, WYNIKI 
	INNER JOIN
		(SELECT OSADA.id_osady
			FROM OSADA INNER JOIN CZLONEK_OSADY
			ON OSADA.id_osady = CZLONEK_OSADY.nalezy_do
			WHERE CZLONEK_OSADY.przynalezy = 91020255555) AS osady
	ON WYNIKI.uzyskane_przez = osady.id_osady
WHERE WYSCIG.nr_wyscigu = WYNIKI.uzyskane_w 
	AND WYSCIG.opis = 'Finał Mężczyzn Jedynki'
	AND WYSCIG.przypisany_do = 'M1x'

	
--2. Zorientowanie sie kiedy startują zawodnicy danego trenera.
    --Podaj godziny startów zawodników płci męskiej trenerki Pauliny Straszewskiej.
CREATE VIEW startyTrenerki
	(nr_osady, data, godzina, opis, plec)
	AS SELECT zglasza_sie, data, godzina, opis, plec
		FROM KATEGORIE, ZGLOSZENIE_DO_WYSCIGU JOIN WYSCIG
			ON ZGLOSZENIE_DO_WYSCIGU.zglasza_sie_do = WYSCIG.nr_wyscigu
		WHERE zglasza_sie IN 
			(SELECT id_osady
				FROM OSADA JOIN TRENER
					ON OSADA.nadzoruje = TRENER.nr_licencji_trenera
				WHERE TRENER.imie = 'Paulina'
					AND TRENER.nazwisko = 'Straszewska')
			AND KATEGORIE.symbol = WYSCIG.przypisany_do;

SELECT *
	FROM startyTrenerki
	WHERE plec = 'M'
	ORDER BY data, godzina

	
--3. Stworzenie statystyk sędziów, w celu odnalezienia najbardziej kompetentnego do prowadzenia nadchodzących zawodów. Podaj liste sędziów (imie nazwisko numer_licencji) których licencja nie kończy się w okresie
    --najbliższych pół roku, którzy prowadzili już zawody kategorii jedynka i podaj liczbe prowadzonych przez nich wyścigów w tej kategorii. Posortuj rosnąco względem nazwiska.
SELECT S.nr_licencji_sedziego, SEDZIA.imie, nazwisko, SEDZIA.data_waznosci_licencji, ilosc_wyscigow
	FROM SEDZIA JOIN 
		(SELECT nr_licencji_sedziego, COUNT(nr_wyscigu) AS ilosc_wyscigow 
			FROM WYSCIG JOIN SEDZIA
				ON WYSCIG.sedziuje = SEDZIA.nr_licencji_sedziego
			WHERE przypisany_do LIKE '%1x'
				AND DATEDIFF(DAY ,SEDZIA.data_waznosci_licencji, GETDATE()) < 180
			GROUP BY nr_licencji_sedziego ) AS S
		ON S.nr_licencji_sedziego = SEDZIA.nr_licencji_sedziego
	ORDER BY ilosc_wyscigow DESC


--4. biznesman szuka zawodników najlepszego zepołu juniorów żeby ich sponsorować znajdź zawodników, należących 
	--do osady,która ma największą ilość wygranych, którzy biorą udział wyłącznie w zawodach juniorów
SELECT pesel, imie, nazwisko, trenuje_w, lodz, ilosc_wygranych
	FROM OSADA JOIN CZLONEK_OSADY
		ON OSADA.id_osady = CZLONEK_OSADY.nalezy_do,
		ZAWODNIK,
		(SELECT TOP (1) uzyskane_przez, COUNT(miejsce) AS ilosc_wygranych
			FROM WYNIKI JOIN WYSCIG
				ON WYNIKI.uzyskane_w = WYSCIG.nr_wyscigu
			WHERE miejsce = 1
				AND WYSCIG.przypisany_do LIKE 'J%%'
			GROUP BY uzyskane_przez
			ORDER BY ilosc_wygranych DESC) as sub
	WHERE sub.uzyskane_przez = OSADA.id_osady
		AND ZAWODNIK.pesel = CZLONEK_OSADY.przynalezy	

	
--5. organizator zawodów, chce poinformować zawodników o sprawach organizacyjnych, ale nie wie kto startuje znajdź zawodników, oraz trenera 
	--każdego z nich, dla każdej osady która bierze udział w wyścigach dnia 2024-06-01
SELECT ZAWODNIK.pesel, ZAWODNIK.imie AS imie_zawodnika, ZAWODNIK.nazwisko AS nazwisko_zawodnika, nr_licencji_trenera,TRENER.imie AS imie_trenera, TRENER.nazwisko AS nazwisko_trenera, lodz
	FROM CZLONEK_OSADY JOIN ZAWODNIK
			ON ZAWODNIK.pesel = CZLONEK_OSADY.przynalezy, 
		OSADA JOIN TRENER 
			ON OSADA.nadzoruje = TRENER.nr_licencji_trenera
	WHERE EXISTS
		(SELECT ZGLOSZENIE_DO_WYSCIGU.zglasza_sie
			FROM WYSCIG JOIN ZGLOSZENIE_DO_WYSCIGU
				ON WYSCIG.nr_wyscigu = ZGLOSZENIE_DO_WYSCIGU.zglasza_sie_do
			WHERE WYSCIG.data = '2024-06-01')
		AND CZLONEK_OSADY.nalezy_do = OSADA.id_osady
	ORDER BY pesel

	
--6. zawodnik zapomniał o której ma wyścig znajdź wyścigi w których bierze udział dany zawodnik o peselu 87080865432, 
	--które jeszcze się nie odbyły, posortuj z najbliższym na górze
SELECT WYSCIG.data, godzina, przypisany_do AS kategoria, opis
	FROM WYSCIG join ZGLOSZENIE_DO_WYSCIGU
			ON WYSCIG.nr_wyscigu = ZGLOSZENIE_DO_WYSCIGU.zglasza_sie_do,
		OSADA JOIN CZLONEK_OSADY
			ON OSADA.id_osady = CZLONEK_OSADY.nalezy_do
	WHERE przynalezy = '87080865432'
		AND ZGLOSZENIE_DO_WYSCIGU.zglasza_sie = OSADA.id_osady
		AND	DATEDIFF(DAY, WYSCIG.data, getdate()) < 0
	ORDER BY WYSCIG.data, godzina


--7. trener chce przeanalizować wyniki swojego zawodnika
    --Zestawienie wszystkich wyników (i w jakiej kategorii) jednego zawodnika o peselu 88051177777
CREATE VIEW wynikiZawodnika
	(kategoria, miejsce, czas, opis)
	AS SELECT przypisany_do, miejsce, czas, opis
		FROM WYSCIG join WYNIKI
				ON WYSCIG.nr_wyscigu = WYNIKI.uzyskane_w,
			OSADA JOIN CZLONEK_OSADY
				ON OSADA.id_osady = CZLONEK_OSADY.nalezy_do
		WHERE przynalezy = '88051177777'
			AND WYNIKI.uzyskane_przez = OSADA.id_osady;
SELECT *
	FROM wynikiZawodnika
	ORDER BY KATEGORIA, MIEJSCE

--8. Jeden sędzia zachorował, organizatorzy poszukują zastępcy dla wyścigu
    --Znalezienie sędziów nie zajmujących się żadnym wyścigiem konkretnego dnia (2024-06-01) i mających aktualną licencje
SELECT *
	FROM SEDZIA 
	WHERE SEDZIA.nr_licencji_sedziego NOT IN
		(SELECT sedziuje
			FROM WYSCIG
			WHERE data = '2024-06-01'
			GROUP BY sedziuje)
		AND DATEDIFF(DAY, data_waznosci_licencji, getdate()) < 0

	
	
--9. Porównanie ilości zawodników i trenerów (format klub, ilość_zawodników, ilość_trenerów) we wszystkich klubach, lista od największego wg zawodników a pot
SELECT trenuje_w AS 'KLUB', sub1.ilosc_zawodnikow, sub2.ilosc_trenerow
FROM 
		(SELECT trenuje_w, COUNT(ZAWODNIK.pesel) AS 'ilosc_zawodnikow'
			FROM ZAWODNIK
			GROUP BY trenuje_w) 
		AS sub1
	INNER JOIN
		(SELECT pracuje_w, COUNT(TRENER.nr_licencji_trenera) AS 'ilosc_trenerow'
			FROM TRENER
			GROUP BY pracuje_w) 
		AS sub2
	ON sub1.trenuje_w = sub2.pracuje_w
		
ORDER BY sub1.ilosc_zawodnikow DESC, sub2.ilosc_trenerow DESC
