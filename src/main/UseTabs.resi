open Expln_React_common

type tab<'a> = {
    data: 'a
}

type tabMethods<'a> = {
    addTab: (~data:'a) => unit,
}

let useTabs: unit => tabMethods<'a>
