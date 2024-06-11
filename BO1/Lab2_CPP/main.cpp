#include <iostream>
#include <map>
#include <vector>
#include <queue>

/*
 * Funkcja przeszukuje graf za pomoca algorytmu bfs. Zwraca liste odwiedzonych wierzcholkow w kolejnosci z jaka
 * przeszukuje graf algorytm bfs oraz dwa slowa w postaci mapy ktore informuja czy graf jest spojny i czy posiada cykl
 */
std::map<std::vector<int>, std::map<std::string, std::string>> bfs(const std::map<int, std::vector<int>> &graph, int start) {
    // inicjalizacja zmiennych
    std::queue<int> queue = {};
    std::map<int, int> visited = {};
    std::vector<int> labels = {start + 1};
    int number = 1;
    int v = start;
    bool is_consistent = false;
    bool has_cycle = false;

    // wyzerowanie zmiennej visited, przypisanie kazdemu wierzcholkowi etykiety 0
    for (const auto &elem: graph)
        visited[elem.first] = 0;

    // ustawienie poczatkowemu wierzcholkowi etykiety 1
    visited[start] = number;

    // dodanie do kolejki wszystkich sasiadow poczatkowego wierzcholka
    for (auto value: graph.find(v)->second) {
        queue.push(value);
    }

    // glowna petla realizujaca algorytm bfs
    while (!queue.empty()) {
        v = queue.front();
        queue.pop();

        if (visited[v] == 0) {
            visited[v] = ++number;
            labels.push_back(v + 1);
        }
        for (auto elem: graph.find(v)->second) {
            if (visited[elem] == 0) {
                queue.push(elem);

            }
            if (visited[elem] == visited[v]) // warunek na sprawdzenie czy graf jest cykliczny
                has_cycle = true;
        }
    }

    if (labels.size() == graph.size()) // Warunek na sprawdzenie czy graf jest spojny
        is_consistent = true;

    // zwracanie wynikow
    return {{labels, {{is_consistent ? "TRUE" : "FALSE", has_cycle ? "TRUE" : "FALSE"}}}};
}


int main() {
    // deklaracja zmiennej result ktora przechowuje wynik zwrocony przez funkcje bfs
    std::map<std::vector<int>, std::map<std::string, std::string>> result;

    // graf spojny acykliczny
    std::map<int, std::vector<int>> g1 = {
            {0, {1, 2, 3, 6}},
            {1, {2, 4, 7}},
            {2, {3, 6, 7}},
            {3, {5, 6, 9}},
            {4, {7, 8}},
            {5, {6, 9}},
            {6, {9}},
            {7, {6, 9}},
            {8, {7}},
            {9, {}}
    };

    // graf spojny z cyklami
    std::map<int, std::vector<int>> g2 = {
            {0, {1, 4, 5}},
            {1, {2, 5}},
            {2, {2, 3, 8}},
            {3, {4, 7, 9}},
            {4, {5, 6}},
            {5, {6}},
            {6, {0, 7}},
            {7, {8}},
            {8, {3, 9}},
            {9, {0, 4}}
    };

    // graf niespojny z cyklami
    std::map<int, std::vector<int>> g3 = {
            {0, {1, 2}},
            {1, {0, 1, 2, 4}},
            {2, {0, 3}},
            {3, {2, 4}},
            {4, {1}},
            {5, {6, 7, 9}},
            {6, {5, 7}},
            {7, {5, 6}},
            {8, {7, 9}},
            {9, {5, 6, 8}}
    };

    // prezentacja wynikow dla pierwszego grafu
    result = bfs(g1, 0);
    std::cout << "Consistent nocycle graph\n";
    std::cout << "Is consistent   Has cycle\n";
    std::cout << result.cbegin()->second.cbegin()->first << "\t\t" << result.cbegin()->second.cbegin()->second
              << std::endl;

    // prezentacja wynikow dla drugiego grafu
    result = bfs(g2, 0);
    std::cout << "\nConsistent cycle graph\n";
    std::cout << "Is consistent   Has cycle\n";
    std::cout << result.cbegin()->second.cbegin()->first << "\t\t" << result.cbegin()->second.cbegin()->second
              << std::endl;

    // prezentacja wynikow dla trzeciego grafu
    result = bfs(g3, 0);
    std::cout << "\nInconsistent cycle graph\n";
    std::cout << "Is consistent   Has cycle\n";
    std::cout << result.cbegin()->second.cbegin()->first << "\t\t" << result.cbegin()->second.cbegin()->second
              << std::endl;
}
