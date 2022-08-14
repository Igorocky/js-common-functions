let {log,log2} = module(Js.Console)
let {objToTable, objToTableWithChildren} = module(Expln_utils_data)
let {parseObj, arrOpt, num, str} = module(Expln_utils_jsonParse)
let {id} = module(Expln_utils_common)
let {describe,it,assertEq,fail} = module(Expln_test)

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

        //when
        let tbl = objToTable(
            jsonAny,
            [
                {
                    selectors: [
                        ja=>("rootId", num(ja,"id")->Js_json.number),
                        ja=>("rootName", str(ja,"name")->Js_json.string),
                    ],
                    childRef: Some(arrOpt(_, "children", id))
                }
                ,{
                    selectors: [
                        ja=>("childId", num(ja,"id")->Js_json.number),
                        ja=>("type", str(ja,"type")->Js_json.string),
                    ],
                    childRef: Some(arrOpt(_, "sub", id))
                }
                ,{
                    selectors: [
                        ja=>("sn", num(ja,"sn")->Js_json.number),
                    ],
                    childRef: None
                }
            ]
        ) 

        //then
        log(tbl)
    })
})