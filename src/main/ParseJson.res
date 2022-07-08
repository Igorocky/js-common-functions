type param = {
    name: string,
    value: string,
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