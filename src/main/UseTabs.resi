type tab<'a> = {
    data: 'a
}

type tabMethods<'d> = {
    addTab: (~data:'d) => tab<'d>,
}

let useTabs: 'c => tabMethods<'c>
