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
          // incase list is empty
            addMockCell()
          
           let tableView = self.app.tables["List todos"]
           let cell = tableView.cells.element(matching: .cell, identifier: "myCell_0")
           _ = cell.waitForExistence(timeout: 2)
           XCTAssert(cell.exists && cell.isHittable)

            removeMockCell()
       }
    
      func testAccessibilityButton() {
           // incase list is empty
           addMockCell()

           let tableView = app.tables["List todos"]
           let cell = tableView.cells.element(matching: .cell, identifier: "myCell_0")
           _ = cell.waitForExistence(timeout: 2)
           let accessibilityButton = cell.buttons["More Info"]
           XCTAssert(accessibilityButton.exists && accessibilityButton.isHittable)
            
          removeMockCell()

          }
    
    func testDisabledDeleteButton() {
        
        let toDoListNavigationBar = app.navigationBars["To-Do List"]
        let deleteButton = toDoListNavigationBar.buttons["trash.circle.fill"]
        XCTAssert(deleteButton.exists && !deleteButton.isEnabled)

    }
    
    
    func testDeleteButton() {
        
        // incase list is empty
        addMockCell()
        
        let tableView = app.tables["List todos"]
        let cell = tableView.cells.element(matching: .cell, identifier: "myCell_0")
        _ = cell.waitForExistence(timeout: 2)
         let toDoListNavigationBar = app.navigationBars["To-Do List"]
        toDoListNavigationBar.buttons["Edit"].tap()
        tableView.cells["myCell_0"].children(matching: .button).element.tap()
        let deleteButton = toDoListNavigationBar.buttons["trash.circle.fill"]
        XCTAssert(deleteButton.exists && deleteButton.isEnabled)
        let doneButton = app.navigationBars["To-Do List"].buttons["Done"]
        doneButton.tap()
        
        removeMockCell()
        
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    // MARK: - Helper methods
    
    func addMockCell(){
    
        let addButton = app.buttons["Add"]
        addButton.tap()
        let addAlert = app.alerts
        let textField = addAlert.textFields.element
        textField.typeText("Go to lunch")
        app.tap()
    
    }
        
    func removeMockCell(){
        
        let tableView = app.tables["List todos"]
        let index = "myCell_" + String((tableView.cells.count) - 1 )
 
        // Swipe down until it is visible   
        while !tableView.cells[index].exists {
            app.swipeUp()
        }

        let toDoListNavigationBar = app.navigationBars["To-Do List"]
        toDoListNavigationBar.buttons["Edit"].tap()
        tableView.cells[index].children(matching: .button).element.tap()
        toDoListNavigationBar.buttons["trash.circle.fill"].tap()
        
    }
    
}

