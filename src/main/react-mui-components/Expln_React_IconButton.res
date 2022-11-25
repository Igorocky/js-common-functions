open Expln_React_common

type variant = [#text|#contained|#outlined]
@module("@mui/material/IconButton") @react.component
external make: (
    ~onClick: reMouseHnd=?, 
    ~color: string=?, 
    ~style: reStyle=?,
    ~component:string=?,
    ~disabled:bool=?,
    ~children: reElem=?
) => reElem = "default"
