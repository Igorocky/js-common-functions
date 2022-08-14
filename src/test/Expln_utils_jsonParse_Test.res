let {log,log2} = module(Js.Console)
let {parseObjOpt, parseObj, str} = module(Expln_utils_jsonParse)
let {describe,it,assertEq,fail} = module(Expln_test)

type param = {
    name: string,
    value: string,
}

describe("Expln_utils_json.parseObj", (.) => {
    it("should parse simple object", (.) => {
        //given
        let jsonStr = `{
            "name": "AAA",
            "value": "BBB"
        }`

        //when
        let p = parseObj(jsonStr, d => {
            name: d->str("name"),
            value: d->str("value"),
        })

        //then
        switch p {
            | Ok(param) =>
                assertEq("AAA", param.name)
                assertEq("BBB", param.value)
            | _ => fail()
        }
    })
    it("returns a meaningful message when null is passed", (.) => {
        //given
        let jsonStr = `null`

        //when
        let p = parseObj(jsonStr, d => {
            name: d->str("name"),
            value: d->str("value"),
        })

        //then
        switch p {
            | Error(msg) =>
                assertEq("Parse error: an object was expected at '/'.", msg)
            | _ => fail()
        }
    })
    it("returns an error message when unparsable text is passed", (.) => {
        //given
        let jsonStr = `null-`

        //when
        let p = parseObj(jsonStr, d => {
            name: d->str("name"),
            value: d->str("value"),
        })

        //then
        switch p {
            | Error(msg) =>
                assertEq("Parse error: Unexpected number in JSON at position 4", msg)
            | _ => fail()
        }
    })
    it("returns a meaningful message when null is passed for a non-null attribute", (.) => {
        //given
        let jsonStr = `{
            "name": null,
            "value": "BBB"
        }`

        //when
        let p = parseObj(jsonStr, d => {
            name: d->str("name"),
            value: d->str("value"),
        })

        //then
        switch p {
            | Error(msg) =>
                assertEq("Parse error: a string was expected at '/name'.", msg)
            | _ => fail()
        }
    })
    it("returns a meaningful message when a non-null attribute is absent", (.) => {
        //given
        let jsonStr = `{
            "name": "vvv"
        }`

        //when
        let p = parseObj(jsonStr, d => {
            name: d->str("name"),
            value: d->str("value"),
        })

        //then
        switch p {
            | Error(msg) =>
                assertEq("Parse error: a string was expected at '/value'.", msg)
            | _ => fail()
        }
    })
})

describe("Expln_utils_json.parseObjOpt", (.) => {
    it("should return None when null is passed", (.) => {
        //given
        let jsonStr = `null`

        //when
        let p = parseObjOpt(jsonStr, d => {
            name: d->str("name"),
            value: d->str("value"),
        })

        //then
        switch p {
            | Ok(None) => ()
            | _ => fail()
        }
    })
})

Expln_utils_jsonParse.runTests___()