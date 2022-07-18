let {log,log2} = module(Js.Console)
let {parseObjOpt, parseObj, str} = module(Expln_utils_jsonParse)
let {describe,it,assertEq,assertTrue,fail} = module(Expln_test)

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


//describe("objToTable", (.) => {
//    it("should transform an object to a table", (.) => {
//        //given
//        let json = `{
//            "id": 1244,
//            "name": "NAME--",
//            "children": [
//                {"id":888,"type":"AA"},
//                {"id":22222,"type":"cRR","sub":[{"sn":5},{"sn":6}]}
//            ]
//        }` -> Js_json.parseExn

//        //when
//        let tbl: Expln_utils_json.table = objToTable(
//            json,
//            {
//                columnOrder: Belt_Map.String.empty,
//                selectStages: [
//                    {
//                        selectors: [
//                            Attr({attr:"id",name:"rootId"}),
//                            Attr({attr:"name",name:"rootName"}),
//                        ],
//                        childRef: Some(json => obj_(json,list{},(d,p) => arrOpt("children",d,p,(d,p)=>d)))
//                    }
//                    ,{
//                        selectors: [
//                            Attr({attr:"id",name:"childId"}),
//                            Attr({attr:"type",name:"type"}),
//                        ],
//                        childRef: Some(json => obj_(json,list{},(d,p) => arrOpt("sub",d,p,(d,p)=>d)))
//                    }
//                    ,{
//                        selectors: [
//                            Attr({attr:"sn",name:"sn"}),
//                        ],
//                        childRef: None
//                    }
//                ]
//            }
//        ) -> Belt_Array.map(( (dictjs,_) ) => dictjs)

//        //then
//        tbl->Belt_Array.forEach(e => log(Js_json.stringifyAny(e)))
//    })
//})

Expln_utils_jsonParse.runTests___()