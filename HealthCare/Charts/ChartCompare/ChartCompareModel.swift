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
    @Published var descriptions = [String]()
    @Published var values = [[String]]()
    @Published var descriptionWidth:CGFloat=0.1
    @Published var recordWidth: CGFloat = 0.45
    @Published var count=7
    @Published var position: Int=0
    @Published var clrLeft: Color = .clear
    @Published var clrRight: Color = .clear
    @Published var stringHeight: CGFloat=0
    @Published var selectedRecord: Storage.Record?
    
    var colors: Colors?
    var chartWidth: CGFloat=0
    var chartHeight: CGFloat=0
    var clrBad=Color.red.opacity(0.3)
    var clrGood=Color.green.opacity(0.3)
    var clrDefault=Color.yellow.opacity(0.3)
    
    var valLeft=[String]()
    var valRight=[String]()
    
    func setData(descriptions: [String]?=nil, values: [[String]]){
        self.descriptions = descriptions ?? self.descriptions
        self.values=values
        self.updateSize()
        self.setPosition(0)
    }
    
    func setColors(_ colors: Colors){
        self.colors=colors
    }
    func setDescriptions(descriptions: [String]){
        self.descriptions=descriptions
        self.updateSize()
    }
    
    func setSize(width: CGFloat,height: CGFloat){
        self.chartWidth=width
        self.chartHeight=height
        self.updateSize()
    }
    
    func findRecordByDate(_ date: String)->Storage.Record?{
        let storage=Storage.shared
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        for i in 0..<storage.all.count{
            let str = formatter.string(from: storage.all[i].date)
            if(str==date){
                return storage.all[i]
            }
        }
        return nil
    }
    
    func updateSize(){
        self.width = 0.5*self.chartWidth * CGFloat(self.values.count)
        self.descriptionWidth=0.3*self.chartWidth
        self.recordWidth=0.35*self.chartWidth
        if(self.descriptions.count>0){
            self.stringHeight=self.chartHeight/CGFloat(self.descriptions.count)
        }
    }
    
    func setPosition(_ position: Int){
        self.position=position
        if(position+1>self.values.count-1){
            return
        }
        
        self.valLeft=self.values[position]
        self.valRight=self.values[position+1]
        
        guard let left=Double(valLeft[2]),
              let right=Double(valRight[2])
        else{
            return
        }
        if(left>right){
            clrLeft=self.clrGood
            clrRight=self.clrBad
        }
        if(right>left){
            clrRight=self.clrGood
            clrLeft=self.clrBad
        }
        if(right==left){
            clrLeft = self.clrDefault
            clrRight = self.clrDefault
        }
        //        self.clrLeft = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
        //        self.clrRight = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
}
