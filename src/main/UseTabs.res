open Expln_React_common
open Expln_React_Mui

type tab<'a> = {
    data: 'a
}

type tabMethods<'a> = {
    addTab: (~label:string, ~closable:bool, ~data:'a) => unit,
}

type st<'a> = {
    nextId: int,
    tabs: array<tab<'a>>,
}

let initSt = {
    nextId: 0,
    tabs: [],
}

let getNextId = st => {
    ({...st, nextId: st.nextId+1}, st.nextId->Belt_Int.toString)
}

let addTab = (st, ~label:string, ~closable:bool, ~data:'a) => {
    let newTabs = st.tabs->Js_array2.concat([{data}])
    ()
}

let useTabs = ():tabMethods<'a> => {
    let (state, setState) = useStateF(initSt)

    let addTab = (~label:string, ~closable:bool, ~data:'a) => {
        setState(prev => {
            prev->addTab(~label, ~closable, ~data)
            prev
        })
    }

    {
        addTab: addTab,
    }
}