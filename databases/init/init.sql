
-- Tworzenie tabel
CREATE TABLE KLUB (
    skrot_nazwy VARCHAR(10) PRIMARY KEY,
    pelna_nazwa VARCHAR(150) NOT NULL UNIQUE,
    wzor_wiosel VARCHAR(150)
);

CREATE TABLE ZAWODNIK (
    pesel CHAR(11) PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    data_urodzenia DATE NOT NULL,
    plec CHAR(1) NOT NULL CHECK (plec IN ('M', 'K')),
    trenuje_w VARCHAR(10) NOT NULL,
    FOREIGN KEY (trenuje_w) REFERENCES KLUB(skrot_nazwy) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TRENER (
    nr_licencji_trenera INT PRIMARY KEY,
    imie VARCHAR(30) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    pracuje_w VARCHAR(10) NOT NULL,
    data_waznosci_licencji DATE NOT NULL,
    FOREIGN KEY (pracuje_w) REFERENCES KLUB(skrot_nazwy) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE OSADA (
    id_osady INT PRIMARY KEY,
    nadzoruje INT NOT NULL,
    lodz VARCHAR(150),
    FOREIGN KEY (nadzoruje) REFERENCES TRENER(nr_licencji_trenera) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CZLONEK_OSADY (
    przynalezy CHAR(11) NOT NULL,
    nalezy_do INT NOT NULL,
    czy_sternik BIT NOT NULL,
    PRIMARY KEY (przynalezy, nalezy_do),
    FOREIGN KEY (przynalezy) REFERENCES ZAWODNIK(pesel) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nalezy_do) REFERENCES OSADA(id_osady) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE SEDZIA (
    nr_licencji_sedziego INT PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    data_waznosci_licencji DATE NOT NULL
);

CREATE TABLE KATEGORIE (
    symbol CHAR(5) PRIMARY KEY,
    nazwa VARCHAR(50) NOT NULL,
    ilosc_osob INT NOT NULL CHECK (ilosc_osob > 0),
    plec CHAR(1) NOT NULL CHECK (plec IN ('M', 'K')),
    maks_wiek INT CHECK (maks_wiek > 0),
    wymaga_sternika BIT NOT NULL
);

CREATE TABLE WYSCIG (
    nr_wyscigu INT PRIMARY KEY,
    data DATE NOT NULL,
    sedziuje INT,
    godzina TIME NOT NULL,
    przypisany_do CHAR(5) NOT NULL,
    opis VARCHAR(150),
    FOREIGN KEY (sedziuje) REFERENCES SEDZIA(nr_licencji_sedziego) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (przypisany_do) REFERENCES KATEGORIE(symbol) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ZGLOSZENIE_DO_WYSCIGU (
    zglasza_sie INT NOT NULL,
    zglasza_sie_do INT NOT NULL,
    status_platnosci VARCHAR(20) NOT NULL CHECK (status_platnosci IN ('opłacone', 'nieopłacone')),
    czy_dopuszczono_do_startu BIT,
    PRIMARY KEY (zglasza_sie, zglasza_sie_do),
    FOREIGN KEY (zglasza_sie) REFERENCES OSADA(id_osady) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (zglasza_sie_do) REFERENCES WYSCIG(nr_wyscigu) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE WYNIKI (
    uzyskane_w INT NOT NULL,
    uzyskane_przez INT NOT NULL,
    miejsce INT NOT NULL CHECK (miejsce > 0),
    czas TIME NOT NULL,
    PRIMARY KEY (uzyskane_w, uzyskane_przez),
    FOREIGN KEY (uzyskane_w) REFERENCES WYSCIG(nr_wyscigu) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (uzyskane_przez) REFERENCES OSADA(id_osady) ON DELETE CASCADE ON UPDATE CASCADE
);
