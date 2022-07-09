let {exn} = module(Expln_utils_common)
let {classify} = module(Js.Json)
let {reduce} = module(Belt.List)

type path = list<string>
type json = Js.Json.t
type jsmap = Js.Dict.t<json>

let pathToStr = (p: path) => switch p {
    | list{} => "/"
    | _ => p->reduce("", (a,b) => a ++ "/" ++ b)
}

let objOpt = (js:json, pathToThis:path, mapper: (jsmap,path) => 'a) =>
    switch js->classify {
        | Js.Json.JSONObject(dict) => Some(mapper(dict,pathToThis))
        | Js.Json.JSONNull => None
        | _ => exn(`an object was expected at '${pathToStr(pathToThis)}'.`)
    }

let obj = (js: json, pathToThis: path, mapper:(jsmap,path) => 'a) => 
    switch objOpt(js,pathToThis,mapper) {
        | Some(o) => o
        | None => exn(`an object was expected at '${pathToStr(pathToThis)}'.`)
    }

let jsonToStrOpt = (js: json, pathToThis: path) => 
    switch js->classify {
        | Js.Json.JSONString(str) => Some(str)
        | Js.Json.JSONNull => None
        | _ => exn(`a string was expected at '${pathToStr(pathToThis)}'.`)
    }

let strOpt = (name:string, dict: jsmap, pathToParent: path) => 
    switch dict -> Js.Dict.get(name) {
        | Some(js) => jsonToStrOpt(js, list{name, ...pathToParent})
        | None => None
    }

let str = (name:string, dict: jsmap, pathToParent: path) => 
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