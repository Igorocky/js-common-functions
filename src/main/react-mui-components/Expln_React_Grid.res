open Expln_React_common

type direction = [ #column | #"column-reverse" | #row | #"row-reverse" ]
type justifyContent = [ #"flex-start" | #"center" | #"flex-end" | #"space-between" | #"space-around" | #"space-evenly" ]
type alignItems = [ #"flex-start" | #"center" | #"flex-end" | #"stretch" | #"baseline" ]
@module("@mui/material/Grid") @react.component
external make: (
    ~container:bool=?, 
    ~item:bool=?, 
    ~direction:direction=?,
    ~justifyContent:justifyContent=?,
    ~alignItems:alignItems=?,
    ~spacing:float=?,
    ~style:reStyle=?, 
    ~children: reElem=?
) => reElem = "default"