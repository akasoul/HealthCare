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
    let data: [Double]?
    let backgroundColor: Color
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    let title: String
    
    let topColor = UIColor.blue
    let bottomColor = UIColor.blue.withAlphaComponent(0.3)
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
        
        if(self.data != nil){
            self.model.setup(data: self.data!, topColor: self.topColor, bottomColor: self.bottomColor)
        }
}

    func setup(data: [Double]){
        self.model.setup(data: data, topColor: self.topColor, bottomColor: self.bottomColor)
    }
    
var body: some View{
    GeometryReader{ g in
        Group{
            ChartBase(text: self.title,backgroundColor:self.backgroundColor)
            
            Image(uiImage: self.model.img ?? UIImage())
                //.frame(width: g.size.width-2*self.offset, height: g.size.height-2*self.offset)
                //.clipped()
                .offset(x: self.offset, y: 2*self.offset)
        }.onAppear(perform: {
            self.model.setSize(height: 0.5*g.size.height, width: g.size.width-2*self.offset)
        })
    }
}


}







