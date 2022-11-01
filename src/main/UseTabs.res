type tab<'a> = {
    data: 'a
}

type tabMethods<'d> = {
    addTab: (~data:'d) => tab<'d>,
}

type st<'t> = {
    tabs: array<tab<'t>>,
}

let initSt: 'a => st<'a> = d => {
    tabs: [],
}

let addTab = (st, ~data:'d) => {
    let newTab = {data:data}
    st.tabs->Js_array2.concat([newTab])->ignore
    newTab
}

let useTabs = (init:'c):tabMethods<'c> => {

    let addTab = (~data:'c) => {
        let newTab = {data:data}
        addTab(initSt(init), ~data)
    }

    { addTab: addTab }
}