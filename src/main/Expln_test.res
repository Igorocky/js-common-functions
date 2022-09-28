@val external describe: (string, (. unit)=>unit) => unit = "describe"
@val external it: (string, (. unit)=>unit) => unit = "it"

let {exn, stringify} = module(Expln_utils_common)

let assertEq = (actual:'a, expected:'a) => {
    if (expected != actual) {
        exn(`\n  actual: '${stringify(actual)}'\nexpected: '${stringify(expected)}'`)
    }
}

let assertEqNum = (actual: float, expected: float, precision: float) => {
    if (actual <= expected -. precision || actual >= expected +. precision) {
        exn(`\n  actual: '${Js.String.make(actual)}'\nexpected: '${Js.String.make(expected)}'`)
    }
}


let fail = () => exn("Test failed.")