//
//  Chart.swift
//  testapp
//
//  Created by User on 06.04.2020.
//  Copyright © 2020 User. All rights reserved.
//

import Foundation
import SwiftUI



struct ChartRhythmogram: View {
    let clrBorder: Color = Color.clear
    let xCount: Int = 10
    let yCount: Int = 10
    let space: CGFloat = 20.0
    let clr: Color = Color.blue
    let offsetX:CGFloat = 100
    let offsetY:CGFloat = 50
    let scrollSpeedMod:CGFloat = 0.02
    let gridColor1: Color
    let gridColor2: Color
    let clrChartText: Color
    var virtualStartPosX:CGFloat
    var virtualEndPosX:CGFloat
    var virtualStartPosY:CGFloat
    var virtualEndPosY:CGFloat
    var viewWidth:CGFloat
    var viewHeight:CGFloat
    var chartWidth:CGFloat
    var chartHeight: CGFloat
    var data: [Double]
    var filter: [Int]
    let grid: [CGFloat]
    var count: Int
    var expectedCount: Int?
    var step: CGFloat
    let title: String

    let clrRhythmogramLower: Color
    let clrRhythmogramUpper: Color
    let clrRhythmogramUpperLine: Color
    @State var delta: chartOffset = chartOffset(dy: 0.0, dx: 0.0)

    let backgroundColor: Color
    let cornerRadius: CGFloat = 20
    
    init(viewWidth:CGFloat,viewHeight:CGFloat,data:[Double],expectedCount: Int? = nil,filter:[Int], grid: [CGFloat],rhythmogramColors: [Color],gridColors: [Color],clrChartText: Color,title: String="",backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.3)){
        self.viewWidth=viewWidth
        self.viewHeight=viewHeight
        self.chartWidth=self.viewWidth-self.offsetX
        self.chartHeight=self.viewHeight-self.offsetY
        self.title=title
        self.data=data
        self.filter=filter
        self.grid=grid
        self.gridColor1 = gridColors[0]
        self.gridColor2 = gridColors[1]
        self.clrRhythmogramLower=rhythmogramColors[2]
        self.clrRhythmogramUpper=rhythmogramColors[1]
        self.clrRhythmogramUpperLine=rhythmogramColors[0]
        self.clrChartText=clrChartText
        self.backgroundColor=backgroundColor
        self.count=self.data.count
        self.expectedCount=expectedCount
        if(expectedCount != nil){
            self.count=max(self.count,self.expectedCount!)
        }
        self.step=self.viewWidth/CGFloat(self.count)
        if(self.data.count>0){
            self.virtualStartPosX = 0
            self.virtualEndPosX = CGFloat(self.count)
            self.virtualStartPosY = CGFloat(self.data.min()!)
            self.virtualEndPosY = -CGFloat(self.data.max()!)
            self.virtualStartPosX=0
            self.virtualEndPosX=self.chartWidth
            self.virtualStartPosY=0
            self.virtualEndPosY = self.chartHeight
        }
        else{
            self.virtualStartPosX = 0
            self.virtualEndPosX = -CGFloat(self.count)
            self.virtualStartPosY = 0
            self.virtualEndPosY = 0
            self.virtualEndPosX=self.chartWidth
        }
    }
    
    static func == (lhs: ChartRhythmogram,rhs: ChartRhythmogram) -> Bool{
        return lhs.data==rhs.data
    }
    
    func calculateXPos(index: Int, width: CGFloat) -> CGFloat{
        return self.space + CGFloat(index) * (width - self.space * 2.0) / CGFloat(self.xCount)
    }
    
    func calculateYPos(index: Int, height: CGFloat) -> CGFloat{
        return self.space + CGFloat(index) * (height - self.space * 2.0) / CGFloat(self.yCount)
    }
    
    var body: some View{
        ZStack{
            GeometryReader{ g in
                Group{
                    RoundedRectangle(cornerRadius: self.cornerRadius).foregroundColor(self.backgroundColor).scaledToFill()
                    //Rectangle().stroke(self.clrBorder, lineWidth: 1)
                    
                    Group{
                        Grid(step: self.grid[0], lineColor: self.gridColor1, lineWidth: 0.3, virtualStartPosX: self.virtualStartPosX, virtualEndPosX: self.virtualEndPosX, virtualStartPosY: self.virtualStartPosY, virtualEndPosY: self.virtualEndPosY,marksEnabled: false,viewHeight: self.chartHeight,viewWidth: self.chartWidth,delta: self.delta)
                        Grid(step: self.grid[1], lineColor: self.gridColor2, lineWidth: 0.3, virtualStartPosX: self.virtualStartPosX, virtualEndPosX: self.virtualEndPosX, virtualStartPosY: self.virtualStartPosY, virtualEndPosY: self.virtualEndPosY,marksEnabled:true, marksColor: clrChartText, viewHeight: self.chartHeight,viewWidth: self.chartWidth, delta: self.delta,xMarksFormatter: "%0.frr", xMarksMinValue: 0, xMarksMaxValue: Double(self.count))//self.data.count>0 ? -Double(self.count) : Double(300))
                        if(self.data.count>0){
                            RhythmogramPath(data: self.data,expectedCount: self.expectedCount, filter: self.filter,upperLineColor: clrRhythmogramUpperLine, upperGrColor: clrRhythmogramUpper, lowerGrColor: clrRhythmogramLower, viewHeight: self.chartHeight,viewWidth: self.chartWidth).opacity(0.7)
                        }
                    }.frame(width: self.chartWidth, height: self.chartHeight).offset(x: 0.5*self.offsetX, y: 0.5*self.offsetY)
                }
            }
        }
    }
    
}




