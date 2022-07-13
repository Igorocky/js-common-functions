let {log,log2} = module(Js.Console)
let {exn,flatMapArr,cast} = module(Expln_utils_common)
let {classify} = module(Js.Json)
let {reduce} = module(Belt.List)

type path = list<string>
type json = Js.Json.t
type dictjs = Js.Dict.t<json>

let emptyDict = Js.Dict.empty()
type table = array<dictjs>
type selectExpr<'a> =
    | Attr({attr:string, name:string})
    | Func({func:'a=>json, name:string})
type selectStage<'a> = {
    selectors: array<selectExpr<'a>>,
    childRef: option<'a=>option<array<'a>>>,
}
type objToTableConfig<'a> = {
    selectStages: array<selectStage<'a>>,
    columnOrder: Belt.Map.String.t<int>,
}

let pathToStr = (p: path) => switch p {
    | list{} => "/"
    | _ => p->reduce("", (a,b) => a ++ "/" ++ b)
}

let objOpt_: (json, path, (dictjs, path) => 'a) => option<'a> = 
(json, pathToJson, mapper) =>
    switch json->classify {
    | Js.Json.JSONObject(dict) => Some(mapper(dict,pathToJson))
    | Js.Json.JSONNull => None
    | _ => exn(`an object was expected at '${pathToStr(pathToJson)}'.`)
    }

//try to use underscores here
let obj_ = (json, pathToJson, mapper) => 
    switch objOpt_(json,pathToJson,mapper) {
    | Some(o) => o
    | None => exn(`an object was expected at '${pathToStr(pathToJson)}'.`)
    }

let objOpt: (string,dictjs,path,(json,path)=>'a) => option<'a> = 
(attrName,dict,pathToDict,mapper) =>
    switch dict->Js_dict.get(attrName) {
    | Some(json) => Some(mapper(json,list{attrName,...pathToDict}))
    | None => None
    }

let obj = (attrName,dict,pathToDict,mapper) =>
    switch objOpt(attrName,dict,pathToDict,mapper) {
    | Some(o) => o
    | None => exn(`an object was expected at '${pathToStr(list{attrName, ...pathToDict})}'.`)
    }
    
let arrOpt_: (json, path, (json, path) => 'a) => option<array<'a>> = 
(json, pathToJson, mapper) =>
    switch json->classify {
    | Js.Json.JSONArray(arr) => 
        Some(arr->Belt_Array.mapWithIndex((i,e)=>mapper(e,list{Js_int.toString(i),...pathToJson})))
    | Js.Json.JSONNull => None
    | _ => exn(`an array was expected at '${pathToStr(pathToJson)}'.`)
    }

//try to use underscores here
let arr_ = (json, pathToJson, mapper) => 
    switch arrOpt_(json,pathToJson,mapper) {
    | Some(a) => a
    | None => exn(`an array was expected at '${pathToStr(pathToJson)}'.`)
    }

let arrOpt: (string,dictjs,path,(json,path)=>'a) => option<array<'a>> = 
(attrName,dict,pathToDict,mapper) =>
    switch dict->Js_dict.get(attrName) {
    | Some(json) => arrOpt_(json,list{attrName,...pathToDict},mapper)
    | None => None
    }

let arr = (attrName,dict,pathToDict,mapper) =>
    switch arrOpt(attrName,dict,pathToDict,mapper) {
    | Some(a) => a
    | None => exn(`an array was expected at '${pathToStr(list{attrName, ...pathToDict})}'.`)
    }

let strOpt_: (json, path) => option<string> = 
(json, pathToJson) =>
    switch json->classify {
    | Js.Json.JSONString(str) => Some(str)
    | Js.Json.JSONNull => None
    | _ => exn(`a string was expected at '${pathToStr(pathToJson)}'.`)
    }

//try to use underscores here
let str_ = (json, pathToJson) => 
    switch strOpt_(json,pathToJson) {
    | Some(s) => s
    | None => exn(`a string was expected at '${pathToStr(pathToJson)}'.`)
    }

let strOpt: (string,dictjs,path) => option<string> = 
(attrName,dict,pathToDict) =>
    switch dict->Js_dict.get(attrName) {
    | Some(json) => strOpt_(json,list{attrName,...pathToDict})
    | None => None
    }

let str = (attrName,dict,pathToDict) =>
    switch strOpt(attrName,dict,pathToDict) {
    | Some(s) => s
    | None => exn(`a string was expected at '${pathToStr(list{attrName, ...pathToDict})}'.`)
    }

let parseObjOpt: (string,(dictjs,path)=>'a) => result<option<'a>,string> = (jsonStr, mapper) => try {
    let json = jsonStr -> Js.Json.parseExn
    Ok(objOpt_(json,list{},mapper))
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

let applySingleSelect:('a,selectExpr<'a>) => dictjs = 
(obj, sel) =>             
    switch sel {
    | Attr({attr,name}) => 
        if (!Js_json.test(obj,Js_json.Object)) {
            exn(`An attempt to apply Attr("${attr}") selector for a non-json object.`)
        } else {
            switch cast(obj)->classify {
            | Js_json.JSONObject(dict) =>
                switch dict->Js.Dict.get(attr) {
                | Some(v) => Js_dict.fromArray([(name,v)])
                | None => Js_dict.empty()
                }
            | _ => exn(`Should never happen.`)
            }
        }
    | Func({func,name}) => Js_dict.fromArray([(name,func(obj))])
    }

let v = applySingleSelect(1, Func({func:_=>Js_json.number(3.), name:"gggg"}))


let mergeRows:(dictjs,dictjs) => dictjs = (r1,r2) => {
    let result = r1->Js_dict.entries->Js_dict.fromArray
    r2->Js_dict.entries->Belt_Array.forEach(((k,v)) => result->Js_dict.set(k,v))
    result
}

let select: (array<'a>, array<selectExpr<'a>>) => array<dictjs> = 
    (t,s) => t->Belt.Array.map( o=>
        s->Belt.Array.map(applySingleSelect(o,_))
            ->Belt.Array.reduce(emptyDict,mergeRows)
    )

let objToTable:('a,objToTableConfig<'a>) => array<(dictjs,option<'a>)> = (json, cfg) => {
    cfg.selectStages->Belt.Array.reduceWithIndex(
        [(emptyDict,Some(json))],
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
    ) 
}