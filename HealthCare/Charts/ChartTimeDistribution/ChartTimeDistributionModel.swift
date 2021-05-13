//
//  ChartRhythmogram2Model.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 03.05.2021.
//

import Foundation
import CoreGraphics
import UIKit

class ChartTimeDistributionModel: ObservableObject{
    struct Wrapped{
        var img: UIImage?
        var imgAxisX: UIImage?
        var imgAxisY: UIImage?
    }
    @Published var daily = Wrapped()
    @Published var weekly = Wrapped()
    
    @Published var imgDaily: UIImage?
    @Published var imgWeekly: UIImage?
    @Published var imgAxisXDaily: UIImage?
    @Published var imgAxisYDaily: UIImage?
    
    var axisColor=UIColor.blue
    var axisWidth: CGFloat?
    var axisHeight: CGFloat?
    let axisFontSize:CGFloat=12

    var height: CGFloat?
    var width: CGFloat?
    var topColor: UIColor?
    var bottomColor: UIColor?
    var data: [Storage.Record]?
    let gridColor = UIColor.gray.cgColor
    init() {
        
    }
    
    func setSize(height: CGFloat,width:CGFloat){
        self.height=height
        self.width=width
        self.update()
    }
    
    func setup(data: [Storage.Record],topColor: UIColor,bottomColor: UIColor){
        self.data=data
        self.topColor=topColor
        self.bottomColor=bottomColor
        self.update()
    }
    
    func update(){
        guard let data=self.data,
              let height=self.height,
              let width=self.width
        else{ return }

        let calendar=Calendar.current
        //daily img
        do{
           let gridLayer=CAShapeLayer()
            gridLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            gridLayer.backgroundColor = UIColor.clear.cgColor
            gridLayer.fillColor = UIColor.clear.cgColor
            gridLayer.strokeColor = self.gridColor
            
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
            
            
            for i in 0..<data.count{
                let recordLayer=CAShapeLayer()
                recordLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
                recordLayer.backgroundColor = UIColor.clear.cgColor
                recordLayer.fillColor = UIColor.blue.cgColor
                //recordLayer.strokeColor = self.gridColor

                let hour = calendar.component(.hour, from: data[i].date)
                let minute = calendar.component(.minute, from: data[i].date)
                let subPath=UIBezierPath()
                subPath.addArc(withCenter: .init(x: CGFloat(hour)*step, y: height*0.5), radius: 10, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
                recordLayer.path=subPath.cgPath
                gridLayer.addSublayer(recordLayer)
            }
            let renderer = UIGraphicsImageRenderer(bounds: gridLayer.bounds)
            self.daily.img = renderer.image(actions: { context in
                        gridLayer.render(in: context.cgContext)
                    })
            
        }
        
        //weekly img
        do{
            let gridLayer=CAShapeLayer()
             gridLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
             gridLayer.backgroundColor = UIColor.clear.cgColor
             gridLayer.fillColor = UIColor.clear.cgColor
             gridLayer.strokeColor = self.gridColor
             
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
             
             let renderer = UIGraphicsImageRenderer(bounds: gridLayer.bounds)
            self.weekly.img = renderer.image(actions: { context in
                         gridLayer.render(in: context.cgContext)
                     })
        }

        
//
//
//        let renderer = UIGraphicsImageRenderer(bounds: grLayer.bounds)
//        self.imgDaily = renderer.image(actions: { context in
//            grLayer.render(in: context.cgContext)
//        })
    }
}
