//
//  NavigationItemView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 01.05.2021.
//

import SwiftUI

struct NavigationItemView: View {
    let backgroundColor = Color(red: 1, green: 1, blue: 1).opacity(0.3)
    let borderColor = Color(red: 1, green: 1, blue: 1).opacity(0.5)
    let data: Storage.Record
    let offset:CGFloat=10
    let dateFormatter=DateFormatter()
    let ecgLineColor: UIColor
    init(data: Storage.Record,ecgLineColor: UIColor=UIColor.blue) {
        self.data=data
        self.ecgLineColor=ecgLineColor
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .medium
    }
    var body: some View {
        GeometryReader{ g in
            Group{
                    RoundedRectangle(cornerRadius: self.offset)
                        .fill(self.backgroundColor)
                    
                    RoundedRectangle(cornerRadius: self.offset)
                        .stroke(self.borderColor,lineWidth: 1)
                    
                GeometryReader{ g2 in
                        VStack{
                            Text(self.dateFormatter.string(from: self.data.date))
                                .frame(width:g2.size.width-2*self.offset,alignment:.leading)
                            
                            Text(String("❤️ "+String(self.data.heartRate)))
                                .frame(width:g2.size.width-2*self.offset,alignment:.leading)
                            
                            ChartEcg(data: self.data.ecgData, marks: [],lineColor: self.ecgLineColor, backgroundColor: .clear,miniature: true)
                                .frame(height: 100)
                                .allowsHitTesting(false)
                        }.offset(x: self.offset, y: self.offset)
                        .frame(width: g2.size.width-2*self.offset, height: g2.size.height-2*self.offset,alignment:.leading)
                        
                }
                
            }
            .offset(x: self.offset, y: self.offset)
            .frame(width: g.size.width-2*self.offset, height: g.size.height-2*self.offset)
            
        }
    }
}

//struct NavigationItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationItemView()
//    }
//}
