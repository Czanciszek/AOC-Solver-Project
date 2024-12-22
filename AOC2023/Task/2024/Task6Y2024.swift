final class Task6Y2024: TaskProvider {
    private let data: [String]

    private lazy var taskData: [[String]] = {
        data.map { $0.split(separator: "").map { String($0) } }
    }()

    init(data: [String]) {
        self.data = data
    }

    struct SearchPoint: Hashable {
        let x: Int
        let y: Int
    }

    func solveA() -> Int {

        let searchPoints = findAllSearchPoints()

        return searchPoints.count
    }

    func solveB() -> Int {

        var searchPoints = findAllSearchPoints()
        searchPoints.removeFirst()

        guard let startOriginSearchPoint = findStartSearchPoint() else { return 0 }

        var result = 0
        for searchPoint in searchPoints {
            resetDirection()

            var taskData2 = taskData
            taskData2[searchPoint.y][searchPoint.x] = "#"
            
            var startSearchPoint = startOriginSearchPoint
            var history: [SearchPoint: [Direction]] = [:]
            
            while let point = go(from: startSearchPoint, using: taskData2) {
                if taskData2[safe: point.y]?[safe: point.x] == "#" {
                    rotateRight()
                } else {
                    if history[point]?.contains(direction) == true {
                        result += 1
                        break
                    } else {
                        if history[point] == nil {
                            history[point] = [direction]
                        } else {
                            history[point]?.append(direction)
                        }
                      
                        startSearchPoint = point
                    }
                }
            }
            
        }

        return result
    }
    
    func findAllSearchPoints() -> Set<SearchPoint> {
        resetDirection()

        guard var searchPoint = findStartSearchPoint() else { return [] }

        var searchedPoints: Set<SearchPoint> = [searchPoint]

        while let point = go(from: searchPoint, using: taskData) {
            if taskData[safe: point.y]?[safe: point.x] == "#" {
                rotateRight()
            } else {
                searchedPoints.insert(point)
                searchPoint = point
            }
        }
        
        return searchedPoints
    }
    
    private var direction: Direction = .up
}

private extension Task6Y2024 {

    enum Direction {
        case up, down, left, right
    }

    func go(from point: SearchPoint, using taskData: [[String]]) -> SearchPoint? {
        switch direction {
        case .up:
            taskData[safe: point.y-1]?[safe: point.x] != nil ? SearchPoint(x: point.x, y: point.y-1) : nil
        case .down:
            taskData[safe: point.y+1]?[safe: point.x] != nil ? SearchPoint(x: point.x, y: point.y+1) : nil
        case .left:
            taskData[safe: point.y]?[safe: point.x-1] != nil ? SearchPoint(x: point.x-1, y: point.y) : nil
        case .right:
            taskData[safe: point.y]?[safe: point.x+1] != nil ? SearchPoint(x: point.x+1, y: point.y) : nil
        }
    }

    func rotateRight() {
        direction = switch direction {
        case .down: .left
        case .left: .up
        case .up: .right
        case .right: .down
        }
    }

    func resetDirection() {
        direction = .up
    }

    func findStartSearchPoint() -> SearchPoint? {
        for (lineIndex, line) in taskData.enumerated() {
            if let char = line.enumerated().first(where: { $1.contains("^") }) {
                return .init(x: Int( char.offset), y: Int(lineIndex))
            }
        }

        return nil
    }
}
