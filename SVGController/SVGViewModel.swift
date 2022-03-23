//
//  SVGViewState.swift
//  SVGController
//
//  Created by Orel Zilberman on 21/02/2022.
//

import Foundation
import Macaw

class SVGViewModel: ObservableObject{
    
    static let shared = SVGViewModel()
    @Published var coloredNodes: [String] = [String](["2$EuNBdQLC5BiPtCApWDUN", "2RKZjX6N5Bd871L82NgxWj"])
    @Published var svgView =  SVGView(fileName: "SvgTest", coloredNodesGUIDs: [])
    
    @Published var svgNodes = [String: Node]()
    
    func update(){
        svgView.svgMacawView.contentMode = .scaleAspectFit
        svgView.svgMacawView.setNeedsLayout()
        var x = 1
        for (guid, node) in svgNodes {
            if(coloredNodes.contains(guid)){
                if((node as! Shape).fill != Color.red){
                    (node as! Shape).fill = Color.red
                } else{
                    (node as! Shape).fill = Color.rgba(r: 231, g: 81, b: 99, a: 0.1*Double(x^2))
                    x+=1
                }
            }
        }
    }
    
    
    private init(){}
}

extension Node {
    var height: Double? {
        bounds?.size().h
    }
    var width: Double?{
        bounds?.size().w
    }
}

extension SVGParser {
    static func getSVGSize(fileName: String) -> Size? {
        if let svg = try? SVGParser.parse(resource: fileName, ofType: "svg", inDirectory: nil, fromBundle: Bundle.main){
            return svg.bounds?.size()
        } else {
             return nil
        }
    }
}
