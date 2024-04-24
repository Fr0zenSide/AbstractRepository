//
//  PocketListContainer.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 04/04/2024.
//

import Foundation


public struct PocketListContainer<Item: Decodable>: MutableCollection, BidirectionalCollection/*Collection*/, Decodable, Hashable {
    public typealias Item = Decodable
    public typealias Index = Int
    public typealias Element = Item
    
    var page: Int
    let perPage: Int
    let totalPages: Int
    let totalItems: Int
    
    var items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case page, perPage, totalPages, totalItems, items
    }
}

// MARK: - MutableCollection Methods
public extension PocketListContainer {
    var startIndex: Index { items.startIndex }
    var endIndex: Index { items.endIndex }
    
    subscript(position: Index) -> Element {
//        _read {
//            return items[position]
//        }
        get {
            precondition(position >= startIndex && position < endIndex, "Index out of range")
            return items[position]
        }
        set(newValue) {
            precondition(position >= startIndex && position < endIndex, "Index out of range")
            items[position] = newValue
//            var productsInCategory = self[product.category]
//                    productsInCategory.append(product)
//                    self[product.category] = productsInCategory
        }
    }
    
    func index(after i: Index) -> Index {
        precondition(i < endIndex, "Index out of range")
        return items.index(after: i)
    }
}

// MARK: - BidirectionalCollection Methods
public extension PocketListContainer {
    func index(before i: Index) -> Index {
        precondition(i > startIndex, "Index out of range")
        return items.index(before: i)
    }
    
    mutating func prepend(_ element: Element) {
        items.insert(element, at: 0)
    }
    
    mutating func append(_ element: Element) {
        items.append(element)
    }
    
    @discardableResult
    mutating func removeFirst() -> Element? {
        items.removeFirst()
    }
    
    @discardableResult
    mutating func removeLast() -> Element? {
        items.removeLast()
    }
}

public extension PocketListContainer {
    static func ==(lhs: PocketListContainer, rhs: PocketListContainer) -> Bool {
        lhs.page == rhs.page && lhs.totalItems == rhs.totalItems
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(page)
        hasher.combine(totalItems)
    }
}
