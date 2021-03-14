//
//  TestAirlineVC.swift
//  TestSunWebTests
//
//  Created by Gerard Riera  on 14/03/2021.
//

import XCTest
@testable import TestSunWeb

class TestAirlineVC: XCTestCase {

    var sut: AirlineVC!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func makeSUT(id: String) -> AirlineVC {
        //When
        let airlineVC = kStoryboardHome.instantiateViewController(withIdentifier: kAirlineVC) as! AirlineVC
        airlineVC.id = id
        airlineVC.loadViewIfNeeded()
        airlineVC.airlineVM = AirlineVM(delegate: self, airlineId: id)
        return airlineVC
    }
    
    func test_fill_sections() {
        sut = makeSUT(id: "Mock")
        //Then
        XCTAssertEqual(sut.sections.count, 3)
    }
    
    func test_n_sections() {
        sut = makeSUT(id: "Mock")
        //Then
        let n = sut.numberOfSections(in: sut.mainTV)
        XCTAssertEqual(n, 3)
    }
    func test_n_rows_section() {
        let expectation = self.expectation(description: "zuc")
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
        self.sut = self.makeSUT(id: "Mock")
        let n = sut.tableView(sut.mainTV, numberOfRowsInSection: sut.sections.count)
        XCTAssertEqual(n, 1)
    }
    
    func test_title() {
        let expectation = self.expectation(description: "zuc")
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
        self.sut = self.makeSUT(id: "Mock")
        XCTAssertEqual(self.sut.title, "Mock Airlines")
    }
    
    func test_cell_for_top() {
        let expectation = self.expectation(description: "zuc")
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
        self.sut = self.makeSUT(id: "Mock")
        let tvc = self.sut.cellForTop(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(tvc.isKind(of: TopTVC.self))
    }
    
    func test_cell_for_header() {
        let expectation = self.expectation(description: "zuc")
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
        self.sut = self.makeSUT(id: "Mock")
        let tvc = self.sut.cellForHeader(at: IndexPath(row: 0, section: 1))
        XCTAssertTrue(tvc.isKind(of: HeaderTVC.self))
    }
    
    func test_cell_for_description() {
        let expectation = self.expectation(description: "zuc")
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
        self.sut = self.makeSUT(id: "Mock")
        let tvc = self.sut.cellForDescription(at: IndexPath(row: 0, section: 2))
        XCTAssertTrue(tvc.isKind(of: DescriptionTVC.self))
    }
    
    func test_height_for_sections() {
        let expectation = self.expectation(description: "zuc")
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
        self.sut = self.makeSUT(id: "Mock")
        XCTAssertEqual(sut.tableView(sut.mainTV, heightForRowAt: IndexPath(item: 0, section: 0)), kHeightForTop)
        XCTAssertEqual(sut.tableView(sut.mainTV, heightForRowAt: IndexPath(item: 0, section: 1)), kHeightForHeadline)
        XCTAssertEqual(sut.tableView(sut.mainTV, heightForRowAt: IndexPath(item: 0, section: 2)), kHeightForDesc)
    }
}

extension TestAirlineVC: AirlineVMDelegate {
    func didLoadData() {}
    func error(error: Error) {}
}
