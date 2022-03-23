//
//  SVGView.swift
//  SVGController
//
//  Created by Orel Zilberman on 20/02/2022.
//


import UIKit
import Foundation
import Macaw


class UISVGView: UIView {
    
    let maxScale: CGFloat = 15.0
    let minScale: CGFloat = 1.0
    let maxWidth: CGFloat = 4000.0
    
    var svgView : SVGMacawView!
//    var scrollViewDelegate : SVGScrollViewDelegate?
    
    private var scaleValue : CGFloat = 0
    private var zoomValue : CGFloat = 1.2
    
    public init(fileName: String, frame : CGRect) {
        super.init(frame: frame)
        print("init UISVGView")
        svgView = SVGMacawView(fileName: fileName, frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        addSubview(svgView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
