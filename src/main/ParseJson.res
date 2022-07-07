type param = {
    name: string,
    value: string,
}

type path = list<string>
type json = Js.Json.t
type jsmap = Js.Dict.t<json>
let exn = str => Js.Exn.raiseError(str)

let pathToStr = (p: path) => p->Belt.List.reduce("", (a,b) => a ++ "/" ++ b)

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

let getStringFromDict: (Js.Dict.t<Js.Json.t>, string) => Belt.Result.t<string,string> = 
    (dict,attr) => switch dict -> Js.Dict.get(attr) {
        | Some(json) => switch json -> Js.Json.classify {
                            | Js.Json.JSONString(str) => Ok(str)
                            | _ => Error("a string expected")
                        }
        | None => Error("attribute expected")
    }

let parseParam2: string => Belt.Result.t<param,string> = 
    str => switch str -> Js.Json.parseExn -> Js.Json.classify {
        | Js.Json.JSONObject(dict) => Ok({
            name: getStringFromDict(dict, "name") -> Belt.Result.getExn,
            value: getStringFromDict(dict, "value") -> Belt.Result.getExn,
        })
        | exception ex => {
            let msg = ex 
                -> Js.Exn.asJsExn 
                -> Belt.Option.flatMap(Js.Exn.message)
                -> Belt.Option.getWithDefault("no message was provided.")
            Error( "Parse error: " ++ msg)
        }
        | _ => Error("object was expected.")
    }

let p = parseParam2(`{
    "name": "AAA",
    "value": "BBB"
}`)

switch p {
    | Ok(p) => "Parsed: " ++ (Js.Json.stringifyAny(p) -> Belt.Option.getWithDefault("###"))
    | Error(msg) => msg
} -> Js.Console.log