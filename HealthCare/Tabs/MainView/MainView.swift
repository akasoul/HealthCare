//
//  MainView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 24.04.2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model = MainViewModel()
    var chartUserInfo=ChartInfo()
    var chartDistribution=ChartDistribution()
    let offset:CGFloat=10
    let colors: Colors
    
    init(colors: Colors) {
        self.colors=colors
        self.chartUserInfo.setColors(titleColor: self.colors.mainViewChartTitleColor.color, textColor: self.colors.mainViewChartTextColor.color, backgroundColor: self.colors.globalItemBackground.color)
        self.chartDistribution.setColors(titleColor: self.colors.mainViewChartTitleColor.color, textColor: self.colors.mainViewChartTextColor.color, axisColor: self.colors.mainViewChartAxisColor)
        
        self.chartDistribution.setupAxisY(minValue: 0, maxValue: 10)
        
        self.chartUserInfo.setTitle(Localization.getString("IDS_CHART_USERINFO_TITLE"))
        self.chartDistribution.setTitle(Localization.getString("IDS_CHART_DISTRIBUTION_TITLE"))
    }
    var body: some View {
        GeometryReader{ g in
            NavigationView{
                
                ScrollView{
                    VStack{
                        
                        self.chartUserInfo
                            //                            .equatable()
                            .frame(width: g.size.width-2*self.offset, height: 160)
                            .onAppear(perform: {
                                self.chartUserInfo.setData(descriptions: [
                                    Localization.getString("IDS_CHART_USERINFO_DATEOFBIRTH"),
                                    Localization.getString("IDS_CHART_USERINFO_GENDER"),
                                    Localization.getString("IDS_CHART_USERINFO_HEIGHT"),
                                    Localization.getString("IDS_CHART_USERINFO_WEIGHT")
                                    
                                ], values: [
                                    "","","",""
                                ])
                            })
                            .onReceive(self.model.$info, perform: { i in
                                if let userInfo = i{
                                    var values=[String]()
                                    let formatter = DateFormatter()
                                    formatter.dateStyle = .short
                                    formatter.timeStyle = .none
                                    let str = formatter.string(from: userInfo.dateOfBirth)
                                    values.append(str)
                                    
                                    values.append(userInfo.gender)
                                    values.append(String(userInfo.height))
                                    values.append(String(userInfo.weight))
                                    
                                    self.chartUserInfo.setData(descriptions: [
                                        Localization.getString("IDS_CHART_USERINFO_DATEOFBIRTH"),
                                        Localization.getString("IDS_CHART_USERINFO_GENDER"),
                                        Localization.getString("IDS_CHART_USERINFO_HEIGHT"),
                                        Localization.getString("IDS_CHART_USERINFO_WEIGHT")
                                        
                                    ], values: values)
                                }
                            })
                        
                        self.chartDistribution
                            .frame(width: g.size.width-2*self.offset, height: 200)
                            .onReceive(self.model.$records, perform: { i in
                                let dates =  i.compactMap({ $0.date })
                                let values = i.compactMap({ $0.calculatedData?.hrvIndex})
                                self.chartDistribution.setData(dates: dates,values: values)
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

