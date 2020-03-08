//
//  File.swift
//  SliderCustom
//
//  Created by Eduardo dos santos on 05/03/20.
//  Copyright © 2020 Eduardo dos santos. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSlider: UISlider {
    
    public var indicator : UILabel!
    public var indice : Int!
    private let trackHeight: CGFloat = 10
    private let thumbWidth: Float = 20
    private let thumbRadius: CGFloat = 35
    private lazy var startingOffset: Float = 0 - (thumbWidth / 2)
    private lazy var endingOffset: Float = thumbWidth
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let xTranslation =  startingOffset + (minimumValue + endingOffset) / maximumValue * value
        return super.thumbRect(forBounds: bounds, trackRect: rect.applying(CGAffineTransform(translationX: CGFloat(xTranslation), y: 0)), value: Float(Int(value)))
    }
    
    public func themeRating(){
        let view = self
        //Default Values
        super.minimumTrackTintColor = UIColor(named: "CustomSliderColorMinimum")
        super.maximumTrackTintColor = UIColor(named: "CustomSliderColorMaximum")
        super.value = 10
        super.minimumValue = 1
        super.maximumValue = 10
        
        //Creating marks
        for i in 1...8 {
            
            let trackRect = self.trackRect(forBounds: self.bounds)
            let marks = UIView(frame: CGRect(x: (CGFloat(self.frame.size.width / 10) * CGFloat(i)).rounded(), y: self.frame.size.height / 2, width: 1, height: trackRect.height))
            marks.backgroundColor = UIColor.white
            marks.layer.zPosition = 1
            marks.tag = i
            self.insertSubview(marks, aboveSubview: self)
            
        }
                
        //Indicator
        indicator = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        indicator.font = UIFont.boldSystemFont(ofSize: 19.0)
        indicator.textAlignment = .center
        indicator.textColor = UIColor(named: "CustomSliderColorMinimum")
        
        //let thumb : UIImage = self.thumbImage(radius: thumbRadius)
        
        let ratio : CGFloat = CGFloat (1.4)
        let thumbImage : UIImage = #imageLiteral(resourceName: "slider_thumb")
        let size = CGSize( width: thumbImage.size.width * ratio, height: thumbImage.size.height * ratio)
        setThumbImage(resizeImage(image: thumbImage,targetSize: size), for: .normal)
        
        //Indice
        indice = Int(super.value) - 1
        
        view.addSubview(indicator)
    }
    
    public func updateLabelLocation() {
        let view = self
        let tempIndice = Int(self.value) - 1
        if tempIndice != indice {
            
            indice = tempIndice
            //Hides mark when thumb is up (@fixme)
            for i in 1...8 {
                if let foundView = view.viewWithTag(i) {
                    if(i == indice) {
                        foundView.isHidden = true
                    } else {
                        foundView.isHidden = false
                    }
                }
            }
            
            //Feedback
            if(indice <= 3){
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
            } else if (indice >= 7) {
                let impact = UIImpactFeedbackGenerator(style: .heavy)
                impact.impactOccurred()
            } else {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
            }
            
            let trackRect = self.trackRect(forBounds: self.bounds)
            let thumbRect = self.thumbRect(forBounds: self.bounds, trackRect: trackRect, value: Float(Int(self.value)))
            let y = self.frame.origin.y - 13
            let x = (thumbRect.origin.x + self.frame.origin.x + (thumbRect.width / 2))
            self.indicator.center = CGPoint(x: x, y: y)
            self.indicator.text = String(indice+1)
        }
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 15))
    }

//BETA Shadow
    
//    private lazy var thumbView: UIView = {
//
//        var thumbImageView : UIImageView = UIImageView(frame: UIScreen.main.bounds)
//        let ratio : CGFloat = CGFloat (1.4)
//        let thumbImage : UIImage = #imageLiteral(resourceName: "slider_thumb")
//        let size = CGSize( width: thumbImage.size.width * ratio, height: thumbImage.size.height * ratio)
//        thumbImageView.image = resizeImage(image: thumbImage,targetSize: size)
//        thumbImageView.clipsToBounds = true
//        thumbImageView.contentMode =  UIView.ContentMode.scaleAspectFit
//
//        let thumb = UIView()
//        thumb.addSubview(thumbImageView)
//        thumb.layer.borderWidth = 0.4
//        thumb.layer.zPosition = 5
//
//        return thumb
//    }()
    
//    private func thumbImage(radius: CGFloat) -> UIImage {
//        // Set proper frame
//        // y: radius / 2 will correctly offset the thumb
//
//        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
//        thumbView.layer.cornerRadius = radius / 2
//
//        let width: CGFloat = 200
//        let height: CGFloat = 200
//        let shadowWidth: CGFloat = 1.4
//        let shadowHeight: CGFloat = 5
//        let shadowOffsetX: CGFloat = -1500
//        let shadowRadius: CGFloat = 25
//
//        let shadowPath = UIBezierPath()
//        shadowPath.move(to: CGPoint(x: shadowRadius / 2, y: height - shadowRadius / 2))
//        shadowPath.addLine(to: CGPoint(x: width, y: height - shadowRadius / 2))
//        shadowPath.addLine(to: CGPoint(x: width * shadowWidth + shadowOffsetX, y: height + (height * shadowHeight)))
//        shadowPath.addLine(to: CGPoint(x: width * -(shadowWidth - 1) + shadowOffsetX, y: height + (height * shadowHeight)))
//
//        thumbView.layer.shadowOpacity = 1
//        thumbView.layer.shadowPath = shadowPath.cgPath
//
//        // Convert thumbView to UIImage
//        // See this: https://stackoverflow.com/a/41288197/7235585
//
//        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
//        return renderer.image { rendererContext in
//            thumbView.layer.render(in: rendererContext.cgContext)
//        }
//  }
    
}
