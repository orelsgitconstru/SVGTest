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
    
    init(fileName: String) {
        super.init(frame : UIScreen.main.bounds)
        if let node = try? SVGParser.parse(resource: fileName, ofType: "svg", inDirectory: nil, fromBundle: Bundle.main) {
            self.node = node
            self.node.place = .scale(0.2, 0.2)
            if let url = Bundle.main.url(forResource: fileName, withExtension: "svg") {
                if let xmlString = try? String(contentsOf: url) {
                    let xml = XMLHash.parse(xmlString)
                    enumerate(indexer: xml, level: 0)
                    let noDuplicates = guids
                    for case let element in noDuplicates {
                        self.setNodeAttributes(id: element)
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
                    let guid = idAttribute.text
                    if !guids.contains(guid) {
                        guids.append(guid)
                    }
                }
            }
            enumerate(indexer: child, level: level + 1)
        }
    }
    
    private func setNodeAttributes(id : String) {
        let node = self.node.nodeBy(tag: id)
        if SVGViewModel.shared.coloredNodes.contains(id) {
            (node as! Shape).fill = Color.hotPink
        }
        node?.onTouchPressed({ (touch) in
            (node as! Shape).fill = Color.darkRed
        })
    }
    
    func colorNode(guid: String){
        let nodeShape = self.node.nodeBy(tag: guid) as! Shape
        nodeShape.fill = Color.darkRed
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
