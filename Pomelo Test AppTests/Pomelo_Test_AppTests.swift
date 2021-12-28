//
//  Pomelo_Test_AppTests.swift
//  Pomelo Test AppTests
//
//  Created by Achyuth Bujjigadu  on 27/12/21.
//

import XCTest
@testable import Pomelo_Test_App

class Pomelo_Test_AppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testApiCall() {
        let expectations = expectation(description: "Alamofire")
        APIClient.getMostPopularList() { result in
            switch result {
            case .success(let response):
                if !response.results.isEmpty {
                    XCTAssertNotNil(response.results, "The result array is not empty")
                } else {
                    XCTAssertNil(response.results, "The result array is empty")
                }
                expectations.fulfill()
            case .failure(let error):
                XCTFail("Server response failed : \(error.localizedDescription)")
                expectations.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: { (error) in
            if let error = error {
                print("Failed : \(error.localizedDescription)")
            }
        })
    }
}
