//
//  ChartRhythmogram2.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 23.04.2021.
//

import Foundation
import SwiftUI
import Combine


struct ChartTimeDistribution: View {
    
    @ObservedObject var model = ChartTimeDistributionModel()
    @State var pickerIsPresented = false
    @State var timePicker: String = Localization.getString("IDS_CHART_TIMEDISTRIBUTION_PICKER_DAILY")
    let timePickerOptions=[
        Localization.getString("IDS_CHART_TIMEDISTRIBUTION_PICKER_DAILY"),
        Localization.getString("IDS_CHART_TIMEDISTRIBUTION_PICKER_WEEKLY")
    ]
    var dates: [Date]?
    var values: [Double]?
    var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    let title: String
    
    var titleColor=Color.blue
    var textColor=Color.blue
    
    init(dates:[Date]? = nil,values:[Double]?=nil,miniature: Bool=false){
        self.dates=dates
        self.values=values
        self.miniature=miniature
        
        if(self.miniature){
            self.title=""
            self.offset=0
        }
        else{
            self.title=Localization.getString("IDS_CHART_TIMEDISTRIBUTION_NAME")
        }
        if(self.dates != nil && values != nil){
            self.model.setup(dates: self.dates!, values: self.values!)
        }
    }
    
    func setup(dates: [Date],values: [Double]){
        self.model.setup(dates: dates, values: values)
    }
    
    mutating func setColors(titleColor: Color,textColor: Color,axisColor: UIColor,gridColor: UIColor?=nil,colors: [UIColor]?=nil){
        self.titleColor=titleColor
        self.textColor=textColor
        self.model.setColors(axisColor: axisColor,gridColor: gridColor,colors: colors)
    }

    var body: some View{
        GeometryReader{ g in
            Group{
                ChartBase(text: self.title,textColor: self.titleColor,backgroundColor:self.backgroundColor)
                Text( (self.pickerIsPresented ? "↓ " : "↑ ") + self.timePicker)
                    .foregroundColor(self.textColor)
                    .frame(width:g.size.width-self.offset,alignment: .trailing)
                    .offset(x:0,y:self.offset)
                    .onTapGesture {
                        self.pickerIsPresented = self.pickerIsPresented ? false : true
                    }
                
                if(self.pickerIsPresented){
                    Picker("", selection: self.$timePicker, content: {
                        ForEach(self.timePickerOptions,id:\.self){ i in
                            Text(i).foregroundColor(self.textColor)
                        }
                        
                        
                    })
                    .frame(width: g.size.width-2*self.offset, height: 100,alignment: . topLeading)
                    .offset(x: self.offset, y: 2*self.offset)
                    
                }
                else{
                    if(self.timePicker==timePickerOptions[0]){
                        Image(uiImage: self.model.daily.img ?? UIImage())
                            .offset(x: self.offset+self.model.axisWidth, y: 3*self.offset)
                        
                        Image(uiImage: self.model.daily.imgAxisX ?? UIImage())
                            .offset(x: self.offset, y: 3*self.offset)
                            .offset(x: self.model.axisWidth, y: self.model.height ?? 0)
                        
                        
                        Image(uiImage: self.model.daily.imgAxisY ?? UIImage())
                            .offset(x: self.offset, y: 3*self.offset)
                    }
                    else{
                        Image(uiImage: self.model.weekly.img ?? UIImage())
                            .offset(x: self.offset+self.model.axisWidth, y: 3*self.offset)
                        
                        Image(uiImage: self.model.weekly.imgAxisX ?? UIImage())
                            .offset(x: self.offset, y: 3*self.offset)
                            .offset(x: self.model.axisWidth, y: self.model.height ?? 0)
                        
                        
                        Image(uiImage: self.model.weekly.imgAxisY ?? UIImage())
                            .offset(x: self.offset, y: 3*self.offset)
                    }
                }
            }.onAppear(perform: {
                self.model.setSize(height: 0.65*g.size.height, width: g.size.width-2*self.offset)
            })
            
        }
    }
    
    
}







