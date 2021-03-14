//
//  TestHomeVM.swift
//  TestSunWebTests
//
//  Created by Gerard Riera  on 14/03/2021.
//

import XCTest
@testable import TestSunWeb

class TestHomeVM: XCTestCase {
    var sut: HomeVM!
    var expectationOutboundFlight: XCTestExpectation?
    var expectationInboundFlight: XCTestExpectation?
    var selectedOutboundFlight: [FlightObject]!
    var selectedInboundFlight: [FlightObject]!
    
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
    
    func test_select_outbound_flight() {
        self.expectationOutboundFlight = expectation(description: "Select outbound flight")
        if let outboundFlight = sut.outboundFlights?.first {
            sut.selectOutboundFlight(outboundFlight: outboundFlight)
            waitForExpectations(timeout: 5, handler: nil)
        } else {
            XCTFail()
        }
    }
}

extension TestHomeVM: HomeVMDelegate {
    func didSelectOutboundFlight() {
        if let outboundFlight = sut.outboundFlights?.first {
            XCTAssertEqual(outboundFlight.checked, true)
        } else {
            XCTFail()
        }
    }
    
    func didSelectInboundFlight() {
        expectationOutboundFlight?.fulfill()
        expectationOutboundFlight = nil
        if let inboundFlight = sut.filteredInboundFlights?.first {
            XCTAssertEqual(inboundFlight.checked, true)
        } else {
            XCTFail()
        }
    }
    
    func couldntSelectInboundFlight() {
    }
}

