-- Usuń rekord z tabeli KLUB, z tabel zawodnicy, trenerzy, członek osady i osada tez znikną dane
DELETE FROM KLUB WHERE skrot_nazwy = 'BTW';


-- usuniecie rekordu wyćcigu pierwszego, znikną zgłoszenia i wyniki
DELETE FROM WYSCIG WHERE nr_wyscigu = 1;

-- usuniecie rekordu sędziego, kaskadowo usunie sie też wyścig do którego jest przypisany
DELETE FROM Sędzia WHERE nr_licencji_sedziego = 220;

-- usuniecie rekordu kategorii, kaskadowo usunie sie też wyścig do którego jest przypisany
DELETE FROM Kategorie WHERE symbol  = 'M1x';

-- usuniecie rekordu osady, znikną zgłoszenia, wyniki i członkowie osady
DELETE FROM Osada WHERE id_osady  = 2;