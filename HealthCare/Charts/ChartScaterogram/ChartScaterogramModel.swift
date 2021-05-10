//
//  ChartScaterogramModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 04.05.2021.
//

import Foundation
import UIKit

class ChartScaterogramModel: ObservableObject{
    @Published var img: UIImage?
    var height: CGFloat?
    var width: CGFloat?
    var fillColor: UIColor?
    var data: [Double]?
    
    init() {
        
    }
    
    func setSize(height: CGFloat,width:CGFloat){
        self.height=height
        self.width=width
        self.update()
    }
    
    func setup(data: [Double],fillColor: UIColor){
        self.data=data
        self.fillColor=fillColor
        self.update()
    }
    
    func update(){
        
        guard let data=self.data,
              var dataMax=data.max(),
              var dataMin=data.min(),
              let height=self.height,
              let width=self.width,
              let fillColor=self.fillColor
        else{ return }
        
        let dist=0.2*(dataMax-dataMin)
        dataMin -= dist
        dataMax += dist
        let mainLayer = CALayer()
        mainLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
        mainLayer.backgroundColor = UIColor.clear.cgColor
        
        let radius:CGFloat=2
        
        for i in 0..<data.count-1{
            let xPos = CGFloat(Double(width)*(data[i]-dataMin)/(dataMax-dataMin))
            let yPos = (height - CGFloat(Double(height)*(data[i+1]-dataMin)/(dataMax-dataMin)))
            
            let path=UIBezierPath()
            path.addArc(withCenter: .init(x: xPos, y: yPos), radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            let pathShadow=UIBezierPath()
            pathShadow.addArc(withCenter: .init(x: xPos, y: yPos), radius: radius+2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            
            let layer = CAShapeLayer()
            layer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            layer.backgroundColor = UIColor.clear.cgColor
            layer.path = path.cgPath
            layer.fillColor = fillColor.cgColor
            mainLayer.addSublayer(layer)
            
            let shadowLayer = CAShapeLayer()
            shadowLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            shadowLayer.backgroundColor = UIColor.clear.cgColor
            shadowLayer.path = pathShadow.cgPath
            shadowLayer.fillColor = fillColor.withAlphaComponent(0.1).cgColor
            mainLayer.addSublayer(shadowLayer)
            
            mainLayer.addSublayer(shadowLayer)
        }
        
        let renderer = UIGraphicsImageRenderer(bounds: mainLayer.bounds)
        self.img = renderer.image(actions: { context in
            mainLayer.render(in: context.cgContext)
        })
    }
}


