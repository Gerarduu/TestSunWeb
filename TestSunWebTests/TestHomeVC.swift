//
//  TestHomeVC.swift
//  TestSunWebTests
//
//  Created by Gerard Riera  on 12/03/2021.
//

import XCTest
@testable import TestSunWeb

class TestHomeVC: XCTestCase {
    
    var sut: HomeVC!
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func makeSUT() -> HomeVC {
        //When
        let homeVC = kStoryboardHome.instantiateViewController(withIdentifier: kHomeVC) as! HomeVC
        homeVC.loadViewIfNeeded()
        return homeVC
    }
    
    func test_home_vc_title() {
        //Then
        XCTAssertEqual(sut.title, "Flights")
    }
    
    func test_fill_sections() {
        //Then
        XCTAssertEqual(sut.sections.count, 2)
    }
    
    func test_sections_num() {
        //Then
        let n = sut.numberOfSections(in: sut.mainTV)
        XCTAssertEqual(n, 2)
    }
    
    func test_height_for_row_in_section() {
        //Then
        XCTAssertEqual(sut.mainTV.rowHeight, 60)
    }
    
    func test_view_for_header() {
        //Then
        if  let view = sut.tableView(sut.mainTV, viewForHeaderInSection: 0) {
            XCTAssertTrue(view.isKind(of: UIView.self))
        } else {
            XCTFail()
        }
    }
    
    func test_show_toast_correct_price() {
        //Given
        if let outboundFlight = FlightManager.shared.getFlights()?.filter({$0.outBound == 1}).first {
            
            outboundFlight.price = NSNumber(value: 20)
            
            sut.homeVM.selectOutboundFlight(outboundFlight: outboundFlight)
            //When
            sut.showToast()
            //Then
            XCTAssertEqual(sut.mainTV.contentInset, UIEdgeInsets(top: 0, left: 0, bottom: sut.toast.view.frame.size.height, right: 0))
        } else {
            XCTFail()
        }
    }
    
    func test_show_toast_price_error() {
        //Given
        if let outboundFlight = FlightManager.shared.getFlights()?.filter({$0.outBound == 1}).first {
            outboundFlight.price = NSNumber(value: 0 - 1)
            
            sut.homeVM.selectOutboundFlight(outboundFlight: outboundFlight)
            //When
            sut.showToast()
            //Then
            XCTAssertEqual(sut.mainTV.contentInset, UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        } else {
            XCTFail()
        }
    }
}
