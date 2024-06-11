def srednia(lista):
    suma = 0
    licznik = 0
    for elem in lista:
        suma += elem
        licznik += 1
    srednia = suma / licznik
    return srednia


def srednia2(lista):
    suma = sum(lista)
    srednia = suma / len(lista)
    return srednia


def zlicz_wystapienia(lista, x):
    licznik = 0
    for liczba in lista:
        if liczba == x:
            licznik += 1
    return licznik


def znajdz_max(lista):
    maksimum = lista[0]
    for liczba in lista:
        if liczba > maksimum:
            maksimum = liczba
    return maksimum


def wstaw_i_posortuj(lista, x):
    n = len(lista)
    pozycja = 0
    while pozycja < n and lista[pozycja] < x:
        pozycja += 1

    lista.insert(pozycja, x)
    return lista


# # Zadanie 1
# L = [4, 5, 6, 7, 8]
# print(srednia(L))
# print(srednia2(L))
#
# # Zadanie 2
# L = [1, 2, 3, 4, 5, 2, 2]
# x = 2
# print(zlicz_wystapienia(L, x))
#
# # Zadanie 3
# L = [5, 3, 10, 1, 9]
# print(znajdz_max(L))
#
# Zadanie 4
L = [1, 3, 5, 7, 9]
x = 4
print(wstaw_i_posortuj(L, x))




# L = [-12, -5, -2]
# print(znajdz_max(L))