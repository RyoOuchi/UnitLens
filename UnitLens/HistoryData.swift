//
//  HistoryData.swift
//  UnitLens
//
//  Created by 大内亮 on 2024/09/15.
//

import Foundation
import RealmSwift

class HistoryData: Object {
    @Persisted var unitKey: String = ""
    @Persisted var accessDate: Date!
    @Persisted var isMarked: Bool = false
    @Persisted var input: Double = 0
    @Persisted var convertToKey: String = ""
    
    func conInit(unitKey: String, accessDate: Date!, isMarked: Bool, input: Double, convertToKey: String) {
        self.unitKey = unitKey
        self.accessDate = accessDate
        self.isMarked = isMarked
        self.input = input
        self.convertToKey = convertToKey
    }
}
