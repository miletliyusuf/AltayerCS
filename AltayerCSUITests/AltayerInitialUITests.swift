import XCTest

class AltayerInitialUITests: XCTestCase {

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    let app = XCUIApplication()
    app.launch()
  }

  /// Test views UI Element existing
  func testUIElementsExisting() {
    let app = XCUIApplication()

    app.collectionViews.cells.firstMatch.tap()

    let tabBars = app.tabBars
    XCTAssert(tabBars.buttons["Bag"].exists)
    XCTAssert(tabBars.buttons["Clothing"].exists)

    XCTAssert(app.buttons["ADD TO BAG"].exists)

    XCTAssert(app.tables.cells.containing(.staticText, identifier:"COLOR").element.exists)
    XCTAssert(app.tables.cells.containing(.staticText, identifier:"SIZE").element.exists)
  }


}
