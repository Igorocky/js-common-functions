let {log,log2} = module(Js.Console)
let {objToTable} = module(Expln_utils_data)
let {parseObj, arrOpt} = module(Expln_utils_jsonParse)
let {id} = module(Expln_utils_common)
let {describe,it,assertEq,assertTrue,fail} = module(Expln_test)

describe("objToTable", (.) => {
    it("should transform an object to a table", (.) => {
        //given
        let json = `{
            "id": 1244,
            "name": "NAME--",
            "children": [
                {"id":888,"type":"AA"},
                {"id":22222,"type":"cRR","sub":[{"sn":5},{"sn":6}]}
            ]
        }` -> parseObj(id)->Belt_Result.getExn

        //when
        let tbl = objToTable(
            json,
            [
                {
                    selectors: [
                        Attr({attr:"id",alias:"rootId"}),
                        Attr({attr:"name",alias:"rootName"}),
                    ],
                    childRef: Some(arrOpt(_, "children", id))
                }
                ,{
                    selectors: [
                        Attr({attr:"id",alias:"childId"}),
                        Attr({attr:"type",alias:"type"}),
                    ],
                    childRef: Some(arrOpt(_, "sub", id))
                }
                ,{
                    selectors: [
                        Attr({attr:"sn",alias:"sn"}),
                    ],
                    childRef: None
                }
            ]
        ) 

        //then
        tbl->Belt_Array.forEach(e => log(Js_json.stringifyAny(e)))
    })
})