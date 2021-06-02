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
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool

    let topColor = UIColor.blue
    let bottomColor = UIColor.blue.withAlphaComponent(0.3)
    init(data:[Double]? = nil,frequency: Double? = nil,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2),miniature: Bool=false){
        self.miniature=miniature
        
        if(self.miniature){
            self.offset=0
        }

        if(data != nil && frequency != nil){
            self.model.setup(data: data!,frequency: frequency!)
        }
        self.model.setColors(topColor: UIColor.blue,bottomColor: UIColor.blue.withAlphaComponent(0.3),axisColor:UIColor.blue)
    }
    
    func setup(data: [Double],frequency: Double){
        self.model.setup(data: data,frequency: frequency)
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }


    func setColors(titleColor: Color,topColor: UIColor,bottomColor: UIColor,axisColor: UIColor,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.backgroundColor=backgroundColor
        self.model.setColors(topColor: topColor,bottomColor: bottomColor,axisColor:axisColor)
    }
    
    var body: some View{
        GeometryReader{ g in
            Group{
                ChartBase(text: self.model.title,textColor: self.model.titleColor,backgroundColor:self.model.backgroundColor)
                
                Image(uiImage: self.model.img ?? UIImage())
                    .offset(x: self.offset+self.model.axisWidth, y: 2*self.offset)
                
                Image(uiImage: self.model.imgAxisX ?? UIImage())
                    .offset(x: self.offset, y: 2*self.offset)
                    .offset(x: self.model.axisWidth, y: self.model.height ?? 0)


                Image(uiImage: self.model.imgAxisY ?? UIImage())
                    .offset(x: self.offset, y: 2*self.offset)

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







