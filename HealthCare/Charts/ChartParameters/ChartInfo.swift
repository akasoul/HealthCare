//
//  ChartParameters.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.05.2021.
//


import Foundation
import SwiftUI
import Combine


struct ChartInfo: View {
    @ObservedObject var model = ChartInfoModel()
    var descriptions: [String]?
    var values: [String]?
    let backgroundColor: Color
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let title: String
    let textColor = Color.blue
    
    
    init(descriptions:[String]?=nil,values:[String]?=nil,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)){
        
        self.descriptions=descriptions
        self.values=values
        self.backgroundColor=backgroundColor
        
        self.title=Localization.getString("IDS_CHART_INFO_NAME")
        
        
        if(self.values != nil && self.descriptions != nil){
            self.setup(descriptions:self.descriptions!,values:self.values!)
        }
        
    }
    func setup(descriptions:[String],values:[String]){
        self.model.setup(descriptions: descriptions,values: values)
    }
    
    var body: some View{
        GeometryReader{ g in
            Group{
                
                ChartBase(text: self.title,backgroundColor:self.backgroundColor)
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







