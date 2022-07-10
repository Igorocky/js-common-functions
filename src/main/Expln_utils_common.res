let exn = str => Js.Exn.raiseError(str)

let flatMapArr = (arr,func) => arr -> Belt.Array.map(func)->Belt.Array.concatMany