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
    var coloredNodes: [String] = [String](["2$EuNBdQLC5BiPtCApWDUN", "2RKZjX6N5Bd871L82NgxWj"])
    var svgView: SVGView {
        SVGView(fileName: "SvgTest", coloredNodesGUIDs: coloredNodes)
    }
    var svgNodes = [String: Node]()
    
    init() {
        update()
    }
    
    func update(){
        for (guid, node) in svgNodes {
            if(coloredNodes.contains(guid)){
                if((node as! Shape).fill != Color.red){
                    (node as! Shape).fill = Color.red
                } else{
                    (node as! Shape).fill = Color.rgba(r: 231, g: 81, b: 99, a: 0.1)
                }
            }
        }
    }
}
