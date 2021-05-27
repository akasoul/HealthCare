//
//  ChartParameters.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.05.2021.
//


import Foundation
import SwiftUI
import Combine


struct ChartUserInfo: View {
    @ObservedObject var model = ChartUserInfoModel()
    var descriptions: [String] = [
        Localization.getString("IDS_CHART_USERINFO_DATEOFBIRTH"),
        Localization.getString("IDS_CHART_USERINFO_GENDER"),
        Localization.getString("IDS_CHART_USERINFO_HEIGHT"),
        Localization.getString("IDS_CHART_USERINFO_WEIGHT")
    ]
    var values: [String]?
    let backgroundColor: Color
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let title: String
    var titleColor = Color.blue
    var textColor = Color.blue
    
    
    init(values:[String]?=nil,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)){
        
        self.values=values
        self.backgroundColor=backgroundColor
        
        self.title=Localization.getString("IDS_CHART_USERINFO_NAME")
        
        
        if(self.values != nil){
            self.setup()
        }
        
    }
    
    func setup(){
        self.model.setup()
    }
    
    mutating func setColors(titleColor: Color,textColor: Color){
        self.titleColor=titleColor
        self.textColor=textColor
    }
    
    var body: some View{
        GeometryReader{ g in
            Group{
                
                ChartBase(text: self.title,textColor: self.titleColor,backgroundColor:self.backgroundColor)
                Group{
                    GeometryReader{ g2 in
                        VStack{
                            ForEach(self.model.descriptions,id:\.self){i in
                                Text(i)
                                    .frame(width:g2.size.width,alignment:.topLeading)
                                    .foregroundColor(self.textColor)
                            }
                        }
                        .frame(width:g2.size.width,height:g2.size.height,alignment:.leading)
                        VStack{
                            ForEach(self.model.values,id:\.self){i in
                                Text(i)
                                    .frame(width:g2.size.width,alignment:.topTrailing)
                                    .foregroundColor(self.textColor)
                            }
                        }
                        .frame(width:g2.size.width,height:g2.size.height,alignment:.trailing)
                    }
                }
                .offset(x: self.offset, y: 2*self.offset)
                .frame(width:g.size.width-2*self.offset,height:g.size.height-3*self.offset)
            }
            
        }
    }
    
    
}







