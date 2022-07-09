let {pathToStr, parseObj, parseObjOpt, str} = module(Expln_utils_json)
let {describe,it,assertStr,assertTrue,fail} = module(Expln_test)

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
        })

        //then
        switch p {
            | Ok(param) =>
                assertStr("AAA", param.name)
                assertStr("BBB", param.value)
            | _ => fail()
        }
    })
    it("returns a meaningful message when null is passed", (. ) => {
        //given
        let jsonStr = `null`

        //when
        let p = parseObj(jsonStr, (d,p) => {
            name: str("name",d,p),
            value: str("value",d,p),
        })

        //then
        switch p {
            | Error(msg) =>
                assertStr("An object was expected.", msg)
            | _ => fail()
        }
    })
    it("returns an error message when unparsable text is passed", (. ) => {
        //given
        let jsonStr = `null-`

        //when
        let p = parseObj(jsonStr, (d,p) => {
            name: str("name",d,p),
            value: str("value",d,p),
        })

        //then
        switch p {
            | Error(msg) =>
                assertStr("Parse error: Unexpected number in JSON at position 4", msg)
            | _ => fail()
        }
    })
    it("returns a meaningful message when null is passed for a non-null attribute", (. ) => {
        //given
        let jsonStr = `{
            "name": null,
            "value": "BBB"
        }`

        //when
        let p = parseObj(jsonStr, (d,p) => {
            name: str("name",d,p),
            value: str("value",d,p),
        })

        //then
        switch p {
            | Error(msg) =>
                assertStr("Parse error: a string was expected at '/name'.", msg)
            | _ => fail()
        }
    })
    it("returns a meaningful message when a non-null attribute is absent", (. ) => {
        //given
        let jsonStr = `{
            "name": "vvv"
        }`

        //when
        let p = parseObj(jsonStr, (d,p) => {
            name: str("name",d,p),
            value: str("value",d,p),
        })

        //then
        switch p {
            | Error(msg) =>
                assertStr("Parse error: a string was expected at '/value'.", msg)
            | _ => fail()
        }
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
        })

        //then
        switch p {
            | Ok(None) => ()
            | _ => fail()
        }
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

