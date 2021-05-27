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
    let backgroundColor = UIColor(red: 1, green: 1, blue: 1,alpha: 0.0)
    let coloredNavAppearance = UINavigationBarAppearance()

    init(tintColor: UIColor?=nil) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backIndicatorImage=UIImage()
        if(tintColor != nil){
        UINavigationBar.appearance().tintColor = tintColor!
        }
    }
    var body: some View {
        GeometryReader{ g in
            NavigationView{
                ScrollView{
                    VStack{
                        ForEach(self.model.list, id: \.self){ i in
                            NavigationLink(destination: DetailView(record: i)){
                                NavigationItemView(data: i).frame(width:g.size.width,height:200)
                            }//.frame(height:30)
                        }
                    }
                }
                .mask(Rectangle())
                //.mask(Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.black,.clear]), startPoint: UnitPoint.top, endPoint: .bottom)).edgesIgnoringSafeArea(.all))
                .background(BackgroundView())
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationBarHidden(true)
            .statusBar(hidden: true)
            
        }
    }
}



