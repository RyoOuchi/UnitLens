//
//  AddViewController.swift
//  UnitLens
//
//  Created by 大内亮 on 2024/09/15.
//

import UIKit
import RealmSwift
import PhotosUI

class AddViewController: UIViewController, PHPickerViewControllerDelegate {

    
    
    let realm = try! Realm()
    var conversionDataArray: [ConversionData] = []
    @IBOutlet var inputValueUnique: UITextField!
    @IBOutlet var unitName: UITextField!
    @IBOutlet var inputValueOriginal: UITextField!
    @IBOutlet var inputImage: UIImageView!
    @IBOutlet var imageSelectButton: UIButton!
    @IBOutlet var unitLabel: UILabel!
    let conversionAlgorithm = ConversionAlgorithm()
    var keyString = [String]()
    var keyInt: Int = 0
    var viewKey: Int = 0
    //TODO create outlet for buttons

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left

        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        keyString = conversionAlgorithm.length
        unitLabel.text = keyString[2]
        conversionDataArray = fetchConversionData()
    }
    
    
    @IBAction func save() {
        guard let unitKey = unitName.text, !unitKey.isEmpty,
              let inputUniqueText = inputValueUnique.text, 
              let inputUnique = Double(inputUniqueText),
              let inputOriginalText = inputValueOriginal.text,
              let inputOriginal = Double(inputOriginalText) else {
            showAlert(message: "Please fill out all fields.")
            return
        }
        
        if realm.objects(ConversionData.self).filter("unitKey == %@", unitKey).first != nil {
            showAlert(message: "There exists a unit that is already named \(unitKey).")
            return
        }
        
        let imageData: Data? = inputImage.image?.jpegData(compressionQuality: 1.0)
        let newConversionData = ConversionData()
        
        
        newConversionData.conInit(unitKey: unitKey, conversionRate: inputUnique / conversionAlgorithm.convertToBaseUnit(input: inputOriginal, inputUnit: unitLabel.text ?? "nil", inputUnitType: conversionAlgorithm.getUnitCategory(for: unitLabel.text ?? "nil") ?? "nil"), unitImageData: imageData, convertToKey: conversionAlgorithm.convertToBaseString(inputUnitType: conversionAlgorithm.getUnitCategory(for: unitLabel.text ?? "nil") ?? "nil"))
        //TODO fill convertToKey
        
        conversionDataArray.append(newConversionData)
        
        try! realm.write {
            realm.add(conversionDataArray)
        }
        
        dismiss(animated: true)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func fetchConversionData() -> [ConversionData] {
        return Array(realm.objects(ConversionData.self))
    }
    
    @IBAction func selectImage() {
        var configuration = PHPickerConfiguration()
        let filter = PHPickerFilter.images
        configuration.filter = filter
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        if let itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image , error in 
                DispatchQueue.main.async {
                    self.inputImage.image = image as? UIImage
                }
            }
        }
        
        dismiss(animated: true)
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
            self.keyString = conversionAlgorithm.length
            unitLabel.text = keyString[2]
        case 1:
            self.keyString = conversionAlgorithm.weight
            unitLabel.text = keyString[2]
        case 2:
            self.keyString = conversionAlgorithm.time
            unitLabel.text = keyString[0]
        default:
            break
        }
    }
    
    @IBAction func up(){
        if keyInt == keyString.count - 1 {
            keyInt = 0
        } else {
            keyInt += 1
        }
        
        print(keyInt)
        print(keyString.count - 1)
        
        unitLabel.text = keyString[keyInt]
    }
    
    @IBAction func down(){
        if keyInt == 0 {
            keyInt = keyString.count - 1
        } else {
            keyInt -= 1
        }
        
        unitLabel.text = keyString[keyInt]
    }

}
