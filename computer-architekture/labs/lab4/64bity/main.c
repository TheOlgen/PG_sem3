/* Poszukiwanie największego elementu w tablicy liczb
 całkowitych za pomoca funkcji (podprogramu)
 szukaj64_max, ktora zostala zakodowana w asemblerze.
 Wersja 64-bitowa
*/
#include <stdio.h>
extern __int64 szukaj64_max(__int64* tablica, __int64 n);
__int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64
	v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);


int main()
{
	__int64 wyniki[12] =
	{ -15, 4000000, -345679, 88046592,
	-1, 2297645, 7867023, -19000444, 31,
	456000000000000,
	444444444444444,
	-123456789098765 };

	__int64 wartosc_max;
	wartosc_max = szukaj64_max(wyniki, 12);

	printf("\nNajwiekszy element tablicy wynosi %I64d\n", wartosc_max);

	__int64 tablica[7] = { 1, 2, 3, 4, 5, 6, 7 }, suma;
	suma = suma_siedmiu_liczb(tablica[0], tablica[1], tablica[2], tablica[3], tablica[4], tablica[5], tablica[6]);
	printf("Suma tych 7 liczb : %I64d", suma);

	return 0;
}
