open Expln_React_common

@module("@mui/material/Select") @react.component
external make: (
    ~labelId:string=?,
    ~label:string=?,
    ~value:string,
    ~onChange:reFormHnd=?,
    ~children:reElem=?
) => reElem = "default"