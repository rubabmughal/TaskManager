//
//  TaskManagerUITests.swift
//  TaskManagerUITests
//
//  Created by Macbook Pro on 11/03/2025.
//

import XCTest

final class TaskManagerUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
        func testAddingNewTask() {
                // ✅ Step 1: Open Task Creation View
                let addButton = app.buttons["Add new task"]
                   XCTAssertTrue(addButton.exists, "Add Task button should exist")
                   addButton.tap()
    
                // ✅ Step 2: Enter Task Title
                let titleField = app.textFields["Title"]
                XCTAssertTrue(titleField.exists, "Title text field should exist")
                titleField.tap()
                titleField.typeText("Test Task")
    
                // ✅ Step 3: Enter Task Description
                let descriptionField = app.textFields["Description"]
                XCTAssertTrue(descriptionField.exists, "Description text field should exist")
                descriptionField.tap()
                descriptionField.typeText("This is a test task")
            // ✅ Step 4: Set Priority
            // Select priority
            // Ensure the picker exists (in Form, it's a Button)
            let priorityPickerButton = app.buttons["PriorityPicker"].firstMatch
                XCTAssertTrue(priorityPickerButton.exists, "Priority picker button does not exist")
    
                // Tap the picker to open selection (opens a modal)
                priorityPickerButton.tap()
    
                // Select "High" priority from the modal list
            let highPriorityOption = app.staticTexts["Low"].firstMatch
            XCTAssertTrue(highPriorityOption.waitForExistence(timeout: 2), "High priority option does not exist")
               highPriorityOption.tap()
    

                    // ✅ Step 5: Set Due Date
                    let datePicker = app.datePickers["DueDatePicker"]
                    XCTAssertTrue(datePicker.waitForExistence(timeout: 3), "Date picker should exist")
                    datePicker.tap()
                    datePicker.swipeUp() // Ensure visibility
    
                    // Select a future date dynamically
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                    let formatter = DateFormatter()
                    formatter.dateStyle = .long
                    let tomorrowString = formatter.string(from: tomorrow)
    
    
                    // ✅ Step 6: Save Task
            // Ensure the save button exists in the navigation bar
    
            let saveButton = app.navigationBars.buttons["SaveButton"].firstMatch
            XCTAssertTrue(saveButton.waitForExistence(timeout: 3), "Save button should exist")
    
            if !saveButton.isHittable {
                let buttonFrame = saveButton.frame
                let buttonCoordinate = app.coordinate(withNormalizedOffset: CGVector(dx: buttonFrame.midX, dy: buttonFrame.midY))
                buttonCoordinate.tap()
            } else {
                saveButton.tap()
            }
    
            }
    
    func testSortingAndFilteringTasks() {
      

//        // ✅ Wait for Task List to Load
        let taskList = app.tables.firstMatch
//        XCTAssertTrue(taskList.waitForExistence(timeout: 10), "Task list should load")
//
//        // ✅ Ensure There's At Least One Task
        let firstTask = taskList.cells.firstMatch
//        XCTAssertTrue(firstTask.waitForExistence(timeout: 5), "There should be at least one task in the list")

        // ✅ Verify the Sorting Picker Exists
        let sortPicker = app.segmentedControls["SortSegmentControl"]
        XCTAssertTrue(sortPicker.exists, "Sort segment control should exist")

        // Test Sorting by Priority
        sortPicker.buttons["Priority"].tap()
               
                // Test Sorting by Due Date
        sortPicker.buttons["Due Date"].tap()
               
                
                // Test Sorting Alphabetically
        sortPicker.buttons["Alphabetically"].tap()
               
                
        
        // ✅ Verify the Filter Picker Exists
        let filterPicker = app.segmentedControls["FilterSegmentControl"]
        XCTAssertTrue(filterPicker.exists, "Filter segment control should exist")

        // ✅ Apply "Completed" Filter
        filterPicker.buttons["Completed"].tap()

        // ✅ Ensure "Pending" Tasks Are Not Visible
        let pendingTask = taskList.cells.containing(.staticText, identifier: "Pending").firstMatch
        XCTAssertFalse(pendingTask.exists, "Only completed tasks should be visible")
        // ✅ Apply "All" Filter Back
        filterPicker.buttons["Pending"].tap()
        
        // ✅ Apply "All" Filter Back
        filterPicker.buttons["All"].tap()
        
    }





//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
