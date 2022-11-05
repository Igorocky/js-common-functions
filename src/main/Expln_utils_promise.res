type promise<'a> = Js.Promise.t<'a>
let promise: (('a => unit) => unit) => promise<'a> = procedure => {
    Js.Promise.make(
        (~resolve, ~reject) => {
            try {
                procedure(result => resolve(. result))
            } catch {
                | exn => {
                    reject(. exn)
                }
            }
        }
    )
}
let prFlatMap = (promise, mapper) => promise -> Js.Promise.then_(mapper, _)
let prMap = (promise, mapper) => promise -> prFlatMap(value => Js_promise.resolve(mapper(value)))