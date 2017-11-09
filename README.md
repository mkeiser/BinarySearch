# BinarySearch

This is a Swift module for binary search in sorted collections. It supports searching for existing elements as well as for the insertion index. There are additional options to specify if you are searching for the first, last, or any of the matching indexes.

## Requirements

 * Swift 3 or Swift 4
 * iOS 8.0+ or macOS 10.11+

## Note

All of the following methods assume that the Collection is sorted. The result of calling these methods on an unsorted Collection is undefined.

## Basic Usage

If the elements of the `Collection` conform to the the `Comparable` protocol, usage is very simple:

```Swift

let sortedArray = [3,5,7,7,9]

// Search for the index of an existing element:

if let index = sortedArray.binary(search: 5) {

	print("The index is \(index)") // 1

} else {

	print("Not found.")
}

// Search for the insertion index:

let insertionIndex = sortedArray.binaryInsertion(search: 6)
print("insertionIndex: \(insertionIndex)") // 2

```
If you need to, you can specify which index should be returned when the array contains a range of matching indexes:

```Swift

let sortedArray = [3,5,7,7,9]
let index = sortedArray.binary(search: 7, position: .last) // 3
let insertionIndex = sortedArray.binaryInsertion(search: 7, position: .last) // 4

```

For collections whose elements do not conform to `Comparable`, you have to specify a comparison block:

```Swift

struct Person {

	let name: String
	
	init(_ name: String) {

		self.name = name
	}
}

let persons: [Person] = [Person("Lucy Diamonds"), Person("Joe Schmoe")]

let index = persons.binary(search: Person("Lucy Diamonds"), comparator: { (person1, person2) -> ComparisonResult in

	if person1.name < person2.name {
		return .orderedAscending
	}
	if person1.name > person2.name {
		return .orderedDescending
	}
	return .orderedSame
})
```
