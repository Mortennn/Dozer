import XCTest
import Cocoa

final class MenuBarCompatibilityTests: XCTestCase {
    private let normal = CGRect(x: 500, y: 0, width: 25, height: 32)
    private let remove = CGRect(x: 200, y: 0, width: 25, height: 32)

    private func item(_ bundle: String, x: CGFloat, y: CGFloat = 0) -> MenuBarInventoryItem {
        MenuBarInventoryItem(bundleIdentifier: bundle, frame: CGRect(x: x, y: y, width: 20, height: 32))
    }

    func testClassifiesBothSectionsAndKeepsOtherMenuBarsVisible() {
        let sections = NativeMenuBarVisibility.classify([
            item("removed", x: 100), item("hidden", x: 300), item("visible", x: 600),
            item("otherDisplay", x: 100, y: 1000)
        ], normal: normal, remove: remove)
        XCTAssertEqual(sections["removed"], .remove)
        XCTAssertEqual(sections["hidden"], .normal)
        XCTAssertEqual(sections["visible"], .visible)
        XCTAssertEqual(sections["otherDisplay"], .visible)
    }

    func testMostVisibleIconWinsForAnApplicationSpanningSections() {
        for items in [[item("app", x: 100), item("app", x: 600)],
                      [item("app", x: 600), item("app", x: 100)]] {
            XCTAssertEqual(NativeMenuBarVisibility.classify(items, normal: normal, remove: remove)["app"], .visible)
        }
        XCTAssertEqual(NativeMenuBarVisibility.classify([
            item("app", x: 100), item("app", x: 300)
        ], normal: normal, remove: remove)["app"], .normal)
    }

    func testMissingRemoveSeparatorClassifiesEverythingLeftAsNormal() {
        XCTAssertEqual(NativeMenuBarVisibility.classify([item("app", x: 100)], normal: normal, remove: nil)["app"], .normal)
    }

    func testAdjacentIconWithAccessibilityPaddingIsStillOnTheHiddenSide() {
        let icon = MenuBarInventoryItem(bundleIdentifier: "adjacent", frame: CGRect(x: 458, y: 0, width: 43, height: 32))
        XCTAssertEqual(NativeMenuBarVisibility.classify([icon], normal: normal, remove: nil)["adjacent"], .normal)
    }

    func testCollapsePreservesVisibleUnreadableAndOwnApplications() {
        let inventory = FakeInventory([item("hidden", x: 300), item("visible", x: 600), item("dozer", x: 50)])
        let service = FakeService()
        let controller = makeController(inventory, service)
        controller.apply(.init(hideNormal: true), normal: normal, remove: nil) { XCTAssertNil($0) }
        XCTAssertEqual(Set(service.allowed[0]), ["dozer", "visible", "unreadable"])
    }

    func testOptionClickCanRevealNormalItemsWhileRemoveSectionStaysHidden() {
        let inventory = FakeInventory([item("removed", x: 100), item("hidden", x: 300)])
        let service = FakeService()
        let controller = makeController(inventory, service)
        controller.apply(.init(hideNormal: true, hideRemove: true), normal: normal, remove: remove) { XCTAssertNil($0) }
        let first = FakeAssertion()
        service.completions[0](.success(first))
        controller.apply(.init(hideNormal: false, hideRemove: true), normal: nil, remove: nil) { XCTAssertNil($0) }
        XCTAssertTrue(service.allowed[1].contains("hidden"))
        XCTAssertFalse(service.allowed[1].contains("removed"))
        XCTAssertEqual(inventory.reads, 1, "Restricted positions must not be read again")
        service.completions[1](.success(FakeAssertion()))
        XCTAssertEqual(first.invalidations, 1)
    }

    func testExpandCancelsAnInFlightHideAndInvalidatesItsLateAssertion() {
        let service = FakeService()
        let controller = makeController(FakeInventory([item("hidden", x: 300)]), service)
        controller.apply(.init(hideNormal: true), normal: normal, remove: nil) { _ in XCTFail("Stale callback") }
        controller.apply(.expanded, normal: nil, remove: nil) { XCTAssertNil($0) }
        let stale = FakeAssertion()
        service.completions[0](.success(stale))
        XCTAssertEqual(stale.invalidations, 1)
        XCTAssertEqual(controller.requestedState, .expanded)
    }

    func testNewestHideWinsWhenActivationsFinishOutOfOrder() {
        let service = FakeService()
        let controller = makeController(FakeInventory([item("hidden", x: 300)]), service)
        controller.apply(.init(hideNormal: true), normal: normal, remove: remove) { _ in XCTFail("Stale callback") }
        controller.apply(.init(hideNormal: true, hideRemove: true), normal: normal, remove: remove) { XCTAssertNil($0) }
        let current = FakeAssertion()
        let stale = FakeAssertion()
        service.completions[1](.success(current))
        service.completions[0](.success(stale))
        XCTAssertEqual(stale.invalidations, 1)
        XCTAssertEqual(current.invalidations, 0)
        controller.restore()
        XCTAssertEqual(current.invalidations, 1)
    }

