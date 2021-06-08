//
//  ChartCompare.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 07.06.2021.
//

import SwiftUI


struct ChartCompare: View {
    
    @ObservedObject var model = ChartCompareModel()
    @State var delta: chartOffset = chartOffset(dy: 0, dx: 0)
    var dates: [Date]?
    var values: [Double]?
    var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    
    
    init(dates:[Date]? = nil,values:[Double]?=nil,miniature: Bool=false){
        self.dates=dates
        self.values=values
        self.miniature=miniature
        
        if(self.miniature){
            self.offset=0
        }
        
        if(self.dates != nil && values != nil){
            // self.model.setup(dates: self.dates!, values: self.values!)
        }
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }
    
    
    func setData(dates: [Date],values: [Double]){
        //self.model.setup(dates: dates, values: values)
    }
    
    func setColors(titleColor: Color,textColor: Color,backgroundColor: Color = UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.textColor=textColor
        self.model.backgroundColor=backgroundColor
        //self.model.setColors(axisColor: axisColor,gridColor: gridColor,colors: colors)
    }
    
    var body: some View{
        GeometryReader{ g in
            Group{
                ChartBase(text: self.model.title,textColor: self.model.titleColor,backgroundColor:self.model.backgroundColor)
                
                
                Group{
                    Color.clear.contentShape(Rectangle())
                    VStack{
                        ForEach(self.model.descriptions, id:\.self){ i in
                            Text(i)
                        }
                    }
                }
                    .border(Color.red)
                    .foregroundColor(self.model.textColor)
                    .frame(width:self.model.descriptionWidth, height: g.size.height-3*self.offset,alignment:.leading)
                    .offset(x: self.offset, y: 2*self.offset)

                
                Group{
                    Color.clear.contentShape(Rectangle())
                    HStack{
                        ForEach(self.model.values,id:\.self){ i in
                            VStack{
                                Text(i[0])
                                Text(i[1])
                                Text(i[2])
                            }
                            .foregroundColor(self.model.textColor)
                            .frame(width:self.model.recordWidth)
                        }
                        
                    }
                }
                .border(Color.red)
                .frame(width: 2*self.model.recordWidth, height: g.size.height-3*self.offset,alignment:.leading)
                .offset(x: self.delta.dx, y: self.delta.dy)
                .clipped()
                .offset(x: self.offset+self.model.descriptionWidth, y: 2*self.offset)
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            let scrollDirection:CGFloat = -1.0
                            let offsetX = self.delta.x + scrollDirection * (value.startLocation.x-value.location.x)
                            
                            let width:CGFloat = (CGFloat(self.model.values.count-1)-0.5)*self.model.recordWidth
                            
                            if(-offsetX < width && -offsetX > 0){
                                self.delta.dx =  offsetX// < 0 ? -1.0 : 1.0
                            }
                        })
                        .onEnded({ value in
                            withAnimation(.linear(duration:1)){
                                self.delta.dx = CGFloat(Int(self.delta.dx/(self.model.recordWidth)))*self.model.recordWidth
                            }
                            self.delta.x=self.delta.dx
                            self.delta.y=self.delta.dy
                        })
                )
                .onAppear(perform:{
                    self.model.setSize(width: g.size.width-2*self.offset)
                    self.model.setDescriptions(descriptions: [
                        Localization.getString("IDS_CHART_COMPARE_DATE"),
                        Localization.getString("IDS_CHART_COMPARE_HEARTRATE"),
                        Localization.getString("IDS_CHART_COMPARE_HRVINDEX")
                    ])
                    var arr = [[String]]()
                    for i in 0..<self.model.count{
                        arr.append([String(i),String(Int.random(in: 0..<20)),String(Int.random(in: 0..<20))])
                    }
                    self.model.values=arr
                })
                
                
            }
            
        }
    }
    
    
}







