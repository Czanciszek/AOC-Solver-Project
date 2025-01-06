final class Task10Y2024: TaskProvider {
    private let data: [String]

    private lazy var taskData: [[Int]] = {
        data.map { $0.split(separator: "").compactMap { Int($0) } }
    }()

    init(data: [String]) {
        self.data = data
    }

    func solveA() -> Int {
        let searchPoints = findAllStartPoints()

        var result = 0
        for searchPoint in searchPoints {
            let score = lookThrough(points: [searchPoint], result: Set<SearchPoint>())
            result += score.count
        }

        return result
    }

    func solveB() -> Int {
        let searchPoints = findAllStartPoints()
        
        let result = lookThrough2(points: searchPoints, result: 0)

        return result
    }
}

private extension Task10Y2024 {
    
    struct SearchPoint: Hashable {
        let x: Int
        let y: Int
    }
    
    func findAllStartPoints() -> [SearchPoint] {
        var startPoints = [SearchPoint]()

        for (lineIndex, line) in taskData.enumerated() {
            for (trailIndex, trail) in line.enumerated()  {
                if trail == 0 {
                    startPoints.append(.init(x: trailIndex, y: lineIndex))
                }
            }
        }

        return startPoints
    }

    func lookAround(in point: SearchPoint) -> [SearchPoint] {
        [
            .init(x: point.x, y: point.y - 1), // up
            .init(x: point.x, y: point.y + 1), // down
            .init(x: point.x - 1, y: point.y), // left
            .init(x: point.x + 1, y: point.y), // right
        ].filter { taskData[safe: $0.y]?[safe: $0.x] == taskData[point.y][point.x] + 1 }
    }

    private func lookThrough(points: [SearchPoint], result: Set<SearchPoint>) -> Set<SearchPoint> {
        var result = result

        for point in points {
            if taskData[point.y][point.x] == 9 {
                result.insert(.init(x: point.x, y: point.y))
            } else {
                let newPoints = lookAround(in: point)
                for resultPoint in lookThrough(points: newPoints, result: result) {
                    result.insert(resultPoint)
                }
            }
        }

        return result
    }
    
    private func lookThrough2(points: [SearchPoint], result: Int, isRoot: Bool = false) -> Int {
        var result = 0

        for point in points {
            if taskData[point.y][point.x] == 9 {
                result += 1
            } else {
                let newPoints = lookAround(in: point)
                result += lookThrough2(points: newPoints, result: result)
            }
        }

        return result
    }
}
