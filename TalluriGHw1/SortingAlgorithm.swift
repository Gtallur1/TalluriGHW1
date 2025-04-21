//
//  SortingAlgorithm.swift
//  TalluriGHw1
//
//  Created by Gayatri Talluri on 4/17/25.
//
import Foundation

protocol SortingAlgorithm {
    func sort(_ array: inout [Int], updateHandler: ([Int]) -> Void)
}

// Selection Sort
class Selection: SortingAlgorithm {
    func sort(_ array: inout [Int], updateHandler: ([Int]) -> Void) {
        let count = array.count
        
        for i in 0..<count {
            var minIndex = i
            
            for j in i+1..<count {
                if array[j] < array[minIndex] {
                    minIndex = j
                }
            }
            
            if minIndex != i {
                array.swapAt(i, minIndex)
                updateHandler(array)
            }
        }
    }
}

//Insertion Sort
class Insertion: SortingAlgorithm {
    func sort(_ array: inout [Int], updateHandler: ([Int]) -> Void) {
        let count = array.count
        
        for i in 1..<count {
            let key = array[i]
            var j = i - 1
            
            while j >= 0 && array[j] > key {
                array[j + 1] = array[j]
                j -= 1
                updateHandler(array)
            }
            
            array[j + 1] = key
            updateHandler(array)
        }
    }
}

// Quick Sort
class QuickSort: SortingAlgorithm {
    func sort(_ array: inout [Int], updateHandler: ([Int]) -> Void) {
        quickSort(&array, low: 0, high: array.count - 1, updateHandler: updateHandler)
    }
    
    private func quickSort(_ array: inout [Int], low: Int, high: Int, updateHandler: ([Int]) -> Void) {
        if low < high {
            let pivotIndex = partition(&array, low: low, high: high, updateHandler: updateHandler)
            
            quickSort(&array, low: low, high: pivotIndex - 1, updateHandler: updateHandler)
            quickSort(&array, low: pivotIndex + 1, high: high, updateHandler: updateHandler)
        }
    }
    
    private func partition(_ array: inout [Int], low: Int, high: Int, updateHandler: ([Int]) -> Void) -> Int {
        let pivot = array[high]
        var i = low - 1
        
        for j in low..<high {
            if array[j] <= pivot {
                i += 1
                array.swapAt(i, j)
                updateHandler(array)
            }
        }
        
        array.swapAt(i + 1, high)
        updateHandler(array)
        
        return i + 1
    }
}

//Merge Sort
class MergeSort: SortingAlgorithm {
    func sort(_ array: inout [Int], updateHandler: ([Int]) -> Void) {
        mergeSort(&array, left: 0, right: array.count - 1, updateHandler: updateHandler)
    }
    
    private func mergeSort(_ array: inout [Int], left: Int, right: Int, updateHandler: ([Int]) -> Void) {
        if left < right {
            let mid = (left + right) / 2
            
            mergeSort(&array, left: left, right: mid, updateHandler: updateHandler)
            mergeSort(&array, left: mid + 1, right: right, updateHandler: updateHandler)
            
            merge(&array, left: left, mid: mid, right: right, updateHandler: updateHandler)
        }
    }
    
    private func merge(_ array: inout [Int], left: Int, mid: Int, right: Int, updateHandler: ([Int]) -> Void) {
        let leftSize = mid - left + 1
        let rightSize = right - mid
        
        var leftArray = [Int](repeating: 0, count: leftSize)
        var rightArray = [Int](repeating: 0, count: rightSize)
       
        for i in 0..<leftSize {
            leftArray[i] = array[left + i]
        }
        
        for j in 0..<rightSize {
            rightArray[j] = array[mid + 1 + j]
        }
        
        var i = 0, j = 0, k = left
        
        while i < leftSize && j < rightSize {
            if leftArray[i] <= rightArray[j] {
                array[k] = leftArray[i]
                i += 1
            } else {
                array[k] = rightArray[j]
                j += 1
            }
            k += 1
            updateHandler(array)
        }
       
        while i < leftSize {
            array[k] = leftArray[i]
            i += 1
            k += 1
            updateHandler(array)
        }
        
        while j < rightSize {
            array[k] = rightArray[j]
            j += 1
            k += 1
            updateHandler(array)
        }
    }
}

// Sorting Factory
class SortingFactory {
    static func createSorter(for algorithm: String) -> SortingAlgorithm {
        switch algorithm {
        case "Selection":
            return Selection()
        case "Insertion":
            return Insertion()
        case "Quick Sort":
            return QuickSort()
        case "Merge Sort":
            return MergeSort()
        default:
            return Insertion()// Default to Insertion sort
        }
    }
}
