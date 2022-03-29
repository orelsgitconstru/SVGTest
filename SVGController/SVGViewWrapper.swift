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
import Combine

class MyLayout: ContentLayout {

    override func layout(rect: Rect, into sizeToFitIn: Size) -> Transform {
        print(sizeToFitIn)
        print(rect.w)
        print(rect.h)
        return Transform.scale(sx: (sizeToFitIn.w / rect.w), sy: sizeToFitIn.h / rect.h)
            .move(dx: -30, dy: 0)
    }
}

struct SVGViewWrapper: UIViewRepresentable {
    var fileName: String
    var wrapper: SVGViewModel
    
    func makeUIView(context: Context) -> SVGView {
        let view = SVGView(fileName: fileName, wrapper: wrapper)
        view.contentMode = .scaleAspectFit
//        view.contentLayout = MyLayout()
        return view
    }

    func updateUIView(_ uiView: SVGView, context: Context) {}
}


internal class SVGView: MacawView {
    private struct Constants {
        static let svgExtension = "svg"
        static let attributeName = "guid"
    }
    
    private var guids = [String]()
    private var anyCancellables: [AnyCancellable] = []
    
    var viewModel: SVGViewModel
    
    
    init(fileName: String, wrapper: SVGViewModel) {
        self.viewModel = wrapper
        super.init(frame : UIScreen.main.bounds)
        if let node = try? SVGParser.parse(resource: fileName, ofType: Constants.svgExtension, inDirectory: nil, fromBundle: Bundle.main) {
            self.node = node
            if let url = Bundle.main.url(forResource: fileName, withExtension: Constants.svgExtension) {
                if let xmlString = try? String(contentsOf: url) {
                    let xml = XMLHash.parse(xmlString)
                    enumerate(indexer: xml, level: 0)
                    for case let element in guids {
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
                    if !guids.contains(guid) { // guid is the id of each shape in the svg
                        guids.append(guid)
                    }
                }
            }
            enumerate(indexer: child, level: level + 1)
        }
    }
    
    private func setNodeAttributes(id : String) {
        viewModel.coloredNodes.sink { coloredNodes in
            for guid in coloredNodes {
                let node = self.node.nodeBy(tag: guid)
                (node as? Macaw.Shape)?.fill = Color.blue
            }
        }.store(in: &anyCancellables)
        let node = self.node.nodeBy(tag: id)
//        if !wrapper.svgNodes.keys.contains(id) {
//            wrapper.svgNodes[id] = node
//        }
//        if viewModel.coloredNodes1.contains(id) {
//            (node as! Macaw.Shape).fill = Color.hotPink
//        }
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

internal class SVGViewModel: ObservableObject {
    
//    var coloredNodes1: [String] = [String](["2$EuNBdQLC5BiPtCApWDUN", "2RKZjX6N5Bd871L82NgxWj"]) // Publisher
    var coloredNodes: AnyPublisher<[String], Never> = CurrentValueSubject(["2$EuNBdQLC5BiPtCApWDUN", "2RKZjX6N5Bd871L82NgxWj"]).eraseToAnyPublisher()
    // var pressedNode Publisher
//    var svgNodes = [String: Node]()
//
//    func update(){
//        for (guid, node) in svgNodes {
//            if(coloredNodes.contains(guid)){
//                if((node as! Shape).fill != Color.red){
//                    (node as! Shape).fill = Color.red
//                } else{
//                    (node as! Shape).fill = Color.rgba(r: 231, g: 81, b: 99, a: 0.1)
//                }
//            }
//        }
//    }
}
