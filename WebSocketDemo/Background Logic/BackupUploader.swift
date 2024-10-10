//
//  BackupUploader.swift
//  WebSocketDemo
//
//  Created by Ashraf Uddin on 10/10/24.
//

import Foundation

class BackupUploader {
    static let shared = BackupUploader()
    let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlNWUzZjYyYzEyMTg3N2RlYmU1YjY0ZCIsImlhdCI6MTcyODIzNzc3NSwiZXhwIjoxNzI4MzI0MTc1fQ.0spSclloJiWu0TAu4nDQjwvPL1Crasy-MgzbaGzr6S0"
    let uploadNetworkUrl = "https://messaging-dev.kotha.im/api/v1/message/backup"
    
    private init() {}
    
    func uploadBackupFile(_ fileURL: URL, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: uploadNetworkUrl) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = createMultipartBody(fileURL: fileURL, boundary: boundary)
        
        let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if error != nil {
                completion(false)
                return
            }
            completion(true)
        }
        task.resume()

    }
    
    private func createMultipartBody(fileURL: URL, boundary: String) -> Data {
        var body = Data()
        let fileName = fileURL.lastPathComponent
        let mimeType = "application/zip"
        
        // Add form boundary
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        
        // Add file data
        if let fileData = try? Data(contentsOf: fileURL) {
            body.append(fileData)
        }
        body.append("\r\n".data(using: .utf8)!)
        
        // End form boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body

    }
}
