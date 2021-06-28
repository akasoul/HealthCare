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

struct ChartEcg: View,Equatable {
    static func == (lhs: ChartEcg, rhs: ChartEcg) -> Bool {
        return false
    }
    
    
    @State var delta: chartOffset = chartOffset(dy: 0, dx: 0)
    @ObservedObject var model = ChartEcgModel()
    @State var showHelp:Bool=false
    
    let data: [Double]?
    let marks: [Double]?
    let duration: Double?
    let backgroundColor: Color
    let cornerRadius: CGFloat = 20
    var offset: CGFloat=20
    let miniature: Bool
    var lineColor: UIColor
    let textHelp=Localization.getString("IDS_CHART_ECG_HELP")
    
    init(data:[Double]? = nil,marks:[Double]? = nil,duration: Double? = nil,titleColor: Color?=nil,marksColor:UIColor?=nil,lineColor: UIColor=UIColor.blue,axisColor:UIColor?=nil,backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.3),miniature: Bool=false){
        self.data=data
        self.marks=marks
        self.duration=duration
        self.miniature=miniature
        self.backgroundColor=backgroundColor
        self.lineColor=lineColor
        if(self.miniature){
            self.offset=0
        }
        else{
        }
        
        if(titleColor != nil && marksColor != nil && axisColor != nil){
            self.model.titleColor = titleColor!
            self.model.backgroundColor=backgroundColor
            self.model.setColors(lineColor:lineColor,marksColor:marksColor!,axisColor:axisColor!)
        }
        if(self.data != nil && self.marks != nil){
            self.model.setData(data: self.data!, marks: self.marks!)
        }
    }
    
    func setColors(titleColor: Color,textColor: Color,lineColor: UIColor,marksColor: UIColor,axisColor: UIColor,backgroundColor: Color=UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.model.titleColor=titleColor
        self.model.textColor=textColor
        self.model.backgroundColor=backgroundColor
        self.model.setColors(lineColor:lineColor,marksColor:marksColor,axisColor:axisColor)
    }
    
    func setTitle(_ title: String){
        self.model.title=title
    }
    
    
    func setData(data: [Double],marks: [Double],duration: Double?=nil){
        self.model.setData(data: data, marks: marks,duration: duration)
    }
    
    func help(){
        withAnimation(.linear(duration: 0.5), {
            //self.rotationAngle = self.rotationAngle == Angle(degrees: 360) ? Angle(degrees: 0) : Angle(degrees: 360)
            self.showHelp = self.showHelp == true ? false : true
        })
    }
    
    var body: some View{
        GeometryReader{ g in
            Group{
                if(!self.miniature){
                    ChartBase(text: self.model.title,textColor: self.model.titleColor,showHelpButton: true,showHelpButtonColor: self.model.textColor,showHelpButtonAction: self.help, backgroundColor:self.model.backgroundColor)
                }
                if(!self.showHelp){
                    if(!self.miniature){
                        Image(uiImage: self.model.imgAxisX ?? UIImage())
                            .frame(width: g.size.width-5*self.offset,height: self.model.axisHeight,alignment:.leading)
                            .offset(x: self.delta.dx)
                            .clipped()
                            .offset(x: self.offset, y: 2.5*self.offset)
                            .offset(x: self.model.axisWidth, y: self.model.height ?? 0)
                        
                        Image(uiImage: self.model.imgAxisY ?? UIImage())
                            .frame(width: self.model.axisWidth,height: g.size.height-3*self.offset,alignment:.leading)
                            .offset(y: self.delta.dy)
                            .clipped()
                            .offset(x: self.offset, y: 2.5*self.offset)
                        
                    }
                    
                    Image(uiImage: self.model.img ?? UIImage())
                        .frame(width: g.size.width-2*self.offset-self.model.axisWidth, height: g.size.height-2*self.offset-self.model.axisHeight,alignment:.leading)
                        .offset(x: self.delta.dx, y: self.delta.dy)
                        .clipped()
                        .offset(x: self.offset+self.model.axisWidth, y: 2.5*self.offset)
                        .gesture(
                            DragGesture()
                                .onChanged({ (value) in
                                    let scrollDirection:CGFloat = -1.0
                                    let offsetX = self.delta.x + scrollDirection * (value.startLocation.x-value.location.x)
                                    let offsetY = self.delta.y + scrollDirection * (value.startLocation.y-value.location.y)
                                    
                                    let tmpView = UIImageView(image: self.model.img ?? UIImage())
                                    let width = tmpView.frame.width
                                    let height = tmpView.frame.height
                                    
                                    if(-offsetX < (width - g.size.width) + self.offset && -offsetX > 0){
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
                else{
                    Text(self.textHelp)
                        .font(.system(size: 12))
                        .frame(width:g.size.width-2*self.offset,alignment: .leading)
                        .offset(x:self.offset,y:2.5*self.offset)
                        .foregroundColor(self.model.textColor)
                    
                }
                
            }
            .onAppear(perform: {
                if(!miniature){
                    self.model.setSize(height: 0.7*g.size.height)
                }
                else{
                    self.model.setSize(height: 0.7*g.size.height,width: g.size.width)
                }
            })
            
            
        }
    }
    
}





