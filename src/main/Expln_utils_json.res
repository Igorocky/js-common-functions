let {log,log2} = module(Js.Console)
let {exn,flatMapArr} = module(Expln_utils_common)
let {classify} = module(Js.Json)
let {reduce} = module(Belt.List)

type path = list<string>
type json = Js.Json.t
type dictjs = Js.Dict.t<json>

type mapjs = Belt.Map.String.t<json>
let emptyRow = Belt.Map.String.empty
type table = array<mapjs>
type selectExpr =
    | Attr({attr:string, name:string})
    | Func({func:dictjs=>json, name:string})
type selectStage = {
    selectors: array<selectExpr>,
    childRef: option<json=>option<array<json>>>,
}
type objToTableConfig = {
    selectStages: array<selectStage>,
    columnOrder: Belt.Map.String.t<int>,
}

let pathToStr = (p: path) => switch p {
    | list{} => "/"
    | _ => p->reduce("", (a,b) => a ++ "/" ++ b)
}

let objOpt: (json, path, (dictjs, path) => 'a) => option<'a> = 
    (js, pathToThis, mapper) =>
        switch js->classify {
            | Js.Json.JSONObject(dict) => Some(mapper(dict,pathToThis))
            | Js.Json.JSONNull => None
            | _ => exn(`an object was expected at '${pathToStr(pathToThis)}'.`)
        }

let obj: (json, path, (dictjs, path) => 'a) => 'a = 
    (js, pathToThis, mapper) => 
        switch objOpt(js,pathToThis,mapper) {
            | Some(o) => o
            | None => exn(`an object was expected at '${pathToStr(pathToThis)}'.`)
        }

let jsonToArrOpt = (js: json, pathToThis: path, mapper: (json,path) => 'a) =>
    switch js->classify {
        | Js.Json.JSONArray(arr) => Some(arr->Belt_Array.map(e=>mapper(e,pathToThis)))
        | Js.Json.JSONNull => None
        | _ => exn(`an array was expected at '${pathToStr(pathToThis)}'.`)
    }

let arrOpt: (string, dictjs, path, (json,path) => 'a) => option<array<'a>> = 
    (name, dict, pathToParent, mapper) => 
        switch dict -> Js.Dict.get(name) {
            | Some(js) => jsonToArrOpt(js, list{name, ...pathToParent}, mapper)
            | None => None
        }

let arr: (string, dictjs, path, (json,path) => 'a) => array<'a> = 
    (name, dict, pathToParent, mapper) => 
        switch arrOpt(name, dict, pathToParent, mapper) {
            | Some(arr) => arr
            | None => exn(`an array was expected at '${pathToStr(list{name, ...pathToParent})}'.`)
        }

let jsonToStrOpt = (js: json, pathToThis: path) =>
    switch js->classify {
        | Js.Json.JSONString(str) => Some(str)
        | Js.Json.JSONNull => None
        | _ => exn(`a string was expected at '${pathToStr(pathToThis)}'.`)
    }

let strOpt: (string, dictjs, path) => option<string> = 
    (name, dict, pathToParent) => 
        switch dict -> Js.Dict.get(name) {
            | Some(js) => jsonToStrOpt(js, list{name, ...pathToParent})
            | None => None
        }

let str: (string, dictjs, path) => string = 
    (name, dict, pathToParent) => 
        switch strOpt(name, dict, pathToParent) {
            | Some(str) => str
            | None => exn(`a string was expected at '${pathToStr(list{name, ...pathToParent})}'.`)
        }

let parseObjOpt = (jsonStr, mapper) => try {
    let js = jsonStr -> Js.Json.parseExn
    Ok(objOpt(js,list{},mapper))
} catch {
    | ex =>
        let msg = ex 
            -> Js.Exn.asJsExn 
            -> Belt.Option.flatMap(Js.Exn.message)
            -> Belt.Option.getWithDefault("no message was provided.")
        Error( "Parse error: " ++ msg)
}

let parseObj = (jsonStr, mapper) =>
    switch parseObjOpt(jsonStr, mapper) {
        | Ok(Some(o)) => Ok(o)
        | Ok(None) => Error(`An object was expected.`)
        | Error(msg) => Error(msg)
    }

let jsonToStr = json =>
    switch json -> classify {
        | Js_json.JSONFalse => "false"
        | Js_json.JSONTrue => "true"
        | Js_json.JSONNull => "null"
        | Js_json.JSONString(str) => str
        | Js_json.JSONNumber(num) => num->Js_float.toString
        | Js_json.JSONObject(_) => "<object>"
        | Js_json.JSONArray(_) => "<array>"
    }

let rowToStr: mapjs => string = row => {
    let content = row -> Belt_Map.String.keysToArray 
        -> Belt_Array.map(k => `"${k}": "${row->Belt_Map.String.getExn(k)->jsonToStr}"`)
        -> Belt_Array.reduce("", (a,e) => e ++ ", ")
    "{" ++ content ++ "}"
}

let applySingleSelect:(json,selectExpr) => mapjs = 
    (obj, sel) => switch obj->classify {
        | Js.Json.JSONObject(d) =>
            switch sel {
                | Attr({attr,name}) => 
                    switch d->Js.Dict.get(attr) {
                        | Some(v) => Belt.Map.String.fromArray([(name,v)])
                        | None => Belt.Map.String.fromArray([(name,Js.Json.null)])
                    }
                | Func({func,name}) => Belt.Map.String.fromArray([(name,func(d))])
            }
        | _ => exn("an attempt to apply applySingleSelect to a non-object.")
    }

let mergeRows:(mapjs,mapjs) => mapjs = (r1,r2) => 
    r1->Belt.Map.String.reduce(r2,(a,k,v)=>a->Belt.Map.String.set(k,v))

let select: (array<json>, array<selectExpr>) => table = 
    (t,s) => t->Belt.Array.map( o=>
        s->Belt.Array.map(applySingleSelect(o,_))
            ->Belt.Array.reduce(emptyRow,mergeRows)
    )

let objToTable = (jsObj, cfg) => {
    cfg.selectStages->Belt.Array.reduceWithIndex(
        [(emptyRow,Some(jsObj))],
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
                            if (idx < Belt_Array.length(cfg.selectStages)-1) {
                                exn("Intermediate selector stage must have children ref.")
                            } else {
                                [(newRow, None)]
                            }
                    }
            })
        }
    ) -> Belt_Array.map(( (row,_) ) => row)
}