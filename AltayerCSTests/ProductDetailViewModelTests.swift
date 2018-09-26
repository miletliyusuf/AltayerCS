import XCTest
@testable import AltayerCS

class ProductDetailViewModelTests: XCTestCase {

  let viewModel: ProductDetailViewModel = ProductDetailViewModel()

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testIncomingData() {
    let r: ProductRequest = ProductRequest()
    r.slug = "212382014"
    _ = ProductsDataService.product(req: r).subscribe(onNext: { (response) in
      XCTAssertNotNil(response as? ProductResponseModel)
    }, onError: { (error) in
    })
    // Wait to finish request and test incoming data
    sleep(3)
  }

  func testGetCellHeight() {
    XCTAssertTrue(self.viewModel.getCellHeight(heights: [ProductDetailHeights.attributeCellClose[]], at: 0) == [ProductDetailHeights.attributeCellOpen[]])
    XCTAssertFalse(self.viewModel.getCellHeight(heights: [ProductDetailHeights.attributeCellClose[]], at: 0) == [ProductDetailHeights.attributeCellClose[]])
  }

  func testGetDiscountedString() {
    XCTAssertTrue(self.viewModel.getDiscountedString(for: "A", specialPrice: "B").string == "A B")
    XCTAssertFalse(self.viewModel.getDiscountedString(for: "A", specialPrice: "B").string == "AB")
  }
}
