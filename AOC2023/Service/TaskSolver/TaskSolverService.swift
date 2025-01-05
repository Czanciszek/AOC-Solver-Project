//
//  TaskSolverService.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import Foundation

protocol TaskSolverServiceProtocol {
    func solve(taskNumber: String, year: String, data: [String]) throws -> TasksResult
}

final class TaskSolverService: TaskSolverServiceProtocol {
    func solve(taskNumber: String, year: String, data: [String]) throws -> TasksResult {
        let task: TaskProvider = switch year {
        case "2024":
            try provide2024Task(for: taskNumber, data: data)
        default:
            try provide2023Task(for: taskNumber, data: data)
        }

        let resultA = measureTime {
            task.solveA()
        }

        let resultB = measureTime {
            task.solveB()
        }

        return TasksResult(
            taskA: resultA,
            taskB: resultB
        )
    }
    
    private func provide2023Task(for taskNumber: String, data: [String]) throws -> TaskProvider {
        switch taskNumber {
        case "1": Task1(data: data)
        case "2": Task2(data: data)
        case "3": Task3(data: data)
        case "4": Task4(data: data)
        case "5": Task5(data: data)
        case "6": Task6(data: data)
        case "7": Task7(data: data)
        case "8": Task8(data: data)
        case "9": Task9(data: data)
        case "10": Task10(data: data)
        case "11": Task11(data: data)
        default: throw TaskError.unknownTask
        }
    }

    private func provide2024Task(for taskNumber: String, data: [String]) throws -> TaskProvider {
        switch taskNumber {
        case "1": Task1Y2024(data: data)
        case "2": Task2Y2024(data: data)
        case "4": Task4Y2024(data: data)
        case "5": Task5Y2024(data: data)
        case "6": Task6Y2024(data: data)
        case "7": Task7Y2024(data: data)
        case "8": Task8Y2024(data: data)
        case "9": Task9Y2024(data: data)
        default: throw TaskError.unknownTask
        }
    }

    private func measureTime(for closure: () -> Int) -> TasksResult.TaskResult {
        let start = CFAbsoluteTimeGetCurrent()
        let value = closure()
        let diff = CFAbsoluteTimeGetCurrent() - start
        return .init(value: value, time: diff)
    }
}
