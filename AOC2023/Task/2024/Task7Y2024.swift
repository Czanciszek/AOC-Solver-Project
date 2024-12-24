import Darwin
import Foundation

final class Task7Y2024: TaskProvider {
    private let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        data.reduce(0, {
            $0 + checkEquation(line: $1, radix: 2)
        })
    }

    func solveB() -> Int {
        data.reduce(0, {
            $0 + checkEquation(line: $1, radix: 3)
        })
    }

    private func checkEquation(line: String, radix: Double) -> Int {
        let equation = line.split(separator: ":")
        let values = equation[1].split(separator: " ").reversed()

        let operations = makeOperationList(for: values.count, radix: radix)

        for operation in operations {

            var result = Int(equation[0])!

            var pass = true

            for (index, value) in values.enumerated() {

                if operation[index] == "0" {
                    result -= Int(value)!
                } else if operation[index] == "1" {
                    if result % Int(value)! != 0 {
                        pass = false
                        break
                    }

                    result /= Int(value)!
                } else if operation[index] == "2" {
                    let strResult = String(result)
                    if !strResult.hasSuffix(value) {
                        pass = false
                        break
                    }

                    let partResult = strResult.prefix(strResult.count - String(value).count)
                    result = Int(partResult)!
                }

                if !pass { break }
            }

            if !pass { continue }

            if result == Int(values.last!) {
                return Int(equation[0])!
            }
        }

        return 0
    }

    private func makeOperationList(for value: Int, radix: Double) -> [String] {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = value - 1

        return (0 ..< Int(pow(radix, Double(value))))
            .map { String($0, radix: Int(radix)) }
            .filter { $0.count < value }
            .map { formatter.string(from: NSNumber(value: Int($0)!))! }
    }
}

extension String {

    subscript (i: Int) -> String {
        self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (
            lower: max(0, min(count, r.lowerBound)),
            upper: min(count, max(0, r.upperBound))
        ))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
