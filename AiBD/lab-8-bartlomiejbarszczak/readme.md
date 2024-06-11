# Wprowadzenie do ggplot2 
Celem ćwiczenia jest zapoznanie się z podstawowymi funkcjami do wizualizacji dostępnymi w ramach `ggplot2` i `tidyverse` 
(tidyverse zawiera ggplot2).

W ramach ćwiczenia będziemy wykorzystywać między innymi funkcje:
```r
ggplot()
geom_point()
aes()
factor()
geom_smooth()
geom_boxplot()
geom_histogram()
geom_density()
after_stat()
facet_grid()
scale_x_continuous()
scale_colour_gradient2()
labs()
theme()
ggsave()
```

Będziemy pracować na następującym zbiorze danych:
```r
library(tidyverse)
patients <- read_tsv("patient-data-cleaned.txt")
patients
```

Ćwiczenie zostało opracowane na podstawie kursu:

"Data Manipulation and Visualisation using R - Intermediate  R Course"
[link](http://bioinformatics-core-shared-training.github.io/r-intermediate/)




## Geomy i estetyki

### Wykresy punktowe (scatterplot)

1. Narysuj wykres punktowy wagi pacjenta w funkcji BMI (w estetyce globalnej) i pokoloruj punkty w oparciu o wzrost (w estetyce lokalnej). 



2. Za pomocą dodatkowego geoma dopasuj gładką linię określającą trend. 


3. Czy dopasowanie z poprzedniego wykresu wygląda dobrze? Spójrz na stronę pomocy dla
    `geom_smooth` i dostosuj metodę tak, aby pasowała do linii prostej i nie rysowała przedziału ufności.


### Wykresy pudełkowe

1. Wygeneruj wykres pudełkowy zmiennej Score porównując palaczy i niepalących


2. Za pomocą kolorów rozdziel wykresy pudełkowe dodatkowo ze względu na płeć. 



### Histogramy i estymatory jądrowe

1. Wygeneruj histogram BMI kolorując każdy słupek na niebiesko. Dobierz odpowiednią szerokość przedziałów (binów). Swój wybór uzasadnij.


2. Zamiast histogramu wygeneruj wykres estymatora jądrowego. 


3. Porównaj histogram z estymatorem jądrowym na jednym wykresie. Ustaw przeźroczystość histogramu (alpha) na 20%.
Dlaczego wysokości wykresów są różne? Ustaw estetykę globalną wykresu tak, aby ujednolicić pionową oś (*wskazówka: użyj funkcji `after_stat()` z odpowiednim argumentem*)



4. Wygeneruj wykresy estymatorów jądrowych BMI pokolorowane ze względu na płeć (kolor wypełnienia). Dobierz odpowiednią przeźroczystość. 


## Kafelki

1. Narysuj wykres punktowy wagi pacjenta w funkcji BMI i pokoloruj punkty w oparciu o wzrost. Podziel go na siatkę wykresów (kafelki) w oparciu o płeć i palenie papierosów. 


2. Wygeneruj wykres pudełkowy BMI porównując palących i niepalących, pokolorowanych ze względu na płeć i dodaj osobny kafelek ze względu na wiek.



3. Utwórz podobny boxplot BMI, ale tym razem pogrupuj dane ze względu na płeć, pokoloruj ze względu na wiek (*wskazówka:przekształć kolor do zmiennej kategorycznej*) a kafelki ze względu na to kto jest osobą palącą. 



## Skale i tematy


### Skale

1. Narysuj wykres punktowy wagi pacjenta w funkcji BMI. 


2. Zaczynając od poprzedniego wykresu dostosuj oś BMI tak aby zaznaczone byly tylko wartości 20, 30, 40 a na osi wagi wartości od 60 do 100 ze skokiem 5. Dodaj polską nazwę zmiennej i jednostkę (kg).





3. Narysuj wykres punktowy wagi pacjenta w funkcji BMI. Pokoloruj go w skali kolorowej ze względu na wzrost. Utwórz skalę kolorystyczną z punktem środkowym odpowiadającym średniemu wzrostowi pacjenta zaś ekstremami skali mają być zielony (minimum) i czerwony (maksimum) w odcieniach zgodnych z kolorami AGH. Jako środkowy kolor przyjąć szarość `grey`


### Motywy

1.  Narysuj wykres punktowy wagi pacjenta w funkcji BMI. Pokoloruj go w skali kolorowej ze względu na wzrost. Dodaj do niego linie trendu  bez przedziałów ufności dla każdej z grup wiekowych




2. Usuń tytuł legendy. Zmień kolory tła pozycji legendy (key) na biało i umieść legendę pod wykresem. 



3. Dodaj odpowiedni tytuł do wykresu. Usuń pomniejsze linie siatki. Zapisz jako plik png o wymiarach 16 na 16 cm. 


