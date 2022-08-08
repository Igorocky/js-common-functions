let {log,log2} = module(Js.Console)
let {objToTable, objToTableWithChildren} = module(Expln_utils_data)
let {parseObj, arrOpt} = module(Expln_utils_jsonParse)
let {id} = module(Expln_utils_common)
let {describe,it,assertEq,assertTrue,fail} = module(Expln_test)

describe("objToTable", (.) => {
    it("should transform an object to a table", (.) => {
        //given
        let jsonAny = `{
            "id": 1244,
            "name": "NAME--",
            "children": [
                {"id":888,"type":"AA"},
                {"id":22222,"type":"cRR","sub":[{"sn":5},{"sn":6}]}
            ]
        }` -> parseObj(id)->Belt_Result.getExn
        let json = jsonAny

        //when
        let tbl = objToTableWithChildren(
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
        log(tbl)
    })
})