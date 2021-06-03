//
//  NavigationView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 24.04.2021.
//

import SwiftUI
import Combine


struct RecordsNavigationView: View {
    @ObservedObject var model = NavigationViewModel()
    let colors: Colors
    
    init(colors: Colors) {
        self.colors=colors
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backIndicatorImage=UIImage()
        UINavigationBar.appearance().tintColor = colors.tintColor
    }
    
    var body: some View {
        GeometryReader{ g in
            NavigationView{
                ScrollView{
                    VStack{
                        ForEach(self.model.records, id: \.self){ i in
                            NavigationLink(destination: DetailView(record: i,colors: self.colors)){
                                NavigationItemView(data: i,ecgLineColor: self.colors.navViewEcgLineColor, titleColor: self.colors.navViewItemTitleColor,textColor: self.colors.navViewItemTextColor).frame(width:g.size.width,height:150)
                            }
                        }
                    }
                }
                .frame(width: g.size.width,height: g.size.height)
                .mask(Rectangle())
                //.mask(Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.clear,.black,.black,.clear]), startPoint: UnitPoint.top, endPoint: .bottom)).edgesIgnoringSafeArea(.all))
                .background(BackgroundView())
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationBarHidden(true)
            .statusBar(hidden: true)
            
        }
    }
}



