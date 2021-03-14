//
//  TestHomeVM.swift
//  TestSunWebTests
//
//  Created by Gerard Riera  on 14/03/2021.
//

import XCTest
@testable import TestSunWeb

class TestHomeVMInbound: XCTestCase {
    var sut: HomeVM!
    var expectationInboundFlight: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func makeSUT() -> HomeVM {
        let homeVM = HomeVM(delegate: self)
        return homeVM
    }
    
    func test_select_inbound_flight() {
        self.expectationInboundFlight = expectation(description: "Select inbound flight")
        if let inboundFlight = sut.filteredInboundFlights?.first {
            sut.selectInboundFlight(inboundFlight: inboundFlight)
            waitForExpectations(timeout: 5, handler: nil)
        } else {
            XCTFail()
        }
    }
}

extension TestHomeVMInbound: HomeVMDelegate {
    func didSelectOutboundFlight() {}
    
    func didSelectInboundFlight() {
        expectationInboundFlight?.fulfill()
        if let inboundFlight = sut.filteredInboundFlights?.first {
            XCTAssertEqual(inboundFlight.checked, true)
        } else {
            XCTFail()
        }
    }
    
    func couldntSelectInboundFlight() {
    }
}

