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
    var backgroundColor: Color
    var textColor = Color.blue
    let showHelpButton: Bool
    let showHelpButtonColor: Color
    var showHelpButtonAction: (()->Void)?
    init(text: String,textColor: Color=Color.blue,showHelpButton: Bool=false,showHelpButtonColor:Color=Color.blue,showHelpButtonAction: (()->Void)?=nil, backgroundColor:Color=Color(red: 1, green: 1, blue: 1).opacity(0.3)) {
        self.text=text
        self.textColor=textColor
        self.backgroundColor=backgroundColor
        self.showHelpButton=showHelpButton
        self.showHelpButtonColor=showHelpButtonColor
        self.showHelpButtonAction=showHelpButtonAction
    }
    var body: some View {
        GeometryReader{ g in
            Group{
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .foregroundColor(self.backgroundColor)
                
                Text(self.text)
                    .fontWeight(.medium)
                    .font(.system(size: 14))
                    .foregroundColor(self.textColor)
                    .offset(x: self.offset, y: self.offset)
                
                if(self.showHelpButton){
                    Spacer()
                        .frame(width:10)
                    ZStack{
                        Color.clear.contentShape(Circle()).frame(width: 15, height: 15)
                        Circle().stroke(self.showHelpButtonColor).frame(width:15,height:15)
                        Text("ℹ︎")
                            .font(.system(size: 14))
                            .foregroundColor(self.showHelpButtonColor)
                    }
                    .offset(x: self.offset, y: self.offset)
                    .frame(width:g.size.width-2*self.offset,alignment:.trailing)
                    .onTapGesture(perform: self.showHelpButtonAction ?? {} )
                }
                
            }.frame(alignment: .topLeading)
        }
        
    }
}



struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

