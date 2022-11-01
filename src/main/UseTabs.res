open Expln_React_common
open Expln_React_Mui

type tab<'a> = {
    data: 'a
}

type tabMethods<'a> = {
    addTab: (~data:'a) => unit,
}

type st<'a> = {
    tabs: array<tab<'a>>,
}

let initSt = {
    tabs: [],
}

let addTab = (st, ~data:'a) => {
    let newTabs = st.tabs->Js_array2.concat([{data:data}])
    ()
}

let useTabs = ():tabMethods<'a> => {
    let (state, setState) = useStateF(initSt)

    let addTab = (~data:'a) => {
        setState(prev => {
            prev->addTab(~data)
            prev
        })
    }

    {
        addTab: addTab,
    }
}