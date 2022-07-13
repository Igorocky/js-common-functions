@val external describe: (string, (. unit)=>unit) => unit = "describe"
@val external it: (string, (. unit)=>unit) => unit = "it"

let {exn,cast} = module(Expln_utils_common)

let assertTrue = (actual:bool) => {
    if (!actual) {
        exn(`true was expected`)
    }
}

let assertEq = (expected:'a, actual:'a) => {
    if (expected != actual) {
        exn(`\nexpected: "${cast(expected)}"\n  actual: "${cast(actual)}"`)
    }
}


let fail = () => exn("Test failed.")