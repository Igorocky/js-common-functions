let {log,log2} = module(Js.Console)
let {exn,flatMapArr,cast} = module(Expln_utils_common)
let {classify} = module(Js.Json)
let {reduce} = module(Belt.List)

type path = list<string>
let rootPath = list{}
type json = Js.Json.t
type dictjs = Js.Dict.t<json>
let emptyDict = Js.Dict.empty()

let pathToStr = (p: path) => switch p {
    | list{} => "/"
    | _ => p->reduce("", (a,b) => a ++ "/" ++ b)
}

type jsonAny = 
    | JsonNull(path)
    | JsonDict(Js_dict.t<Js_json.t>, path)
    | JsonArr(array<Js_json.t>, path)
    | JsonStr(string, path)

let jsonToAny: (json,path) => jsonAny = (json,path) =>
    switch json->classify {
        | Js_json.JSONNull => JsonNull(path)
        | Js_json.JSONObject(dict) => JsonDict(dict,path)
        | Js_json.JSONArray(arr) => JsonArr(arr,path)
        | Js_json.JSONString(str) => JsonStr(str,path)
        | _ => exn("Not implemented.")
    }

let attrOpt: (string, jsonAny, (json,path) => option<'a>) => option<'a> = (attrName, jsonAny, mapper) =>
    switch jsonAny {
        | JsonDict(dict,path) => 
            switch dict->Js_dict.get(attrName) {
                | Some(json) => mapper(json,list{attrName, ...path})
                | None => None
            }
        | JsonNull(path) | JsonStr(_,path) | JsonArr(_,path) => exn(`an object was expected at '${pathToStr(path)}'.`)
    }

let objOpt: (string, jsonAny, jsonAny => 'a) => option<'a> = (attrName, jsonAny, mapper) =>
    attrOpt(attrName, jsonAny, (json,path) => 
        switch json->classify {
            | Js_json.JSONNull => None
            | Js_json.JSONObject(_) => Some(json -> jsonToAny(path) -> mapper)
            | _ => exn(`an object was expected at '${pathToStr(path)}'.`)
        }
    )

let arrOpt: (string, jsonAny, jsonAny => 'a) => option<array<'a>> = (attrName, jsonAny, mapper) =>
    attrOpt(attrName, jsonAny, (json,path) => 
        switch json->classify {
            | Js_json.JSONNull => None
            | Js_json.JSONArray(arr) => 
                Some(
                    arr 
                        -> Js_array2.mapi((e,i) => jsonToAny(e, list{Js_int.toString(i), ...path})) 
                        -> Js_array2.map(mapper)
                )
            | _ => exn(`an array was expected at '${pathToStr(path)}'.`)
        }
    )

let strOpt: (string, jsonAny) => option<string> = (attrName, jsonAny) =>
    attrOpt(attrName, jsonAny, (json,path) => 
        switch json->classify {
            | Js_json.JSONNull => None
            | Js_json.JSONString(str) => Some(str)
            | _ => exn(`a string was expected at '${pathToStr(path)}'.`)
        }
    )

let parseObjOpt: (string, jsonAny=>option<'a>) => result<option<'a>,string> = (jsonStr, mapper) => try {
    let json = jsonStr -> Js.Json.parseExn
    Ok(mapper(jsonToAny(json, rootPath)))
} catch {
    | ex =>
        let msg = ex 
            -> Js.Exn.asJsExn 
            -> Belt.Option.flatMap(Js.Exn.message)
            -> Belt.Option.getWithDefault("no message was provided.")
        Error( "Parse error: " ++ msg)
}