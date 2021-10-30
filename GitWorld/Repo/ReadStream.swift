//
//  ReadStream.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 29.10.21.
//

import Foundation

class ReadStream {
    private let bufferSize: Int = 1024
    private var buffer: Data
    private let fileHandle: FileHandle?
    private let delimiter = "\n".data(using: .utf8)!
    
    init(url: URL) {
        do {
            fileHandle = try FileHandle(forReadingFrom: url)
        } catch {
            fileHandle = nil
            print("Can't create FileHandler: \(error)")
        }
        buffer = Data(capacity: bufferSize)
    }
    
    func readLine() -> String? {
        var rangeOfDelimiter = buffer.range(of: delimiter)
        
        while rangeOfDelimiter == nil {
            guard let chunk = fileHandle?.readData(ofLength: bufferSize) else { return nil }
            
            if chunk.count == 0 {
                if buffer.count > 0 {
                    defer { buffer.count = 0 }
                    
                    return String(data: buffer, encoding: .utf8)
                }
                
                return nil
            } else {
                buffer.append(chunk)
                rangeOfDelimiter = buffer.range(of: delimiter)
            }
        }
        
        let rangeOfLine = 0..<rangeOfDelimiter!.upperBound
        let line = String(data: buffer.subdata(in: rangeOfLine), encoding: .utf8)
        
        buffer.removeSubrange(rangeOfLine)
        
        return line?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension ReadStream: Sequence {
    
    func makeIterator() -> ReadStringIterator {
        return ReadStringIterator(stream: self)
    }
    
}

class ReadStringIterator: IteratorProtocol {
    private let stream: ReadStream
    
    init(stream: ReadStream) {
        self.stream = stream
    }
    
    func next() -> String? {
        return stream.readLine()
    }
}
