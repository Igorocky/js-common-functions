@val external describe: (string, (. unit)=>unit) => unit = "describe"
@val external it: (string, (. unit)=>unit) => unit = "it"

let {exn, stringify} = module(Expln_utils_common)

let assertEq = (actual:'a, expected:'a) => {
    if (expected != actual) {
        exn(`\nexpected: "${stringify(expected)}"\n  actual: "${stringify(actual)}"`)
    }
}

let assertEqNum = (actual: float, expected: float, precision: float) => {
    if (actual <= expected -. precision || actual >= expected +. precision) {
        exn(`\nexpected: "${Js.String.make(expected)}"\n  actual: "${Js.String.make(actual)}"`)
    }
}


let fail = () => exn("Test failed.")