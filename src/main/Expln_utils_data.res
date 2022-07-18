let {log,log2} = module(Js.Console)
let {exn,flatMapArr,cast} = module(Expln_utils_common)
let {classify} = module(Js_json)

type json = Js.Json.t
type dictjs = Js.Dict.t<json>

type selectExpr<'a> =
    | Attr({attr:string, alias:string})
    | Func({func:'a=>json, alias:string})
type selectStage<'a> = {
    selectors: array<selectExpr<'a>>,
    childRef: option<'a=>option<array<'a>>>,
}

let applySingleSelect:('a,selectExpr<'a>) => dictjs = 
(obj, sel) =>             
    switch sel {
    | Attr({attr,alias}) => 
        if (!Js_json.test(obj,Js_json.Object)) {
            exn(`An attempt to apply Attr("${attr}") selector for a non-json object.`)
        } else {
            switch cast(obj)->classify {
            | Js_json.JSONObject(dict) =>
                switch dict->Js.Dict.get(attr) {
                | Some(v) => Js_dict.fromArray([(alias,v)])
                | None => Js_dict.empty()
                }
            | _ => exn(`Should never happen.`)
            }
        }
    | Func({func,alias}) => Js_dict.fromArray([(alias,func(obj))])
    }

let mergeRows:(dictjs,dictjs) => dictjs = (r1,r2) => {
    let result = r1->Js_dict.entries->Js_dict.fromArray
    r2->Js_dict.entries->Belt_Array.forEach(((k,v)) => result->Js_dict.set(k,v))
    result
}

let select: (array<'a>, array<selectExpr<'a>>) => array<dictjs> = 
    (t,s) => t->Belt.Array.map( o=>
        s->Belt.Array.map(applySingleSelect(o,_))
            ->Belt.Array.reduce(Js_dict.empty(),mergeRows)
    )

let objToTableWithChildren:('a,array<selectStage<'a>>) => array<(dictjs,option<'a>)> = (json, selectStages) => {
    selectStages->Belt.Array.reduceWithIndex(
        [(Js_dict.empty(),Some(json))],
        (acc, stage, idx) => {
            acc->flatMapArr( ( (row,jsObjOpt) ) => switch jsObjOpt {
                | None => [(row,jsObjOpt)]
                | Some(jsObj) =>
                    let newRow = select([jsObj], stage.selectors)
                        ->Belt_Array.getExn(0)
                        ->mergeRows(row)
                    switch stage.childRef {
                        | Some(func) => switch func(jsObj) {
                                            | Some([]) | None => [(newRow, None)]
                                            | Some(arr) => arr->Belt_Array.map(ch=>(newRow,Some(ch)))
                                        }
                        | None => 
                            if (idx < Belt_Array.length(selectStages)-1) {
                                exn("Intermediate selector stage must have children ref.")
                            } else {
                                [(newRow, None)]
                            }
                    }
            })
        }
    ) 
}

let objToTable = (json, selectStages) => 
    objToTableWithChildren(json, selectStages) 
    -> Belt_Array.map(( (dictjs,_) ) => dictjs)