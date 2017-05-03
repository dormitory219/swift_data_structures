//
//  FibonacciHeapTests.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 28/4/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import XCTest
@testable import DataStructures

class FibonacciHeapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /* func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
	
	func testCreation() {
		let heap = FibonacciHeap<Int>()
		XCTAssertEqual(heap.count, 0, "The count should be 0")
		
		let heap2 = FibonacciHeap<Int>(comparator: { $0 > $1 })
		XCTAssertEqual(heap2.count, 0, "The count should be 0")
		
		let heap3 = FibonacciHeap<String>(comparator: { $0.characters.count < $1.characters.count })
		XCTAssertEqual(heap3.count, 0, "The count should be 0")
	}
	
	func testBasicInsertion() {
		let heap = FibonacciHeap<Int>()
		insertAndAssert((0...200).reversed(), on: heap)
		
		let heap2 = FibonacciHeap<Int>(comparator: { $0 > $1 })
		insertAndAssert(stride(from: -500, to: 500, by: 5), on: heap2)
		
		let heap3 = FibonacciHeap<Double>()
		insertAndAssert((0...100).map({ pow(2, -0.2 * Double($0)) }), on: heap3)
	}
	
	private func insertAndAssert<T: Hashable, S: Sequence>(_ values: S, on heap: FibonacciHeap<T>) where S.Iterator.Element == T {
		var min: T?
		
		for (index, elem) in values.enumerated() {
			heap.insert(elem)
			XCTAssertEqual(heap.count, index + 1, "The count is not correct")
			
			if min == nil || heap.less(elem, min!) {
				min = elem
			}
			
			if let minimum = heap.minimum {
				XCTAssertEqual(minimum, min, "The minimum is not correct")
			} else {
				XCTFail("There should be a minimum")
			}
		}
	}
	
	func testInsertAndRemove() {
		let heap = FibonacciHeap<Int>()
		insertAndRemoveAsserting((0...200).reversed(), on: heap)
		
		let heap2 = FibonacciHeap<Int>(comparator: { $0 > $1 })
		insertAndRemoveAsserting(stride(from: -500, to: 500, by: 5), on: heap2)
		
		let heap3 = FibonacciHeap<Double>()
		insertAndRemoveAsserting((0...100).map({ pow(2, -0.2 * Double($0)) }), on: heap3)
	}
	
	private func insertAndRemoveAsserting<T: Hashable, S: Sequence>(_ values: S, on heap: FibonacciHeap<T>) where S.Iterator.Element == T {
		for elem in values {
			heap.insert(elem)
		}
		
		var lastExtracted: T?
		if !heap.isEmpty {
			lastExtracted = heap.extractMinimum()
		}
		for _ in 0..<heap.count {
			if let extracted = heap.extractMinimum() {
				XCTAssertTrue(heap.less(lastExtracted!, extracted), "We can't have extracted something smaller")
				lastExtracted = extracted
			}
		}
	}
	
	func testBigRandomData() {
		if let path = Bundle(for: FibonacciHeapTests.self).path(forResource: "random3000", ofType: "txt") {
			do {
				let contents = try String(contentsOfFile: path)
				let numbers = contents.components(separatedBy: CharacterSet.newlines).dropLast().map({ Int($0)! })
				
				// 6.080 sec (4% Std) for 6001 numbers
				// sum_i=1^6001 log(i) = 9426
				let heap = FibonacciHeap<Int>()
				self.insertAndRemoveAsserting(numbers, on: heap)
				// ---
				
				let heap2 = FibonacciHeap<Int>(comparator: { $0 > $1 })
				self.insertAndRemoveAsserting(numbers, on: heap2)
			} catch {
				XCTFail("File parsing failed")
			}
		}
	}
	
	func testUnion() {
		if let path = Bundle(for: FibonacciHeapTests.self).path(forResource: "random3000", ofType: "txt") {
			do {
				let contents = try String(contentsOfFile: path)
				let numbers = contents.components(separatedBy: CharacterSet.newlines).dropLast().map({ Int($0)! })
				
				// 6.080 sec (4% Std) for 6001 numbers
				// sum_i=1^6001 log(i) = 9426
				let heap1 = FibonacciHeap<Int>()
				let heap2 = FibonacciHeap<Int>()
				
				for i in 0..<numbers.count {
					if i % 2 == 0 {
						heap1.insert(i)
					} else {
						heap2.insert(i)
					}
				}
				
				let union = heap1.union(heap2)
				XCTAssertEqual(union.count, numbers.count, "The unicon count is wrong")
				
				var lastExtracted: Int?
				if !union.isEmpty {
					lastExtracted = union.extractMinimum()
				}
				for _ in 0..<union.count {
					if let extracted = union.extractMinimum() {
						XCTAssertTrue(union.less(lastExtracted!, extracted), "We can't have extracted something smaller")
						lastExtracted = extracted
					}
				}
			} catch {
				XCTFail("File parsing failed")
			}
		}
	}
}
