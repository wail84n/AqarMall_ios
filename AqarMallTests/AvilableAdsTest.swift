//
//  AvilableAdsTest.swift
//  AqarMallTests
//
//  Created by wael on 7/18/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//
@testable import AqarMall
import XCTest

class AvilableAdsTest: XCTestCase {

    var userDetails: UserDetails!
    var vc: ChooseAdvSectionViewController!
    override func setUp() {
        super.setUp()
        userDetails = UserDetails(availableAds: 2, noOfPaidAds: 3, pendingFreeAds: 3)
        vc = ChooseAdvSectionViewController()
        
    }

    
    func test_user_ads_availability(){
        let total = userDetails.availableAds + userDetails.noOfPaidAds
        let reult = total == 0 ? false : true
        
        
        XCTAssertTrue(reult, "hello")
    }
    
    func test_total_avilable_ads(){
        vc.totalAvailableAds = 1
        
        let reult = vc.totalAvailableAds <= 0 ? false : true
        
        XCTAssertTrue(reult, "the user doesn't has enough credit")
        
    }
    
    func testBaseVC(){
        let vc = BaseVC()
        let queue = DispatchQueue(label: "test-queue")
        XCTAssertFalse(vc.didComplete)
        
        // Inject our test queue.
        vc.doSomethingAsynchronous(queue: queue)
        print("aaaaa befor")
        // Synchronize the queue to wait for it to complete.
         queue.sync { /* Do nothing, just synchronize */
            print("aaaaa hello")
         }

        
        print("aaaaa after")
        // didComplete should now be true.
         XCTAssertTrue(vc.didComplete)
    }
    
    override func tearDown() {
        userDetails = nil
        super.tearDown()
    }
}
