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
    
    func test_load_data() {
        
    }
    
    func test_select_outbound_flight() {
        
    }
}

extension TestHomeVM: HomeVMDelegate {
    func didSelectOutboundFlight() {}
    
    func didSelectInboundFlight() {}
    
    func couldntSelectInboundFlight() {}
}
