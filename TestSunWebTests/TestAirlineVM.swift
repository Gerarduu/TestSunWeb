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
    
    override func setUp() {
        super.setUp()
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func makeSUT() -> AirlineVM {
        let airlineVM = AirlineVM(delegate: self, airlineId: "")
        return airlineVM
    }
}

extension TestAirlineVM: AirlineVMDelegate {
    func didLoadData() {
        
    }
    
    func error(error: Error) {
        
    }
}
