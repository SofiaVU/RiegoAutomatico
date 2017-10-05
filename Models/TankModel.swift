//
//  TankModel.swift
//  RiegoAutomatico
//
//  Created by Sofia Vidal Urriza on 30/09/2017.
//  Copyright © 2017 Sofia Vidal Urriza. All rights reserved.
//

import Foundation
// Modelo de datos para representar el deposito de agua
class TankModel {
    
    // VARIABLES/PARAMETROS
    // gravedad en la tierra
    let g = 9.807 // [m/s^2]
    // param de entrada: radio del deposito que contiene h2o para regar
    //let radiousTank = 0.3 // en metros (30 cm)
    let radiousTank = 0.2
    // param de entrada: radio de la tuberia por donde sale el h2o
    let radiousPipe = 0.0025 // 2.5 cm
    // param de entrada: altura inicial del h20 en el deposito
    let initialWaterHeight = 0.5 // 50 cm
    // Valor auxiliar: Área o seccion del deposito
    private let areaTank : Double
    // Valor auxiliar: Área o seccion de la tuberia
    private let areaPipe: Double
    // Valor auxiliar: (areaTank^2/areaPipe^2)-1
    private let aux1_TP: Double
    // Valor auxiliar: (areaPipe^2/areaTank^2)-1
    private let aux2_PT: Double
    // Tiempo de vaciado
    let timeToEmpty: Double
    
    //INICIALIZADOR
    init() {
        //areaTank = Double.pi * pow(radiousTank,2)
        //areaPipe = Double.pi * pow(radiousPipe,2)
        areaTank = Double.pi * radiousTank// ?? Elisa
        areaPipe = Double.pi * radiousPipe  // ?? Elisa
        aux1_TP = (pow(areaTank,2) / pow(areaPipe,2) ) - 1
        aux2_PT = (pow(areaPipe,2) / pow(areaTank,2) ) - 1 // ELISA
        //aux2_PT = 1 - (pow(areaPipe,2) / pow(areaTank,2) ) // PDF
        
        // velocidad de vaciado . descenso del nivel de agua
        //timeToEmpty = sqrt((2 * g * initialWaterHeight)/aux1_TP) //PDF
        timeToEmpty = sqrt((2*initialWaterHeight*aux1_TP)/g) // ELSIA
    }
    
    // velocidad de salida del agua en funcion de la h
    func waterOutputSpeed(waterHeight h: Double) -> Double {
    let v = sqrt((-2 * g * h) / aux2_PT) // ¿¿?? XQ negativo // Elisa
    //let v = sqrt((2 * g * h) / aux2_PT) // PDF
    return max(0, v)
    }
    
    //Velocidad de bajada del nivel del agua en el deposito en funcion de la altura
    // velocidad de descenso del nivel de agua
    func waterHeightSpeed(waterHeight h: Double) -> Double{
        let v = sqrt(2*g*h/aux1_TP) // ELISA
       // let v = sqrt(2*g*h/aux1_TP)//PDF
        return max (0, v)
    }
    
    // Nivel de agua en el deposito en funcion del tiempo
    func waterHeightAt ( time t: Double) -> Double {
        if t > timeToEmpty { return 0.0}
        let c0 = initialWaterHeight
        let c1 = -sqrt((2 * g * initialWaterHeight) / aux1_TP) * t
        if c1.isNaN { return 0.0}
        let c2 = ((1/2) * g / aux1_TP) * (t*t)
        return (c0 + c1 + c2)
    }
    
    // Tiempo de vaciado del deposito en funcion de la altura inicial del deposito
    func timeToEmptyTank (waterHeight h: Double) -> Double {
        return sqrt((2 * h * aux1_TP) / g)
        
    }   
}
