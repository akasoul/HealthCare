//
//  ChartEcg.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 23.04.2021.
//

import Foundation
import SwiftUI
import Combine
import UIKit

struct ChartEcg: View {
    
    @State var delta: chartOffset = chartOffset(dy: 0, dx: 0)
    @ObservedObject var model = ChartEcgModel()
    let data: [Double]?
    let marks: [Double]?
    let duration: Double?
    let backgroundColor: Color
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    let title: String
    var titleColor = Color.blue
    var lineColor: UIColor
    init(data:[Double]? = nil,marks:[Double]? = nil,duration: Double? = nil,lineColor: UIColor=UIColor.blue,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.3),miniature: Bool=false){
        self.data=data
        self.marks=marks
        self.duration=duration
        self.miniature=miniature
        self.backgroundColor=backgroundColor
        self.lineColor=lineColor
        if(self.miniature){
            self.title=""
            self.offset=0
        }
        else{
            self.title=Localization.getString("IDS_CHART_ECG_NAME")
        }
        
        if(self.data != nil && self.marks != nil){
            self.model.setup(data: self.data!, marks: self.marks!)
        }
        
        self.model.setColors(lineColor: self.lineColor,axisColor: UIColor.blue)
        
    }
    
    mutating func setColors(titleColor: Color,lineColor: UIColor,marksColor: UIColor,axisColor: UIColor){
        self.titleColor=titleColor
        self.model.setColors(lineColor:lineColor,marksColor:marksColor,axisColor:axisColor)
    }
    
    func setup(data: [Double],marks: [Double],duration: Double?=nil){
        self.model.setup(data: data, marks: marks,duration: duration)
    }
    
    var body: some View{
        GeometryReader{ g in
            Group{
                ChartBase(text: self.title,textColor: self.titleColor,backgroundColor:self.backgroundColor)
                
                if(!self.miniature){
                Image(uiImage: self.model.imgAxisX ?? UIImage())
                    .frame(width: g.size.width-5*self.offset,height: self.model.axisHeight,alignment:.leading)
                    .offset(x: self.delta.dx)
                    .clipped()
                    .offset(x: self.offset, y: 2*self.offset)
                    .offset(x: self.model.axisWidth, y: self.model.height ?? 0)

                Image(uiImage: self.model.imgAxisY ?? UIImage())
                    .frame(width: self.model.axisWidth,height: g.size.height-3*self.offset,alignment:.leading)
                    .offset(y: self.delta.dy)
                    .clipped()
                    .offset(x: self.offset, y: 2*self.offset)
                    
                }
                
                Image(uiImage: self.model.img ?? UIImage())
                    .frame(width: g.size.width-2*self.offset-self.model.axisWidth, height: g.size.height-2*self.offset-self.model.axisHeight,alignment:.leading)
                    .offset(x: self.delta.dx, y: self.delta.dy)
                    .clipped()
                    .offset(x: self.offset+self.model.axisWidth, y: 2*self.offset)
                    .gesture(
                        DragGesture()
                            .onChanged({ (value) in
                                let scrollDirection:CGFloat = -1.0
                                let offsetX = self.delta.x + scrollDirection * (value.startLocation.x-value.location.x)
                                let offsetY = self.delta.y + scrollDirection * (value.startLocation.y-value.location.y)
                                
                                let tmpView = UIImageView(image: self.model.img ?? UIImage())
                                let width = tmpView.frame.width
                                let height = tmpView.frame.height
                                
                                if(-offsetX < (width - g.size.width)/2 + self.offset && -offsetX > 0){
                                    self.delta.dx =  offsetX// < 0 ? -1.0 : 1.0
                                }
                                if(-offsetY < height-0.5*g.size.height && -offsetY > 0){
                                    self.delta.dy =  offsetY// < 0 ? -1.0 : 1.0
                                }
                            })
                            .onEnded({ value in
                                self.delta.x=self.delta.dx
                                self.delta.y=self.delta.dy
                            })
                    )
            }
            .onAppear(perform: {
                if(!miniature){
                    self.model.setSize(height: 0.75*g.size.height)
                }
                else{
                    self.model.setSize(height: 0.75*g.size.height,width: g.size.width)
                }
            })
            
            
        }
    }
    
}





