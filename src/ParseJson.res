type param = {
    name: string,
    value: string,
}

let pathToStr = (path: list<string>) => path->Belt.List.reduce("", (a,b) => a ++ "/" ++ b)

let objExn = (json: Js.Json.t, pathToThis: list<string>, mapper:(Js.Dict.t<Js.Json.t>) => 'a) => 
    switch json->Js.Json.classify {
        | Js.Json.JSONObject(dict) => mapper(dict)
        | _ => Js.Exn.raiseError("object was expected at '" ++ pathToStr(pathToThis) ++ "'.")
    }

let strAttr(dict: Js.Dict.t<Js.Json.t>, pathToParent: list<string>, name:string) => 
    switch dict -> Js.Dict.get(attr) {
        | Some(json) => switch json -> Js.Json.classify {
                            | Js.Json.JSONString(str) => str
                            | _ => Js.Exn.raiseError("a string was expected at '" ++ pathToStr(pathToThis) ++ "'.")
                        }
        | None => Error("attribute expected")
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