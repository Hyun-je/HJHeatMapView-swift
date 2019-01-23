//
//  HJHeatMapView.swift
//  HJHeatMapView
//
//  Created by JaehyeonPark on 20/01/2019.
//  Copyright © 2019 Jae-Hyeon-Park. All rights reserved.
//

import UIKit



class HJHeatMapView: UIImageView {

    var colorMapImage: CIImage?
    var heatMapImage: CIImage?
    var backgroundImage: CIImage?
    
    
    
    func drawPoints(_ points: [CGPoint]) {
        
        // Background 이미지 불러오기
        guard let backgroundImage = self.backgroundImage else { return }
        let imageSize = backgroundImage.extent.size


        // HeatMap 이미지 생성
        let heatMapImage = HJHeatMapView.renderHeatMapImage(points: points, size: imageSize, mapImage: colorMapImage)
        self.heatMapImage = heatMapImage
        
        
        // 배경 이미지에 HeatMap 이미지 블렌딩
        let blendFilter = CIFilter(name: "CIScreenBlendMode")!
        blendFilter.setValue(heatMapImage, forKey: kCIInputImageKey)
        blendFilter.setValue(backgroundImage, forKey: kCIInputBackgroundImageKey)
        
        let blendedImage = blendFilter.outputImage!

        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(blendedImage, from: blendedImage.extent)!

        self.image = UIImage(cgImage: cgImage)
        
    }
    

    
    
    static func renderHeatMapImage(points: [CGPoint], size: CGSize, mapImage: CIImage?) -> CIImage {
        
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.scale = 1.0
        
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        
        let uiImage = renderer.image { ctx in
            
            // 배경 Black으로 초기화
            ctx.cgContext.setFillColor(gray: 0.0, alpha: 1.0)
            ctx.cgContext.fill(CGRect(origin: CGPoint.zero, size: size))
            
            
            // Gradient 생성
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [UIColor.init(white: 1.0, alpha: 0.5).cgColor,
                          UIColor.init(white: 1.0, alpha: 0.0).cgColor]
            let colorLocations: [CGFloat] = [0.0, 1.0]
            
            let gradient = CGGradient(colorsSpace: colorSpace,
                                      colors: colors as CFArray,
                                      locations: colorLocations)!
            
            let radius = max(size.width, size.height) / 20.0
            
            
            // 각 포인트에서 Radial Gradient 그리기
            for point in points {
                
                let origin = CGPoint(x: point.x * size.width,
                                     y: point.y * size.height)
                
                ctx.cgContext.drawRadialGradient(gradient,
                                                 startCenter: origin,   startRadius: 0,
                                                 endCenter: origin,     endRadius: radius,
                                                 options: [])
            }// for points
            
            
        }
        
        
        let ciImage = CIImage(image: uiImage)
        
        
        if let mapImage = mapImage {
            // Color Map 이미지가 있는 경우 → Color Map 효과 적용
            let filter = CIFilter(name: "CIColorMap")!
            filter.setValue(ciImage,  forKey: kCIInputImageKey)
            filter.setValue(mapImage, forKey: kCIInputGradientImageKey)
            
            return filter.outputImage!
            
        }
        else {
            // Color Map 이미지가 없는 경우 → Grayscale 이미지 리턴
            return ciImage!
            
        }
        
    }
    
    

}
