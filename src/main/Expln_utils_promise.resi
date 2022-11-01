let promise: (('a => unit) => unit) => Js.Promise.t<'a>
let prFlatMap: (Js.Promise.t<'a>, 'a => Js.Promise.t<'b>) => Js.Promise.t<'b>
let prMap: (Js.Promise.t<'a>, 'a => 'b) => Js.Promise.t<'b>
