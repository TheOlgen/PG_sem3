#include <stdio.h>

extern int szukaj_max(int a, int b, int c);
extern int szukaj_max4(int a, int b, int c, int d);
void plus_jeden(int* a);
void liczba_przeciwna(int* a);
void przestaw(int tabl[], int n);


int main()
{
		int x, y, z, a, wynik;

		//zad1
		printf("\nProsze podac trzy liczby calkowite ze znakiem: ");
		scanf_s("%d %d %d %d", &x, &y, &z, &a, 32);

		wynik = szukaj_max4(x, y, z, a);
		printf("\nSposrod podanych liczb, liczba %d jest najwieksza\n", wynik);


		//zad2
		int m = -9;
		liczba_przeciwna(&m);
		printf("\n m = %d\n", m);


		//zad3
		int k;
		int* wsk;
		wsk = &k;
		printf("\nProsze napisac liczbe: ");
		scanf_s("%d", &k, 12);
		odejmij_jeden(&wsk);
		printf("\nWynik = %d\n", k);


		//zad4
	int T[] = {1, 4, 56, 22, 6, 2, 7, 2};

	int n = 7;
	int m = n+1;	
	for (int i = 0; i < n; i++) {
		przestaw(T, m);
		m--;
	}
	for (int i = 0; i < n; i++) {
		printf("%d ", T[i]);
	}

	return 0;
}
