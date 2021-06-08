//
//  ChartCompareModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 07.06.2021.
//

import Foundation
import Combine
import SwiftUI
import UIKit

class ChartCompareModel: ObservableObject {
    @Published var titleColor=Color.blue
    @Published var textColor = Color.blue
    @Published var title: String=""
    @Published var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)
    @Published var width: CGFloat=0
    var chartWidth: CGFloat=0
    @Published var descriptions = [String]()
    @Published var values = [[String]]()
    @Published var descriptionWidth:CGFloat=0.2
    @Published var recordWidth: CGFloat = 0.4
    @Published var count=7
    func setData(descriptions: [String]?=nil, values: [[String]]){
        self.descriptions = descriptions ?? self.descriptions
        self.values=values
        self.updateSize()
    }
    
    func setDescriptions(descriptions: [String]){
        self.descriptions=descriptions
        self.updateSize()
    }
    
    func setSize(width: CGFloat){
        self.chartWidth=width
        self.updateSize()
    }
    
    func updateSize(){
        self.width = 0.5*self.chartWidth * CGFloat(self.values.count)
        self.descriptionWidth=0.3*self.chartWidth
        self.recordWidth=0.35*self.chartWidth
    }
}
