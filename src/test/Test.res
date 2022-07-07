let passedCnt = ref(0)
let failedCnt = ref(0)

type testToRun = {descr:string,body:unit=>unit}

let allTests = ref(list{})

let test = (descr, body) => {
    allTests:=list{{descr,body}, ...allTests.contents}
}

let runTest = (test:testToRun) => try {
    test.body()
    passedCnt:=passedCnt.contents+1
    ()
} catch {
    | ex => 
        failedCnt:=failedCnt.contents+1
        `FAILED: ${test.descr}`->Js.Console.log
        ex
            ->Js.Exn.asJsExn
            ->Belt.Option.flatMap(Js.Exn.message)
            ->Belt.Option.getWithDefault("\tNo error message is available.")
            ->Js.Console.log
        ()
}

let runAllTests = _ => allTests.contents->Belt.List.forEach(runTest)