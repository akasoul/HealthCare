//
//  ChartScaterogram.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 04.05.2021.
//

import Foundation
import SwiftUI
import Combine


struct ChartScaterogram: View {
    
    @ObservedObject var model = ChartScaterogramModel()
    @State var showHelp:Bool=false
    
    var data: [Double]?
    var frequency: Double?
    let backgroundColor: Color
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    let textHelp=Localization.getString("IDS_CHART_SCATEROGRAM_HELP")
    
    init(data:[Double]?=nil,fillColor:UIColor=UIColor.blue,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2),miniature: Bool=false){
        
        self.data=data
        self.miniature=miniature
        self.backgroundColor=backgroundColor
        if(self.miniature){
            self.offset=0
        }
        
        if(self.data != nil && self.frequency != nil){
            self.setData(data: self.data!,frequency: self.frequency!)
        }
        self.model.setColors(fillColor: UIColor.blue,axisColor: UIColor.blue)
        
    }
    
    func setColors(titleColor: Color,textColor: Color,fillColor: UIColor,axisColor: UIColor,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.textColor=textColor
        self.model.backgroundColor=backgroundColor
        self.model.setColors(fillColor: fillColor,axisColor: axisColor)
    }
    
    func setData(data: [Double],frequency: Double){
        self.model.setData(data: data,frequency: frequency)
    }
    
    func setTitle(_ title: String){
        self.model.title=title
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
                    Image(uiImage: self.model.img ?? UIImage())
                        .offset(x: self.offset+self.model.axisWidth, y: 2.5*self.offset)
                    
                    Image(uiImage: self.model.imgAxisX ?? UIImage())
                        .offset(x: self.offset, y: 2.5*self.offset)
                        .offset(x: self.model.axisWidth, y: self.model.height ?? 0)
                    
                    
                    Image(uiImage: self.model.imgAxisY ?? UIImage())
                        .offset(x: self.offset, y: 2.5*self.offset)
                }
                else{
                    Text(self.textHelp)
                        .font(.system(size: 12))
                        .frame(width:g.size.width-2*self.offset,alignment: .leading)
                        .offset(x:self.offset,y:2.5*self.offset)
                        .foregroundColor(self.model.textColor)
                    
                }
                
            }.onAppear(perform: {
                self.model.setSize(height: 0.7*g.size.height, width: g.size.width-2*self.offset)
            })
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: {i in
                self.model.setSize(height: 0.7*g.size.height, width: g.size.width-2*self.offset)
            })
        }
    }
    
    
}







