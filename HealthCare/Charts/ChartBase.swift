//
//  ChartBase.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 03.05.2021.
//




import SwiftUI



struct ChartBase: View {//
    let text: String
    let cornerRadius:CGFloat = 20
    let offset: CGFloat = 20
    let backgroundColor: Color
    var textColor = Color.blue
    
    init(text: String,textColor: Color=Color.blue,backgroundColor:Color=Color(red: 1, green: 1, blue: 1).opacity(0.3)) {
        self.text=text
        self.textColor=textColor
        self.backgroundColor=backgroundColor
    }
    var body: some View {
        GeometryReader{ g in
        Group{
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .foregroundColor(self.backgroundColor)
            Text(self.text)
                .foregroundColor(self.textColor)
                .offset(x: self.offset, y: self.offset)
            
        }.frame(alignment: .topLeading)
        }
    }
}



