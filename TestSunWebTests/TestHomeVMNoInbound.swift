//
//  TestHomeVM.swift
//  TestSunWebTests
//
//  Created by Gerard Riera  on 14/03/2021.
//

import XCTest
@testable import TestSunWeb

class TestHomeVMNoInbound: XCTestCase {
    var sut: HomeVM!
    var expectationOutboundNoInbound: XCTestExpectation?
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
    
    func test_select_outbound_no_inbound() {
        //Given
        self.expectationOutboundNoInbound = expectation(description: "Select outbound no inbound")
        if let outboundFlight = sut.outboundFlights.filter({ $0.arrivalAirportCode == "ROT" }).first {
            //When
            sut.selectOutboundFlight(outboundFlight: outboundFlight)
            waitForExpectations(timeout: 5, handler: nil)
        } else {
            XCTFail()
        }
    }
}

extension TestHomeVMNoInbound: HomeVMDelegate {
    func didSelectOutboundFlight() {}
    func didSelectInboundFlight() {}
    
    func couldntSelectInboundFlight() {
        expectationOutboundNoInbound?.fulfill()
        //Then
        XCTAssertEqual(sut.filteredInboundFlights.count, 0)
    }
}
