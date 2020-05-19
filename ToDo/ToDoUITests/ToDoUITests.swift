//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Engin KUK on 19.05.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//
 

 
import XCTest

class ToDoUITests: XCTestCase {

    var app:  XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

       app = XCUIApplication()
       app.launch()
       
    }

    override func tearDown() {
         app = nil
         super.tearDown()
    }

    func testInitialScreen() {

         XCTAssert(app.tables["List todos"].exists)
    }
    
    func testTapCell() {
        
            let tableView = app.tables["List todos"]
            let cell = tableView.cells.element(matching: .cell, identifier: "myCell_0")
            XCTAssert(cell.exists && cell.isHittable)
             
       }
     
     func testAccessibilityButton() {
           
           let tableView = app.tables["List todos"]
           let cell = tableView.cells.element(matching: .cell, identifier: "myCell_0")
           let accessibilityButton = cell.buttons["More Info"]
           XCTAssert(accessibilityButton.exists && accessibilityButton.isHittable)
            
          }
    

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
  
}
