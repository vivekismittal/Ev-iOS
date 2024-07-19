@testable import Yahhvi___EV_Charging
import XCTest

class AvailableChargersViewModelTests: XCTestCase {

    var viewModel: AvailableChargersViewModel!
    var mockRepo: MockAvailableChargersRepo!

    override func setUp() {
        super.setUp()
        mockRepo = MockAvailableChargersRepo()
//        viewModel = AvailableChargersViewModel(availableChargersRepo: mockRepo)
    }

    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        super.tearDown()
    }

    func testFetchAvailableChargingStationsSuccess() {
        // Given
        let expectedStations = [AvailableChargers(maintenance: false, publics: true, stationOpenForCharging: true), AvailableChargers(maintenance: false, publics: true, stationOpenForCharging: true)]
        mockRepo.mockStations = expectedStations

        // When
        let expectation = self.expectation(description: "Fetch charging stations")
        viewModel.fetchSortedAvailableChargingStations { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success)
//                XCTAssertEqual(self.viewModel.availableChargingStations, expectedStations)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testFetchAvailableChargingStationsFailure() {
        // Given
        mockRepo.shouldReturnError = true

        // When
        let expectation = self.expectation(description: "Fetch charging stations")
        viewModel.fetchSortedAvailableChargingStations { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertTrue(self.viewModel.availableChargingStations.isEmpty)
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
