//
//  TrajectoryModel.swift
//  RiegoAutomatico
//
//  Created by Sofia Vidal Urriza on 30/09/2017.
//  Copyright © 2017 Sofia Vidal Urriza. All rights reserved.
//

import Foundation
class TrajectoryModel {
    
    // VARIABLES
    // Posicion inicial del disparo
    var originPos = (x: 0.0, y: 0.0){
        // Empleamos didSet para que cuando se cambie el valor de la varibale se ejecute el update, es decir se actualice el valor
        didSet {
            update()
        }
    }
    // Posicion destino del disparo
    var targetPos = (x: 0.0, y: 0.0){
        didSet {
            update()
        }
    }
    // Velocidad inicial de salida del agua
    var v: Double = 0.0 {
        didSet {
            update()
        }
    }
    // Ángulo inicial de salida del agua/ angulo de disparo
    private var angle: Double = 0.0
    // Componente horizontal de la velocidad inicial
    private var vX = 0.0
    // Componente vertical de la velocidad inicial
    private var vY = 0.0
    // Gravedad en la Tierra
    private let g = 9.807
    
    // funcion que actualiza los datos de la trayectoria si cambia la posicion del origen, la pos del destino o la vel inicial
    private func update(){
        // Distancia a la que se encuentra el objetivo
        let xf = targetPos.x - originPos.x
        // Altura a la que se encuentra el obejtivo
        let yf = targetPos.y - originPos.y
        // var aux xf*v^2
        let aux = xf * pow(v, 2)
        let c1 = 2*aux/g
        let c2 = 4*pow(aux, 2) / pow(g, 2)
        let c3 = 4 * xf*xf * (xf*xf + 2 * yf * v*v / g)
        let c4 = 2 * xf*xf
        angle = atan((c1 + sqrt(c2 - c3)) / c4)
        
        if !angle.isNormal {
            vX = 0
            vY = 0
        } else {
            vX = v * cos(angle)
            vY = v * sin(angle)
        }
    }
    // PRUEBAAAAAA
     func getAngle() -> Double{
        // Distancia a la que se encuentra el objetivo
        let xf = targetPos.x - originPos.x
        // Altura a la que se encuentra el obejtivo
        let yf = targetPos.y - originPos.y
        // var aux xf*v^2
        let aux = xf * pow(v, 2)
        let c1 = 2*aux/g
        let c2 = 4*pow(aux, 2) / pow(g, 2)
        let c3 = 4 * xf*xf * (xf*xf + 2 * yf * v*v / g)
        let c4 = 2 * xf*xf
        angle = atan((c1 + sqrt(c2 - c3)) / c4) // MIO
        print("%0.2 grados", angle)
        return angle
    }
    
    // Tiempo que tarda el agua en alcanzar su oibjetivo
    func timeToTarget() -> Double  { // ?
        // Distancia a la que se encuentra el objetivo
        let xf = targetPos.x - originPos.x
        let tf = xf / vX
        //Si t es un numero normal, es decir no es infinito porque la velocidad de x haya llegado a cero, devolvemos t. Sino devolvemos un opcional(nil)
        return tf.isNormal ? tf : 0
    }
    
    // Trayectoria que sigue una gota: posicion en un momento dado
    func positionAt(time: Double) -> (x: Double, y: Double){
        
        let AnAngle = getAngle()
        let v1 = v * cos(AnAngle)
        print("%0.2 traza v1", v1)
        let v2 = v * sin(AnAngle)
        print("%0.2 traza v2", v2)
        print("%0.2 velocidad", v)
        let x = originPos.x + v1 * time //  let x = vX * time
        let y = originPos.y + v2 * time - 0.5 * g * time*time
        
        // no pongo vq, v2 porq el v1 varia muy poco entre los estremos del slider por lo que me da x iguales todo el rato CREO
       /*
        let x = originPos.x + v * time //  let x = vX * time
        let y = originPos.y + v * time - 0.5 * g * time*time
  */
        return (x, y)

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
