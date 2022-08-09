type jsonAny

let parseObjOpt: (string, jsonAny=>'a) => result<option<'a>,string>
let parseObj: (string, jsonAny=>'a) => result<'a,string>

let objOpt: (jsonAny, string, jsonAny => 'a) => option<'a>
let obj: (jsonAny, string, jsonAny => 'a) => 'a

let arrOpt: (jsonAny, string, jsonAny => 'a) => option<array<'a>>
let arr: (jsonAny, string, jsonAny => 'a) => array<'a>

let strOpt: (jsonAny, string) => option<string>
let str: (jsonAny, string) => string

let numOpt: (jsonAny, string) => option<float>
let num: (jsonAny, string) => float

let runTests___: unit => unit