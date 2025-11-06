#include <iostream>
#include <vector>
#include <cmath>
#include <chrono>
#include <algorithm>
#include <random>
#include <numeric>
#include <unordered_set>

// Optimized function: iterative factorial with memoization
static long long factorial_cache[21] = {0};
long long optimized_factorial(int n) {
    if (n <= 1) return 1;
    if (n <= 20 && factorial_cache[n] != 0) {
        return factorial_cache[n];
    }
    long long result = 1;
    for (int i = 2; i <= n; ++i) {
        result *= i;
    }
    if (n <= 20) {
        factorial_cache[n] = result;
    }
    return result;
}

// Optimized function: binary search in sorted array
bool optimized_binary_search(const std::vector<int>& arr, int target) {
    int left = 0;
    int right = arr.size() - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) {
            return true;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return false;
}

// Optimized function: using std::sort (typically uses introsort - hybrid of quicksort, heapsort, and insertion sort)
void optimized_sort(std::vector<int>& arr) {
    std::sort(arr.begin(), arr.end());
}

// Optimized function: pre-compute values and use lookup
double optimized_math_calculation(int iterations) {
    // Pre-compute sin and cos values
    std::vector<double> sin_values(iterations);
    std::vector<double> cos_values(1000);
    
    for (int i = 0; i < iterations; ++i) {
        sin_values[i] = sin(i * 0.001);
    }
    for (int j = 0; j < 1000; ++j) {
        cos_values[j] = cos(j * 0.001);
    }
    
    double result = 0.0;
    // Reduced inner loop iterations to keep it optimized but still measurable
    for (int i = 0; i < iterations; ++i) {
        for (int j = 0; j < 1000; ++j) {
            result += sin_values[i] * cos_values[j] * sqrt(i + j);
        }
    }
    return result;
}

// Optimized function: use reference to avoid unnecessary copies
const std::vector<int>& optimized_copy_operations(const std::vector<int>& source) {
    // Return reference instead of copying
    return source;
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    
    std::cout << "Starting optimized computations..." << std::endl;
    
    // Section 1: Optimized factorial calculations (increased workload)
    std::cout << "Section 1: Computing factorials (optimized)..." << std::endl;
    for (int repeat = 0; repeat < 1000; ++repeat) {
        for (int i = 1; i <= 20; ++i) {
            optimized_factorial(i);
        }
    }
    
    // Section 2: Binary searches (after sorting) - increased workload
    std::cout << "Section 2: Binary searches (optimized)..." << std::endl;
    std::vector<int> large_array(100000);  // Increased from 10000
    std::iota(large_array.begin(), large_array.end(), 1);
    std::random_device rd;
    std::mt19937 g(rd());
    std::shuffle(large_array.begin(), large_array.end(), g);
    
    // Sort once, then use binary search
    std::sort(large_array.begin(), large_array.end());
    
    for (int i = 0; i < 10000; ++i) {  // Increased from 1000
        optimized_binary_search(large_array, (i * 10) % 100000);
    }
    
    // Section 3: Optimized sort (std::sort) - increased workload
    std::cout << "Section 3: Optimized sort..." << std::endl;
    for (int repeat = 0; repeat < 10; ++repeat) {
        std::vector<int> sort_array(10000);  // Increased from 5000
        std::iota(sort_array.begin(), sort_array.end(), 1);
        std::shuffle(sort_array.begin(), sort_array.end(), g);
        optimized_sort(sort_array);
    }
    
    // Section 4: Optimized mathematical calculations - increased iterations
    std::cout << "Section 4: Optimized mathematical calculations..." << std::endl;
    double math_result = optimized_math_calculation(5000);  // Increased from 1000
    std::cout << "Calculation result: " << math_result << std::endl;
    
    // Section 5: Optimized copy operations (using references) - increased workload
    std::cout << "Section 5: Optimized copy operations..." << std::endl;
    std::vector<int> source_array(100000);  // Increased from 10000
    std::iota(source_array.begin(), source_array.end(), 1);
    for (int i = 0; i < 1000; ++i) {  // Increased from 100
        const std::vector<int>& result = optimized_copy_operations(source_array);
        (void)result; // Avoid unused variable warning
    }
    
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::seconds>(end - start);
    
    std::cout << "Total execution time: " << duration.count() << " seconds" << std::endl;
    
    return 0;
}

