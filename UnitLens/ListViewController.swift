//
//  ListViewController.swift
//  UnitLens
//
//  Created by 大内亮 on 2024/09/15.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var navLabel: UINavigationItem!
    var tabBarID: String = ""
    let realm = try! Realm()
    @IBOutlet var tableView: UITableView!
    var historyData: [HistoryData] = []
    var conversionData: [ConversionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        
        tableView.dataSource = self
        historyData = fetchHistoryData()
        conversionData = fetchConversionData()
        
        print("History Data Count: \(historyData.count)")
        print("Conversion Data Count: \(conversionData.count)")
        
        navLabel.title = tabBarID
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
            let history = historyData.reversed()[indexPath.row]
            if let unit = conversionData.first(where: { $0.unitKey == history.unitKey }) {
                
                cell.setCell(
                    originalUnitValue: history.input * unit.conversionRate,
                    originalUnitString: history.unitKey,
                    uniqueUnitValue: history.input,
                    uniqueUnitString: unit.unitKey,
                    unitImage: unit.unitImage ?? UIImage(systemName: "nosign")!,
                    isMarked: history.isMarked
                )
            } else {
                cell.setCell(
                    originalUnitValue: 0,
                    originalUnitString: history.unitKey,
                    uniqueUnitValue: history.input,
                    uniqueUnitString: "Unknown",
                    unitImage: UIImage(systemName: "nosign")!,
                    isMarked: history.isMarked
                )
            }
            
            return cell
        }
    
    func fetchHistoryData() -> [HistoryData] {
        return Array(realm.objects(HistoryData.self))
    }
    
    func fetchConversionData() -> [ConversionData] {
        return Array(realm.objects(ConversionData.self))
    }

}
