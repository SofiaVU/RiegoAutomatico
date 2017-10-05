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
    func pointsOfInterestFor(_ pfgv: ParametricFunctionVIew) -> [FunctionPoint] // Puntos de interes a pintar
    
}
// Un putno de la trayectoria del agua
struct FunctionPoint {
    var x : Double = 0.0
    var y : Double = 0.0
}
//@IBDesignable
class ParametricFunctionVIew: UIView {
    
    //Grosor de la linea que pinta la tranyectoria
    //@IBInspectable
    var lineWidth : Double = 3.0
    
    //color de la linea que pinta la trayectoria
    //@IBInspectable
    var funcColor : UIColor = UIColor.red
    
    // Etiquetado de ejes
    //@IBInspectable
    var textX : String = "x"
    //@IBInspectable
    var textY : String = "y"
    
    // Escalado de ejes
    //@IBInspectable
    var scaleX : Double = 100.0{
        didSet{
            setNeedsDisplay()
        }
    }
    //@IBInspectable
    var scaleY  : Double = 1.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    // Resolucion
    //@IBInspectable
    var resolution : Double =  50 {
        didSet{
            setNeedsDisplay()
        }
    }


    // Objeto que comunica esta clase con ViewController
   var dataSource : ParametricFunctionViewDataSource!
// Directiva para el compilador, dataSource falso para que lo use el compilador
/*#if TARGET_INTERFACE_BUILDER
    // Objeto que comunica esta clase con ViewController
    var dataSource : ParametricFunctionViewDataSource!
#else
    weak var dataSource : ParametricFunctionViewDataSource!
#endif*/
    
    /// Data source falso para que lo use el Interface Builder en tiempo de desarrollo.
    override func prepareForInterfaceBuilder() {
        
        class FakeDataSource : ParametricFunctionViewDataSource{
            
            func startFor(_ pfgv: ParametricFunctionVIew) -> Double {
                return 0.0
            }
            
            func endFor(_ pfgv: ParametricFunctionVIew) -> Double {
                return 200.0
            }
            
            func nextPointAt(_ pfgv: ParametricFunctionVIew, poinAt index: Double) -> FunctionPoint {
                return FunctionPoint(x: index , y: index.truncatingRemainder(dividingBy: 25))
            }
            
            func pointsOfInterestFor(_ pfgv: ParametricFunctionVIew) -> [FunctionPoint] {
                return []
            }
        }
        dataSource = FakeDataSource()
    }
    
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
        
        // necesitamos conversion a Double pues al div en delta_t da error
        let w = Double(bounds.width)
        //let h = Double(bounds.height) //////////
        
        //path.move(to: CGPoint(x: w/2, y: h/2)) ////////
        
        let ti = dataSource.startFor(self) // timepo inicial
        let tf = dataSource.endFor(self) //tiempo final
        let delta_t = max((tf - ti) / w, 0.001)
        
        var position = dataSource.nextPointAt(self, poinAt: ti) //valor inical
        var x = scalingX(position.x)
        var y = scalingY(position.y)
        path.move(to: CGPoint(x: x, y: y))
        
        
        for t in stride(from: ti, to: tf, by: delta_t){
            
            /*let v = dataSource.nextPointAt(self, poinAt: p)
            let x = scalingX(v.x)
            let y = scalingY(v.y)*/
            
            position = dataSource.nextPointAt(self, poinAt: t)
            x = scalingX(position.x)
            y = scalingY(position.y)
            
            //Actualizo la linea
            path.addLine(to: CGPoint(x: x, y: y))
        }
        //Trazo
        path.lineWidth = CGFloat(lineWidth)
        UIColor.red.setStroke()
        path.stroke()
    }
    
    private func scalingX(_ scaleInX: Double) -> Double {
        let weigh = Double(bounds.width)
        return (weigh/2 + scaleInX*scaleX)
    }
    
    private func scalingY(_ scaleInY: Double) -> Double {
        let height = Double(bounds.height)
        return (height/2 - scaleInY*scaleY) /// NEGATIVO POR DIOS !!!!!!!!!!!!!! 
    }
    
}
