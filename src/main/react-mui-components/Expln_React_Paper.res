open Expln_React_common

type variant = [ #elevation | #outlined ]

@module("@mui/material/Paper") @react.component
external make: (
    ~onClick:reMouseHnd=?,
    ~elevation:int=?,
    ~style: reStyle=?,
    ~variant:variant=?,
    ~square:bool=?,
    ~children: reElem=?
) => reElem = "default"
