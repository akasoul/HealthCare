//
//  ChartRhythmogram2Model.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 03.05.2021.
//

import Foundation
import CoreGraphics
import UIKit
import SwiftUI


class ChartDistributionModel: ObservableObject{
    struct ChartImages{
        var img: UIImage?
        var imgAxisX: UIImage?
        var imgAxisY: UIImage?
    }
    @Published var daily = ChartImages()
    @Published var weekly = ChartImages()
    
    @Published var titleColor=Color.blue
    @Published var textColor = Color.blue
    @Published var title: String=""
    @Published var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)

    var axisColor=UIColor.blue
    var axisWidth: CGFloat = 30
    var axisHeight: CGFloat = 20
    let axisFontSize:CGFloat=12
    
    var axisYMin: CGFloat?
    var axisYMax: CGFloat?
    
    var height: CGFloat?
    var width: CGFloat?
    var data: [Storage.Record]?
    var dates:[Date]?
    var values:[Double]?
    var colors=[UIColor.red,UIColor.yellow,UIColor.green,UIColor.blue]
    var gridColor = UIColor.gray.withAlphaComponent(0.3)
    let gridSize:CGFloat=0.5
    let circleRadius: CGFloat=5
    
    init() {
        
    }
    
    func setTitle(_ title: String){
        self.title=title
    }
    
    func setColors(axisColor: UIColor,gridColor: UIColor?=nil,colors: [UIColor]?=nil){
        self.axisColor=axisColor
        self.gridColor = gridColor ?? self.gridColor
        self.colors = colors ?? self.colors
    }
    
    func setYAxisMarks(minValue: Double,maxValue: Double){
        self.axisYMin = CGFloat(minValue)
        self.axisYMax = CGFloat(maxValue)
    }

    private func getColor(value: Double)->UIColor{
        if(value<25){
            return self.colors[0]
        }
        if(value<50){
            return self.colors[1]
        }
        if(value<75){
            return self.colors[2]
        }
        return self.colors[3]
    }
    
    func setSize(height: CGFloat,width:CGFloat){
        self.height=height - self.axisHeight
        self.width=width - self.axisWidth
        self.update()
    }
    func setup(data: [Storage.Record]){
        self.data=data
        self.update()
    }
    func setup(dates: [Date],values: [Double]){
        self.dates=dates
        self.values=values
        self.update()
    }

    func update(){
        guard
              let height=self.height,
              let width=self.width,
              let dates=self.dates,
            var values=self.values,
            let ymin=self.axisYMin,
            let ymax=self.axisYMax
        else{ return }
        
        let calendar=Calendar.init(identifier: .gregorian)
        
        values = values.map({ $0 - Double(ymin) })
        
        //daily img
        do{
            let gridLayer=CAShapeLayer()
            gridLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            gridLayer.backgroundColor = UIColor.clear.cgColor
            gridLayer.fillColor = UIColor.clear.cgColor
            gridLayer.strokeColor = self.gridColor.cgColor
            gridLayer.lineWidth=self.gridSize
            let path = UIBezierPath()
            let step = width/24
            for i in 0..<24{
                path.move(to: .init(x: CGFloat(i)*step, y: 0))
                path.addLine(to: .init(x: CGFloat(i)*step, y: height))
            }
            
            for i in 0..<5{
                path.move(to: .init(x: 0, y: 25*CGFloat(i)))
                path.addLine(to: .init(x: width, y: 25*CGFloat(i)))
            }
            
            gridLayer.path=path.cgPath
            
            
            for i in 0..<dates.count{
                if(i>=values.count){
                    return
                }
                let recordLayer=CAShapeLayer()
                recordLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
                recordLayer.backgroundColor = UIColor.clear.cgColor
                recordLayer.fillColor = self.getColor(value: values[i]).cgColor
                //recordLayer.strokeColor = self.gridColor
                
                let hour = calendar.component(.hour, from: dates[i])
                let subPath=UIBezierPath()
                subPath.addArc(withCenter: .init(x: (CGFloat(hour)-0.5)*step, y: height*(1-(CGFloat(values[i]/Double(ymax))))), radius: self.circleRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
                recordLayer.path=subPath.cgPath
                
                let maskLayer=CAGradientLayer()
                maskLayer.frame=CGRect(origin: .init(x: (CGFloat(hour)-0.5)*step-self.circleRadius, y: height*(1-(CGFloat(values[i]/Double(ymax))))-self.circleRadius), size: CGSize(width: 2*self.circleRadius, height: 2*self.circleRadius))
                maskLayer.type = CAGradientLayerType.radial
                maskLayer.startPoint = .init(x: 0.5, y: 0.5)
                maskLayer.endPoint = .init(x: 1, y: 1)
                maskLayer.colors=[UIColor.white.cgColor,UIColor.white.withAlphaComponent(0).cgColor]
                recordLayer.mask=maskLayer
                
                //gridLayer.addSublayer(maskLayer)
                gridLayer.addSublayer(recordLayer)

            }
            let renderer = UIGraphicsImageRenderer(bounds: gridLayer.bounds)
            self.daily.img = renderer.image(actions: { context in
                gridLayer.render(in: context.cgContext)
            })
            
            
            let xMarksCount = 12
            let xMarksStrings=[
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_1"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_2"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_3"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_4"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_5"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_6"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_7"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_8"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_9"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_10"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_11"),
                Localization.getString("IDS_CHART_DISTRIBUTION_HOUR_12"),
            ]
            
            let yMarksCount = 5
            let yMarksStartValue:CGFloat=ymin
            let yMarksEndValue:CGFloat=ymax
            let yMarksFormat=NSString(string: Localization.getString("IDS_CHART_DISTRIBUTION_Y_MARKS_FORMAT"))
            
            //axis x
            do{
                let layer = CALayer()
                layer.frame=CGRect(x: 0, y: 0, width: width, height: axisHeight)
                
                let count = xMarksCount
                let step = width/CGFloat(count)
                for i in 0..<count{
                    let textLayer=CATextLayer()
                    textLayer.frame=CGRect(x: step*CGFloat(i), y: 5, width: step, height: axisHeight-5)
                    textLayer.string = xMarksStrings[i]
                    textLayer.foregroundColor=self.axisColor.cgColor
                    textLayer.fontSize=self.axisFontSize
                    textLayer.alignmentMode = .left
                    layer.addSublayer(textLayer)
                }
                let renderer = UIGraphicsImageRenderer(bounds: layer.bounds)
                self.daily.imgAxisX = renderer.image(actions: { context in
                    layer.render(in: context.cgContext)
                })
            }
            //axis y
            do{
                let layer = CALayer()
                layer.frame=CGRect(x: 0, y: 0, width: axisWidth, height: height)
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
                self.daily.imgAxisY = renderer.image(actions: { context in
                    layer.render(in: context.cgContext)
                })
            }
            
        }
        
        //weekly img
        do{
            let gridLayer=CAShapeLayer()
            gridLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            gridLayer.backgroundColor = UIColor.clear.cgColor
            gridLayer.fillColor = UIColor.clear.cgColor
            gridLayer.strokeColor = self.gridColor.cgColor
            gridLayer.lineWidth=self.gridSize

            let path = UIBezierPath()
            let step = width/7
            for i in 0..<7{
                path.move(to: .init(x: CGFloat(i)*step, y: 0))
                path.addLine(to: .init(x: CGFloat(i)*step, y: height))
            }
            
            for i in 0..<5{
                path.move(to: .init(x: 0, y: 25*CGFloat(i)))
                path.addLine(to: .init(x: width, y: 25*CGFloat(i)))
            }
            
            gridLayer.path=path.cgPath
            
            for i in 0..<dates.count{
                let recordLayer=CAShapeLayer()
                recordLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
                recordLayer.backgroundColor = UIColor.clear.cgColor
                recordLayer.fillColor = self.getColor(value: values[i]).cgColor
                //recordLayer.strokeColor = self.gridColor
                
                let day = calendar.component(.weekday, from: dates[i])
                let subPath=UIBezierPath()
                subPath.addArc(withCenter: .init(x: (CGFloat(day)-0.5)*step, y: height*(1-(CGFloat(values[i]/Double(ymax))))), radius: self.circleRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
                recordLayer.path=subPath.cgPath
                
                let maskLayer=CAGradientLayer()
                maskLayer.frame=CGRect(origin: .init(x: (CGFloat(day)-0.5)*step-self.circleRadius, y: height*(1-(CGFloat(values[i]/Double(ymax))))-self.circleRadius), size: CGSize(width: 2*self.circleRadius, height: 2*self.circleRadius))
                maskLayer.type = CAGradientLayerType.radial
                maskLayer.startPoint = .init(x: 0.5, y: 0.5)
                maskLayer.endPoint = .init(x: 1, y: 1)
                maskLayer.colors=[UIColor.white.cgColor,UIColor.white.withAlphaComponent(0).cgColor]
                recordLayer.mask=maskLayer

                
                gridLayer.addSublayer(recordLayer)
            }
            
            
            let renderer = UIGraphicsImageRenderer(bounds: gridLayer.bounds)
            self.weekly.img = renderer.image(actions: { context in
                gridLayer.render(in: context.cgContext)
            })
            
            
            let xMarksCount = 7
            let xMarksStrings=[
                Localization.getString("IDS_CHART_DISTRIBUTION_DAY_1"),
                Localization.getString("IDS_CHART_DISTRIBUTION_DAY_2"),
                Localization.getString("IDS_CHART_DISTRIBUTION_DAY_3"),
                Localization.getString("IDS_CHART_DISTRIBUTION_DAY_4"),
                Localization.getString("IDS_CHART_DISTRIBUTION_DAY_5"),
                Localization.getString("IDS_CHART_DISTRIBUTION_DAY_6"),
                Localization.getString("IDS_CHART_DISTRIBUTION_DAY_7")
            ]
            
            let yMarksCount = 5
            let yMarksStartValue:CGFloat=ymin
            let yMarksEndValue:CGFloat=ymax
            let yMarksFormat=NSString(string: Localization.getString("IDS_CHART_DISTRIBUTION_Y_MARKS_FORMAT"))
            
            //axis x
            do{
                let layer = CALayer()
                layer.frame=CGRect(x: 0, y: 0, width: width, height: axisHeight)
                
                let count = xMarksCount
                let step = width/CGFloat(count)
                for i in 0..<count{
                    let textLayer=CATextLayer()
                    textLayer.frame=CGRect(x: step*CGFloat(i), y: 5, width: step, height: axisHeight-5)
                    textLayer.string = xMarksStrings[i]
                    textLayer.foregroundColor=self.axisColor.cgColor
                    textLayer.fontSize=self.axisFontSize
                    textLayer.alignmentMode = .left
                    layer.addSublayer(textLayer)
                }
                let renderer = UIGraphicsImageRenderer(bounds: layer.bounds)
                self.weekly.imgAxisX = renderer.image(actions: { context in
                    layer.render(in: context.cgContext)
                })
            }
            //axis y
            do{
                let layer = CALayer()
                layer.frame=CGRect(x: 0, y: 0, width: axisWidth, height: height)
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
                self.weekly.imgAxisY = renderer.image(actions: { context in
                    layer.render(in: context.cgContext)
                })
            }
            
        }
    }
}
