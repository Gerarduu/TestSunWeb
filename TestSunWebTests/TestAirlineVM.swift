//
//  TestAirlineVM.swift
//  TestSunWebTests
//
//  Created by Gerard Riera  on 14/03/2021.
//

import XCTest
@testable import TestSunWeb

class TestAirlineVM: XCTestCase {

    var sut: AirlineVM!
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func makeSUT() -> AirlineVM {
        let airlineVM = AirlineVM(delegate: self, airlineId: "")
        return airlineVM
    }
    
    func test_load_mock_airline() {
        let expectation = self.expectation(description: "Load airline")
        //Given
        let airline = Airline(
            id: "Mock",
            name: "Mock",
            headline: "Mock Headline",
            description: "Mock Desc",
            logoImg: URL(string: "https://www.google.com"),
            mainImg: URL(string: "https://www.google.com")
        )
        AirlineManager.shared.saveAirlines(airlines: [airline]) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        self.sut = AirlineVM(delegate: self, airlineId: "Mock")
        //When
        self.sut.loadData()
        //Then
        XCTAssertEqual(self.sut.id, "Mock")
        XCTAssertEqual(self.sut.name, "Mock")
        XCTAssertEqual(self.sut.headline, "Mock Headline")
        XCTAssertEqual(self.sut.description, "Mock Desc")
        XCTAssertEqual(self.sut.logoImg, URL(string: "https://www.google.com"))
        XCTAssertEqual(self.sut.mainImg, URL(string: "https://www.google.com"))
    }
    
    func test_load_mock_inexistent_airline() {
        let expectation = self.expectation(description: "Load inexistent Airline")
        //Given
        let airline = Airline(
            id: "Mock",
            name: "Mock",
            headline: "Mock Headline",
            description: "Mock Desc",
            logoImg: URL(string: "https://www.google.com"),
            mainImg: URL(string: "https://www.google.com")
        )
        AirlineManager.shared.saveAirlines(airlines: [airline]) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        self.sut = AirlineVM(delegate: self, airlineId: "InexistentAirline")
        //When
        self.sut.loadData()
        //Then
        XCTAssertEqual(self.sut.id, nil)
        XCTAssertEqual(self.sut.name, nil)
        XCTAssertEqual(self.sut.headline, nil)
        XCTAssertEqual(self.sut.description, nil)
        XCTAssertEqual(self.sut.logoImg, nil)
        XCTAssertEqual(self.sut.mainImg, nil)
    }
}

extension TestAirlineVM: AirlineVMDelegate {
    func didLoadData() {}
    func error(error: Error) {}
}
