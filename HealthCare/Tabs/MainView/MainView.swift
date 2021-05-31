//
//  MainView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 24.04.2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model = MainViewModel()
    var chartUserInfo=ChartUserInfo()
    var chartTimeDistribution=ChartTimeDistribution()
    let offset:CGFloat=10
    let colors: Colors
    
    init(colors: Colors) {
        self.colors=colors
        self.chartUserInfo.setColors(titleColor: self.colors.mainViewChartTitleColor.color, textColor: self.colors.mainViewChartTextColor.color, backgroundColor: self.colors.globalItemBackground.color)
        self.chartTimeDistribution.setColors(titleColor: self.colors.mainViewChartTitleColor.color, textColor: self.colors.mainViewChartTextColor.color, axisColor: self.colors.mainViewChartAxisColor)
    }
    var body: some View {
        GeometryReader{ g in
            NavigationView{
                
                ScrollView{
                    VStack{
                        
                        self.chartUserInfo
                            .frame(width: g.size.width-2*self.offset, height: 160)
                            .onAppear(perform: {
                                self.chartUserInfo.setup()
                            })
                        
                        self.chartTimeDistribution
                            .frame(width: g.size.width-2*self.offset, height: 200)
                            .onReceive(self.model.$records, perform: { i in
                                let dates =  self.model.records.compactMap({ $0.date })
                                let values = i.compactMap({ $0.calculatedData?.health})
                                self.chartTimeDistribution.setup(dates: dates,values: values)
                            })
                           
                    }.frame(width:g.size.width,alignment:.leading)
                    .offset(x:self.offset)
                }
                .navigationBarTitleDisplayMode(.inline)
                .background(BackgroundView())
            }
            .navigationBarHidden(true)
            .statusBar(hidden: true)
            
        }
        
        
        
    }
}

