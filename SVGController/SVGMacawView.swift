//
//  SVGMacawView.swift
//  SVGInteraction
//
//  Created by Ankur Lahiry on 6/12/19.
//  Copyright © 2019 Prefeex. All rights reserved.
//

import UIKit
import Macaw
import SWXMLHash

protocol SVGMacawViewDelegate {
    func getId(id : String?)
}

class SVGMacawView: MacawView {
    
    var delegate : SVGMacawViewDelegate?
    
    private var guids = [String]()
    
    init(fileName: String, frame : CGRect) {
        super.init(frame : UIScreen.main.bounds)
        self.backgroundColor = .white
        if let node = try? SVGParser.parse(resource: fileName, ofType: "svg", inDirectory: nil, fromBundle: Bundle.main) {
            if let group = node as? Group {
//                zoom.enable(move: false, scale: true, rotate: false)
//                zoom.set(offset: Size(), scale: 0.5, angle: 0)
                let rect = Rect.init(x: 0, y: 0, w: 600, h: 600)
                let backgroundShape = Shape(form: rect, fill: Color.clear, tag: ["back"])
                var contents = group.contents
                contents.insert(backgroundShape, at: 0)
                contentMode = .scaleAspectFit
                group.contents = contents
                group.place = .scale(0.05, 0.05)
                self.zoom.enable()
                self.node = group
                self.node.place = .scale(0.2, 0.2)
                if let url = Bundle.main.url(forResource: fileName, withExtension: "svg") {
                    if let xmlString = try? String(contentsOf: url) {
                        let xml = XMLHash.parse(xmlString)
                        enumerate(indexer: xml, level: 0)
                        let noDuplicates = Array(Set(guids))
                        for case let element in noDuplicates {
                            self.registerForSelection(nodeTag: element)
                        }
                    }
                }
            }
            else {
                self.node = node
            }
        }
    }
    
    private func enumerate(indexer: XMLIndexer, level: Int) {
        for child in indexer.children {
            if let element = child.element {
                if let idAttribute = element.attribute(by: "guid") {
                    let text = idAttribute.text
                    guids.append(text)
                }
            }
            enumerate(indexer: child, level: level + 1)
        }
    }
    
    private func registerForSelection(nodeTag : String) {
        //        if(SVGViewModel.shared.coloredNodes.contains(nodeTag)){
        //            colorNode(guid: nodeTag)
        //        }
        let node = self.node.nodeBy(tag: nodeTag)
        
//        node?.place = .scale(0.3, 0.3) // Rescale each node on its own
        if(!SVGViewModel.shared.svgNodes.keys.contains(nodeTag)){
            SVGViewModel.shared.svgNodes[nodeTag] = node
        }
//        for guid in SVGViewModel.shared.coloredNodes {
//            colorNode(guid: guid)
//        }
            node?.onTouchPressed({ (touch) in
//            self.colorNode(guid: nodeTag)
            for guid in SVGViewModel.shared.coloredNodes {
//                self.colorNode(guid: guid)
                (node as! Shape).fill = Color.darkRed
            }
            //            self.delegate?.getId(id: nodeTag)
        })
    }
    
    func getFunc() -> (_ guid: String)->Void{
        return colorNode
    }
    
    func colorNode(guid: String){
        print("color node \(guid)")
        let nodeShape = self.node.nodeBy(tag: guid) as? Shape
        nodeShape?.fill = Color.darkRed
    }
    
    func applyToNode(guid: String, apply: @escaping(_ shape: Shape)->Void){
        //        if let node = self.node.nodeBy(tag: guid){
        //            let shape = node as! Shape
        //            apply(shape)
        //        }
        
        colorNode(guid: guid)
        //            self.delegate?.getId(id: nodeTag)
        
    }
    
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
