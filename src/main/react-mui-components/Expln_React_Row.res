open Expln_React_common

@react.component
let make = (
    ~justifyContent:option<Expln_React_Grid.justifyContent>=?,
    ~alignItems:option<Expln_React_Grid.alignItems>=?,
    ~spacing:option<float>=?,
    ~style:option<reStyle>=?, 
    ~children:option<reElem>=?
) => {
    <Expln_React_Grid container=true direction=#row ?justifyContent ?alignItems ?spacing ?style >
        {switch children {
            | Some(ch) => 
                React.Children.map(ch, c => {
                    <Expln_React_Grid item=true > c </Expln_React_Grid>
                } )
            | None => React.null
        }}
    </Expln_React_Grid>
}