let {pathToStr, parseObj, parseObjOpt, str} = module(Expln_utils_json)
let {describe,it,assertStr,assertTrue} = module(Expln_test)

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
        let p = parseObj(jsonStr, (d,p) => {
            name: str("name",d,p),
            value: str("value",d,p),
        })->Belt.Result.getExn

        //then
        assertStr("AAA", p.name)
        assertStr("BBB", p.value)
    })
})

describe("Expln_utils_json.parseObjOpt", (. ) => {
    it("should return None when null is passed", (. ) => {
        //given
        let jsonStr = `null`

        //when
        let p = parseObjOpt(jsonStr, (d,p) => {
            name: str("name",d,p),
            value: str("value",d,p),
        })->Belt.Result.getExn

        //then
        assertTrue(p->Belt.Option.isNone)
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

