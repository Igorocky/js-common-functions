let {describe,it,assertEq,assertTrue,fail} = module(Expln_test)

let {exn} = module(Expln_utils_common)
let {classify} = module(Js.Json)
let {reduce} = module(Belt.List)

type path = list<string>
let rootPath = list{}

let pathToStr = (p: path) => switch p {
    | list{} => "/"
    | _ => p->reduce("", (a,b) => a ++ "/" ++ b)
}

let pathToStr2 = (path,attrName) => pathToStr(list{attrName, ...path})

type json = Js.Json.t

type jsonAny = 
    | JsonNull(path)
    | JsonObj(Js_dict.t<Js_json.t>, path)
    | JsonArr(array<Js_json.t>, path)
    | JsonStr(string, path)

let jsonToAny: (json,path) => jsonAny = (json,path) =>
    switch json->classify {
        | Js_json.JSONNull => JsonNull(path)
        | Js_json.JSONObject(dict) => JsonObj(dict,path)
        | Js_json.JSONArray(arr) => JsonArr(arr,path)
        | Js_json.JSONString(str) => JsonStr(str,path)
        | _ => exn("Not implemented.")
    }

let getPath = jsonAny => 
    switch jsonAny {
        | JsonNull(path) | JsonObj(_,path) | JsonArr(_,path) | JsonStr(_,path) => path
    }

let location = jsonAny => jsonAny -> getPath -> pathToStr
let location2 = (jsonAny,nextPathElem) => jsonAny -> getPath -> pathToStr2(_,nextPathElem)

let attrOpt: (jsonAny, string, (json,path) => option<'a>) => option<'a> = (jsonAny, attrName, mapper) =>
    switch jsonAny {
        | JsonObj(dict,path) => 
            switch dict->Js_dict.get(attrName) {
                | Some(json) => mapper(json,list{attrName, ...path})
                | None => None
            }
        | JsonNull(path) | JsonStr(_,path) | JsonArr(_,path) => exn(`an object was expected at '${pathToStr(path)}'.`)
    }

let objOpt: (jsonAny, string, jsonAny => 'a) => option<'a> = (jsonAny, attrName, mapper) =>
    attrOpt(jsonAny, attrName, (json,path) =>
        switch json->classify {
            | Js_json.JSONNull => None
            | Js_json.JSONObject(_) => Some(json -> jsonToAny(path) -> mapper)
            | _ => exn(`an object was expected at '${pathToStr(path)}'.`)
        }
    )

let obj: (jsonAny, string, jsonAny => 'a) => 'a = (jsonAny, attrName, mapper) =>
    switch objOpt(jsonAny, attrName, mapper) {
        | Some(o) => o
        | None => exn(`an object was expected at '${location2(jsonAny, attrName)}'.`)
    }

let arrOpt: (jsonAny, string, jsonAny => 'a) => option<array<'a>> = (jsonAny, attrName, mapper) =>
    attrOpt(jsonAny, attrName, (json,path) =>
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

let arr: (jsonAny, string, jsonAny => 'a) => array<'a> = (jsonAny, attrName, mapper) =>
    switch arrOpt(jsonAny, attrName, mapper) {
        | Some(a) => a
        | None => exn(`an array was expected at '${location2(jsonAny, attrName)}'.`)
    }

let strOpt: (jsonAny, string) => option<string> = (jsonAny, attrName) =>
    attrOpt(jsonAny, attrName, (json,path) =>
        switch json->classify {
            | Js_json.JSONNull => None
            | Js_json.JSONString(str) => Some(str)
            | _ => exn(`a string was expected at '${pathToStr(path)}'.`)
        }
    )

let str: (jsonAny, string) => string = (jsonAny, attrName) =>
    switch strOpt(jsonAny, attrName) {
        | Some(s) => s
        | None => exn(`a string was expected at '${location2(jsonAny, attrName)}'.`)
    }

let parseObjOpt: (string, jsonAny=>'a) => result<option<'a>,string> = (jsonStr, mapper) => try {
    switch jsonStr -> Js.Json.parseExn -> classify {
        | Js_json.JSONNull => Ok(None)
        | Js_json.JSONObject(dict) => JsonObj(dict, rootPath) -> mapper -> Some -> Ok
        | _ => exn(`an object was expected at '/'.`)
    }
} catch {
    | ex =>
        let msg = ex 
            -> Js.Exn.asJsExn 
            -> Belt.Option.flatMap(Js.Exn.message)
            -> Belt.Option.getWithDefault("no message was provided.")
        Error( "Parse error: " ++ msg)
}

let parseObj: (string, jsonAny=>'a) => result<'a,string> = (jsonStr, mapper) => 
    switch parseObjOpt(jsonStr, mapper) {
        | Ok(Some(obj)) => Ok(obj)
        | Error(str) => Error(str)
        | _ => Error(`Parse error: an object was expected at '/'.`)
    }

let runTests___ = () => {
    describe("pathToStr", (.) => {
        it("should return slash for empty path", (.) => {
            assertEq("/", pathToStr(list{}))
        })
        it("should return slash separated values for non-empty path", (.) => {
            assertEq("/settings/14/name", pathToStr(list{"settings", "14", "name"}))
        })
    })
}