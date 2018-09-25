//
//  ProductsViewModelTests.swift
//  AltayerCSTests
//
//  Created by Yusuf Miletli on 25.09.2018.
//  Copyright © 2018 Miletli. All rights reserved.
//

import XCTest
@testable import AltayerCS

class ProductsViewModelTests: XCTestCase {

  let viewModel: ProductsViewModel = ProductsViewModel()

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testIncomingData() {
    let r = ProductsRequest()
    r.page = 0
    _ = ProductsDataService.products(req: r).subscribe(onNext: { (res) in
      XCTAssertNotNil(res as? ProductsResponse)
      if let response = res as? ProductsResponse,
        let hits = response.hits {
        self.testGetIndexPaths(for: hits)
      }
    }, onError: { (error) in

    })
    // Wait to finish request and test incoming data
    sleep(3)
  }

  func testGetIndexPaths(for hits: [ProductModel]) {
    XCTAssertTrue(self.viewModel.getIndexPaths(for: hits, in: hits).count == hits.count)
  }

  func testSizeForItem() {
    let isLandscape: Bool = UIDevice.current.orientation.isLandscape
    XCTAssertTrue(self.viewModel.sizeForItem(for: CGSize(width: 100, height: 100)) == CGSize(width: isLandscape ? 80 / 3 : 45, height: isLandscape ? 120 : 60),
                  "If you've changed UI Constants change tests as well")
  }

  func testWillContinueToInfiniteScroll() {
    XCTAssertTrue(self.viewModel.willContinueToInfiniteScroll(for: 0, until: 20))
    XCTAssertFalse(self.viewModel.willContinueToInfiniteScroll(for: 1, until: 0))
    XCTAssertFalse(self.viewModel.willContinueToInfiniteScroll(for: 0, until: nil))
  }

  func testConstants() {
    XCTAssertTrue((UIStoryboard.main.instantiateViewController(withIdentifier: self.viewModel.productDetailVCIdentifier) as? ProductDetailViewController) != nil,
                  "If you've changed id from storyboard should change it in viewmodel as well.")
  }

  func testActivityIndicator() {
    XCTAssertFalse(self.viewModel.activityIndicator.translatesAutoresizingMaskIntoConstraints, "FooterView UI will be broken")
    XCTAssertTrue(self.viewModel.activityIndicator.isAnimating, "FooterView will show frozen view")
  }
}
