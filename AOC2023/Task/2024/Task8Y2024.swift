final class Task8Y2024: TaskProvider {
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

        let satellites = prepareSatellites()
        
        var result: Set<SearchPoint> = []
        
        for satellite in satellites.keys {
            let pairs = satellites[satellite]?.combinationsWithoutRepetition.filter { $0.count == 2 }
            guard let pairs else { continue }

            for pair in pairs {
                let x1 = pair[0].x
                let x2 = pair[1].x
                let y1 = pair[0].y
                let y2 = pair[1].y

                let xDiff = abs(x1 - x2)
                let yDiff = abs(y1 - y2)
                
                let xPos1 = min(x1, x2) - xDiff
                let xPos2 = max(x1, x2) + xDiff
                
                var yPos1 = x1 < x2 ? y1 : y2
                var yPos2 = x1 < x2 ? y2 : y1

                if x1 < x2 {
                    if y1 < y2 {
                        yPos1 -= yDiff
                        yPos2 += yDiff
                    } else {
                        yPos1 += yDiff
                        yPos2 -= yDiff
                    }
                } else {
                    if y1 < y2 {
                        yPos1 += yDiff
                        yPos2 -= yDiff
                    } else {
                        yPos1 -= yDiff
                        yPos2 += yDiff
                    }
                }

                if validatePos(x: xPos1, y: yPos1) {
                    result.insert(.init(x: xPos1, y: yPos1))
                }

                if validatePos(x: xPos2, y: yPos2) {
                    result.insert(.init(x: xPos2, y: yPos2))
                }
            }
        }

        return result.count
    }
    


    func solveB() -> Int {

        let satellites = prepareSatellites()

        var result: Set<SearchPoint> = []

        for satellite in satellites.keys {
            let pairs = satellites[satellite]?.combinationsWithoutRepetition.filter { $0.count == 2 }
            guard let pairs else { continue }

            for pair in pairs {
               
                let x1 = pair[0].x
                let x2 = pair[1].x
                let y1 = pair[0].y
                let y2 = pair[1].y

                let xDiff = abs(x1 - x2)
                let yDiff = abs(y1 - y2)

                var startX1 = min(x1, x2)
                var startY1 = x1 < x2 ? y1 : y2

                while validatePos(x: startX1, y: startY1) {
                    result.insert(.init(x: startX1, y: startY1))
                    
                    startX1 -= xDiff
                    if (x1 < x2 && y1 < y2) || (x1 >= x2 && y1 >= y2) {
                        startY1 -= yDiff
                    } else {
                        startY1 += yDiff
                    }
                }

                var startX2 = max(x1, x2)
                var startY2 = x1 < x2 ? y2 : y1

                while validatePos(x: startX2, y: startY2) {
                    result.insert(.init(x: startX2, y: startY2))

                    startX2 += xDiff
                    if (x1 < x2 && y1 < y2) || (x1 >= x2 && y1 >= y2) {
                        startY2 += yDiff
                    } else {
                        startY2 -= yDiff
                    }
                }
            }
        }

        return result.count
    }
    
}

private extension Task8Y2024 {

    private func prepareSatellites() -> [Character: [SearchPoint]] {
        var satellites: [Character: [SearchPoint]] = [:]

        for (lineIndex, line) in data.enumerated() {
            for (pointIndex, point) in line.enumerated() {
                let searchPoint: SearchPoint = .init(x: pointIndex, y: lineIndex)
                if point != "." {
                    if satellites[point] == nil {
                        satellites[point] = [searchPoint]
                    } else {
                        satellites[point]?.append(searchPoint)
                    }
                }
            }
        }

        return satellites
    }

    private func validatePos(x: Int, y: Int) -> Bool {
        guard y >= 0, y < data.count else { return false }
        guard x >= 0, x < data[y].count else { return false }

        return true
    }
}

extension Array {
    var combinationsWithoutRepetition: [[Element]] {
        guard !isEmpty else { return [[]] }
        return Array(self[1...]).combinationsWithoutRepetition.flatMap { [$0, [self[0]] + $0] }
    }
}
