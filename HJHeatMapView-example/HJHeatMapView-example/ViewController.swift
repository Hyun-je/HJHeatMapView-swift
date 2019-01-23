//
//  ViewController.swift
//  HJHeatMapView-example
//
//  Created by JaehyeonPark on 20/01/2019.
//  Copyright © 2019 Jae-Hyeon-Park. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    //@IBOutlet weak var heatMapView: HJHeatMapView!
    @IBOutlet weak var imageView: HJHeatMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 배경 이미지 불러오기
        let backgroundURL = Bundle.main.url(forResource: "background", withExtension: "jpg")
        let backgroundImage = CIImage(contentsOf: backgroundURL!)!
        imageView.backgroundImage = backgroundImage
        
        
        // Color Map 이미지 불러오기
        let mapURL = Bundle.main.url(forResource: "map", withExtension: "jpg")
        let mapImage = CIImage(contentsOf: mapURL!)!
        imageView.colorMapImage = mapImage
        
        
        // 포인트 클라우드 생성
        var points = [CGPoint]()
        points.reserveCapacity(300)
        
        for i in 0..<300 {
            
            let xCoord = CGFloat.random(in: 0 ..< 1)
            let yCoord = CGFloat.random(in: 0 ..< 1)
            
            points.append(CGPoint(x: xCoord, y: yCoord))
            
        }
        
        
        // HeatMap 그리기
        imageView.drawPoints(points)
        

    }
    
    

    
}

