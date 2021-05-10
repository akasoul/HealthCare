//
//  ChartHistogramModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 04.05.2021.
//

import Foundation
import UIKit

class ChartHistogramModel: ObservableObject{
    @Published var img: UIImage?
    var height: CGFloat?
    var width: CGFloat?
    var topColor: UIColor?
    var bottomColor: UIColor?
    var data: [Double]?

    init() {
        
    }
    
    func setSize(height: CGFloat,width:CGFloat){
        self.height=height
        self.width=width
        self.update()
    }
    
    func setup(data: [Double],topColor: UIColor,bottomColor: UIColor){
        self.data=data
        self.topColor=topColor
        self.bottomColor=bottomColor
        self.update()
    }
    
    func update(){
        guard let data=self.data,
              let topColor=self.topColor,
              let bottomColor=self.bottomColor,
              let height=self.height,
              let width=self.width
        else{ return }
        
        var dict: [Int:Int] = [:]
        
        for i in 0..<data.count{
            if let _ = dict[Int(data[i])] {
                dict[Int(data[i])]! += 1
            }
            else{
                dict[Int(data[i])]=0
            }
            
        }
        
        
        guard var max = dict.map({ $1 }).max()
        else{ return }
        let min = 0

        let sorted = dict.sorted(by: { $0.0 < $1.0})

        var counters = sorted.map({ $0.1 })
        
        for _ in 0..<3{
            counters.insert(0, at: 0)
            counters.insert(0, at: counters.count)
        }
        let count: CGFloat = CGFloat(counters.count)
        let step = width / count

        let dist = Int(0.25*CGFloat(max-min))
        max += dist
        let dataHeight=CGFloat(max-min)

        let mainLayer = CALayer()
        mainLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
        mainLayer.backgroundColor = UIColor.clear.cgColor

        for i in 0..<counters.count{
            let maskLayer = CAShapeLayer()
            maskLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            maskLayer.backgroundColor = UIColor.clear.cgColor
            let posY = height-CGFloat(counters[i])*height/dataHeight
            let path=UIBezierPath(rect: CGRect(x: CGFloat(i)*step, y: posY, width: step, height: height-posY))
            maskLayer.path = path.cgPath
            maskLayer.fillColor = UIColor.red.cgColor
            
            let gradientLayer=CAGradientLayer()
            gradientLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            gradientLayer.backgroundColor = UIColor.clear.cgColor
            gradientLayer.colors=[topColor.cgColor,bottomColor.cgColor]
            gradientLayer.mask=maskLayer
            
            mainLayer.addSublayer(gradientLayer)
            
            let borderLayer=CAShapeLayer()
            borderLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            borderLayer.backgroundColor = UIColor.clear.cgColor
            borderLayer.path=path.cgPath
            borderLayer.strokeColor = UIColor.white.cgColor
            borderLayer.fillColor=UIColor.clear.cgColor
            borderLayer.lineWidth=0.5
            
            mainLayer.addSublayer(borderLayer)
        }

        let renderer = UIGraphicsImageRenderer(bounds: mainLayer.bounds)
        self.img = renderer.image(actions: { context in
            mainLayer.render(in: context.cgContext)
        })
    }
}
