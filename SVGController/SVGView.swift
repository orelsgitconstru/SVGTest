//
//  SVGView.swift
//  SVGController
//
//  Created by Orel Zilberman on 20/02/2022.
//

import SwiftUI
import UIKit
import Macaw
import SWXMLHash

struct SVGView: UIViewRepresentable {
    
    var fileName: String
    var wrapper: SVGViewWrapper
    
    func makeUIView(context: Context) -> SVGMacawView {
        SVGMacawView(fileName: fileName, wrapper: wrapper)
    }

    func updateUIView(_ uiView: SVGMacawView, context: Context) {
        for coloredNodeGUID in wrapper.coloredNodes {
            uiView.colorNode(guid: coloredNodeGUID)
        }
    }
}


internal class SVGMacawView: MacawView {
    private struct Constants {
        static let svgExtension = "svg"
        static let attributeName = "guid"
    }
    
    var wrapper: SVGViewWrapper
    
    private var guids = [String]()
    
    init(fileName: String, wrapper: SVGViewWrapper) {
        self.wrapper = wrapper
        super.init(frame : UIScreen.main.bounds)
        if let node = try? SVGParser.parse(resource: fileName, ofType: Constants.svgExtension, inDirectory: nil, fromBundle: Bundle.main) {
            self.node = node
            if let url = Bundle.main.url(forResource: fileName, withExtension: Constants.svgExtension) {
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
                if let idAttribute = element.attribute(by: Constants.attributeName) {
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
        if !wrapper.svgNodes.keys.contains(id){
            wrapper.svgNodes[id] = node
        }
        if wrapper.coloredNodes.contains(id) {
            (node as! Macaw.Shape).fill = Color.hotPink
        }
        node?.onTouchPressed({ (touch) in
            (node as! Macaw.Shape).fill = Color.darkRed
        })
    }
    
    func colorNode(guid: String){
        let nodeShape = self.node.nodeBy(tag: guid) as! Macaw.Shape
        nodeShape.fill = Color.darkRed
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
