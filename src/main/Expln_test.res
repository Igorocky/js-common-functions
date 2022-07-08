@val external describe: (string, (. unit)=>unit) => unit = "describe"
@val external it: (string, (. unit)=>unit) => unit = "it"

let {exn} = module(Expln_utils_common)

let assertStr = (expected:string, actual:string) => {
    if (expected != actual) {
        exn(`\nexpected: "${expected}"\n  actual: "${actual}"`)
    }
}