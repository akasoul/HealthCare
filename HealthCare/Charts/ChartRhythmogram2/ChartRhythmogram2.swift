//
//  ChartRhythmogram2.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 23.04.2021.
//

import Foundation
import SwiftUI
import Combine


struct ChartRhythmogram2: View {
    
    @ObservedObject var model = ChartRhythmogram2Model()
    @State var showHelp:Bool=false
    
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    let topColor = UIColor.blue
    let bottomColor = UIColor.blue.withAlphaComponent(0.3)
    let textHelp=Localization.getString("IDS_CHART_RHYTHMOGRAM_HELP")
    
    init(data:[Double]? = nil,frequency: Double? = nil,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2),miniature: Bool=false){
        self.miniature=miniature
        
        if(self.miniature){
            self.offset=0
        }
        
        if(data != nil && frequency != nil){
            self.model.setData(data: data!,frequency: frequency!)
        }
        self.model.setColors(topColor: UIColor.blue,bottomColor: UIColor.blue.withAlphaComponent(0.3),axisColor:UIColor.blue)
    }
    
    func setData(data: [Double],frequency: Double){
        self.model.setData(data: data,frequency: frequency)
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }
    
    
    func setColors(titleColor: Color,textColor: Color,topColor: UIColor,bottomColor: UIColor,axisColor: UIColor,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.backgroundColor=backgroundColor
        self.model.textColor=textColor
        self.model.setColors(topColor: topColor,bottomColor: bottomColor,axisColor:axisColor)
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
                        .frame(width:g.size.width-2.5*self.offset,alignment: .leading)
                        .offset(x:self.offset,y:2*self.offset)
                        .foregroundColor(self.model.textColor)
                    
                }
                
            }
            .onAppear(perform: {
                self.model.setSize(height: 0.7*g.size.height, width: g.size.width-2*self.offset)
            })
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification), perform: {i in
                self.model.setSize(height: 0.7*g.size.height, width: g.size.width-2*self.offset)
            })
            
        }
    }
    
    
}







