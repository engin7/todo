//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Engin KUK on 18.05.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

// TODO: - CoreData UnitTests


import XCTest
import CoreData
@testable import ToDo

class ToDoTests: XCTestCase {

    var sut:  ToDoListViewController!

    override func setUp() {
        super.setUp()

        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToDoListViewController") as? ToDoListViewController
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testExample() {
        
          // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

     func testBarButtonItemsAreSet() {
          
           let addButton = sut.navigationItem.rightBarButtonItem
            
             XCTAssertNotNil(addButton, "Should not be nil")
             XCTAssertEqual(addButton!.action, #selector(UIPushBehavior.addItem(_:)), "Action should be addItem")
          }
    
}

