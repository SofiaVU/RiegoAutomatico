//
//  ViewController.swift
//  RiegoAutomatico
//
//  Created by Sofia Vidal Urriza on 30/09/2017.
//  Copyright © 2017 Sofia Vidal Urriza. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ParametricFunctionViewDataSource {
    
    // VARIABLES
    let tankModel = TankModel()
    let trajectoryModel = TrajectoryModel() // tantos como num de tiestos
    
    @IBOutlet weak var outSpeedTimefucView: ParametricFunctionVIew!
    
    @IBOutlet weak var outSpeedHeightFuncView: ParametricFunctionVIew!
    
    @IBOutlet weak var waterHeightTimeFuncView: ParametricFunctionVIew!
    
    @IBOutlet weak var trajectoryFuncView: ParametricFunctionVIew!
    
    // para variar el tiempo
    @IBOutlet weak var tSlider: UISlider!
    @IBOutlet weak var timeValue: UILabel!
    
    // slider para variar la altura
    @IBOutlet weak var hSlider: UISlider!
    @IBOutlet weak var waterHeightValue: UILabel!
    
    // Instante en el que quiero dibijar la trayectoria del agua desde el deposito hasta la planta a regar
    var trajectoryTime: Double = 0.0{
        didSet {
        // como lo que vario con el slider es el t necesito que cada vez que cambie el tiempo todas las gráficas se repitan, se actualicen
            outSpeedTimefucView.setNeedsDisplay()
            outSpeedHeightFuncView.setNeedsDisplay()
            waterHeightTimeFuncView.setNeedsDisplay()
            trajectoryFuncView.setNeedsDisplay()
        }
    }
    
    var waterheight : Double = 0.0 {
        didSet {
            outSpeedTimefucView.setNeedsDisplay()
            outSpeedHeightFuncView.setNeedsDisplay()
            waterHeightTimeFuncView.setNeedsDisplay()
            trajectoryFuncView.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Conexion entre clases
        outSpeedTimefucView.dataSource = self
        outSpeedHeightFuncView.dataSource = self
        waterHeightTimeFuncView.dataSource = self
        trajectoryFuncView.dataSource = self
        
        // DATOS INICIALES
        trajectoryModel.originPos = (0, 2)
        //trajectoryModel.targetPos = (1.0, 0)
        trajectoryModel.targetPos = (0.5, 0)
        //trajectoryModel.v = 15.0
        
        tSlider.sendActions(for: .valueChanged)
        
        // Escalado
        // x con 1 se ve muy juntas las sinusoides
        // y *100 para que se vean los picos bien
        
        outSpeedTimefucView.scaleX = 3
        outSpeedTimefucView.scaleY = 10
        outSpeedTimefucView.textX = "Tiempo"
        outSpeedTimefucView.textY = "Velocidad salida"
        
        outSpeedHeightFuncView.scaleX = 150
        outSpeedHeightFuncView.scaleY = 15
        outSpeedHeightFuncView.textX = "Nivel agua"
        outSpeedHeightFuncView.textY = "Velocidad de salida"
        
        waterHeightTimeFuncView.scaleX = 2
        waterHeightTimeFuncView.scaleY = 50
        waterHeightTimeFuncView.textX = "Tiempo"
        waterHeightTimeFuncView.textY = "Nivel agua"
        
        trajectoryFuncView.scaleX = 50 //50
        trajectoryFuncView.scaleY = 20
        trajectoryFuncView.textX = "x"
        trajectoryFuncView.textY = "y"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Control del Slider de Tiempo
    @IBAction func tsliderUpsate(_ sender: UISlider) {
        //tenemos que asignarselo a la variable que hemos creado antes
        trajectoryTime = Double(sender.value)
        timeValue.text = String(format: "%.2f seg", arguments: [sender.value])
        
    }
    // Control del Slider del Nivel de Agua / Altura agua
    // cambiar la altura incial del agua initialWater height
    @IBAction func hSliderUpdate(_ sender: UISlider) {
        waterheight = Double(sender.value)
        waterHeightValue.text = String(format: "%.2f seg", arguments: [sender.value])
    }
    
    
    // FUNCIONES PROTOCOLO
    func startFor(_ pfgv: ParametricFunctionVIew) -> Double {
        return 0.0
    }
    
    func endFor(_ pfgv: ParametricFunctionVIew) -> Double {
        switch pfgv {
        case outSpeedTimefucView:
            return tankModel.timeToEmpty
            
        case outSpeedHeightFuncView:
            return tankModel.initialWaterHeight // no entiendo porq initial y no waterOutputSpeed
            
        case waterHeightTimeFuncView:
            return tankModel.timeToEmpty
            
        case trajectoryFuncView:
            let h = tankModel.waterHeightAt(time: Double(tSlider.value)) // aqui paso eslaider para que pinte hasta el , no trajectoryTime
            let v = tankModel.waterOutputSpeed(waterHeight: h)
            trajectoryModel.v = v
            return trajectoryModel.timeToTarget()//! // AQUI ?  ¿?
            
// AQUI
          /*  if Double(tSlider.value) > trajectoryModel.timeToTarget()! {
                return Double(tSlider.value)
            } else {
                return trajectoryModel.timeToTarget()!
            }*/
        default:
            return 0.0
        }
    }
    
    func nextPointAt(_ pfgv: ParametricFunctionVIew, poinAt index: Double) -> FunctionPoint {
         // en esta funcion solo le dices que pinte una x y una y, pero aun no sabes que van a ser
        // es en el ViewController con un swich case cuando le dices x e y en funcion de la grafica
        switch pfgv {
        case outSpeedTimefucView:
            let time = index
            let h = tankModel.waterHeightAt(time: time)
            let v = tankModel.waterOutputSpeed(waterHeight: h)
            return FunctionPoint(x: time, y: v)
            
        case outSpeedHeightFuncView:
            let h = index
            let v = tankModel.waterOutputSpeed(waterHeight: h)
            return FunctionPoint(x: h, y: v)
            
        case waterHeightTimeFuncView:
            let time = index
            let h = tankModel.waterHeightAt(time: time)
            return FunctionPoint(x: time, y: h)
            
        case trajectoryFuncView:
            let h = tankModel.waterHeightAt(time: trajectoryTime) // altura del agua a la t dada
            let v = tankModel.waterOutputSpeed(waterHeight: h) // velocidad con la que sale el agua para esa altura
            trajectoryModel.v = v
            let pos = trajectoryModel.positionAt(time: index)
            return FunctionPoint(x: pos.x, y: pos.y)
        default:
            return FunctionPoint(x: 0.0, y: 0.0)
        }
    }
    //Funcion que muestras los puntos de interes dados unos parametros
    func pointsOfInterestFor(_ pfgv: ParametricFunctionVIew) -> [FunctionPoint] {
        switch pfgv {
        case outSpeedTimefucView:
            if(trajectoryTime >= tankModel.timeToEmpty){
                return [FunctionPoint(x: tankModel.timeToEmpty, y: 0)]
            }else{
                let h = tankModel.waterHeightAt(time: trajectoryTime)
                let v = tankModel.waterOutputSpeed(waterHeight: h)
                //vtLabel.text = String(floor(10000*v)/10000) + " m/seg"
                return [FunctionPoint(x: trajectoryTime, y: v)]
            }
        case outSpeedHeightFuncView:
            if (trajectoryTime >= tankModel.timeToEmpty){
                return [FunctionPoint(x: tankModel.timeToEmpty, y: 0)]
            }else {
                let h = tankModel.waterHeightAt(time: trajectoryTime)
                let v = tankModel.waterOutputSpeed(waterHeight: h)
                return [FunctionPoint(x: h, y: v)]
            }
        case waterHeightTimeFuncView:
            if (trajectoryTime >= tankModel.timeToEmpty){
                return [FunctionPoint(x: tankModel.timeToEmpty, y: 0)]
            }else {
                let h = tankModel.waterHeightAt(time: trajectoryTime)
                //  htLabel.text = String(floor(10000*h)/10000) + " m"
                return [FunctionPoint(x: trajectoryTime, y: h)]
            }
        case trajectoryFuncView:
            return [FunctionPoint(x: trajectoryModel.originPos.x, y: trajectoryModel.originPos.y)]
        default:
            return [FunctionPoint(x: 0.0, y: 0.0)]
        }
    }

}












