open Expln_React_common

type variant = [#text|#contained|#outlined]
@module("@mui/material/IconButton") @react.component
external make: (
    ~onClick: reMouseHnd=?, 
    ~children: reElem=?
) => reElem = "default"
