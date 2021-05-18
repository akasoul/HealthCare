//
//  ContentView.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.04.2021.
//

import SwiftUI



struct DetailView: View {
    let chartEcg=ChartEcg()
    let chartScat=ChartScaterogram()
    let chartHisto=ChartHistogram()
    let chartRhythmogram=ChartRhythmogram2()
    @ObservedObject var model =  DetailViewModel()
    @State var ecgScale = CGSize(width: 1, height: 1)
    @GestureState var magnifyBy = CGFloat(1.0)
    @State var counter = 0
    let record: Storage.Record
    let offset:CGFloat=10
    var rrValues: [Double]=[]
    init(record: Storage.Record) {
        self.record=record
        //self.model.setRecord(self.record)
        //        for _ in 0..<100{
        //            self.rrValues.append(Double.random(in: 400...450))
        //        }
    }
    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                print(gestureState,currentState)
                gestureState = currentState
            }
    }
    
    var body: some View {
        GeometryReader{ g in
            ScrollView{
                VStack{
                    
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
        .onAppear(perform: {
            self.model.setRecord(self.record)
        })
        .onReceive(self.model.$recentEcgData2, perform: { i in
            self.chartEcg.setup(data: i.data,marks: i.marks,duration: i.duration)
            self.chartScat.setup(data: i.rrs)
            self.chartHisto.setup(data: i.rrs)
            self.chartRhythmogram.setup(data: i.rrs)
        })
            
    }
}

