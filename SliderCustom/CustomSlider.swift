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
    private let thumbWidth: Float = 25
    private let thumbRadius: CGFloat = 10
    private lazy var startingOffset: Float = 0 - (thumbWidth / 2)
    private lazy var endingOffset: Float = thumbWidth
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let xTranslation =  startingOffset + (minimumValue + endingOffset) / maximumValue * value
        return super.thumbRect(forBounds: bounds, trackRect: rect.applying(CGAffineTransform(translationX: CGFloat(xTranslation), y: 0)), value: Float(Int(value)))
    }
    
    public func themeRating(){
        let view = self
        //Default Values
        if #available(iOS 11.0, *) {
            super.minimumTrackTintColor = UIColor(named: "CustomSliderColorMinimum")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            super.maximumTrackTintColor = UIColor(named: "CustomSliderColorMaximum")
        } else {
            // Fallback on earlier versions
        }
        super.value = 10
        super.minimumValue = 1
        super.maximumValue = 10
        
        let trackRect = self.trackRect(forBounds: self.bounds)
        let thumbRect = self.thumbRect(forBounds: self.bounds, trackRect: trackRect, value: Float(Int(self.value)))
        
        print("trackRect -> width \(self.layer.bounds.width)")
        
        //Creating marks
        for i in 1...8 {
            
            let marks = UIView(frame: CGRect(x: (CGFloat(self.layer.bounds.width / 9) * CGFloat(i)).rounded(), y: trackRect.height, width: 1, height: trackRect.height))
            marks.backgroundColor = UIColor.white
            marks.layer.zPosition = 1
            marks.tag = i
            self.insertSubview(marks, aboveSubview: self)
            
        }
                
        //Indicator
        indicator = UILabel(frame: CGRect(x: 0, y: 0, width: thumbRect.width, height: 20))
        indicator.font = UIFont.boldSystemFont(ofSize: 19.0)
        indicator.textAlignment = .center
        if #available(iOS 11.0, *) {
            indicator.textColor = UIColor(named: "CustomSliderColorMinimum")
        } else {
            // Fallback on earlier versions
        }
        
        //let thumb : UIImage = self.thumbImage(radius: thumbRadius)
        
//      let ratio : CGFloat = CGFloat (0.8)
        let thumbImage : UIImage = #imageLiteral(resourceName: "slider_thumb")
//      let size = CGSize( width: thumbImage.size.width * ratio, height: thumbImage.size.height * ratio)
//      setThumbImage(resizeImage(image: thumbImage,targetSize: size), for: .normal)
        setThumbImage(thumbImage, for: .normal)
        //Indice
        indice = Int(super.value) - 1
        
        view.addSubview(indicator)
    }
    
    public func updateLabelLocation() {
        //let view = self.trackRect(forBounds: self.bounds)
        let tempIndice = Int(self.value) - 1
        if tempIndice != indice {
            
            indice = tempIndice
            //Hides mark when thumb is up (@fixme)
            for i in 1...8 {
                if let foundView = self.viewWithTag(i) {
                    if(i == indice) {
                        foundView.isHidden = true
                    } else {
                        foundView.isHidden = false
                    }
                }
            }
            
            //Feedback
            if(indice <= 3){
                if #available(iOS 10.0, *) {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                } else {
                    // Fallback on earlier versions
                }
            } else if (indice >= 7) {
                if #available(iOS 10.0, *) {
                    let impact = UIImpactFeedbackGenerator(style: .heavy)
                    impact.impactOccurred()
                } else {
                    // Fallback on earlier versions
                }
            } else {
                if #available(iOS 10.0, *) {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                } else {
                    // Fallback on earlier versions
                }
            }
            
            let trackRect = self.trackRect(forBounds: self.bounds)
            let thumbRect = self.thumbRect(forBounds: self.bounds, trackRect: trackRect, value: Float(Int(self.value)))
            let y = thumbRect.origin.y - 10
            let x = thumbRect.origin.x + (thumbRect.width / 2).rounded()
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
