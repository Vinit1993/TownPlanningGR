//
//  DocumentCategory.swift
//  TP Planning
//
//  Created by Vinit Ingale on 1/1/21.
//

import Foundation
import CoreData

public class DocumentCategory: NSManagedObject {
    
    @NSManaged public var categoryValue: String?
    @NSManaged public var subCategoryValue: String?
    @NSManaged public var leafCategoryValue: String?
    @NSManaged public var documentName: String?
    @NSManaged public var documentYear: String?
    @NSManaged public var fullPath: String?
    
    public func fillObject(string: String) {
        
        let array = string.components(separatedBy: "/")
        
        var subCategoryName: String?
        var leafCategoryName: String?

        if array.count >= 3 {
            subCategoryName = array[1]
        }
        
        if array.count >= 4 {
            leafCategoryName = array[2]
        }
                                
        let nameWithYearArray = array.last?.components(separatedBy: "_")
        
        var yearName: String = "N/A"
        
        if nameWithYearArray?.count ?? 1 > 1 {
            yearName = nameWithYearArray?.last?.components(separatedBy: ".").first ?? "N/A"
        }
        
        categoryValue = array.first ?? "Acts"
        subCategoryValue = subCategoryName
        leafCategoryValue = leafCategoryName
        documentName = nameWithYearArray?.first ?? "Document"
        documentYear = yearName
        fullPath = string
    }
}