struct RhythmogramPath: View{
    var data: [CGPoint]
    var dataFilter: [CGPoint] = []
    var step: CGFloat
    var expectedCount: Int?
    var viewHeight: CGFloat
    var viewWidth: CGFloat
    let marksSize:CGFloat = 10
    let marksColor:Color=Color.blue
    let upperGrColor: Color
    let lowerGrColor: Color
    let upperLineColor: Color
    
    init(data: [Double],expectedCount: Int? = nil, filter:[Int],upperLineColor: Color, upperGrColor: Color, lowerGrColor: Color, viewHeight: CGFloat, viewWidth: CGFloat){
        let viewWidth = viewWidth//*0.85
        self.viewHeight=viewHeight
        self.viewWidth=viewWidth
        self.upperGrColor=upperGrColor
        self.lowerGrColor=lowerGrColor
        self.upperLineColor=upperLineColor
        self.data=[]
        self.expectedCount=expectedCount
        self.step=self.viewWidth/CGFloat(data.count-1)
        if(self.expectedCount != nil){
            if(self.expectedCount! > data.count){
                self.step=self.viewWidth / CGFloat(self.expectedCount! - 1)
            }
        }
        let dataMax=1.0 * data.max()!
        let dataMin=0.5 * data.min()!
        self.data.append(CGPoint(x: 0, y: self.viewHeight))
        for i in 0..<data.count{
            var x: CGFloat = CGFloat(i) * self.step
            var y: CGFloat = self.viewHeight-self.viewHeight*CGFloat(data[i]-dataMin)/CGFloat(dataMax)
            self.data.append(CGPoint(x: x, y: y))
            if(i < data.count-1){
                x = CGFloat(i) * self.step
                y =              self.viewHeight-self.viewHeight*CGFloat(data[i+1]-dataMin)/CGFloat(dataMax)
                self.data.append(CGPoint(x: x, y: y))
            }
            if(filter.count>0){
                if(i < filter.count-1){
                    if(filter[i]==1){
                        self.dataFilter.append(CGPoint(x: CGFloat(i-1)*self.step, y: self.viewHeight))
                        self.dataFilter.append(CGPoint(x: CGFloat(i-1)*self.step, y: self.viewHeight-self.viewHeight*CGFloat(data[i]-dataMin)/CGFloat(dataMax)))
                        self.dataFilter.append(CGPoint(x: CGFloat(i)*self.step, y: self.viewHeight-self.viewHeight*CGFloat(data[i]-dataMin)/CGFloat(dataMax)))
                        self.dataFilter.append(CGPoint(x: CGFloat(i)*self.step, y: self.viewHeight))
                        self.dataFilter.append(CGPoint(x: CGFloat(i-1)*self.step, y: self.viewHeight))
                    }
                }
            }
        }
        self.data.append(CGPoint(x: CGFloat(data.count-1)*self.step, y: self.viewHeight))
    }
    
    
    var body: some View{
        GeometryReader{g in
            Group{
                Path{ path in
                    for i in 0..<self.data.count{
                        if(i==0){
                            path.move(to: self.data[i])
                        }
                        else{
                            path.addLine(to: self.data[i])
                        }
                    }
                    path.addLine(to: self.data[0])
                }.fill(LinearGradient(gradient: Gradient(colors: [self.upperGrColor,self.lowerGrColor]), startPoint: .top, endPoint: .bottom))
                
                if(self.dataFilter.count>0){
                    Path{ path in
                        for i in 0..<self.dataFilter.count{
                            if(i%5==0){
                                path.move(to: self.dataFilter[i])
                            }
                            else{
                                path.addLine(to: self.dataFilter[i])
                            }
                        }
                    }.fill(Color.white)
                }
                
                Path{ path in
                    for i in 1..<self.data.count-1{
                        if(i==1){
                            path.move(to: self.data[i])
                        }
                        else{
                            path.addLine(to: self.data[i])
                        }
                    }
                }.stroke(self.upperLineColor,lineWidth: 1)
            }
        }.frame(width: self.viewWidth, height: self.viewHeight)
    }
    
}






