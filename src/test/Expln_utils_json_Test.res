open Expln_utils_json
open Expln_test

describe("pathToStr", (. ) => {
    it("should return slash for empty path", (. ) => {
        assertStr("/", pathToStr(list{}))
    })
})