let exn = str => Js.Exn.raiseError(str)

@new external createArray: int => array<'a> = "Array"
let arrFlatMap = (arr,func) => arr -> Belt.Array.map(func)->Belt.Array.concatMany
let arrStrDistinct = arr => arr->Belt_Set.String.fromArray->Belt_Set.String.toArray
let arrIntDistinct = arr => arr->Belt_Set.Int.fromArray->Belt_Set.Int.toArray

let strJoin = (ss:array<string>, ~sep:string="", ()):string => {
    let lastIdx = ss->Js.Array2.length - 1
    ss->Js.Array2.mapi((s,i) => if (i != lastIdx) {s++sep} else {s})->Js_string2.concatMany("", _)
}

let toIntCmp: (('a,'a)=>float) => (('a,'a)=>int) = cmp => (a,b) => cmp(a,b)
    ->Js_math.sign_float
    ->Js_math.floor_int
let intCmp = (a:int, b:int) => if a < b {-1} else if a == b {0} else {1}
let floatCmp = (a:float ,b:float) => if a < b {-1} else if a == b {0} else {1}
let strCmp = Js.String2.localeCompare->toIntCmp
let strCmpI = (s1,s2) => strCmp(s1->Js_string2.toLocaleUpperCase ,s2->Js_string2.toLocaleUpperCase)
let cmpRev = cmp => (a,b) => -cmp(a,b)

let stringify: 'a => string = a => switch Js.Json.stringifyAny(a) {
    | Some(str) => str
    | None => exn(`Could not stringify '${Js.String2.make(a)}'`)
}

let promiseFlatMap = (promise,mapper) => promise -> Js.Promise.then_(mapper, _)
let promiseMap = (promise,mapper) => promise -> promiseFlatMap(value => Js_promise.resolve(mapper(value)))