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
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    
    
    init(descriptions:[String]?=nil,values:[String]?=nil,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)){
        
        
        
        
        if(values != nil && descriptions != nil){
            self.setup(descriptions:descriptions!,values:values!)
        }
        
    }
    
    func setColors(titleColor: Color,textColor: Color,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.textColor=textColor
        self.model.backgroundColor=backgroundColor
   }

    func setup(descriptions:[String],values:[String]){
        self.model.setup(descriptions: descriptions,values: values)
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }


    var body: some View{
        GeometryReader{ g in
            Group{
                
                ChartBase(text: self.model.title,textColor: self.model.titleColor,backgroundColor:self.model.backgroundColor)
                Group{
                    GeometryReader{ g2 in
                        VStack{
                            ForEach(self.model.descriptions,id:\.self){i in
                                Text(i)
                                    .frame(width:g2.size.width,alignment:.topLeading)
                                    .foregroundColor(self.model.textColor)
                            }
                        }
                        .frame(width:g2.size.width,height:g2.size.height,alignment:.leading)
                        VStack{
                            ForEach(self.model.values,id:\.self){i in
                                Text(i)
                                    .frame(width:g2.size.width,alignment:.topTrailing)
                                    .foregroundColor(self.model.textColor)
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







