//
//  ResultViewController.swift
//  UnitLens
//
//  Created by 大内亮 on 2024/09/15.
//

import UIKit
import RealmSwift

class ResultViewController: UIViewController {
    
    let realm = try! Realm()
    var dataArray: [ConversionData] = []
    var historyArray: [HistoryData] = []
    var input: Double = 0
    var arrayID: Int = 0
    var output: Double!
    @IBOutlet var starImage: UIBarButtonItem!
    @IBOutlet var inputLabel: UILabel!
    @IBOutlet var outputLabel: UILabel!
    var favBool: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        historyArray = fetchHistoryData()
        dataArray = fetchConversionData()
        output = input * dataArray[arrayID].conversionRate
        inputLabel.text = "\(input)"
        outputLabel.text = "\(output ?? 0)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        historyArray = fetchHistoryData()
        dataArray = fetchConversionData()
        output = input * dataArray[arrayID].conversionRate
        print("success\(input)")
        inputLabel.text = "\(input)"
        outputLabel.text = "\(output ?? 0)"
    }
    
    func fetchConversionData() -> [ConversionData] {
        return Array(realm.objects(ConversionData.self))
    }
    
    func fetchHistoryData() -> [HistoryData] {
        return Array(realm.objects(HistoryData.self))
    }
    
    @IBAction func markStar() {
        favBool.toggle()
        let starImageName = favBool ? "star.fill" : "star"
        starImage.image = UIImage(systemName: starImageName)
        
        guard let lastHistory = historyArray.last else {
            print("No history data found")
            return
        }
        
        do {
            try realm.write {
                lastHistory.isMarked = favBool
            }
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }


    
    //TODO ADD the pictures here
}
