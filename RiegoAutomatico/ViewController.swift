//
//  ViewController.swift
//  RiegoAutomatico
//
//  Created by Sofia Vidal Urriza on 30/09/2017.
//  Copyright © 2017 Sofia Vidal Urriza. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ParametricFunctionViewDataSource {
    func startFor(_ pfgv: ParametricFunctionVIew) -> Double {
        return 0.0
    }
    
    func endFor(_ pfgv: ParametricFunctionVIew) -> Double {
        return 200.0
    }
    
    func nextPointAt(_ pfgv: ParametricFunctionVIew, poinAt index: Double) -> FunctionPoint {
        // en esta funcion solo le dices que pinte una x y una y, pero aun no sabes que van a ser
        // es en el ViewController con un swich case cuando le dices x e y en funcion de la grafica
        switch pfgv {
        case graph1:
            return FunctionPoint(x: index, y: sin(index))
        case graph2:
            return FunctionPoint(x: index, y: cos(index))
        case graph3:
            return FunctionPoint(x: index, y: tan(index))
        default:
            return FunctionPoint(x: 0.0, y: 0.0)
        }
    }
    
    
    
    @IBOutlet weak var graph1: ParametricFunctionVIew!
    
    @IBOutlet weak var graph2: ParametricFunctionVIew!
    
    @IBOutlet weak var graph3: ParametricFunctionVIew!
    // para variar el tiempo
    @IBOutlet weak var tSlider: UISlider!
    // falta otro slider con otro param
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Conexion entre clases
        graph1.dataSource = self
        graph2.dataSource = self
        graph3.dataSource = self
        
        // Escalado
        // x con 1 se ve muy juntas las sinusoides
        // y *100 para que se vean los picos bien
        
        graph1.scaleX = 10.0
        graph1.scaleY = Double(tSlider.value*100)
        
        graph2.scaleX = 10.0
        graph2.scaleY = Double(tSlider.value*100)
        
        graph3.scaleX = 10.0
        graph3.scaleY = Double(tSlider.value*50)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Control del Slider
    @IBAction func sliderScale(_ sender: UISlider) {
        graph1.scaleY = Double(tSlider.value*100)
        graph1.setNeedsDisplay()
        
        graph2.scaleY = Double(tSlider.value*100)
        graph2.setNeedsDisplay()
        
        graph3.scaleY = Double(tSlider.value*100)
        graph3.setNeedsDisplay()
    }
    


}

