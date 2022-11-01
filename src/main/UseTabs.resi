open Expln_React_common

type tab<'a> = {
    data: 'a
}

type tabMethods<'a> = {
    addTab: (~label:string, ~closable:bool, ~data:'a) => unit,
}

let useTabs: unit => tabMethods<'a>
