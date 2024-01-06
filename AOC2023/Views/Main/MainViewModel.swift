//
//  MainViewModel.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {
    @Published var networkToggle: Bool = true
    @Published var error: Error?
    @Published var inProgress: Bool = false
    @Published private(set) var currentTaskResult: TasksResult?

    let taskLoaderService = TaskLoaderService()
    let taskSolverService = TaskSolverService()

    func selectedTask(taskNumber: String) {
        reset()

        inProgress = true

        Task {
            do {
                let data = try await taskLoaderService.getData(
                    taskNumber: taskNumber,
                    viaNetwork: networkToggle
                )

                try await solveTask(taskNumber: taskNumber, using: data)
            } catch {
                await MainActor.run {
                    self.error = error
                    inProgress = false
                }
            }
        }
    }

    func solveTask(taskNumber: String, using data: [String]) async throws {
        let result = try taskSolverService.solve(taskNumber: taskNumber, data: data)
        await MainActor.run {
            currentTaskResult = result
            inProgress = false
        }
    }

    private func reset() {
        currentTaskResult = nil
        error = nil
        inProgress = false
    }
}
