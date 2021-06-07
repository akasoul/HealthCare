//
//  ChartEcgModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 23.04.2021.
//

import Foundation
import CoreGraphics
import UIKit
import SwiftUI

class ChartEcgModel: ObservableObject{
    
    @Published var img: UIImage?
    
    
    @Published var imgAxisX: UIImage?
    @Published var imgAxisY: UIImage?
    @Published var titleColor=Color.blue
    @Published var textColor = Color.blue
    @Published var title: String=""
    @Published var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)

    var axisColor=UIColor.blue
    var axisWidth: CGFloat = 60
    var axisHeight: CGFloat = 20
    let axisFontSize:CGFloat=12
    
    var height: CGFloat?
    var width: CGFloat?
    var data: [Double]?
    var marks: [Double]?
    var duration: Double?
    var lineColor: UIColor?
    var marksColor: UIColor = UIColor.red
    let marksSize: CGFloat=5
    
    init() {
        
    }
    
    func setSize(height: CGFloat,width:CGFloat? = nil){
        if(width != nil){
            self.height=height
            self.width=width
            self.axisWidth=0
            self.axisHeight=0
        }
        else{
            self.height=height - self.axisHeight
            
        }
        self.update()
    }
    
    func setColors(lineColor: UIColor,marksColor: UIColor=UIColor.red,axisColor: UIColor,backgroundColor:Color=UIColor(red: 1, green: 1, blue: 1,alpha: 0.3).color){
        self.lineColor=lineColor
        self.marksColor=marksColor
        self.axisColor=axisColor
        self.backgroundColor=backgroundColor
    }
    func setData(data: [Double],marks:[Double],duration: Double?=nil){
        self.data=data
        self.marks=marks
        self.duration=duration
        self.update()
    }
    
    func update(){
            guard let data=self.data,
                  let marks=self.marks,
                  let lineColor=self.lineColor,
                  let height=self.height
            else{ return }
            guard var min = data.min(),
                  var max = data.max()
            else{ return }

            print("@")
            let dist = 0.1*(max-min)
            min -= dist
            max += dist
            let width = self.width ?? 0.2*CGFloat(data.count)
            
            let dataHeight=max-min
            
            let shadowLayer=CAShapeLayer()
            let lineLayer=CAShapeLayer()
            let marksLayer=CAShapeLayer()
            
            shadowLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            lineLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            marksLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            
            shadowLayer.fillColor = UIColor.clear.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            marksLayer.fillColor = UIColor.clear.cgColor
            
            let path = UIBezierPath()
            let subPath = UIBezierPath()
            for i in 0..<data.count{
                if (self.width != nil){
                    if(0.2*CGFloat(i)>self.width!){
                        break
                    }
                }
                var pointY = data[i]
                pointY -= min
                pointY /= dataHeight
                pointY *= Double(height)
                pointY = Double(height) - pointY
                if(i==0){
                    path.move(to: .init(x: 0.2*CGFloat(i), y: CGFloat(pointY)))
                }
                else{
                    path.addLine(to: .init(x: 0.2*CGFloat(i), y: CGFloat(pointY)))
                    if(self.width == nil){
                        if(i<marks.count){
                            if(marks[i]==1){
                                subPath.move(to: .init(x: 0.2*CGFloat(i), y: CGFloat(pointY)))
                                subPath.addLine(to: .init(x: 0.2*CGFloat(i), y: CGFloat(pointY)))
                                subPath.addLine(to: .init(x: 0.2*CGFloat(i)-self.marksSize, y: self.marksSize+CGFloat(pointY)))
                                subPath.addLine(to: .init(x: 0.2*CGFloat(i)+self.marksSize, y: self.marksSize+CGFloat(pointY)))
                            }
                        }
                    }
                }
            }
            
            shadowLayer.path=path.cgPath
            shadowLayer.strokeColor=lineColor.withAlphaComponent(0.2).cgColor
            shadowLayer.lineWidth=4
            
            lineLayer.path=path.cgPath
            lineLayer.strokeColor=lineColor.cgColor
            lineLayer.lineWidth=1
            
            marksLayer.path=subPath.cgPath
        marksLayer.fillColor=self.marksColor.cgColor
            
            shadowLayer.addSublayer(lineLayer)
            shadowLayer.addSublayer(marksLayer)
            if(self.width == nil){
            }
            
            let renderer = UIGraphicsImageRenderer(bounds: shadowLayer.bounds)
            DispatchQueue.main.async{
                self.img = renderer.image(actions: { context in
                    shadowLayer.render(in: context.cgContext)
                })
            }
            
            if(self.width == nil){
                
                let xMarksPeriod=50
                let xMarksCount = Int(width/CGFloat(xMarksPeriod))
                let xMarksStartValue:CGFloat=0
                let xMarksEndValue:CGFloat=CGFloat(self.duration ?? 0)
                let xMarksFormat=NSString(string: Localization.getString("IDS_CHART_ECG_X_MARKS_FORMAT"))
                
                let yMarksPeriod=25
                let yMarksCount = Int(height/CGFloat(yMarksPeriod))
                let yMarksStartValue:CGFloat = -1
                let yMarksEndValue:CGFloat=1
                let yMarksFormat=NSString(string: Localization.getString("IDS_CHART_ECG_Y_MARKS_FORMAT"))
                
                //axis x
                do{
                    let layer = CALayer()
                    layer.frame=CGRect(x: 0, y: 0, width: width, height: self.axisHeight)
                    
                    let count = xMarksCount
                    let step = width/CGFloat(count)
                    for i in 0..<count{
                        let textLayer=CATextLayer()
                        textLayer.frame=CGRect(x: step*CGFloat(i), y: 5, width: step, height: self.axisHeight-5)
                        let value = Double((CGFloat(i)/CGFloat(count-1)) * (xMarksEndValue-xMarksStartValue) + xMarksStartValue)
                        textLayer.string = NSString(format: xMarksFormat, value)
                        textLayer.foregroundColor=self.axisColor.cgColor
                        textLayer.fontSize=self.axisFontSize
                        textLayer.alignmentMode = .left
                        
                        
                        layer.addSublayer(textLayer)
                    }
                    let renderer = UIGraphicsImageRenderer(bounds: layer.bounds)
                    
                        self.imgAxisX = renderer.image(actions: { context in
                            layer.render(in: context.cgContext)
                        })
                    

                }
                //axis y
                do{
                    let layer = CALayer()
                    layer.frame=CGRect(x: 0, y: 0, width: self.axisWidth, height: height)
                    let count = yMarksCount
                    let step = height/CGFloat(count-1)
                    for i in 0..<count{
                        var fontSizeOffset:CGFloat=0
                        if(i==0){
                            fontSizeOffset = -self.axisFontSize
                        }
                        else{
                            if(i != count-1){
                                fontSizeOffset = -0.5*self.axisFontSize
                            }
                        }
                        let textLayer=CATextLayer()
                        textLayer.frame=CGRect(x: 0, y: CGFloat(count-i-1)*step+fontSizeOffset, width: axisWidth-10, height: self.axisFontSize)
                        let value = Double((CGFloat(i)/CGFloat(count-1)) * (yMarksEndValue-yMarksStartValue) + yMarksStartValue)
                        textLayer.string = NSString(format: yMarksFormat, value)
                        textLayer.foregroundColor=self.axisColor.cgColor
                        textLayer.fontSize=self.axisFontSize
                        textLayer.alignmentMode = .right
                        layer.addSublayer(textLayer)
                    }
                    let renderer = UIGraphicsImageRenderer(bounds: layer.bounds)
                        self.imgAxisY = renderer.image(actions: { context in
                            layer.render(in: context.cgContext)
                        })
                    

                }
            }
            
            
        
    }
}
