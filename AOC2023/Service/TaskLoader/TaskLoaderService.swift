//
//  TaskLoaderService.swift
//  AOC2023
//
//  Created by Franciszek Czana on 05/01/2024.
//

import Foundation

protocol TaskLoaderServiceProtocol {
    func getData(taskNumber: String, year: String, viaNetwork useNetworking: Bool) async throws -> [String]
}

final class TaskLoaderService: TaskLoaderServiceProtocol {
    let apiService: APIServiceProtocol
    let fileService: FileServiceProtocol

    init(apiService: APIServiceProtocol = APIService(),
         fileService: FileServiceProtocol = FileService())
    {
        self.apiService = apiService
        self.fileService = fileService
    }

    func getData(taskNumber: String, year: String, viaNetwork useNetworking: Bool) async throws -> [String] {
        let data: Data = if useNetworking {
            try await apiService.get(taskNumber: taskNumber, year: year)
        } else {
            try fileService.loadFile(fileName: taskNumber)
        }

        guard let stringData = String(data: data, encoding: .utf8) else {
            throw APIError.corruptedData
        }

        return stringData
            .split(separator: "\n")
            .compactMap { String($0) }
    }
}
