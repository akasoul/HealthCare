//
//  ChartEcgModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 23.04.2021.
//

import Foundation
import CoreGraphics
import UIKit

class ChartEcgModel: ObservableObject{
    
    @Published var img: UIImage?
    var height: CGFloat?
    var width: CGFloat?
    var data: [Double]?
    var marks: [Double]?
    var lineColor: UIColor?
    let marksSize: CGFloat=5
    
    init() {
        
    }
    
    func setSize(height: CGFloat,width:CGFloat? = nil){
        self.height=height
        self.width=width
        self.update()
    }
    
    func setup(data: [Double],marks:[Double],lineColor: UIColor){
        self.data=data
        self.marks=marks
        self.lineColor=lineColor
        self.update()
    }
    
    func update(){
        DispatchQueue.global().async{
            guard let data=self.data,
                  let marks=self.marks,
                  let lineColor=self.lineColor,
                  let height=self.height
            else{ return }
            guard var min = data.min(),
                  var max = data.max()
            else{ return }
            
        
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
            marksLayer.fillColor=UIColor.red.cgColor
            
            shadowLayer.addSublayer(lineLayer)
            shadowLayer.addSublayer(marksLayer)
            if(self.width == nil){
            }
            let rendererMarks = UIGraphicsImageRenderer(bounds: marksLayer.bounds)
            let imgMarks = rendererMarks.image(actions: { context in
                marksLayer.render(in: context.cgContext)
            })
            try? imgMarks.pngData()?.write(to: URL(fileURLWithPath: "/Users/antonvoloshuk/Documents/file.png"))
            
            let renderer = UIGraphicsImageRenderer(bounds: shadowLayer.bounds)
            DispatchQueue.main.async{
                self.img = renderer.image(actions: { context in
                    shadowLayer.render(in: context.cgContext)
                })
            }
        }
    }
}
