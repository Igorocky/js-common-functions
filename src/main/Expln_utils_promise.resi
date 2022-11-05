type promise<'a> = Js.Promise.t<'a>
let promise: (('a => unit) => unit) => promise<'a>
let prFlatMap: (promise<'a>, 'a => promise<'b>) => promise<'b>
let prMap: (promise<'a>, 'a => 'b) => promise<'b>
