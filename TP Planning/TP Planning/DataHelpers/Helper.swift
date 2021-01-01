//
//  Helper.swift
//  TP Planning
//
//  Created by Vinit Ingale on 12/26/20.
//

import Foundation
import UIKit

struct LeafCategory {
    var name: String
    var value: String
}

struct SubCategory {
    var name: String
    var value: String
    var leafCategory: [LeafCategory]?
}

struct Category {
    var name: String
    var value: String
    var color: UIColor
    var subCategory: [SubCategory]?
}

class HomeMainDataHelper {
    
    static var shared : HomeMainDataHelper = HomeMainDataHelper()
    
    private let data = [
        [
            "category" : "Acts",
            "value" : "acts",
            "color" : "#2A9D8F",
            "subCategory" : [],
        ],
        [
            "category": "Rules",
            "value": "rules",
            "color": "#E9C46A",
            "subCategory": [
                [
                    "name": "DCPR",
                    "value": "dcpr",
                    "leafCategory": [
                        [
                            "name": "DCR",
                            "value": "dcr",
                        ],
                        [
                            "name": "Clarifications/ Modifications",
                            "value": "clarifmodif",
                        ],
                    ],
                ],
                [
                    "name": "Town Planning",
                    "value": "townplanning",
                    "leafCategory": [
                        [
                            "name": "Building Permission",
                            "value": "bldpermission",
                        ],
                        [
                            "name": "DP/ RP/ TPS",
                            "value": "dprptps",
                        ],
                    ],
                ],
                [
                    "name": "Valuation",
                    "value": "valuation",
                ],
                [
                    "name": "Land Revenue",
                    "value": "landrevenue",
                ],
                [
                    "name": "Civil Service",
                    "value": "civilservice",
                ],
                [
                    "name": "Others",
                    "value": "others",
                ],
            ],
        ],
        [
            "category": "GRs/ Circulars",
            "value": "grscirc",
            "color": "#F4A261",
            
            "subCategory": [
                [
                    "name": "Town Planning",
                    "value": "townplanning",
                    "leafCategory": [
                        [
                            "name": "Building Permission",
                            "value": "bldpermission",
                        ],
                        [
                            "name": "NA-LAYOUT",
                            "value": "nalayout",
                        ],
                        [
                            "name": "Development Plan",
                            "value": "devplan",
                        ],
                        [
                            "name": "Development Charges",
                            "value": "devcharges",
                        ],
                        [
                            "name": "Unauthorised Structures",
                            "value": "unauthstruct",
                        ],
                    ],
                ],
                [
                    "name": "Valuation",
                    "value": "valuation",
                ],
                [
                    "name": "Land Acquisition",
                    "value": "landacqui",
                ],
                [
                    "name": "ULC",
                    "value": "ulc",
                ],
                [
                    "name": "General Administration",
                    "value": "generaladm",
                ],
                [
                    "name": "RTI/ RTS",
                    "value": "rtirts",
                ],
                [
                    "name": "Miscellaneous",
                    "value": "misc",
                    "leafCategory": [
                        [
                            "name": "PMAY",
                            "value": "pmay",
                        ],
                        [
                            "name": "RAY",
                            "value": "ray",
                        ],
                        [
                            "name": "EoDB",
                            "value": "eodb",
                        ],
                        [
                            "name": "Others",
                            "value": "others",
                        ],
                    ],
                ],
            ],
        ],
        [
            "category": "Directives",
            "value": "directives",
            "color": "#E76F51",
            
            "subCategory": [
                [
                    "name": "Regional Plan",
                    "value": "regionplan",
                ],
                [
                    "name": "Development Plan",
                    "value": "devplan",
                ],
                [
                    "name": "TDR",
                    "value": "tdr",
                ],
                [
                    "name": "Premium",
                    "value": "premium",
                ],
                [
                    "name": "Policies",
                    "value": "policies",
                ],
                [
                    "name": "Others",
                    "value": "others",
                ],
            ],
        ],
        [
            "category": "Court Orders",
            "value": "courtorders",
            "color": "#06d6a0",
            
            "subCategory": [],
        ],
        [
            "category": "Notice Formats",
            "value": "noticeformats",
            "color": "#118ab2",
            
            "subCategory": [
                [
                    "name": "Scrutiny Formats",
                    "value": "scrutformats",
                ],
                [
                    "name": "Notices",
                    "value": "notices",
                ],
            ],
        ],
        [
            "category": "Articles",
            "value": "articles",
            "color": "#ffd166",
            
            "subCategory": [
                [
                    "name": "Town Planning",
                    "value": "townplanning",
                ],
                [
                    "name": "Valuation",
                    "value": "valuation",
                ],
                [
                    "name": "Land Revenue",
                    "value": "landrevenue",
                ],
                [
                    "name": "Others",
                    "value": "others",
                ],
            ],
        ],
        [
            "category": "TP Career",
            "value": "tpcareer",
            "color": "#ef476f",
            
            "subCategory": [
                [
                    "name": "Books",
                    "value": "books",
                ],
                [
                    "name": "Recruitment",
                    "value": "recruitment",
                    "leafCategory": [
                        [
                            "name": "Notifications",
                            "value": "notifications",
                        ],
                        [
                            "name": "Result",
                            "value": "result",
                        ],
                        [
                            "name": "Rules/ GR",
                            "value": "rulesgr",
                        ],
                    ],
                ],
            ],
        ],
    ]
    
    var categories: [Category] = []
    
    func fillCategoriesData() {
        for category in data {
            
            var subCategories: [SubCategory] = []
            
            for subCategory in category["subCategory"] as? [[String: Any]] ?? [] {
                
                var leafCategories: [LeafCategory] = []
                
                for leafCategory in subCategory["leafCategory"] as? [[String: String]] ?? [] {
                    leafCategories.append(LeafCategory(name: leafCategory["name"]!, value: leafCategory["value"]!))
                }
                
                subCategories.append(SubCategory(name: subCategory["name"] as! String, value: subCategory["value"] as! String, leafCategory: leafCategories))
            }
            
            categories.append(Category(name: category["category"] as! String, value: category["value"] as! String, color: UIColor.init(hexString: category["color"] as! String), subCategory: subCategories))
        }
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
