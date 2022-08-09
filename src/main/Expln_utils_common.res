let exn = str => Js.Exn.raiseError(str)

let arrFlatMap = (arr,func) => arr -> Belt.Array.map(func)->Belt.Array.concatMany

let id = x => x