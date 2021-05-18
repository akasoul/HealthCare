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
    var data: [Storage.Record]?
    let backgroundColor: Color
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    let title: String
    
    let topColor = UIColor.blue
    let bottomColor = UIColor.blue.withAlphaComponent(0.3)
    let textColor=Color.blue
    init(data:[Storage.Record]? = nil,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2),miniature: Bool=false){
        self.data=data
        self.miniature=miniature
        self.backgroundColor=backgroundColor
        
        if(self.miniature){
            self.title=""
            self.offset=0
        }
        else{
            self.title=Localization.getString("IDS_CHART_TIMEDISTRIBUTION_NAME")
        }
        if(self.data != nil){
            self.model.setup(data: self.data!, topColor: self.topColor, bottomColor: self.bottomColor)
        }
    }
    
    func setup(data: [Storage.Record]){
        self.model.setup(data: data, topColor: self.topColor, bottomColor: self.bottomColor)
    }
    
    
    var body: some View{
        GeometryReader{ g in
            Group{
                ChartBase(text: self.title,backgroundColor:self.backgroundColor)
                Text( (self.pickerIsPresented ? "↓ " : "↑ ") + self.timePicker)
                    .foregroundColor(self.textColor)
                    .frame(width:g.size.width-self.offset,alignment: .trailing)
                    .offset(x:0,y:self.offset)
                    .onTapGesture {
                        print("tap")
                        self.pickerIsPresented = self.pickerIsPresented ? false : true
                    }
                
                if(self.pickerIsPresented){
                    Picker("", selection: self.$timePicker, content: {
                        ForEach(self.timePickerOptions,id:\.self){ i in
                            Text(i).foregroundColor(self.textColor)
                        }
                        
                        
                    })
                    .border(Color.red)
                    .frame(width: g.size.width-2*self.offset, height: 100,alignment: . topLeading)
                    .offset(x: self.offset, y: 2*self.offset)
                    
                }
                else{
                    if(self.timePicker==timePickerOptions[0]){
                        Image(uiImage: self.model.daily.img ?? UIImage())
                            //.frame(width: g.size.width-2*self.offset, height: g.size.height-2*self.offset)
                            //.clipped()
                            .offset(x: self.offset, y: 2*self.offset)
                    }
                    else{
                        Image(uiImage: self.model.weekly.img ?? UIImage())
                            //.frame(width: g.size.width-2*self.offset, height: g.size.height-2*self.offset)
                            //.clipped()
                            .offset(x: self.offset, y: 2*self.offset)
                    }
                }
            }.onAppear(perform: {
                self.model.setSize(height: 0.5*g.size.height, width: g.size.width-2*self.offset)
            })
            
        }
    }
    
    
}







