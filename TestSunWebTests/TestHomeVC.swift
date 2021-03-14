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
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func makeSUT() -> HomeVC {
        //When
        let homeVC = kStoryboardHome.instantiateViewController(withIdentifier: kHomeVC) as! HomeVC
        homeVC.loadViewIfNeeded()
        homeVC.homeVM = HomeVM(delegate: self)
        return homeVC
    }
    
    func test_home_vc_title() {
        sut = makeSUT()
        //Then
        XCTAssertEqual(sut.title, "Flights")
    }
    
    func test_fill_sections() {
        sut = makeSUT()
        //Then
        XCTAssertEqual(sut.sections.count, 2)
    }
    
    func test_sections_num() {
        sut = makeSUT()
        //Then
        let n = sut.numberOfSections(in: sut.mainTV)
        XCTAssertEqual(n, 2)
    }
    
    func test_height_for_row_in_section() {
        sut = makeSUT()
        //Then
        XCTAssertEqual(sut.mainTV.rowHeight, 60)
    }
    
    func test_view_for_header() {
        sut = makeSUT()
        //Then
        if  let view = sut.tableView(sut.mainTV, viewForHeaderInSection: 0) {
            XCTAssertTrue(view.isKind(of: UIView.self))
        } else {
            XCTFail()
        }
    }
    
    func test_show_toast_correct_price() {
        sut = makeSUT()
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
        sut = makeSUT()
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
    
    func test_home_cell_section_outbound() {
        self.sut = makeSUT()
        let rows = sut.mainTV.numberOfRows(inSection: 0)
        for row in 0..<rows {
            let tvc = self.sut.cellForFlight(indexPath: IndexPath(row: row, section: 0))
            XCTAssertTrue(tvc.isKind(of: FlightTVC.self))
        }
    }
    
    func test_home_cell_section_inbound() {
        self.sut = makeSUT()
        let rows = sut.mainTV.numberOfRows(inSection: 1)
        for row in 0..<rows {
            let tvc = self.sut.cellForFlight(indexPath: IndexPath(row: row, section: 1))
            XCTAssertTrue(tvc.isKind(of: FlightTVC.self))
        }
    }
}

extension TestHomeVC:HomeVMDelegate{
    func didSelectOutboundFlight() {}
    func didSelectInboundFlight() {}
    func couldntSelectInboundFlight() {}
}
