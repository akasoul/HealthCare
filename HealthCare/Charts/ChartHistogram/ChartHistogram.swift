//
//  ChartHistogram.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 04.05.2021.
//

import Foundation
import SwiftUI
import Combine


struct ChartHistogram: View {
    
    @ObservedObject var model = ChartHistogramModel()
    var data: [Double]?
    var frequency: Double?
    let backgroundColor: Color
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    let title: String
    var titleColor = Color.blue
    
    init(data:[Double]?=nil,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2),miniature: Bool=false){
        self.data=data
        self.miniature=miniature
        self.backgroundColor=backgroundColor
        
        if(self.miniature){
            self.title=""
            self.offset=0
        }
        else{
            self.title=Localization.getString("IDS_CHART_HISTOGRAM_NAME")
        }
        
        if(self.data != nil && self.frequency != nil){
            self.model.setup(data: self.data!,frequency: self.frequency!)
        }
        self.model.setColors(topColor: UIColor.blue,bottomColor: UIColor.blue.withAlphaComponent(0.3),axisColor: UIColor.blue)
    }
    
    mutating func setColors(titleColor: Color,topColor: UIColor,bottomColor: UIColor,axisColor: UIColor){
        self.titleColor=titleColor
        self.model.setColors(topColor: topColor,bottomColor: bottomColor,axisColor: axisColor)
    }
    
    func setup(data: [Double],frequency: Double){
        self.model.setup(data: data,frequency: frequency)
    }
    
    var body: some View{
        GeometryReader{ g in
            Group{
                ChartBase(text: self.title,textColor: self.titleColor,backgroundColor:self.backgroundColor)
                
                Image(uiImage: self.model.img ?? UIImage())
                    .offset(x: self.offset+self.model.axisWidth, y: 2*self.offset)
                
                Image(uiImage: self.model.imgAxisX ?? UIImage())
                    .offset(x: self.offset, y: 2*self.offset)
                    .offset(x: self.model.axisWidth, y: self.model.height ?? 0)
                
                
                Image(uiImage: self.model.imgAxisY ?? UIImage())
                    .offset(x: self.offset, y: 2*self.offset)
                
            }.onAppear(perform: {
                self.model.setSize(height: 0.7*g.size.height, width: g.size.width-2*self.offset)
            })
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: {i in
                self.model.setSize(height: 0.7*g.size.height, width: g.size.width-2*self.offset)
            })
        }
    }
    
    
}







