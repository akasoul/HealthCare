//
//  Grid.swift
//  testapp
//
//  Created by User on 24.04.2020.
//  Copyright © 2020 User. All rights reserved.
//

import Foundation
import SwiftUI


struct Grid: View{
    let step:CGFloat
    let lineColor: Color
    let lineWidth: CGFloat
    var virtualStartPosX:CGFloat
    var virtualEndPosX:CGFloat
    var virtualStartPosY:CGFloat
    var virtualEndPosY:CGFloat
    var virtualHeight:CGFloat
    var marksEnabled: Bool
    var viewHeight: CGFloat
    var viewWidth: CGFloat
    let marksSize:CGFloat = 10
    let marksColor:Color?
    var delta: chartOffset
    let markLineSize:CGFloat=5
    let marksCountX: Int
    let marksCountY : Int
    let gridCountX: Int
    let gridCountY : Int
    var MarksX: [Mark]?
    var MarksY: [Mark]?
    var GridX: [GridLine]?
    var GridY: [GridLine]?
    var bStaticXMarks: Bool = false
    var xMarksFormatter: String?
    var yMarksFormatter: String?
    var xMarksMinValue: Double?
    var xMarksMaxValue: Double?
    var yMarksMinValue: Double?
    var yMarksMaxValue: Double?
    
