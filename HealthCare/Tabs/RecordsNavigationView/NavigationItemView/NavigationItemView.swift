//
//  NavigationItemView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 01.05.2021.
//

import SwiftUI

struct NavigationItemView: View,Equatable {
    static func == (lhs: NavigationItemView, rhs: NavigationItemView) -> Bool {
        return lhs.data==rhs.data
    }
    @ObservedObject var model = NavigationItemViewModel()
    let backgroundColor = Color(red: 1, green: 1, blue: 1).opacity(0.2)
    let borderColor = Color(red: 1, green: 1, blue: 1).opacity(0.5)
    let data: Storage.Record
    let offset:CGFloat=10
    let dateFormatter=DateFormatter()
    let colors: Colors
    init(data: Storage.Record,colors: Colors) {
        self.data=data
        self.colors=colors
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .medium
        
    }
    
    var body: some View {
        GeometryReader{ g in
            Group{
                ChartBase(text: self.dateFormatter.string(from: self.data.date),textColor: self.colors.detViewChartTitleColor.color,backgroundColor:self.backgroundColor)
                GeometryReader{ g2 in
                    VStack{
                        ChartEcg(data:self.data.ecgData,marks:[Double](),titleColor: self.colors.navViewItemTitleColor.color,marksColor:self.colors.detViewChartEcgMarksColor,lineColor: self.colors.detViewChartEcgLineColor,axisColor:self.colors.detViewChartAxisColor,backgroundColor: Color(red: 1, green: 1, blue: 1).opacity(0.3),miniature: true)
                            .equatable()
                            .frame(height: g2.size.height*0.5)
                            .allowsHitTesting(false)
                        
                    }.offset(x: self.offset, y: 2*self.offset)
                    .frame(width: g2.size.width-2*self.offset, height: g2.size.height-2*self.offset,alignment:.leading)
                }
            }
            .offset(x: self.offset, y: self.offset)
            .frame(width: g.size.width-2*self.offset, height: g.size.height-2*self.offset)
            
        }
    }
}

