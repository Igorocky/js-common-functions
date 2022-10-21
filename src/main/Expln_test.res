@val external describe: (string, (. unit)=>unit) => unit = "describe"
@val external describe_skip: (string, (. unit)=>unit) => unit = "describe.skip"
@val external it: (string, (. unit)=>unit) => unit = "it"
@val external it_skip: (string, (. unit)=>unit) => unit = "it.skip"

let {exn, stringify} = module(Expln_utils_common)

let assertEq = (actual:'a, expected:'a) => {
    if (expected != actual) {
        exn(`\n  actual: ${stringify(actual)}\nexpected: ${stringify(expected)}`)
    }
}

let assertEqMsg = (actual:'a, expected:'a, msg:string) => {
    if (expected != actual) {
        exn(`\nAssertion failed for '${msg}'\n  actual: ${stringify(actual)}\nexpected: ${stringify(expected)}`)
    }
}

let assertEqNum = (actual: float, expected: float, precision: float) => {
    if (actual <= expected -. precision || actual >= expected +. precision) {
        exn(`\n  actual: ${Js.String.make(actual)}\nexpected: ${Js.String.make(expected)}`)
    }
}

let assertEqNumMsg = (actual: float, expected: float, precision: float, msg:string) => {
    if (actual <= expected -. precision || actual >= expected +. precision) {
        exn(`\nAssertion failed for '${msg}'\n  actual: ${Js.String.make(actual)}\nexpected: ${Js.String.make(expected)}`)
    }
}


let fail = () => exn("Test failed.")
let failMsg = str => exn("Test failed: " ++ str)