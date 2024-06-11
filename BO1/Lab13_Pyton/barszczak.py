import numpy as np


class Matrix:
    def __init__(self, matrix, ID):
        self.matrix: np.ndarray = np.array(matrix)
        self.size: int = len(matrix)
        self.ID = ID

    def do_reduction(self) -> int:
        cost = 0
        for i in range(self.size):
            min_element = np.min(self.matrix[i])
            cost += min_element
            for j in range(self.size):
                self.matrix[i, j] -= min_element

        for i in range(self.size):
            min_element = np.inf
            for j in range(self.size):
                if self.matrix[j, i] < min_element:
                    min_element = self.matrix[j, i]
            cost += min_element

            for j in range(self.size):
                self.matrix[j, i] -= min_element

        return cost

    def optimistic_find(self):
        # Szukamy i, j.  Maksymalizujemy d, gdzie d to minimum z wiersza plus minimum z kolumny.
        idx_i = np.NaN
        idx_j = np.NaN
        max_d = 0
        for i in range(self.size):
            for j in range(self.size):
                if self.matrix[i, j] == 0:
                    col_min = np.inf
                    row_min = np.inf
                    for k in range(self.size):
                        if k != j:
                            row = self.matrix[i, k]
                            if row < row_min:
                                row_min = row
                        if k != i:
                            col = self.matrix[k, j]
                            if col < col_min:
                                col_min = col
                    d = col_min + row_min
                    if d > max_d:
                        max_d = d
                        idx_i = i
                        idx_j = j
        return idx_i, idx_j

    def remove(self, row_to_remove, col_to_remove):
        for k in range(self.size):
            self.matrix[row_to_remove, k] = np.inf
            self.matrix[k, col_to_remove] = np.inf


class TSP:
    def __init__(self, matrix):
        self.matrix: Matrix = Matrix(matrix, 1)
        self.lower_bound = np.inf
        self.id_list = [1]

    def little(self):
        # krok 1
        self.lower_bound = self.matrix.do_reduction()
        print("Krok 1")
        print(f"LB = {self.lower_bound}")
        print(f"Matrix:\n{self.matrix.matrix}")
        # krok 2
        opt_I, opt_J = self.matrix.optimistic_find()
        print("Krok 2")
        print(f"Optymalny odcinek to <{opt_I}, {opt_J}>")
        # krok 3
        # PP1 - wykreślamy <I, J> wiersz, zabraniamy podcyklu, redukcja i LB
        new_id = self.id_list[-1] + 1
        self.id_list.append(new_id)
        PP1 = Matrix(self.matrix.matrix, new_id)    # idk kopiuje sobie chyba xd do podproblemu
        PP1.remove(opt_I, opt_J)       # wykreślenie
        PP1.matrix[opt_J, opt_I] = np.inf  # zabraniam podcyklu takiego, że po prostu wraca
        LB1 = self.lower_bound + PP1.do_reduction()

        # PP2 - zabraniamy <I, J>, redukcja i LB
        new_id = self.id_list[-1] + 1
        self.id_list.append(new_id)
        PP2 = Matrix(self.matrix.matrix, new_id)
        PP2.matrix[opt_I, opt_J] = np.inf
        LB2 = self.lower_bound + PP2.do_reduction()


if __name__ == "__main__":
    six_cities_problem = [
        [np.inf, 27, 43, 16, 30, 26],
        [7, np.inf, 16, 1, 30, 25],
        [20, 13, np.inf, 35, 5, 0],
        [21, 16, 25, np.inf, 18, 18],
        [12, 46, 27, 48, np.inf, 5],
        [23, 5, 5, 9, 5, np.inf]
    ]
    TSP(matrix=six_cities_problem).little()
