//
//  ViewController.swift
//  TalluriGHw1
//
//  Created by Gayatri Talluri on 4/13/25.
//


import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sampleSizeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var topAlgorithmSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomAlgorithmSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var topChartView: SortingChartView!
    @IBOutlet weak var bottomChartView: SortingChartView!

    private let algorithms = ["Insertion","Selection","Quick Sort", "Merge Sort"]
    private let sampleSizes = [16, 32, 48, 64]
    
    private var currentSampleSize: Int {
        return sampleSizes[sampleSizeSegmentedControl.selectedSegmentIndex]
    }
    
    private var topSelectedAlgorithm: Int = 0
    private var bottomSelectedAlgorithm: Int = 0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSegmentedControls()
        generateNewArrays()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Configure UI elements
        sortButton.layer.cornerRadius = 5
        sampleSizeSegmentedControl.selectedSegmentIndex = 0
    }
    
    private func setupSegmentedControls() {
        topAlgorithmSegmentedControl.removeAllSegments()
        bottomAlgorithmSegmentedControl.removeAllSegments()
        for (index, algorithm) in algorithms.enumerated()
        {
            topAlgorithmSegmentedControl.insertSegment(withTitle: algorithm, at: index, animated: false)
            bottomAlgorithmSegmentedControl.insertSegment(withTitle: algorithm, at: index, animated: false)
        }

        topAlgorithmSegmentedControl.selectedSegmentIndex = 0
        bottomAlgorithmSegmentedControl.selectedSegmentIndex = 0
    }
    @IBAction func topAlgorithmChanged(_ sender: UISegmentedControl) {
        topSelectedAlgorithm = sender.selectedSegmentIndex
        generateNewArrays()
    }

    @IBAction func bottomAlgorithmChanged(_ sender: UISegmentedControl) {
        bottomSelectedAlgorithm = sender.selectedSegmentIndex
        generateNewArrays()
    }
    
    // Actions
    @IBAction func sampleSizeChanged(_ sender: UISegmentedControl) {
        generateNewArrays()
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        setUIEnabled(false)
        let topAlgorithm = algorithms[topSelectedAlgorithm]
        let bottomAlgorithm = algorithms[bottomSelectedAlgorithm]
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.runSortingAlgorithm(algorithm: topAlgorithm, forChartView: self.topChartView) {
                dispatchGroup.leave()
            }
        }
      
        dispatchGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.runSortingAlgorithm(algorithm: bottomAlgorithm, forChartView: self.bottomChartView) {
                dispatchGroup.leave()
            }
        }
       
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.setUIEnabled(true)
        }
    }
    
    private func generateNewArrays() {
        let size = currentSampleSize
        //random arrays
        let topArray = (0..<size).map { _ in Int.random(in: 1...100) }
        let bottomArray = (0..<size).map { _ in Int.random(in: 1...100) }
        
        topChartView.setArray(topArray,barColor: .systemGreen)
        bottomChartView.setArray(bottomArray,barColor: .systemOrange)
    }
    
    private func setUIEnabled(_ enabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
                
            self.sortButton.isEnabled = enabled
            self.sampleSizeSegmentedControl.isEnabled = enabled
            self.topAlgorithmSegmentedControl.isEnabled = enabled
            self.bottomAlgorithmSegmentedControl.isEnabled = enabled
        }
    }
    
    private func runSortingAlgorithm(algorithm: String, forChartView chartView: SortingChartView, completion: @escaping () -> Void) {
       
        guard var array = chartView.getArray() else {
            completion()
            return
        }
      
        let sorter = SortingFactory.createSorter(for: algorithm)
       
        sorter.sort(&array) { [weak self] currentArray in
            guard let self = self else { return }
           
            DispatchQueue.main.async {
                if chartView == self.topChartView
                {
                    chartView.updateArray(currentArray, barColor: .systemGreen)
                }
                else
                {
                    chartView.updateArray(currentArray, barColor: .systemOrange)
                }
            }
           
            Thread.sleep(forTimeInterval: 0.05)
        }
        
        DispatchQueue.main.async {
            if chartView == self.topChartView
            {
                chartView.updateArray(array, barColor: .systemGreen)
            }
            else
            {
                chartView.updateArray(array, barColor: .systemOrange)
            }
            completion()
        }
    }
}

