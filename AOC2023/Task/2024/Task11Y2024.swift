final class Task11Y2024: TaskProvider {
    private let data: [String]

    private lazy var taskData: [Int: Int] = {
        data.first!
            .split(separator: " ")
            .compactMap { Int($0) }
            .reduce(into: [Int: Int]()) { $0[$1] = ($0[$1] ?? 0) + 1 }
    }()

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        processStones(blinks: 25)
    }

    func solveB() -> Int {
        processStones(blinks: 75)
    }

    private func processStones(blinks: Int) -> Int {
        var numbersDict = taskData

        for _ in 0 ..< blinks {
            numbersDict = numbersDict.reduce(into: [Int: Int]()) {
                if $1.key == 0 {
                    $0[1] = ($0[1] ?? 0) + $1.value
                } else {
                    let strKey = String($1.key)
                    if strKey.count % 2 == 0 {
                        let left = Int(strKey[0..<(strKey.count/2)])!
                        let right = Int(strKey[strKey.count/2..<strKey.count])!

                        $0[left] = ($0[left] ?? 0) + $1.value
                        $0[right] = ($0[right] ?? 0) + $1.value
                    } else {
                        let newKey = $1.key * 2024
                        $0[newKey] = ($0[newKey] ?? 0) + $1.value
                    }
                }
            }
        }

        return numbersDict.values.reduce(0, +)
    }
}
