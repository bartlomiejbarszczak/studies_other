# private includes
library("ggplot2")

# private functions
do.grade <- function(points) {
  result <- NULL

  for (point in points) {
    if (point >= 90) {
      result <- c(result, 5.0)
    }else if (point >= 80) {
      result <- c(result, 4.5)
    }else if (point >= 70) {
      result <- c(result, 4.0)
    }else if (point >= 60) {
      result <- c(result, 3.5)
    } else if (point >= 50) {
      result <- c(result, 3.0)
    }else {
      result <- c(result, 2.0)
    }
  }
  return(result)
}


# cwiczenie 1
base.vector <- seq(5, 25, by = 5)

new.vector <- base.vector[base.vector > 15]
vectors.mean <- mean(base.vector)
vectors.sum <- sum(base.vector[1:3])
new.vector
vectors.mean
vectors.sum
cat("\n")


# cwiczenie 2
results <- c(75, 48, 90, 60, 30)

for (result in results) {
  if (result < 60) {
    cat("Wynik ", result, ": Niezaliczony\n")
  } else {
    cat("Wynik ", result, ": Zaliczony\n")
  }
}
cat("\n")


# cwiczenie 3
names <- c("Jan", "Ola", "Ela")
ages <- c(25, 30, 28)
points <- c(85, 92, 78)
df <- data.frame(Name = names, Age = ages, Points = points)

df <- cbind(df, Grade = do.grade(df[["Points"]]))
df
new.df <- df[df$Age < 30,]
new.df


# cwiczenie 4
subjects <- c("Analiza i Bazy Danych", "Metody Numeryczne", "Eksploracja danych")
means <- c(71, 67, 89)
classes <- rep(2022, times = 3)

df <- data.frame(Przedmiot = subjects, Srednia = means, Rocznik = classes)

mybarplot <- ggplot(df, aes(x = Przedmiot, y = Srednia)) +
  geom_bar(stat = 'identity', fill = 'cyan') +
  labs(title = "Srednia wybranych przedmiotow dla rocznika 2022", x = "Przedmiot", y = "Srednia")

mybarplot


# Zadanie Domowe
# Test 1 Wyniki testów Matematyki dla Grupy A i Grupy B
wyniki_mat_grupa_A <- c(60, 65, 75, 68, 62)
wyniki_mat_grupa_B <- c(78, 80, 85, 92, 88)

# Test 2 Wyniki testów Historii dla Grupy A i Grupy B
wyniki_his_grupa_A <- c(80, 65, 75, 68, 72)
wyniki_his_grupa_B <- c(78, 80, 85, 92, 88)

exam.means <- c(mean(wyniki_mat_grupa_A), mean(wyniki_mat_grupa_B), mean(wyniki_his_grupa_A), mean(wyniki_his_grupa_B))
exam.df <- data.frame(Przedmiot = c("Matematyka", "Matematyka", "Historia", "Historia"), Grupa = c("A", "B", "A", "B"), Srednia = exam.means)

# filtrowanie danych
filtered.df <- exam.df[exam.df$Srednia >= 70,]

# sprawdzanie czy zaszla zmiana w dataframie
has.changes <- TRUE
if (length(filtered.df[["Srednia"]]) == length(exam.df[["Srednia"]])) {
  has.changes <- FALSE
}

# tworzenie wykresu
mybarplot <- ggplot(filtered.df, aes(x = Przedmiot, y = Srednia, fill = Grupa)) +
  geom_bar(stat = 'identity', position = position_dodge()) +
  geom_text(aes(label = Srednia), vjust = 2.0, color = "#ffffff", position = position_dodge(0.9), size = 6) +
  labs(title = "Srednia wynikow z egzaminu dla wybranych przedmitow", x = "Przedmiot", y = "Srednia")

# dodawanie notki odnosnie wyniku z matematyki grupy A
if (has.changes) {
  mybarplot <- mybarplot + labs(caption = "Wynik grupy A z matematyki jest nizszy niz 70") +
    theme(plot.caption = element_text(color = "red"))
}

mybarplot