    init(step: CGFloat, lineColor: Color, lineWidth: CGFloat, virtualStartPosX: CGFloat, virtualEndPosX: CGFloat, virtualStartPosY: CGFloat, virtualEndPosY: CGFloat, marksEnabled:Bool,marksColor: Color? = nil, viewHeight: CGFloat, viewWidth: CGFloat,delta: chartOffset, xMarksFormatter: String? = nil,  xMarksMinValue: Double? = nil,xMarksMaxValue: Double? = nil, yMarksFormatter: String? = nil,yMarksMinValue:Double?=nil,yMarksMaxValue:Double?=nil, bStaticXMarks: Bool = false){
        self.step=step
        self.lineColor=lineColor
        self.lineWidth=lineWidth
        self.marksColor=marksColor
        self.virtualStartPosX=virtualStartPosX
        self.virtualEndPosX=virtualEndPosX
        self.virtualStartPosY=virtualStartPosY
        self.virtualEndPosY = -virtualEndPosY
        self.virtualHeight=abs(self.virtualEndPosY-self.virtualStartPosY)
        self.marksEnabled=marksEnabled
        self.bStaticXMarks=bStaticXMarks
        self.viewHeight=viewHeight
        self.viewWidth=viewWidth
        self.delta = delta
        
        if(xMarksFormatter != nil){
            self.xMarksFormatter=xMarksFormatter
        }
        if(yMarksFormatter != nil){
            self.yMarksFormatter=yMarksFormatter
        }
        if(xMarksMinValue != nil){
            self.xMarksMinValue=xMarksMinValue
        }
        if(xMarksMaxValue != nil){
            self.xMarksMaxValue=xMarksMaxValue
        }
        if(yMarksMinValue != nil){
            self.yMarksMinValue=yMarksMinValue
        }
        if(yMarksMaxValue != nil){
            self.yMarksMaxValue=yMarksMaxValue
        }
        
        //x grid init
        let normalizedPosX = normalizeDelta(delta: delta.dx, scale: step)
        self.gridCountX = 1+Int((viewWidth-normalizedPosX)/step)
        if(self.gridCountX>0){
            for i in 0..<self.gridCountX{
                let pos = normalizedPosX + CGFloat(i) * step
                if(pos<=viewWidth && pos >= 0){
                    if(self.GridX == nil){
                        self.GridX=[GridLine(xStartPos: pos, yStartPos: 0, xEndPos: pos, yEndPos: viewHeight)]
                    }
                    else{
                        self.GridX!.append(GridLine(xStartPos: pos, yStartPos: 0, xEndPos: pos, yEndPos: viewHeight))
                    }
                }
            }
        }
        
        
        //y grid init
        let normalizedPosY = normalizeDelta(delta: delta.dy, scale: step)
        self.gridCountY = 1+Int((viewHeight-normalizedPosY)/step)
        if(self.gridCountY>0){
            for i in 0..<self.gridCountY{
                let pos = normalizedPosY + CGFloat(i) * step
                if(pos<=viewHeight && pos >= 0){
                    if(self.GridY == nil){
                        self.GridY=[GridLine(xStartPos: 0, yStartPos: pos, xEndPos: viewWidth, yEndPos: pos)]
                    }
                    else{
                        self.GridY!.append(GridLine(xStartPos: 0, yStartPos: pos, xEndPos: viewWidth, yEndPos: pos))
                    }
                }
            }
        }
        
        if(marksEnabled){
            //x marks init
            let frameStartPosX = ( -(delta.dx + virtualStartPosX))
            let normalizedPosX = normalizeDelta(delta: delta.dx, scale: step)
            let firstIndexInFrameX = Int(0.99 + frameStartPosX / step)
            self.marksCountX = 1+Int((viewWidth-normalizedPosX)/step)
            if(self.marksCountX>0){
                for i in 0..<self.marksCountX{
                    let pos = normalizedPosX + CGFloat(i) * step
                    var num = CGFloat(firstIndexInFrameX+i) * step
                    var str:String = String(format: "%.0f",num)
                    if(xMarksFormatter != nil){
                        if(xMarksMinValue != nil && xMarksMaxValue != nil){
                            num=num/(self.virtualEndPosX-self.virtualStartPosX)*(CGFloat(self.xMarksMaxValue!)-CGFloat(self.xMarksMinValue!)) + CGFloat(self.xMarksMinValue!)
                            str = String(format: xMarksFormatter!, num)
                        }
                        else{
                            str = String(format: xMarksFormatter!, num)
                        }
                    }
                    if(pos<=viewWidth && pos >= 0){
                        if(self.MarksX == nil){
                            self.MarksX=[Mark(text: str, xPos: pos, yPos: viewHeight)]
                        }
                        else{
                            self.MarksX!.append(Mark(text: str, xPos: pos, yPos: viewHeight))
                        }
                    }
                }
            }
            
            //y marks init
            let normalizedPosY = normalizeDelta(delta: delta.dy, scale: step)
            let frameStartPosY = virtualStartPosY - delta.dy + normalizedPosY
            let firstIndexInFrameY = Int(frameStartPosY / step)
            self.marksCountY = 1+Int((viewHeight-normalizedPosY)/step)
            if(self.marksCountY>0){
                for i in 0..<self.marksCountY{
                    let pos = normalizedPosY + CGFloat(i) * step
                    var num = -self.virtualEndPosY - CGFloat(firstIndexInFrameY+i) * step
                    if(self.viewHeight>self.virtualHeight){
                        num = self.viewHeight - CGFloat(firstIndexInFrameY+i) * step
                    }
                    var str:String = String(format: "%.0f",num)
                    if(pos<=viewHeight && pos >= 0){
                        
                        if(yMarksFormatter != nil){
                            if(yMarksMinValue != nil && yMarksMaxValue != nil){
                                
                                if(abs(self.virtualStartPosY-self.virtualEndPosY)>self.viewHeight){
                                    num = (num+self.virtualStartPosY)*CGFloat(self.yMarksMaxValue! - self.yMarksMinValue!)/(-self.virtualEndPosY+self.virtualStartPosY)+CGFloat(self.yMarksMinValue!)
                                    
                                }
                                else{
                                    num = (num+0)*CGFloat(self.yMarksMaxValue! - self.yMarksMinValue!)/(self.viewHeight)+CGFloat(self.yMarksMinValue!)
                                }
                                
                                str = String(format: yMarksFormatter!, num)
                            }
                            else{
                                str = String(format: yMarksFormatter!, num)
                            }
                        }
                        
                        if(self.MarksY == nil){
                            self.MarksY=[Mark(text: str, xPos: 0 , yPos: pos)]
                        }
                        else{
                            self.MarksY!.append(Mark(text: str, xPos: 0, yPos: pos))
                        }
                    }
                }
            }
            if(self.bStaticXMarks){
                for i in 0..<self.MarksX!.count{
                    self.MarksX![i].text = String(format: "%.0f",CGFloat(self.xMarksMinValue!) + CGFloat(self.xMarksMaxValue!-self.xMarksMinValue!) * self.MarksX![i].xPos/self.viewWidth)
                    if(self.xMarksFormatter != nil){
                        self.MarksX![i].text = String(format: self.xMarksFormatter!,CGFloat(self.xMarksMinValue!) + CGFloat(self.xMarksMaxValue!-self.xMarksMinValue!) * self.MarksX![i].xPos/self.viewWidth)
                    }
                }
            }
        }
        else{
            self.marksCountX=0
            self.marksCountY=0
        }
    }
    
    
    
    
    var body: some View{
        GeometryReader{g in
            Group{
                //grid start
                ZStack{
                    Path{ path in
                        path.move(to: CGPoint(x:0,y:0))
                        path.addLine(to: CGPoint(x:self.viewWidth,y:0))
                        path.addLine(to: CGPoint(x:self.viewWidth,y:self.viewHeight))
                        path.addLine(to: CGPoint(x:0,y:self.viewHeight))
                        path.addLine(to: CGPoint(x:0,y:0))
                    }.stroke(lineWidth: self.lineWidth).border(Color.clear, width: 20.0).foregroundColor(self.lineColor)
                    
                    if(self.GridX != nil){
                        Path{ path in
                            for i in self.GridX!{
                                path.move(to: CGPoint(x:i.xStartPos,y:i.yStartPos))
                                path.addLine(to: CGPoint(x:i.xEndPos,y:i.yEndPos))
                            }
                        }.stroke(lineWidth: self.lineWidth).border(Color.clear, width: 20.0).foregroundColor(self.lineColor)
                    }
                    if(self.GridY != nil){
                        Path{ path in
                            for i in self.GridY!{
                                path.move(to: CGPoint(x:i.xStartPos,y:i.yStartPos))
                                path.addLine(to: CGPoint(x:i.xEndPos,y:i.yEndPos))
                            }
                        }.stroke(lineWidth: self.lineWidth).border(Color.clear, width: 20.0).foregroundColor(self.lineColor)
                    }
                    
                    if(self.marksEnabled){ // marks lines
                        if(self.GridX != nil){
                            Path{ path in
                                for i in self.GridX!{
                                    path.move(to: CGPoint(x:i.xStartPos,y:i.yEndPos-0.5*self.markLineSize))
                                    path.addLine(to: CGPoint(x:i.xEndPos,y:i.yEndPos+0.5*self.markLineSize))
                                }
                            }.stroke(lineWidth: 5.0*self.lineWidth).border(Color.clear, width: 20.0).foregroundColor(self.marksColor)
                        }
                        
                        if(self.GridY != nil){
                            Path{ path in
                                for i in self.GridY!{
                                    path.move(to: CGPoint(x:i.xStartPos-0.5*self.markLineSize,y:i.yStartPos))
                                    path.addLine(to: CGPoint(x:0.5*self.markLineSize,y:i.yEndPos))
                                }
                            }.stroke(lineWidth: 5.0*self.lineWidth).border(Color.clear, width: 20.0).foregroundColor(self.marksColor)
                        }
                    }
                }
                //grid end
                
                if(self.marksEnabled){ //marks start
                    if(self.MarksX != nil){
                        ForEach(self.MarksX!, id: \.self){i in
                            Text("\(i.text)").offset(x: i.xPos-20.0, y: i.yPos+10)
                                .font(.system(size: self.marksSize, weight: .light, design: .serif))
                                .foregroundColor(self.marksColor)
                                .frame(width:40.0,alignment: .center)
                        }
                    }
                    
                    if(self.MarksY != nil){
                        ForEach(self.MarksY!, id: \.self){i in
                            Text("\(i.text)").offset(x: i.xPos-self.viewWidth - 5, y: i.yPos-20.0)
                                .font(.system(size: self.marksSize, weight: .light, design: .serif))
                                .foregroundColor(self.marksColor)
                                .frame(width:self.viewWidth,height:40.0,alignment: .trailing)
                        }
                    }
                }
            }
        }.frame(width: self.viewWidth, height: self.viewHeight)
    }
    
}


struct Mark: Identifiable, Hashable{
    var id = UUID()
    var text: String
    var xPos: CGFloat
    var yPos: CGFloat
    
    init(text: String, xPos: CGFloat, yPos: CGFloat){
        self.text=text
        self.xPos=xPos
        self.yPos=yPos
    }
}

struct GridLine: Identifiable, Hashable{
    var id = UUID()
    
    var xStartPos: CGFloat
    var yStartPos: CGFloat
    var xEndPos: CGFloat
    var yEndPos: CGFloat
    
    init(xStartPos: CGFloat, yStartPos: CGFloat, xEndPos:CGFloat, yEndPos:CGFloat){
        self.xStartPos=xStartPos
        self.yStartPos=yStartPos
        self.xEndPos=xEndPos
        self.yEndPos=yEndPos
    }
}



func normalizeDelta(delta: CGFloat, scale: CGFloat) -> CGFloat{
    var delta = delta
    while(abs(delta)>scale || delta<0){
        if(delta>=0){
            delta -= scale
        }
        else{
            delta+=scale
        }
    }
    return abs(delta)
}