    func testExpandCancelsPendingInventoryBeforeItCanHideAnything() {
        let inventory = FakeInventory([item("hidden", x: 300)])
        inventory.delaysSnapshot = true
        let service = FakeService()
        let controller = makeController(inventory, service)
        controller.apply(.init(hideNormal: true), normal: normal, remove: nil) { _ in XCTFail("Stale callback") }
        controller.restore()
        inventory.pendingSnapshot?(inventory.items)
        XCTAssertTrue(service.allowed.isEmpty)
    }

    func testFailedReplacementRestoresPreviouslyHiddenIcons() {
        let service = FakeService()
        let controller = makeController(FakeInventory([item("hidden", x: 300)]), service)
        controller.apply(.init(hideNormal: true), normal: normal, remove: remove) { XCTAssertNil($0) }
        let first = FakeAssertion()
        service.completions[0](.success(first))
        var reportedError = false
        controller.apply(.init(hideRemove: true), normal: nil, remove: nil) { reportedError = $0 != nil }
        service.completions[1](.failure(NSError(domain: "test", code: 1)))
        XCTAssertTrue(reportedError)
        XCTAssertEqual(first.invalidations, 1)
        XCTAssertEqual(controller.requestedState, .expanded)
    }

    func testDeniedAccessibilityDoesNotHideAndCanBeRetriedAfterGrant() {
        let inventory = FakeInventory([item("hidden", x: 300)])
        inventory.isAuthorized = false
        let service = FakeService()
        let controller = makeController(inventory, service)
        controller.apply(.init(hideNormal: true), normal: normal, remove: nil) { XCTAssertNotNil($0) }
        XCTAssertEqual(inventory.authorizationRequests, 1)
        XCTAssertTrue(service.allowed.isEmpty)
        XCTAssertEqual(controller.requestedState, .expanded)
        inventory.isAuthorized = true
        controller.apply(.init(hideNormal: true), normal: normal, remove: nil) { XCTAssertNil($0) }
        XCTAssertEqual(service.allowed.count, 1)
    }

    func testUnavailableAPIOrMissingBoundaryDoesNotHide() {
        let service = FakeService()
        let controller = makeController(FakeInventory([]), service)
        service.isAvailable = false
        controller.apply(.init(hideNormal: true), normal: normal, remove: nil) { XCTAssertNotNil($0) }
        service.isAvailable = true
        controller.apply(.init(hideNormal: true), normal: nil, remove: nil) { XCTAssertNotNil($0) }
        XCTAssertTrue(service.allowed.isEmpty)
        XCTAssertEqual(controller.requestedState, .expanded)
    }

    func testShowAllRestoresWithoutPermissionAndNextHideReadsNewLayout() {
        let inventory = FakeInventory([item("hidden", x: 300)])
        let service = FakeService()
        let controller = makeController(inventory, service)
        controller.apply(.init(hideNormal: true), normal: normal, remove: nil) { XCTAssertNil($0) }
        let token = FakeAssertion()
        service.completions[0](.success(token))
        inventory.isAuthorized = false
        service.isAvailable = false
        controller.apply(.expanded, normal: nil, remove: nil) { XCTAssertNil($0) }
        XCTAssertEqual(token.invalidations, 1)
        inventory.isAuthorized = true
        service.isAvailable = true
        inventory.items = [item("hidden", x: 600)]
        controller.apply(.init(hideNormal: true), normal: normal, remove: nil) { XCTAssertNil($0) }
        XCTAssertEqual(inventory.reads, 2)
        XCTAssertTrue(service.allowed[1].contains("hidden"))
    }

    private func makeController(_ inventory: FakeInventory, _ service: FakeService) -> NativeMenuBarVisibility {
        NativeMenuBarVisibility(inventory: inventory, service: service, ownBundle: "dozer",
                                runningBundles: { ["dozer", "hidden", "visible", "unreadable"] })
    }
}

private final class FakeInventory: MenuBarInventoryProviding {
    var items: [MenuBarInventoryItem]
    var isAuthorized = true
    var authorizationRequests = 0
    var reads = 0
    var delaysSnapshot = false
    var pendingSnapshot: (([MenuBarInventoryItem]) -> Void)?
    init(_ items: [MenuBarInventoryItem]) { self.items = items }
    func requestAuthorization() { authorizationRequests += 1 }
    func snapshot(completion: @escaping ([MenuBarInventoryItem]) -> Void) {
        reads += 1
        if delaysSnapshot { pendingSnapshot = completion } else { completion(items) }
    }
}

private final class FakeService: MenuBarVisibilityProviding {
    var isAvailable = true
    var allowed: [[String]] = []
    var completions: [(Result<MenuBarVisibilityAssertion, Error>) -> Void] = []
    func activate(allowing bundles: [String], completion: @escaping (Result<MenuBarVisibilityAssertion, Error>) -> Void) {
        allowed.append(bundles)
        completions.append(completion)
    }
}

private final class FakeAssertion: MenuBarVisibilityAssertion {
    var invalidations = 0
    func invalidate() { invalidations += 1 }
}
