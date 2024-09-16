//
//  ViewController.swift
//  UnitLens
//
//  Created by 大内亮 on 2024/09/14.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UITextFieldDelegate {

    let realm = try! Realm()
    
    @IBOutlet var inputField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var unitLabel: UILabel!
    var inputValue: Double!
    var keyString = [String]()
    var keyInt: Int = 0
    var viewKey: Int = 0
    var units: [ConversionData] = []
    var historyArray: [HistoryData] = []
    var arrayIDSelect: Int = 0
    var tabBarID: String = ""
    let conversionAlgorithm = ConversionAlgorithm()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyString = conversionAlgorithm.length
        unitLabel.text = keyString[2]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left

        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        tableView.dataSource = self
        tableView.delegate = self
        tabBar.delegate = self
        inputField.delegate = self
        
        tableView.register(UINib(nibName: "ViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewCell")
        
        units = readConversionData()
        historyArray = fetchHistoryData()
        
        print("History Data Count: \(historyArray.count)")
        print("Conversion Data Count: \(units.count)")


    }
    
    override func viewDidAppear(_ animated: Bool) {
        units = readConversionData()
        historyArray = fetchHistoryData()
        
        print("History Data Count: \(historyArray.count)")
        print("Conversion Data Count: \(units.count)")
        tableView.reloadData()
    }

    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            if viewKey == 2{
                viewKey = 0
            } else {
                viewKey += 1
            }
        case .left:
            if viewKey == 0 {
                viewKey = 2
            } else {
                viewKey -= 1
            }
        default:
            break
        }
        
        switch viewKey {
        case 0:
            keyString = conversionAlgorithm.length
            unitLabel.text = keyString[2]
        case 1:
            keyString = conversionAlgorithm.weight
            unitLabel.text = keyString[2]
        case 2:
            keyString = conversionAlgorithm.time
            unitLabel.text = keyString[0]
        default:
            break
        }
    }
    
    @IBAction func up(){
        if keyInt == self.keyString.count - 1 {
            keyInt = 0
        } else {
            keyInt += 1
        }
        
        unitLabel.text = keyString[keyInt]
        updateConversions()
    }
    
    @IBAction func down(){
        if keyInt == 0 {
            keyInt = self.keyString.count - 1
        } else {
            keyInt -= 1
        }
        
        unitLabel.text = keyString[keyInt]
        updateConversions()
    }
    
    @IBAction func showOptionsMenu(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)
        
        let option1 = UIAlertAction(title: "Option 1", style: .default) { _ in
            print("Option 1 selected")
        }
        let option2 = UIAlertAction(title: "Option 2", style: .default) { _ in
            print("Option 2 selected")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(option1)
        alert.addAction(option2)
        alert.addAction(cancel)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return units.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell", for: indexPath) as! ViewTableViewCell
        let unit: ConversionData = units[indexPath.row]
        let image = unit.unitImage ?? UIImage(systemName: "nosign")!
        
        if let inputText = inputField.text, let inputValue = Double(inputText) {
            let baseUnitType = conversionAlgorithm.convertToBaseString(inputUnitType: unitLabel.text ?? "nil")
            if conversionAlgorithm.convertToBaseString(inputUnitType: unit.convertToKey) == baseUnitType {
                if let conversionValue = conversionAlgorithm.convert(value: inputValue, fromUnit: unit.convertToKey, toUnit: unitLabel.text!) {
                    let amount = unit.conversionRate * conversionValue
                    cell.setCell(amount: amount, unitImage: image, unitName: unit.unitKey)
                }
            }
        }

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrayIDSelect = indexPath.row
        performSegue(withIdentifier: "toResult", sender: self)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBarID = item.title ?? ""
        performSegue(withIdentifier: "toList", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toResult":
            let resultVC = segue.destination as! ResultViewController
            resultVC.arrayID = arrayIDSelect
            resultVC.input = Double(inputField.text ?? "0") ?? 0
            let unitElement = units[arrayIDSelect]
            let currentDate = Date()
            let newHistoryElement = HistoryData()
            newHistoryElement.conInit(unitKey: unitElement.unitKey, accessDate: currentDate, isMarked: false, input: (Double(inputField.text ?? "0") ?? 0), convertToKey: "m")
            
            //TODO convert to key is wrong
            
            historyArray.append(newHistoryElement)
            
            do {
                try realm.write {
                    realm.add(historyArray)
                }
            } catch {
                print("Error saving data: \(error.localizedDescription)")
            }
        case "toList":
            let listVC = segue.destination as! ListViewController
            listVC.tabBarID = self.tabBarID
        default:
            break
        }
        
    }
    
    func readConversionData() -> [ConversionData] {
        return Array(realm.objects(ConversionData.self))
    }
    func fetchHistoryData() -> [HistoryData] {
        return Array(realm.objects(HistoryData.self))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            updateView(with: updatedText)
            
            return true
        }
        
        func updateView(with text: String) {
            inputValue = Double(text) ?? 0
            tableView.reloadData()
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateConversions() {
        inputValue = Double(inputField.text ?? "0") ?? 0
        tableView.reloadData()
    }
}

