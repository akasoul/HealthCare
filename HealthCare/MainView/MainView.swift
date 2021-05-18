//
//  MainView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 24.04.2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model = MainViewModel()
    let chartTimeDistribution=ChartTimeDistribution()
    let offset:CGFloat=10
//    init() {
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().isTranslucent = true
//        
//
//    }
    var body: some View {
        GeometryReader{ g in
            NavigationView{

            ScrollView{
                VStack{
                    
                    self.chartTimeDistribution
                        .frame(width: g.size.width-2*self.offset, height: 200)
                }.frame(width:g.size.width,alignment:.leading)
                .offset(x:self.offset)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(BackgroundView())
            //.frame(width:g.size.width,height:g.size.height)
            }
            .navigationBarHidden(true)
            .statusBar(hidden: true)
            
        }//.background(BackgroundView())
        .onReceive(self.model.$list, perform: { i in
            self.chartTimeDistribution.setup(data: i)
        })
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
