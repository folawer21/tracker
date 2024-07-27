//
//  TypeValueTransformer.swift
//  tracker
//
//  Created by Александр  Сухинин on 04.06.2024.
//
import Foundation

@objc class TypeValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? TrackerType else {return nil}
        return try? JSONEncoder().encode(days)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else {return nil}
        return try? JSONDecoder().decode(TrackerType.self, from: data as Data)
    }

    static func register( ){
        ValueTransformer.setValueTransformer(TypeValueTransformer(), forName: NSValueTransformerName(rawValue: "TypeValueTransformer"))
    }
}
