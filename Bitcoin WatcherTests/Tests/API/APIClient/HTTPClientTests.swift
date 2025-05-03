//
//  HTTPClientTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class HTTPClientTests: XCTestCase {
    var sut: HTTPClient!
    var mockSession: URLSessionMock!
    var mockSessionFactory: URLSessionFactoryMock!
    
    let parseReturnValue = "Oh such a JSON"
    var parseCalls: [Data?] = []
    
    let defaultPath = "foo://bar/path/to/get"
    
    var expectedResource: (String?) -> Resource<String> = { _ in
        fatalError("Provide an implementation for expectedResource")
    }
    
    var expectedRequest: URLRequest!
    var result: Result<String, Error>?
    
    override func setUp() {
        super.setUp()
        mockSession = .init()
        mockSessionFactory = .init()
        mockSessionFactory.createURLSessionReturnValue = mockSession
        
        sut = .init(sessionFactory: mockSessionFactory)
    }
    
    override func tearDown() {
        super.tearDown()
        mockSession = nil
        mockSessionFactory = nil
        sut = nil
        result = nil
        parseCalls = []
        expectedRequest = nil
    }
    
    func createResource(path: String, method: HTTPMethod) -> Resource<String> {
        .init(
            url: .init(string: path)!,
            method: method,
            parse: { [weak self] data in
                guard let self else { throw HTTPErrorMock.noElements }
                parseCalls.append(data)
                return parseReturnValue
            }
        )
    }
    
    func testLoadWithHTTPError() async throws {
        let defaultPath = "/path/to/get"
        let resource = self.createResource(path: defaultPath, method: .get)
        
        mockSession.dataReturnValue = .success((Data(), HTTPURLResponse.error401()))
        expectedRequest = URLRequest(url: .init(string: defaultPath)!)
        expectedRequest.httpMethod = "GET"
        
        do {
            _ = try await sut.load(resource: resource)
            XCTFail("Expected error to be thrown, but none was thrown")
        } catch let error {
            XCTAssertEqual(error as? HTTPClient.Error, .http(code: 401, data: Data()))
            XCTAssertEqual(mockSession.calls, [.data(request: expectedRequest)])
            XCTAssertEqual(parseCalls, [])
        }
    }
    
    func testLoadGET() async throws {
        let responseData = Data([1, 2, 3])
        let resource = self.createResource(path: defaultPath, method: .get)
        
        expectedRequest = URLRequest(url: .init(string: defaultPath)!)
        expectedRequest.httpMethod = "GET"
        
        mockSession.dataReturnValue = .success((responseData, HTTPURLResponse.success()))
        
        let result = try await sut.load(resource: resource)
        
        XCTAssertEqual(result, parseReturnValue)
        XCTAssertEqual(mockSession.calls, [.data(request: expectedRequest)])
        XCTAssertEqual(parseCalls, [responseData])
    }
}

private enum HTTPErrorMock: Error {
    case noElements
}

private extension HTTPURLResponse {
    
    static func fake(
        url: URL = .init(string: "foo://bar")!,
        statusCode: Int,
        headerFields: [String : String]? = nil
    ) -> HTTPURLResponse {
        .init(
            url: .init(string: "foo://bar")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    static func success() -> HTTPURLResponse {
        .fake(statusCode: 200)
    }
    
    static func error401() -> HTTPURLResponse {
        .fake(statusCode: 401)
    }
}
