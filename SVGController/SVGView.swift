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
        SVGMacawView(fileName: fileName)
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
    }
}
