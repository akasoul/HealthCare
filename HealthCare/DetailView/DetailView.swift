//
//  ContentView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.04.2021.
//

import SwiftUI



struct DetailView: View {
    var chartInfo=ChartRecordInfo()
    var chartEcg=ChartEcg()
    var chartScat=ChartScaterogram()
    var chartHisto=ChartHistogram()
    var chartRhythmogram=ChartRhythmogram2()
    @ObservedObject var model =  DetailViewModel()
    @State var ecgScale = CGSize(width: 1, height: 1)
    @GestureState var magnifyBy = CGFloat(1.0)
    @State var counter = 0
    let record: Storage.Record
    let offset:CGFloat=10
    var rrValues: [Double]=[]
    @State var loaded=false
    
    init(record: Storage.Record) {
        self.record=record
        let clr=Color(red: 0, green: 1, blue: 0)
        let uiclr=UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        self.chartInfo.setColors(titleColor: clr,textColor:clr)
        self.chartEcg.setColors(titleColor: clr, lineColor: uiclr, axisColor: uiclr)
        self.chartScat.setColors(titleColor: clr, fillColor: uiclr, axisColor: uiclr)
        self.chartRhythmogram.setColors(titleColor: clr, topColor: uiclr, bottomColor: uiclr.withAlphaComponent(0.3), axisColor: uiclr)
        self.chartHisto.setColors(titleColor:clr,topColor: uiclr, bottomColor: uiclr.withAlphaComponent(0.3), axisColor: uiclr)
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
            self.chartEcg.setup(data: i.data,marks: i.marks,duration: i.duration)
            self.chartScat.setup(data: i.rrs,frequency: i.frequency)
            self.chartHisto.setup(data: i.rrs,frequency: i.frequency)
            self.chartRhythmogram.setup(data: i.rrs,frequency: i.frequency)
            self.chartInfo.setup(descriptions:[
                Localization.getString("IDS_CHART_INFO_DATE"),
                Localization.getString("IDS_CHART_INFO_DURATION"),
                Localization.getString("IDS_CHART_INFO_HEARTRATE"),
                Localization.getString("IDS_CHART_INFO_HEALTH")
            ],
            values: [
                i.date,
                String(i.duration),
                String(i.heartRate),
                String(i.health)
            ])
            if(i.marks.count>0){
            self.loaded=true
            }
        })
        
    }
}

