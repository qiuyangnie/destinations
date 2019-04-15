//
//  CitiesXMLParser.swift
//  QiuyangNieAssign2
//
//  Created by Qiuyang Nie on 11/04/2019.
//  Copyright © 2019 Qiuyang Nie. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CitiesXMLParser: NSObject, XMLParserDelegate {
    
    private var xmlFileName: String

    private var parser = XMLParser()
    private let xmlTagsName = ["name", "state", "image", "url"]
    private var parseData = false
    private var elementID = -1
    
    
    // parsed data from xml file
    private var parsedName: String!
    private var parsedState: String!
    private var parsedImagePath: String!
    private var parsedUrl: String!
    
    // CoreData objects: context, entities, managedObject, frc(fetch result controller)
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var entity: NSEntityDescription! = nil
    private var citiesManagedObject: Cities! = nil
    
    
    init(xmlFileName: String) {
        self.xmlFileName = xmlFileName
    }
    
    
    // XMLParserDelegate methods
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if parseData {
            switch elementID {
                case 0: parsedName = string
                case 1: parsedState = string
                case 2: parsedImagePath = string
                case 3: parsedUrl = string
                default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if (xmlTagsName.contains(elementName)) {
            parseData = true
            switch elementName {
                case "name": elementID = 0
                case "state": elementID = 1
                case "image": elementID = 2
                case "url": elementID = 3
                default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (xmlTagsName.contains(elementName)) {
            parseData = false
            elementID = -1
        }
        
        if (elementName == "city") {
            citiesManagedObject = Cities(context: context)
            citiesManagedObject.name = parsedName
            citiesManagedObject.state = parsedState
            citiesManagedObject.image = parsedImagePath
            citiesManagedObject.url = parsedUrl
        }
    }

    func parsing() {
        let bundleUrl = Bundle.main.bundleURL
        let fileUrl = URL(fileURLWithPath: self.xmlFileName, relativeTo: bundleUrl)
        parser = XMLParser(contentsOf: fileUrl)!
        parser.delegate = self
        parser.parse()
    }

}


