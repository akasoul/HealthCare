//
//  ChartParameters.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.05.2021.
//


import Foundation
import SwiftUI
import Combine


struct ChartInfo: View{//}, Equatable {
//    static func == (lhs: ChartInfo, rhs: ChartInfo) -> Bool {
//        return lhs.model.values==rhs.model.values && lhs.model.descriptions==rhs.model.descriptions
//    }
    
    @ObservedObject var model = ChartInfoModel()
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    
    
    init(descriptions:[String]?=nil,values:[String]?=nil,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)){
        
        
        
        
        if(values != nil && descriptions != nil){
            self.setData(descriptions:descriptions!,values:values!)
        }
        
    }
    
    func setColors(titleColor: Color,textColor: Color,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.textColor=textColor
        self.model.backgroundColor=backgroundColor
   }

    func setData(descriptions:[String],values:[String]){
        self.model.setData(descriptions: descriptions,values: values)
    }
    
    func setAttention(_ text: String){
        self.model.setAttention(text)
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }


    var body: some View{
        GeometryReader{ g in
            Group{
                
                ChartBase(text: self.model.title,textColor: self.model.titleColor,backgroundColor:self.model.backgroundColor)
                Group{
                    if(self.model.attention == ""){
                    GeometryReader{ g2 in
                        VStack{
                            ForEach(self.model.descriptions,id:\.self){i in
                                Text(i)
                                    .font(.system(size: 12))
                                    .frame(width:g2.size.width,alignment:.topLeading)
                                    .foregroundColor(self.model.textColor)
                            }
                        }
                        .frame(width:g2.size.width,height:g2.size.height,alignment:.leading)
                        VStack{
                            ForEach(self.model.values,id:\.self){i in
                                Text(i)
                                    .font(.system(size: 12))
                                    .frame(width:g2.size.width,alignment:.topTrailing)
                                    .foregroundColor(self.model.textColor)
                            }
                        }
                        .frame(width:g2.size.width,height:g2.size.height,alignment:.trailing)
                    }
                    }
                    else{
                        Text(self.model.attention)
                            .font(.system(size: 12))
                            .foregroundColor(self.model.textColor)
                            .frame(width: g.size.width-2*self.offset,height:g.size.height-3*self.offset,alignment:.leading)
                    }
                }
                .offset(x: self.offset, y: 2.5*self.offset)
                .frame(width:g.size.width-2*self.offset,height:g.size.height-3*self.offset)
            }
            
        }
    }
    
    
}







