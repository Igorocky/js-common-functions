let describe: (string, (. unit)=>unit) => unit 
let it: (string, (. unit)=>unit) => unit 

let assertEq: ('a, 'a) => unit
let assertEqNum: (float, float, float) => unit

let fail: () => unit