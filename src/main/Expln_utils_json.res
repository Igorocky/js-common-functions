type path = list<string>
type json = Js.Json.t
type jsmap = Js.Dict.t<json>
let exn = str => Js.Exn.raiseError(str)

let pathToStr = (p: path) => p->Belt.List.reduce("/", (a,b) => a ++ "/" ++ b)

let objOptExn = (js: json, pathToThis: path, mapper:(jsmap,path) => 'a) => 
    switch js->Js.Json.classify {
        | Js.Json.JSONObject(dict) => Some(mapper(dict))
        | Js.Json.JSONNull => None
        | _ => exn(`an object was expected at '${pathToStr(pathToThis)}'.`)
    }

let strOptExn = (js: json, pathToThis: path) => 
    switch js->Js.Json.classify {
        | Js.Json.JSONString(str) => Some(str)
        | Js.Json.JSONNull => None
        | _ => exn(`a string was expected at '${pathToStr(pathToThis)}'.`)
    }

let strAttrOptExn = (dict: jsmap, name:string, pathToParent: path) => 
    switch dict -> Js.Dict.get(name) {
        | Some(js) => strOptExn(js, list{name, ...pathToParent})
        | None => None
    }

