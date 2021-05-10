//
//  BackgroundView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 01.05.2021.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        GeometryReader{ g in
            Group{
                VStack{
                    Circle().fill(Color.red).frame(width: g.size.width*0.7, height: g.size.width*0.7).blur(radius: 100)
                    
                    Circle().fill(Color.blue).frame(width: g.size.width*0.5, height: g.size.width*0.5).blur(radius: 80).offset(x:g.size.width*0.5)
                    
                    Circle().fill(Color.green).frame(width: g.size.width*0.4, height: g.size.width*0.4).blur(radius: 60)
                    
                    Circle().fill(Color.yellow).frame(width: g.size.width*0.3, height: g.size.width*0.3).blur(radius: 50).offset(x:g.size.width*0.4)
                }
            }
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
