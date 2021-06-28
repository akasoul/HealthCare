//
//  ChartParameters.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.05.2021.
//


import Foundation
import SwiftUI
import Combine


struct ChartSwitcher: View{
    
    @ObservedObject var model = ChartSwitcherModel()
    @State var selection: Int=0
    @State var selectionOffset: CGFloat=0
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    
    let switchers:[String]=[
        Localization.getString("IDS_CHART_SWITCHER_RR"),
        Localization.getString("IDS_CHART_SWITCHER_QT")
    ]
    
    init(backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)){
    }
    
    func setAction(action: @escaping ((Int)->Void)){
        self.model.action=action
    }
    func setColors(titleColor: Color,textColor: Color,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.textColor=textColor
        self.model.backgroundColor=backgroundColor
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }
    
    
    var body: some View{
        GeometryReader{ g in
            Group{
                
                ChartBase(text: self.model.title,textColor: self.model.titleColor,backgroundColor:self.model.backgroundColor)
                GeometryReader{ g2 in
                HStack{
                    ForEach(0..<self.switchers.count){ i in
                        ZStack{
                            Color.clear.contentShape(Rectangle())
                        Text(self.switchers[i])
                            .font(.system(size: 12))
                            .frame(width:g2.size.width/2,height: 30,alignment:.center)
                            .foregroundColor(self.model.textColor)
                            //.background(Rectangle().fill(self.selection == i ? self.model.backgroundColor.opacity(0.5) : Color.clear).cornerRadius(self.cornerRadius))
                            
                        }
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.5), {
                                self.selectionOffset = CGFloat(i)*g2.size.width/2
                            })
                            self.model.action?(i)
                        }
                    }
            
                }
                    Rectangle().fill(self.model.backgroundColor.opacity(0.5)).cornerRadius(self.cornerRadius)
                        .offset(x: self.selectionOffset, y: 0)
                        .frame(width:g2.size.width/2)
                }
                .offset(x: self.offset, y: 2.5*self.offset)
                .frame(width:g.size.width-2*self.offset,height:g.size.height-3*self.offset)
            }
            
        }
    }
    
    
}







