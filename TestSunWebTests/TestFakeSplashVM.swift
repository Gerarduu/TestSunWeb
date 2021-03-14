//
//  TestFakeSplashVM.swift
//  TestSunWebTests
//
//  Created by Gerard Riera  on 13/03/2021.
//

import XCTest
@testable import TestSunWeb

class TestFakeSplashVM: XCTestCase {

    var sut: FakeSplashVM!
    
    override func setUp() {
        super.setUp()
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func makeSUT() -> FakeSplashVM {
        let fakeSplashVM = FakeSplashVM(delegate: self)
        return fakeSplashVM
    }
    
    func test_load_data() {
        //When
        sut.loadData()
    }
    
    // MARK: - Testing loading data from API, but there are more flights from the API than in the local storage.
    func test_load_data_more_flights_from_api() {
        for n in 0..<100 {
            self.sut.outboundFlights.append(Flight(id: n+200, airline: "MockAirline", departureAirportCode: "MOCKARR", arrivalAirportCode: "MOCKDEPT", price: 1.0))
            self.sut.inboundFlights.append(Flight(id: n+301, airline: "MockAirline", departureAirportCode: "MOCKARR", arrivalAirportCode: "MOCKDEPT", price: 1.0))
            if n == 99 {
                //When
                self.sut.compareData { (outboundFlightsToSave, inboundFlightsToSave, flightsToDelete) in
                    XCTAssertEqual(outboundFlightsToSave.count,100)
                    XCTAssertEqual(inboundFlightsToSave.count,100)
                    XCTAssertEqual(flightsToDelete.count,10)
                }
            }
        }
    }
}

extension TestFakeSplashVM: FakeSplashVMDelegate {
    func didLoadData() {
        
    }
    
    func error(error: Error) {
        //
    }
}
