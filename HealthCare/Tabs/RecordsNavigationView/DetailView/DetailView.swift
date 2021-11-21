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
    var chartAttention=ChartInfo()
    var chartSwitcher=ChartSwitcher()
    let colors: Colors
    
    @ObservedObject var model =  DetailViewModel()
    @State var ecgScale = CGSize(width: 1, height: 1)
    @GestureState var magnifyBy = CGFloat(1.0)
    @State var counter = 0
    @State var selectedPeaks=0
    let record: Storage.Record
    let offset:CGFloat=10
    var offsetY:CGFloat=0
    var rrValues: [Double]=[]
    @State var loaded=false
    
    init(record: Storage.Record,colors: Colors, useSpacer: Bool=false) {
        self.record=record
        self.colors=colors
        if(useSpacer){
            self.offsetY=self.offset
        }
        self.chartInfo.setColors(titleColor: self.colors.detViewChartTitleColor.color, textColor:self.colors.detViewChartTextColor.color)
        self.chartSwitcher.setColors(titleColor: self.colors.detViewChartTitleColor.color, textColor:self.colors.detViewChartTextColor.color)
        self.chartAttention.setColors(titleColor: self.colors.detViewChartTitleColor.color, textColor:self.colors.detViewChartTextColor.color)
        self.chartEcg.setColors(titleColor: self.colors.detViewChartTitleColor.color, textColor:self.colors.detViewChartTextColor.color, lineColor: self.colors.detViewChartEcgLineColor,marksColor: self.colors.detViewChartEcgMarksColor, axisColor: self.colors.detViewChartAxisColor)
        self.chartScat.setColors(titleColor: self.colors.detViewChartTitleColor.color, textColor:self.colors.detViewChartTextColor.color, fillColor: self.colors.detViewChartScatFillColor, axisColor: self.colors.detViewChartAxisColor)
        self.chartRhythmogram.setColors(titleColor: self.colors.detViewChartTitleColor.color, textColor:self.colors.detViewChartTextColor.color, topColor: self.colors.detViewChartRhythmogramTopColor, bottomColor: self.colors.detViewChartRhythmogramBottomColor, axisColor: self.colors.detViewChartAxisColor)
        self.chartHisto.setColors(titleColor:self.colors.detViewChartTitleColor.color, textColor:self.colors.detViewChartTextColor.color,topColor: self.colors.detViewChartHistogramTopColor, bottomColor: self.colors.detViewChartHistogramBottomColor, axisColor: self.colors.detViewChartAxisColor)
        
        self.chartInfo.setTitle(Localization.getString("IDS_CHART_INFO_TITLE"))
        self.chartSwitcher.setTitle(Localization.getString("IDS_CHART_SWITCHER_TITLE"))
        self.chartAttention.setTitle(Localization.getString("IDS_CHART_ATTENTION_TITLE"))
        self.chartEcg.setTitle(Localization.getString("IDS_CHART_ECG_TITLE"))
        self.chartScat.setTitle(Localization.getString("IDS_CHART_SCATEROGRAM_TITLE"))
        self.chartRhythmogram.setTitle(Localization.getString("IDS_CHART_RHYTHMOGRAM_TITLE"))
        self.chartHisto.setTitle(Localization.getString("IDS_CHART_HISTOGRAM_TITLE"))
        
        self.chartAttention.setAttention(Localization.getString("IDS_CHART_ATTENTION_TEXT"))
    
        self.chartSwitcher.setAction(action: self.switchPeaks(selection:))

    }
    
    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
            }
    }
    
    func switchPeaks(selection: Int){
        self.selectedPeaks=selection
        if(selection==0){
            self.chartEcg.setData(data: self.model.recentEcgData2.data,marks: [self.model.recentEcgData2.rMarks],marksOrientation: [1],duration: self.model.recentEcgData2.duration)
            self.chartRhythmogram.setData(data: self.model.recentEcgData2.rr, frequency: self.model.recentEcgData2.frequency)
            self.chartHisto.setData(data: self.model.recentEcgData2.rr, frequency: self.model.recentEcgData2.frequency)
            self.chartScat.setData(data: self.model.recentEcgData2.rr, frequency: self.model.recentEcgData2.frequency)
        }
        if(selection==1){
            self.chartEcg.setData(data: self.model.recentEcgData2.data,marks: [self.model.recentEcgData2.qMarks,self.model.recentEcgData2.tMarks],marksOrientation: [-1,1],duration: self.model.recentEcgData2.duration)
            self.chartRhythmogram.setData(data: self.model.recentEcgData2.qt, frequency: self.model.recentEcgData2.frequency)
            self.chartHisto.setData(data: self.model.recentEcgData2.qt, frequency: self.model.recentEcgData2.frequency)
            self.chartScat.setData(data: self.model.recentEcgData2.qt, frequency: self.model.recentEcgData2.frequency)
}
    }
    
    var body: some View {
        GeometryReader{ g in
            if(self.loaded){
                ScrollView{
                    VStack{
                        Spacer().frame(height:self.offsetY)
                        self.chartInfo
                            .frame(width: g.size.width-2*self.offset, height: 150)
                        
                        if(self.model.recentEcgData2.reliability<50){
                        self.chartAttention
                            .frame(width: g.size.width-2*self.offset, height: 100)
                        }
                        
                        self.chartSwitcher
                            .frame(width: g.size.width-2*self.offset, height: 100)

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
            print("detail appear")
        })
        .onReceive(self.model.$recentEcgData2, perform: { i in
            self.chartEcg.setData(data: i.data,marks: [i.rMarks],marksOrientation: [1],duration: i.duration)
            self.chartScat.setData(data: i.rr,frequency: i.frequency)
            self.chartHisto.setData(data: i.rr,frequency: i.frequency)
            self.chartRhythmogram.setData(data: i.rr,frequency: i.frequency)
            self.chartInfo.setData(descriptions:[
                Localization.getString("IDS_CHART_INFO_DATE"),
                Localization.getString("IDS_CHART_INFO_DURATION"),
                Localization.getString("IDS_CHART_INFO_HEARTRATE"),
                Localization.getString("IDS_CHART_INFO_HRVINDEX"),
                Localization.getString("IDS_CHART_INFO_RELIABILITY")
            ],
            values: [
                i.date,
                String(format:"%.1f",i.duration),
                String(format:"%.1f",i.heartRate),
                String(format:"%.3f",i.hrvIndex),
                String(String(format:"%.0f",i.reliability)+"%")
            ])
            if(i.rMarks.count>0){
                self.loaded=true
            }
        })
        
    }
}

