let {log,log2} = module(Js.Console)
let {objToTable} = module(Expln_utils_data)
let {describe,it,assertEq,assertTrue,fail} = module(Expln_test)

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
//        let tbl = objToTable(
//            json,
//            [
//                {
//                    selectors: [
//                        Attr({attr:"id",alias:"rootId"}),
//                        Attr({attr:"name",alias:"rootName"}),
//                    ],
//                    childRef: Some(json => obj_(json,list{},(d,p) => arrOpt("children",d,p,(d,p)=>d)))
//                }
//                ,{
//                    selectors: [
//                        Attr({attr:"id",name:"childId"}),
//                        Attr({attr:"type",name:"type"}),
//                    ],
//                    childRef: Some(json => obj_(json,list{},(d,p) => arrOpt("sub",d,p,(d,p)=>d)))
//                }
//                ,{
//                    selectors: [
//                        Attr({attr:"sn",name:"sn"}),
//                    ],
//                    childRef: None
//                }
//            ]
//        ) 

//        //then
//        tbl->Belt_Array.forEach(e => log(Js_json.stringifyAny(e)))
//    })
//})