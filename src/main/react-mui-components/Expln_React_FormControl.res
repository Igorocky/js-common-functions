open Expln_React_common

@module("@mui/material/FormControl") @react.component
external make: (
    ~disabled:bool=?,
    ~children:reElem=?
) => reElem = "default"