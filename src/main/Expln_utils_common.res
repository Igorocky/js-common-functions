let exn = str => Js.Exn.raiseError(str)

let arrFlatMap = (arr,func) => arr -> Belt.Array.map(func)->Belt.Array.concatMany
let arrIsEmpty = arr => Belt_Array.size(arr) == 0

let id = x => x

let stringify = a => Js.Json.stringifyAny(a) -> Belt.Option.getExn

let promiseFlatMap = (promise,mapper) => promise -> Js.Promise.then_(mapper, _)
let promiseMap = (promise,mapper) => promise -> promiseFlatMap(value => Js_promise.resolve(mapper(value)))