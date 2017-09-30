//
//  ParametricFunctionVIew.swift
//  RiegoAutomatico
//
//  Created by Sofia Vidal Urriza on 30/09/2017.
//  Copyright © 2017 Sofia Vidal Urriza. All rights reserved.
//

import UIKit

protocol ParametricFunctionViewDataSource{
    func start() -> Double
    func end() -> Double
    func pintAt(index : Double) -> Double
}

struct FunctionPint {
    var x : Double = 0.0
    var y : Double = 0.0
}

class ParametricFunctionVIew: UIView {
    
    // Objeto que comunica esta clase con ViewController
    var dataSource : ParametricFunctionViewDataSource!
    

    
}
