open Expln_React_common

type variant = [#text|#contained|#outlined]
@module("@mui/material/Button") @react.component
external make: (
    ~onClick: reMouseHnd=?, 
    ~variant:variant=?, 
    ~children: reElem=?
) => reElem = "default"
