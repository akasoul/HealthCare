//
//  ChartRhythmogram2.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 23.04.2021.
//

import Foundation
import SwiftUI
import Combine


struct ChartDistribution: View {
    
    @ObservedObject var model = ChartDistributionModel()
    @State var pickerIsPresented = false
    @State var timePicker: String = Localization.getString("IDS_CHART_DISTRIBUTION_PICKER_DAILY")
    @State var showHelp: Bool=false
    
    let timePickerOptions=[
        Localization.getString("IDS_CHART_DISTRIBUTION_PICKER_DAILY"),
        Localization.getString("IDS_CHART_DISTRIBUTION_PICKER_WEEKLY")
    ]
    let textHelp=Localization.getString("IDS_CHART_DISTRIBUTION_HELP")
    var dates: [Date]?
    var values: [Double]?
    var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    
    init(dates:[Date]? = nil,values:[Double]?=nil,miniature: Bool=false){
        self.dates=dates
        self.values=values
        self.miniature=miniature
        
        if(self.miniature){
            self.offset=0
        }

        if(self.dates != nil && values != nil){
            self.model.setup(dates: self.dates!, values: self.values!)
        }
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }

    func setupAxisY(minValue: Double,maxValue: Double){
        self.model.setYAxisMarks(minValue: minValue, maxValue: maxValue)
    }

    func setData(dates: [Date],values: [Double]){
        self.model.setup(dates: dates, values: values)
    }
    
    func setColors(titleColor: Color,textColor: Color,axisColor: UIColor,gridColor: UIColor?=nil,colors: [UIColor]?=nil,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.textColor=textColor
        self.model.backgroundColor=backgroundColor
        self.model.setColors(axisColor: axisColor,gridColor: gridColor,colors: colors)
    }

    func help(){
        withAnimation(.linear(duration: 0.5), {
            //self.rotationAngle = self.rotationAngle == Angle(degrees: 360) ? Angle(degrees: 0) : Angle(degrees: 360)
            self.showHelp = self.showHelp == true ? false : true
        })
    }

    var body: some View{
        GeometryReader{ g in
            Group{
                ChartBase(text: self.model.title,textColor: self.model.titleColor,showHelpButton: true,showHelpButtonColor: self.model.textColor,showHelpButtonAction: self.help, backgroundColor:self.model.backgroundColor)
                if(!self.showHelp){
                Text( (self.pickerIsPresented ? "↓ " : "↑ ") + self.timePicker)
                    .font(.system(size: 12))
                    .foregroundColor(self.model.textColor)
                    .frame(width:g.size.width-2*self.offset,alignment: .trailing)
                    .offset(x:0,y:self.offset)
                    .onTapGesture {
                        self.pickerIsPresented = self.pickerIsPresented ? false : true
                    }
                
                if(self.pickerIsPresented){
                    Picker("", selection: self.$timePicker, content: {
                        ForEach(self.timePickerOptions,id:\.self){ i in
                            Text(i)
                                .font(.system(size: 12))
                                .foregroundColor(self.model.textColor)
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
            }
                else{
                    Text(self.textHelp)
                        .font(.system(size: 12))
                        .frame(width:g.size.width-2*self.offset,alignment: .leading)
                        .offset(x:self.offset,y:2.5*self.offset)
                        .foregroundColor(self.model.textColor)
                }
            }.onAppear(perform: {
                self.model.setSize(height: 0.65*g.size.height, width: g.size.width-2*self.offset)
            })
            
        }
    }
    
    
}







