//
//  SVGClass.swift
//  SVGController
//
//  Created by Orel Zilberman on 20/02/2022.
//

import Foundation

class SVGClass{
    var fun: ((_ guid: String) -> Void)? = nil
//    var svgView = SVGView(fileName: "SvgTest")

    static let shared = SVGClass()
    private init(){}
}
