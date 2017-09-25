//
//  BinarySearch.swift
//  BinarySearch
//
//  Created by Matthias Keiser on 30.01.17.
//  Copyright © 2017 Tristan Inc. All rights reserved.
// 

import Foundation

public enum BinarySearch {

	/// Options that influence which index is returned if multiple matching elements are found.
	///
	/// - any: Return the any matching index. This is usually the fastest option.
	/// - first: Return the first matching index in the range that is equal to the given element.
	/// - last: Return the last matching index in the range that is equal to the given element.

	public enum Position {

		/// Return the any matching index. This is usually the fastest option.
		case any
		/// Return the first matching index in the range that is equal to the given element.
		case first
		/// Return the last matching index in the range that is equal to the given element.
		case last
	}
}

public extension Collection where Index: SignedInteger {

	typealias NeedleElementComparator<Needle, Element> = (Needle, Element) -> ComparisonResult

	/// Use the binary search algorithm to search for an element in a sorted array.
	///
	/// - Parameters:
	///   - needle: The object to search for. It can be of a different type than Iterator.Element.
	///   - insertion: Set to true if you want to search for the insertion index of `element` instead of searching for an existing element. The default is `false`.
	///   - options: A Position to search for. Specifying `any` might offer a slight performance increase. The default is `any`.
	///   - comparator: A block that compares the needle to the elements and returns a ComparisonResult.
	/// - Returns:
	///	   Returns the matching index, or nil if no index matches.

	func binary<Needle>(search needle: Needle, insertion: Bool = false, options: BinarySearch.Position = .any, comparator: NeedleElementComparator<Needle, Iterator.Element>) -> Index? {

		var low = self.startIndex
		var high = self.endIndex // past end
		var mid: Self.Index = 0

		let useUpperHalf = {low = mid + 1}
		let useLowerHalf = {high = mid}
		var behaviorOnMatch: () -> Void

		var lastMatch: Self.Index? = nil

		switch options {
		case .first:	behaviorOnMatch = useLowerHalf
		case .last:		behaviorOnMatch = useUpperHalf
		case .any:		behaviorOnMatch = {} // doesn't matter, never executed
		}

		while low < high {

			mid = low.advanced(by: low.distance(to: high) / 2)

			switch comparator(needle, self[mid]) {
			case .orderedDescending:
				useUpperHalf()
			case .orderedSame where options == .any:
				return mid
			case .orderedSame:
				lastMatch = mid
				behaviorOnMatch()
			case .orderedAscending:
				useLowerHalf()
			}
		}

		return insertion ? low : lastMatch
	}

	/// This is a convenienve wrapper around `	func binary(search needle: Iterator.Element, insertion: Bool = false, options: BinarySearch.Position = .any, comparator: ElementComparator<Iterator.Element>) -> Index?` with `insertion` set to `true`.
	/// - Parameters:
	///   - needle: The element to search for.
	///   - options: A Position to search for. Specifying `any` might offer a slight performance increase. The default is `any`.
	///   - comparator: A block that compares two elements and returns a ComparisonResult.
	/// - Returns:
	///	   Returns the matching index, or nil if no index matches.

	func binaryInsertion<Needle>(search needle: Needle, options: BinarySearch.Position = .any, comparator: NeedleElementComparator<Needle, Iterator.Element>) -> Index {

		return self.binary(search: needle, insertion: true, options: options, comparator: comparator)!
	}
}

public extension Collection where Iterator.Element: Comparable, Index: SignedInteger {

	/// Use the binary search algorithm to search for element in a sorted array whose elements are Comparable.
	///
	/// - Parameters:
	///   - needle: The element to search for.
	///   - insertion: Set to true if you want to search for the insertion index of `element` instead of searching for an existing element. The default is `false`.
	///   - options: A Position to search for. Specifying `any` might offer a slight performance increase. The default is `any`.
	/// - Returns:
	///   - If an index could be found it is returned, else nil is returned.

	func binary(search needle: Iterator.Element, options: BinarySearch.Position = .any) -> Index? {

		return self.binary(search: needle, options: options, comparator: {(needle, other) in

			if needle < other {return .orderedAscending}
			if needle > other {return .orderedDescending}
			return .orderedSame
		})
	}

	/// This is a convenienve wrapper around `	func binary(search needle: Iterator.Element, insertion: Bool = false, options: BinarySearch.Position = .any, comparator: ElementComparator<Iterator.Element>) -> Index?` with `insertion` set to `true`.
	/// - Parameters:
	///   - needle: The element to search for.
	///   - options: A Position to search for. Specifying `any` might offer a slight performance increase. The default is `any`.
	/// - Returns:
	///   - If an index could be found it is returned, else nil is returned.

	func binaryInsertion(search needle: Iterator.Element, options: BinarySearch.Position = .any) -> Index {

		return self.binaryInsertion(search: needle, options: options, comparator: {(needle, other) in

			if needle < other {return .orderedAscending}
			if needle > other {return .orderedDescending}
			return .orderedSame
		})
	}
}
