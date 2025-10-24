//
//  String+ExtensionTests.swift
//  Audiobooks CCTests
//
//  Created by Chris Campanelli on 2025-10-24.
//

import Testing
@testable import Audiobooks_CC

struct StringExtensionTests {

    struct HtmlStringTestData {
        let input: String
        let expectedResult: String
    }
    @Test(arguments: [
        HtmlStringTestData(input: "<b>Hello</b>", expectedResult: "Hello"),
        HtmlStringTestData(input: "<p>World wide</p>", expectedResult: "World wide"),
        HtmlStringTestData(input: "<p>323r9u2fdiufh9823hr3rgeuvvoervwvwef{';][</p>{';][a", expectedResult: "323r9u2fdiufh9823hr3rgeuvvoervwvwef{';][{';][a"),
        HtmlStringTestData(input: "No tags", expectedResult: "No tags"),
        HtmlStringTestData(input: "", expectedResult: ""),
        HtmlStringTestData(input: "3214", expectedResult: "3214")
    ])
    func testRemoveHtml(data: HtmlStringTestData) async throws {
        let removedHtmlString = data.input.removingHTMLTags
        #expect(removedHtmlString == data.expectedResult)
    }

}
