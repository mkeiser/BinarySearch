//
//  BinarySearchTests.swift
//  BinarySearchTests
//
//  Created by Matthias Keiser on 01.10.16.
//  Copyright © 2016 Tristan Inc. All rights reserved.
//

import XCTest
import BinarySearch

class BinarySearchTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testInsertionAny() {

		self.enumerateTest { array, targetRange, _, _ in

			let insertionRange = targetRange.startIndex...targetRange.endIndex
			XCTAssertTrue(insertionRange ~= array.binaryInsertion(search: needle), "\(array)")
		}
	}

	func testInsertionFirst() {

		self.enumerateTest { array, targetRange, _, _ in

			XCTAssertEqual(array.binaryInsertion(search: needle, options: .first), targetRange.startIndex, "\(array)")
		}
	}

	func testInsertionLast() {

		self.enumerateTest { array, targetRange, _, _ in

			XCTAssertEqual(array.binaryInsertion(search: needle, options: .last), targetRange.endIndex, "\(array)")
		}
	}

	func testSearchAny() {

		self.enumerateTest { array, targetRange, _, _ in

			let result = array.binary(search: needle)

			if targetRange.count == 0 {
				XCTAssertNil(result, "\(array)")
			} else {
				XCTAssertNotNil(result, "\(array)")
				XCTAssertTrue(targetRange ~= result!, "\(array)")
			}
		}
	}

	func testSearchFirst() {

		self.enumerateTest { array, _, first, _ in

			XCTAssertEqual(array.binary(search: needle, options: .first), first, "\(array)")
		}
	}

	func testSearchLast() {

		self.enumerateTest { array, _, _, last in

			XCTAssertEqual(array.binary(search: needle, options: .last), last, "\(array)")
		}
	}

	func enumerateTest( _ test: (Array<Int>, CountableRange<Int>, Int?, Int?) -> Void) {

		for length in 0..<8 {

			for targetLength in 0...length {

				for startIndex in 0...(length - targetLength) {

					let targetRange = startIndex..<(startIndex + targetLength)
					let first: Int? = targetRange.count > 0 ? startIndex : nil
					let last: Int? = (targetRange.count > 0) ? (targetRange.upperBound - 1) : nil

					let array = self.makeArray(with: length, needleRange: targetRange)

					print("\(array)")

					test(array, targetRange, first, last)
				}
			}
		}
	}

	let needle = 5

	func makeArray(with length: Int, needleRange: CountableRange<Int>) -> [Int] {

		precondition(needleRange.upperBound <= length)

		let prefix = Array((needle - needleRange.lowerBound)..<needle)
		let needleArray = Array(repeating: needle, count: needleRange.count)
		let suffix = Array((needle + 1)..<(needle + (length - needleRange.upperBound) + 1))

		let result = prefix + needleArray + suffix

		return result
	}

	// Testing the test infrastructure 🙄
	func testTest()  {

		XCTAssertEqual( self.makeArray(with: 1, needleRange: 0..<1), [5])
		XCTAssertEqual( self.makeArray(with: 2, needleRange: 0..<1), [5,6])
		XCTAssertEqual( self.makeArray(with: 2, needleRange: 1..<2), [4,5])
		XCTAssertEqual( self.makeArray(with: 2, needleRange: 0..<2), [5,5])

		XCTAssertEqual( self.makeArray(with: 3, needleRange: 0..<1), [5,6,7])
		XCTAssertEqual( self.makeArray(with: 3, needleRange: 1..<2), [4,5,6])
		XCTAssertEqual( self.makeArray(with: 3, needleRange: 2..<3), [3,4,5])

		XCTAssertEqual( self.makeArray(with: 3, needleRange: 0..<2), [5,5,6])
		XCTAssertEqual( self.makeArray(with: 3, needleRange: 1..<3), [4,5,5])

		XCTAssertEqual( self.makeArray(with: 3, needleRange: 0..<3), [5,5,5])

		XCTAssertEqual( self.makeArray(with: 8, needleRange: 7..<8), [-2,-1,0,1,2,3,4,5])

		XCTAssertEqual( self.makeArray(with: 8, needleRange: 8..<8), [-3,-2,-1,0,1,2,3,4])

	}
}
