//
//  MainView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 24.04.2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model = MainViewModel()
    let chartUserInfo=ChartUserInfo()
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
                    
                    self.chartUserInfo
                        .frame(width: g.size.width-2*self.offset, height: 200)

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
            let dates =  self.model.list.compactMap({ $0.date })
            var values = [Double]()
            for _ in 0..<dates.count{
                values.append(Double.random(in: 0...100))
            }
            self.chartTimeDistribution.setup(dates: dates,values: values)
            self.chartUserInfo.setup()
        })
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
