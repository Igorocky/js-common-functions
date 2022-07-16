type jsonAny

//let object: (jsonAny, path, jsonAny => 'a) => 'a

let objOpt: (string, jsonAny, jsonAny => 'a) => option<'a>
let arrOpt: (string, jsonAny, jsonAny => 'a) => option<array<'a>>
let strOpt: (string, jsonAny) => option<string>