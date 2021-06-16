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
    var chartCompare=ChartCompare()
    let offset:CGFloat=10
    let colors: Colors
    let barHeight: CGFloat
    init(colors: Colors) {
        let bar = UINavigationBar()
        self.barHeight=bar.frame.height
        self.colors=colors
        self.chartUserInfo.setColors(titleColor: self.colors.mainViewChartTitleColor.color, textColor: self.colors.mainViewChartTextColor.color, backgroundColor: self.colors.globalItemBackground.color)
        self.chartDistribution.setColors(titleColor: self.colors.mainViewChartTitleColor.color, textColor: self.colors.mainViewChartTextColor.color, axisColor: self.colors.mainViewChartAxisColor)
        self.chartCompare.setColors(titleColor: self.colors.mainViewChartTitleColor.color, textColor: self.colors.mainViewChartTextColor.color)
        
        self.chartDistribution.setupAxisY(minValue: 0, maxValue: 5)
        
        self.chartUserInfo.setTitle(Localization.getString("IDS_CHART_USERINFO_TITLE"))
        self.chartDistribution.setTitle(Localization.getString("IDS_CHART_DISTRIBUTION_TITLE"))
        self.chartCompare.setTitle(Localization.getString("IDS_CHART_COMPARE_TITLE"))
        
        self.chartCompare.setDetailViewColors(self.colors)
    }
    var body: some View {
        GeometryReader{ g in
            NavigationView{
                
                ScrollView{
                    VStack{
                        
                        self.chartUserInfo
                            //                            .equatable()
                            .frame(width: g.size.width-2*self.offset, height: 120)
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
                                    formatter.dateStyle = .long
                                    formatter.timeStyle = .none
                                    let str = formatter.string(from: userInfo.dateOfBirth)
                                    values.append(str)
                                    
                                    values.append(userInfo.gender)
                                    values.append(String(format:"%.1f",userInfo.height))
                                    values.append(String(format:"%.1f",userInfo.weight))
                                    
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
                        
                        self.chartCompare
                            .frame(width: g.size.width-2*self.offset, height: 150)
                            .onReceive(self.model.$records, perform: { i in
                                var arr = [[String]]()
                                let formatter = DateFormatter()
                                formatter.dateStyle = .short
                                formatter.timeStyle = .short
                                
                                for j in 0..<i.count{
                                    var str = formatter.string(from: i[j].date)
                                    str=str.replacingOccurrences(of: ",", with: "\n")
                                    arr.append([str,String(i[j].heartRate),String(format:"%.3f",i[j].calculatedData?.hrvIndex ?? 0)])
                                }
                                self.chartCompare.setData(data: arr)
                            })
                        

                    }.frame(width:g.size.width,alignment:.leading)
                    .offset(x:self.offset)
                }
                .mask(Rectangle())
                //.frame(width:g.size.width,height:g.size.height-g.safeAreaInsets.bottom,alignment: .top)
                .navigationBarTitleDisplayMode(.inline)
                .background(BackgroundView())
            }
            .navigationBarHidden(true)
            .statusBar(hidden: true)
            
        }.frame(alignment:.top)
        
        
        
    }
}

