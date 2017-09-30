//
//  ParametricFunctionVIew.swift
//  RiegoAutomatico
//
//  Created by Sofia Vidal Urriza on 30/09/2017.
//  Copyright © 2017 Sofia Vidal Urriza. All rights reserved.
//

import UIKit

protocol ParametricFunctionViewDataSource{
    func startFor(_ pfgv : ParametricFunctionVIew) -> Double
    func endFor(_ pfgv : ParametricFunctionVIew) -> Double
    func nextPointAt(_ pfgv : ParametricFunctionVIew, poinAt index: Double) -> FunctionPoint
    
}

struct FunctionPoint {
    var x : Double = 0.0
    var y : Double = 0.0
}

class ParametricFunctionVIew: UIView {
    
    // Objeto que comunica esta clase con ViewController
    var dataSource : ParametricFunctionViewDataSource!
    var scaleX = 1.0
    var scaleY = 1.0
    
    override func draw(_ rect: CGRect) {
        drawAxis()
        drawTrajectory()
    }
    
    private func drawAxis(){
        let w = bounds.width
        let h = bounds.height
        
        // Pintamos eje x
        let pathX = UIBezierPath()
        pathX.move(to: CGPoint(x: 0, y: h/2))
        pathX.addLine(to: CGPoint(x: w, y: h/2))
        pathX.lineWidth = 2
        UIColor.black.setStroke()
        pathX.stroke()
        
        // Pintamos eje Y
        let pathY = UIBezierPath()
        pathY.move(to: CGPoint(x: w/2, y: 0.0))
        pathY.addLine(to: CGPoint(x: w/2, y: h))
        pathY.lineWidth = 2
        UIColor.black.setStroke()
        pathY.stroke()
        
    }
    
    private func drawTrajectory(){
        //path vacio
        let path = UIBezierPath()
        
        let w = bounds.width
        let h = bounds.height
        
        path.move(to: CGPoint(x: w/2, y: h/2))
        
        let Pi = dataSource.startFor(self)
        let Pf = dataSource.endFor(self)
        
        for p in stride(from: Pi, to: Pf, by: 0.1){
        
            let v = dataSource.nextPointAt(self, poinAt: p)
            let x = scalingX(v.x)
            let y = scalingY(v.y)
            
            //Actualizo la linea
            path.addLine(to: CGPoint(x: x, y: y))
        }
        //Trazo
        path.lineWidth = 1.5
        UIColor.red.setStroke()
        path.stroke()
    }
    
    private func scalingX(_ scaleInX: Double) -> Double {
        let weigh = Double(bounds.width)
        return (weigh/2 + scaleInX*scaleX)
    }
    
    private func scalingY(_ scaleInY: Double) -> Double {
        let height = Double(bounds.height)
        return (height/2 + scaleInY*scaleY)
    }
    
}
