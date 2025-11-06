#include <iostream>
#include <vector>
#include <cmath>
#include <chrono>
#include <algorithm>
#include <random>
#include <numeric>

// Inefficient function: recursive factorial calculation without optimization
long long inefficient_factorial(int n) {
    if (n <= 1) return 1;
    return n * inefficient_factorial(n - 1);
}

// Inefficient function: linear search in unsorted array
bool inefficient_search(const std::vector<int>& arr, int target) {
    for (size_t i = 0; i < arr.size(); ++i) {
        if (arr[i] == target) {
            return true;
        }
    }
    return false;
}

// Inefficient function: bubble sort
void inefficient_bubble_sort(std::vector<int>& arr) {
    for (size_t i = 0; i < arr.size(); ++i) {
        for (size_t j = 0; j < arr.size() - 1; ++j) {
            if (arr[j] > arr[j + 1]) {
                std::swap(arr[j], arr[j + 1]);
            }
        }
    }
}

// Inefficient function: complex and repetitive mathematical calculations
double inefficient_math_calculation(int iterations) {
    double result = 0.0;
    for (int i = 0; i < iterations; ++i) {
        for (int j = 0; j < 1000; ++j) {
            result += sin(i * 0.001) * cos(j * 0.001) * sqrt(i + j);
        }
    }
    return result;
}

// Inefficient function: unnecessary copies
std::vector<int> inefficient_copy_operations(const std::vector<int>& source) {
    std::vector<int> temp1 = source;  // copy 1
    std::vector<int> temp2 = temp1;   // copy 2
    std::vector<int> temp3 = temp2;   // copy 3
    std::vector<int> result = temp3;  // copy 4
    return result;
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    
    std::cout << "Starting inefficient computations..." << std::endl;
    
    // Section 1: Factorial calculations
    std::cout << "Section 1: Computing factorials..." << std::endl;
    for (int i = 1; i <= 20; ++i) {
        inefficient_factorial(i);
    }
    
    // Section 2: Linear searches
    std::cout << "Section 2: Linear searches..." << std::endl;
    std::vector<int> large_array(10000);
    std::iota(large_array.begin(), large_array.end(), 1);
    std::random_device rd;
    std::mt19937 g(rd());
    std::shuffle(large_array.begin(), large_array.end(), g);
    
    for (int i = 0; i < 1000; ++i) {
        inefficient_search(large_array, i * 10);
    }
    
    // Section 3: Bubble sort
    std::cout << "Section 3: Bubble sort..." << std::endl;
    std::vector<int> sort_array(5000);
    std::iota(sort_array.begin(), sort_array.end(), 1);
    std::shuffle(sort_array.begin(), sort_array.end(), g);
    inefficient_bubble_sort(sort_array);
    
    // Section 4: Complex mathematical calculations
    std::cout << "Section 4: Complex mathematical calculations..." << std::endl;
    double math_result = inefficient_math_calculation(1000);
    std::cout << "Calculation result: " << math_result << std::endl;
    
    // Section 5: Unnecessary copies
    std::cout << "Section 5: Unnecessary copies..." << std::endl;
    std::vector<int> source_array(10000);
    std::iota(source_array.begin(), source_array.end(), 1);
    for (int i = 0; i < 100; ++i) {
        inefficient_copy_operations(source_array);
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::seconds>(end - start);
    
    std::cout << "Total execution time: " << duration.count() << " seconds" << std::endl;
    
    return 0;
}

