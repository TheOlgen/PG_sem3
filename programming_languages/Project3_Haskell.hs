-- Wszystkie możliwe rzuty
wszystkieRzuty :: Int -> Int -> [[Int]]
wszystkieRzuty 0 _ = [[]] -- pusta lista dla n = 0
wszystkieRzuty n k = [x : xs | x <- [1..k], xs <- wszystkieRzuty (n - 1) k]

-- Para (suma oczek, prawdopodobieństwo wystąpienia)
suma :: Int -> Int -> [(Int, (Int, Int))]
suma n k = 
  let rolls = wszystkieRzuty n k -- wszystkie kombinacje n i k
      sums = map sum rolls -- suma wyników np. 5,6,5,4 = 20
      grouped = grupujSuma sums -- grupowanie wyników według sumy
      total = k ^ n -- wszystkie możliwości
  in map (\(wylosowanaLiczba, wystapienia) -> (wylosowanaLiczba, (wystapienia, total))) grouped

-- Grupowanie wyników według sumy
-- Wynik to lista par (suma, liczba wystąpień)
grupujSuma :: [Int] -> [(Int, Int)]
grupujSuma [] = []
grupujSuma (x:xs) = 
  let (matches, rest) = podziel (== x) xs
  in (x, 1 + length matches) : grupujSuma rest

-- Funkcja pomocnicza do podziału listy na elementy pasujące i niepasujące do predykatu
podziel :: (a -> Bool) -> [a] -> ([a], [a])
podziel _ [] = ([], [])
podziel pred (x:xs) = 
  let (yes, no) = podziel pred xs
  in if pred x then (x:yes, no) else (yes, x:no)

-- Obliczenie prawdopodobieństwa -> suma gracza 1 > suma gracza 2
-- Prawdopodobieństwo zapisane jako para (licznik, mianownik)
win1 :: [(Int, (Int, Int))] -> [(Int, (Int, Int))] -> (Int, Int)
win1 gracz1 gracz2 = 
  let wyniki = [(licznik1 * licznik2, mianownik1 * mianownik2) |
                (s1, (licznik1, mianownik1)) <- gracz1, 
                (s2, (licznik2, mianownik2)) <- gracz2, 
                s1 > s2]
      licznikSum = sum [licznik * (wspolnyMianownik `div` mianownik) | (licznik, mianownik) <- wyniki]
      wspolnyMianownik = foldl1 lcm [mianownik | (_, mianownik) <- wyniki]
  in (licznikSum, wspolnyMianownik)

extractDigits :: Int -> [Int]
extractDigits 0 = []
extractDigits n = extractDigits (n `div` 10) ++ [n `mod` 10]

--sprawdza czy jakiejś liczby nie jest wiecej 
exceedsLimit :: Int -> [Int] -> Bool
exceedsLimit p digits = any (> p) $ map (\d -> count d digits) [0..9] 
  where
    count x = length . filter (== x)

-- filtrowanie liczb licząc ich cyfry
filterValidDigitSets :: Int -> [Integer] -> [Integer]
filterValidDigitSets p numbers = filter (\n -> isValidDigitSet p (extractDigits (fromIntegral n))) numbers
  where
    isValidDigitSet p digits = not (exceedsLimit p digits)

--funkcja generująca wszystkie wariacje cyfr 0..m o maksymalnej długości n
generateVariations :: Int -> [Int] -> [[Int]]
generateVariations 0 _  = [[]]
generateVariations n xs = 
  [y : zs | y <- xs, zs <- generateVariations (n - 1) xs]

-- pozbywanie sie duplikatów z wariacji
removeDuplicates :: (Eq a) => [a] -> [a]
removeDuplicates [] = []
removeDuplicates (x:xs)
  | x `elem` xs = removeDuplicates xs
  | otherwise = x : removeDuplicates xs

-- conwersja formatu [x,y,z] na xyz
toNumber :: [Int] -> Integer
toNumber = foldl (\acc x -> acc * 10 + fromIntegral x) 0

main :: IO ()
main = do
  putStrLn $ "--------------------------------------------------------------------" 
  putStrLn $ "ZADANIE 16" 
  putStrLn "Podaj n:"
  nInput <- getLine
  putStrLn "Podaj m:"
  mInput <- getLine
  putStrLn "Podaj p:"
  pInput <- getLine
  
  let m = read mInput :: Int
      p = read pInput :: Int
      n = read nInput :: Int
      maxLength = (m + 1) * p -- Maksymalna długość wariacji
      index = n-1 --tabela jest numerowana od zera wiec index bedzie o 1 mniejszy od n
      digits = [0..m] --cyfry z których bedziemy budowac wyniki
      allVariations = removeDuplicates $ generateVariations maxLength digits
      numbers = map toNumber allVariations
      validNumbers = filterValidDigitSets p numbers
      
  -- do celów testowych żeby zobaczyć całą tablice
  --putStrLn "Wynik :"
  --mapM_ print validNumbers

  if index >= 0 && index < length validNumbers --sprawdzamy czy istnieje taki index
    then putStrLn $ "Liczba na pozycji " ++ show n ++ ": " ++ show (validNumbers !! index)
    else putStrLn "zly indeks."
  
  
  let n1 = 3 
  let k1 = 12 
  let n2 = 6 
  let k2 = 6 

  let gracz1 = suma n1 k1
  let gracz2 = suma n2 k2

  let (wygranaLicznik, wygranaMianownik) = win1 gracz1 gracz2
  putStrLn $ "--------------------------------------------------------------------" 
  putStrLn $ "ZADANIE 39" 
  putStrLn $ "Prawdopodobienstwo, ze gracz 1 wyrzuci wiecej oczek jest rowne " ++ show wygranaLicznik ++ "/" ++ show wygranaMianownik
  putStrLn $ "--------------------------------------------------------------------" 
