//
//  ChartInfoModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.05.2021.
//

import Foundation
import SwiftUI

class ChartInfoModel: ObservableObject{
    @Published var descriptions: [String]=[]
    @Published var values: [String]=[]
    @Published var titleColor=Color.blue
    @Published var textColor = Color.blue
    @Published var title: String=""
    @Published var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)

    func setup(descriptions: [String],values: [String]){
        self.descriptions=descriptions
        self.values=values
    }
}
