//
//  SVGView.swift
//  SVGController
//
//  Created by Orel Zilberman on 20/02/2022.
//

import Foundation
import SwiftUI
import Macaw

struct SVGView: UIViewRepresentable {

    var fileName: String
    var cgRect: CGRect = CGRect.zero
    var coloredNodesGUIDs: [String]
    var svgMacawView: SVGMacawView {
        SVGMacawView(fileName: fileName, frame: cgRect)
    }

    func makeUIView(context: Context) -> SVGMacawView {
        let view = svgMacawView
        view.contentMode = .scaleAspectFit
        return view
    }

    func updateUIView(_ uiView: SVGMacawView, context: Context) {
        for coloredNodeGUID in SVGViewModel.shared.coloredNodes{
            svgMacawView.colorNode(guid: coloredNodeGUID)
        }
//        uiView.attributedText = text
    }
    
    func getFunc() -> (_ guid: String)->Void{
        return svgMacawView.getFunc()
    }
    
    mutating func print1(guid: String){
        coloredNodesGUIDs.append(guid)
//        svgMacawView.setNeedsDisplay()
    }
    
    func applyToNode(guid: String, _ apply: @escaping (_ shape: Macaw.Shape)->Void){
        svgMacawView.applyToNode(guid: guid, apply: apply)
    }
}
