#include <iostream>
//#include <vector>
//#include <limits>
//#include <functional>
//
//
//int INF = std::numeric_limits<int>::max();
//
//
//std::vector<int> fill_store(int size, int start) {
//    std::vector<int> result = {};
//    result.reserve(size);
//    for (int i = start; i < size; i++)
//        result.push_back(i);
//
//    return result;
//}
//
////void print_matrix(const std::vector<std::vector<int>> &matrix) {
////    std::cout << "Matrix:\n";
////    for (const std::vector<int>& item : matrix) {
////        for (int element : item)
////            std::cout << element << " ";
////        std::cout << "\n";
////    }
////}
//
//
//
//std::pair<std::vector<std::vector<int>>, std::vector<std::vector<int>>> WOWPP(const std::vector<int> &g, const std::vector<int> &h, const std::vector<int> &q,
//                                                                              int y_min = 2, int y_max = 5, int beg = 4, int end = 3) {
//
//    std::vector<std::vector<int>> result(y_max - y_min + 3, std::vector<int>(g.size() + 1, 0));
//    std::vector<std::vector<int>> f(y_max - y_min + 3, std::vector<int>(g.size() + 1, INF));
//    std::vector<int> y = fill_store(y_max + 1, y_min);
//    int index;
//    int max_value;
//    int min_value;
//    int cost;
//    int state = beg;
//
//    result[0] = std::vector<int>(g.size()+1, beg);
//    result[1] = std::vector<int>(g.size()+1, beg);
//
//
//    for (int month = 1; month < g.size(); month++) {
//        for (int status = y_min; status <= y_max - y_min + 1; status++) {
//            index = (int)g.size() - month - 1;
//
//            if (status == y_min)
//                max_value = min_value = end + q[index] - y[status];
//            else {
//                min_value = std::max(y_min + q[index] - y[status], 0);
//                max_value = std::min(y_max + q[index] - y[status], (int)g.size() - 1);
//            }
//
//            if (min_value > max_value || min_value < 0 || max_value < 0 || max_value > (int)g.size() - 1) {
//                result[month][status] = -INF;
//                f[month][status] = INF;
//                continue;
//            }
//
//            for (int value = min_value; value <= max_value; value++) {
//                if (status != 0)
//                    cost = g[value] + h[y[status] + value - q[index] - y_min] +
//                           f[y[status] + value - q[index] - y_min][month - 1];
//                else
//                    cost = g[value];
//
//                if (cost < f[month][status]) {
//                    result[month][status] = value;
//                    f[month][status] = cost;
//                }
//            }
//        }
//    }
//    std::cout << "Total cost: " << *f[beg - y_min].cend() << "\n";
//
//    for (int i = (int)f.size() - 1; i >= 0; i--) {
//        index = (int)f.size() - 1 - i;
//        std::cout << "State: " << state + result[state - y_min][i] - q[index] << " ";
//        std::cout << "Decision: " << result[state - y_min][i] << "\n";
//
//    }
//
//    return {result, f};
//}
//
//
//int main() {
//    std::vector<int> production_costs = {2, 8, 12, 15, 17, 20};
//    std::vector<int> storing_costs = {INF, INF, 1, 2, 2, 4};
//    std::vector<int> q = {4, 2, 6, 5, 3, 3};
//
//    WOWPP(production_costs, storing_costs, q);
//
//    return 0;
//}

double myPow(double x, int n) {
    if (n < 0) {
        x = 1 / x;
        n = -n;
    }

    double result = x;

    for (int i = 0; i < n - 1; i++) {
        result *= x;
    }

    return result;
}

int main() {
    std::cout << myPow(2, -2);

    return 0;
}
