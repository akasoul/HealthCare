//
//  NavigationItemView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 01.05.2021.
//

import SwiftUI

struct NavigationItemView: View {
    let backgroundColor = Color(red: 1, green: 1, blue: 1).opacity(0.2)
    let borderColor = Color(red: 1, green: 1, blue: 1).opacity(0.5)
    let data: Storage.Record
    let offset:CGFloat=10
    let dateFormatter=DateFormatter()
    let ecgLineColor: UIColor
    let titleColor: UIColor
    let textColor: UIColor
    
    let chartEcg=ChartEcg(backgroundColor: .clear,miniature:true)
    init(data: Storage.Record,ecgLineColor: UIColor=UIColor.blue,titleColor: UIColor = .blue,textColor: UIColor = .blue) {
        self.data=data
        self.ecgLineColor=ecgLineColor
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .medium
        self.titleColor=titleColor
        self.textColor=textColor
        self.chartEcg.setColors(titleColor: self.ecgLineColor.color, lineColor: self.ecgLineColor,marksColor: self.ecgLineColor, axisColor: self.ecgLineColor,backgroundColor: .clear)

    }
    
    var body: some View {
        GeometryReader{ g in
            Group{
                ChartBase(text: self.dateFormatter.string(from: self.data.date),textColor: self.titleColor.color,backgroundColor:self.backgroundColor)
                GeometryReader{ g2 in
                    VStack{
                            //ChartEcg(data: self.data.ecgData, marks: [],lineColor: self.ecgLineColor, backgroundColor: .clear,miniature: true)
                        self.chartEcg
                                .frame(height: g2.size.height*0.5)
                            .allowsHitTesting(false)
                            .onAppear(perform:{
                                print("EC:appear")
                                self.chartEcg.setData(data: self.data.ecgData, marks: [])
                            })
                    }.offset(x: self.offset, y: 2*self.offset)
                    .frame(width: g2.size.width-2*self.offset, height: g2.size.height-2*self.offset,alignment:.leading)
                }
            }
            .offset(x: self.offset, y: self.offset)
            .frame(width: g.size.width-2*self.offset, height: g.size.height-2*self.offset)
        }
    }
}

