open Expln_utils_json
open Expln_test

type param = {
    name: string,
    value: string,
}

describe("Expln_utils_json.parseObj", (. ) => {
    it("should parse simple object", (. ) => {
        //given
        let jsonStr = `{
            "name": "AAA",
            "value": "BBB"
        }`

        //when
        let p = Expln_utils_json.parseObj(jsonStr, (d,p) => {
            name: Expln_utils_json.str(d,"name",p),
            value: Expln_utils_json.str(d,"value",p),
        })->Belt.Result.getExn

        //then
        assertStr("AAA", p.name)
        assertStr("BBB", p.value)
    })
})

describe("pathToStr", (. ) => {
    it("should return slash for empty path", (. ) => {
        assertStr("/", pathToStr(list{}))
    })
    it("should return slash separated values for non-empty path", (. ) => {
        assertStr("/settings/14/name", pathToStr(list{"settings", "14", "name"}))
    })
})

