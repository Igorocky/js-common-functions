open Expln_React_common

@module("@mui/material/Paper") @react.component
external make: (
    ~onClick:reMouseHnd=?,
    ~style: reStyle=?,
    ~children: reElem=?
) => reElem = "default"
