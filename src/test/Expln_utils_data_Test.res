open Expln_utils_common
let {log,log2} = module(Js.Console)
let {objToTable, objToTableWithChildren, traverseNodes} = module(Expln_utils_data)
let {parseObj, arrOpt, num, str} = module(Expln_utils_jsonParse)
let {describe,it,assertEq,fail} = module(Expln_test)

let anyToJson = a => stringify(a) -> Js.Json.parseExn
let id = x=>x

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
        let expected = [
            anyToJson({ "rootId": 1244, "rootName": "NAME--", "childId": 888, "type": "AA"}),
            anyToJson({ "rootId": 1244, "rootName": "NAME--", "childId": 22222, "type": "cRR", "sn": 5}),
            anyToJson({ "rootId": 1244, "rootName": "NAME--", "childId": 22222, "type": "cRR", "sn": 6}),
        ]

        //when
        let actual = objToTable(
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
        assertEq( anyToJson(actual), anyToJson(expected))
    })
})

type rec testNode = {
    name: string,
    ch: option<array<testNode>>
}
describe("traverseNodes", (.) => {
    it("should traverse all nodes in the correct order", (.) => {
        //given
        let tree = {
            name: "1",
            ch: Some([
                {
                    name: "2",
                    ch: Some([
                        {name: "3", ch: None},
                        {name: "4", ch: None},
                        {name: "5", ch: None},
                    ])
                },
                {
                    name: "6",
                    ch: Some([])
                }
            ])
        }

        //when
        let log = []
        let res = traverseNodes(
            log,
            tree,
            node => node.ch,
            ~preProcess=(arr,node)=>{
                arr->Js_array2.push("preProcess: " ++ node.name)->ignore
                None
            },
            ~process=(arr,node)=>{
                arr->Js_array2.push("process: " ++ node.name)->ignore
                None
            },
            ~postProcess=(arr,node)=>{
                arr->Js_array2.push("postProcess: " ++ node.name)->ignore
                None
            },
            ()
        )

        //then
        assertEq(res,None)
        assertEq(
            log,
            [
                "preProcess: 1",
                "process: 1",
                    "preProcess: 2",
                    "process: 2",
                        "preProcess: 3",
                        "process: 3",
                        "postProcess: 3",
                        "preProcess: 4",
                        "process: 4",
                        "postProcess: 4",
                        "preProcess: 5",
                        "process: 5",
                        "postProcess: 5",
                    "postProcess: 2",
                    "preProcess: 6",
                    "process: 6",
                    "postProcess: 6",
                "postProcess: 1",
            ]
        )
    })
})