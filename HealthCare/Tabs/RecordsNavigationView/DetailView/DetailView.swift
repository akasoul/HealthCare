//
//  ContentView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.04.2021.
//

import SwiftUI



struct DetailView: View {
    var chartInfo=ChartInfo()
    var chartEcg=ChartEcg()
    var chartScat=ChartScaterogram()
    var chartHisto=ChartHistogram()
    var chartRhythmogram=ChartRhythmogram2()
    
    let colors: Colors
    
    @ObservedObject var model =  DetailViewModel()
    @State var ecgScale = CGSize(width: 1, height: 1)
    @GestureState var magnifyBy = CGFloat(1.0)
    @State var counter = 0
    let record: Storage.Record
    let offset:CGFloat=10
    var rrValues: [Double]=[]
    @State var loaded=false
    
    init(record: Storage.Record,colors: Colors) {
        self.record=record
        self.colors=colors
        
        self.chartInfo.setColors(titleColor: self.colors.detViewChartTitleColor.color, textColor:self.colors.detViewChartTextColor.color)
        self.chartEcg.setColors(titleColor: self.colors.detViewChartTitleColor.color, lineColor: self.colors.detViewChartEcgLineColor,marksColor: self.colors.detViewChartEcgMarksColor, axisColor: self.colors.detViewChartAxisColor)
        self.chartScat.setColors(titleColor: self.colors.detViewChartTitleColor.color, fillColor: self.colors.detViewChartScatFillColor, axisColor: self.colors.detViewChartAxisColor)
        self.chartRhythmogram.setColors(titleColor: self.colors.detViewChartTitleColor.color, topColor: self.colors.detViewChartRhythmogramTopColor, bottomColor: self.colors.detViewChartRhythmogramBottomColor, axisColor: self.colors.detViewChartAxisColor)
        self.chartHisto.setColors(titleColor:self.colors.detViewChartTitleColor.color,topColor: self.colors.detViewChartHistogramTopColor, bottomColor: self.colors.detViewChartHistogramBottomColor, axisColor: self.colors.detViewChartAxisColor)
        
        self.chartInfo.setTitle(Localization.getString("IDS_CHART_RECORDINFO_TITLE"))
        self.chartEcg.setTitle(Localization.getString("IDS_CHART_ECG_TITLE"))
        self.chartScat.setTitle(Localization.getString("IDS_CHART_SCATEROGRAM_TITLE"))
        self.chartRhythmogram.setTitle(Localization.getString("IDS_CHART_RHYTHMOGRAM_TITLE"))
        self.chartHisto.setTitle(Localization.getString("IDS_CHART_HISTOGRAM_TITLE"))
    }
    
    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
            }
    }
    
    var body: some View {
        GeometryReader{ g in
            if(self.loaded){
                ScrollView{
                    VStack{
                        self.chartInfo
                            .frame(width: g.size.width-2*self.offset, height: 200)
                        
                        self.chartEcg
                            .frame(width: g.size.width-2*self.offset, height: 200)
                            .scaleEffect(self.ecgScale)
                            .gesture(
                                MagnificationGesture().onChanged({ i in
                                    self.ecgScale=CGSize(width: i, height: i)
                                })
                            )
                        
                        self.chartRhythmogram
                            .frame(width: g.size.width-2*self.offset, height: 200)
                        
                        self.chartHisto
                            .frame(width: g.size.width-2*self.offset, height: 200)
                        
                        self.chartScat
                            .frame(width: g.size.width-2*self.offset, height: 200)
                        
                    }.frame(width:g.size.width,alignment:.leading)
                    .offset(x:self.offset)
                }
                .mask(Rectangle())
                .frame(width:g.size.width,height:g.size.height)
                .background(BackgroundView())
            }
            else{
                
                GeometryReader{ g in
                    ProgressView(value: 1.0).progressViewStyle(CircularProgressViewStyle())
                        .frame(width: g.size.width, height: g.size.height, alignment: .center)
                        .background(BackgroundView())
                }
            }
            
        }
        .onAppear(perform: {
            self.model.setRecord(self.record)
        })
        .onReceive(self.model.$recentEcgData2, perform: { i in
            self.chartEcg.setData(data: i.data,marks: i.marks,duration: i.duration)
            self.chartScat.setData(data: i.rrs,frequency: i.frequency)
            self.chartHisto.setData(data: i.rrs,frequency: i.frequency)
            self.chartRhythmogram.setData(data: i.rrs,frequency: i.frequency)
            self.chartInfo.setData(descriptions:[
                Localization.getString("IDS_CHART_INFO_DATE"),
                Localization.getString("IDS_CHART_INFO_DURATION"),
                Localization.getString("IDS_CHART_INFO_HEARTRATE"),
                Localization.getString("IDS_PARAMETER_HRVINDEX_NAME"),
                Localization.getString("IDS_CHART_INFO_RELIABILITY")
            ],
            values: [
                i.date,
                String(format:"%.1f",i.duration),
                String(format:"%.1f",i.heartRate),
                String(format:"%.3f",i.hrvIndex),
                String(String(format:"%.0f",i.reliability)+"%")
            ])
            if(i.marks.count>0){
                self.loaded=true
            }
        })
        
    }
}

