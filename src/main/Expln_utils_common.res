let exn = str => Js.Exn.raiseError(str)

let minI = Js.Math.min_int
let maxI = Js.Math.max_int
let minF = Js.Math.min_float
let maxF = Js.Math.max_float
let f2i = Belt.Int.fromFloat
let f2s = Belt.Float.toString
let i2f = Belt.Int.toFloat
let i2s = Belt.Int.toString
let ints = Belt_Array.range
let ceil = Js_math.ceil_float
let floor = Js_math.floor_float

@new external createArray: int => array<'a> = "Array"

let arrSize = Belt.Array.size
let arrIsEmpty = arr => arrSize(arr) == 0
let arrMap = Belt.Array.map
let arrFlatMap = (arr,func) => arr -> Belt.Array.map(func)->Belt.Array.concatMany
let arrReduce = Belt.Array.reduce
let arrSortInPlace = Js.Array2.sortInPlaceWith
let arrStrDistinct = arr => arr
    -> Belt_Set.String.fromArray
    -> Belt_Set.String.toArray
let arrIntDistinct = arr => arr
    -> Belt_Set.Int.fromArray
    -> Belt_Set.Int.toArray

let strSize = Js.String2.length
let upper = Js.String2.toLocaleUpperCase
let lower = Js.String2.toLocaleLowerCase
let strJoin = (ss:array<string>, ~sep:string):string => {
    let lastIdx = ss->Js.Array2.length - 1
    ss->Js.Array2.mapi((s,i) => if (i != lastIdx) {s++sep} else {s})->Js_string2.concatMany("", _)
}

let toIntCmp: (('a,'a)=>float) => (('a,'a)=>int) = cmp => (a,b) => cmp(a,b)
    ->Js_math.sign_float
    ->Js_math.floor_int
let intCmp = (a:int, b:int) => if a < b {-1} else if a == b {0} else {1}
let floatCmp = (a:float ,b:float) => if a < b {-1} else if a == b {0} else {1}
let strCmp = Js.String2.localeCompare->toIntCmp
let strCmpI = (s1,s2) => strCmp(s1->upper,s2->upper)
let cmpRev = cmp => (a,b) => -cmp(a,b)

let stringify: 'a => string = a => switch Js.Json.stringifyAny(a) {
    | Some(str) => str
    | None => exn(`Could not stringify '${Js.String2.make(a)}'`)
}

let promiseFlatMap = (promise,mapper) => promise -> Js.Promise.then_(mapper, _)
let promiseMap = (promise,mapper) => promise -> promiseFlatMap(value => Js_promise.resolve(mapper(value)))