//
//  TestsAvailableAds.swift
//  AqarMallTests
//
//  Created by wael on 7/18/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import XCTest
@testable import AqarMall

class TestsAvailableAds: XCTestCase {


    func testRetriveNumberOfAvailableAds(){
        
        let expectation = self.expectation(description: "Waiting for the retrieveAlumni call to complete.")

        //expectation.isInverted = true
        var userDetails: UserDetails? = nil
        var _error: Error? = nil
        
        APIs.shared.getUserDetails(mob: "50633124") { (result, error) in
           
            guard error == nil else {
                print(error ?? "")
                _error = error
                return
            }
            userDetails = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
            
            guard _error == nil else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(userDetails)
            
        }
    }

}
