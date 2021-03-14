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
        //Given
        for n in 0..<100 {
            self.sut.outboundFlights.append(Flight(id: n+200, airline: "MockAirline", departureAirportCode: "MOCKARR", arrivalAirportCode: "MOCKDEPT", price: 1.0))
            self.sut.inboundFlights.append(Flight(id: n+301, airline: "MockAirline", departureAirportCode: "MOCKARR", arrivalAirportCode: "MOCKDEPT", price: 1.0))
            if n == 99 {
                if let alreadyLaunched = Preferences.getPrefsHasAlreadyLaunched(), alreadyLaunched {
                    //When
                    self.sut.compareData { (outboundFlightsToSave, inboundFlightsToSave, flightsToDelete) in
                        XCTAssertEqual(outboundFlightsToSave.count,100)
                        XCTAssertEqual(inboundFlightsToSave.count,100)
                        XCTAssertTrue(flightsToDelete.count > 0)
                    }
                } else {
                    //When
                    self.sut.compareData { (outboundFlightsToSave, inboundFlightsToSave, flightsToDelete) in
                        XCTAssertEqual(outboundFlightsToSave.count,100)
                        XCTAssertEqual(inboundFlightsToSave.count,100)
                        XCTAssertEqual(flightsToDelete.count,0)
                    }
                }
            }
        }
    }
    
    func test_load_data_less_flights_from_api() {
        let expectation = self.expectation(description: "save flights")
        var flightsToSave = [Flight]()
        //Given
        for n in 0..<100 {
            let flight = Flight(id: n+1000, airline: "MockAirline", departureAirportCode: "MOCKARR", arrivalAirportCode: "MOCKDEPT", price: 1.0)
            flightsToSave.append(flight)
        }
        FlightManager.shared.saveFlights(flights: flightsToSave, outBound: true) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        //When
        self.sut.compareData { (outboundFlightsToSave, inboundFlightsToSave, flightsToDelete) in
            //Then
            XCTAssertEqual(outboundFlightsToSave.count,0)
            XCTAssertEqual(inboundFlightsToSave.count,0)
            XCTAssertTrue(flightsToDelete.count > 0)
        }
    }
    
    func test_load_airlines() {
        let expectation = self.expectation(description: "save airlines")
        //Given
        MockAPI.shared.requestMockObject(route: "airlines") { (result: Result<AirlinesRoot,Error>) in
            switch result {
            case .failure:
                XCTFail()
                return
            case .success(let value):
                guard let data = value.airlines else {
                    XCTFail()
                    return
                }
                AirlineManager.shared.deleteAirlines {
                    AirlineManager.shared.saveAirlines(airlines: data) {
                        expectation.fulfill()
                    }
                }
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        //When
        if let airline = AirlineManager.shared.getAirline(id: "Transavia") {
            //Then
            XCTAssertEqual(airline.id, "Transavia")
            XCTAssertEqual(airline.name, "Transavia")
            XCTAssertEqual(airline.headline, "Want to fly affordably to more than 100 destinations in Europe? Book a flight with Transavia!")
            XCTAssertEqual(airline.airlineDesc, "Transavia is a low-cost airline that for the past 50 years has taken great pleasure in flying passengers to over 110 destinations in Europe and North Africa. Transavia stands for accessibility and affordability: whether you are planning a holiday or a business trip, you will always find a flight that fits your budget. Transavia operates from the Netherlands and France.")
            XCTAssertEqual(airline.logoImg, URL(string: "https://via.placeholder.com/100x100/32a852/ffffff?text=TR"))
            XCTAssertEqual(airline.mainImg, URL(string: "https://cdn.pixabay.com/photo/2017/03/24/19/53/plane-2172059_1280.jpg"))
        } else {
            XCTFail()
        }
    }
}

extension TestFakeSplashVM: FakeSplashVMDelegate {
    func didLoadData() {}
    func error(error: Error) {}
}
