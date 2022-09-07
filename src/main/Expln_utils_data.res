open Expln_utils_common

let {log,log2} = module(Js.Console)

type selectExpr<'a,'b> = 'a=>(string,'b)
type selectStage<'a,'b> = {
    selectors: array<selectExpr<'a,'b>>,
    childRef: option<'a=>option<array<'a>>>,
}

let applySingleSelect:('a,selectExpr<'a,'b>) => Js.Dict.t<'b> = 
(obj, sel) => Js_dict.fromArray([sel(obj)])

let mergeRows:(Js_dict.t<'b>,Js_dict.t<'b>) => Js_dict.t<'b> = (r1,r2) => {
    let result = r1->Js_dict.entries->Js_dict.fromArray
    r2->Js_dict.entries->Belt_Array.forEach(((k,v)) => result->Js_dict.set(k,v))
    result
}

let select: (array<'a>, array<selectExpr<'a,'b>>) => array<Js_dict.t<'b>> = 
    (objects,selectors) => {
        objects->arrMap( o=>
                        selectors->arrMap(applySingleSelect(o,_))
            ->arrReduce(Js.Dict.empty(),mergeRows)

        )
    }

let objToTableWithChildren:('a,array<selectStage<'a,'b>>) => array<(Js_dict.t<'b>,option<'a>)> = (json, selectStages) => {
    selectStages->Belt.Array.reduceWithIndex(
        [(Js_dict.empty(),Some(json))],
        (acc, stage, idx) => {
            acc->arrFlatMap( ( (row,jsObjOpt) ) => switch jsObjOpt {
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
    -> arrMap(( (dictjs,_) ) => dictjs)