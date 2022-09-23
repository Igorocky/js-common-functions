open Expln_React_common

type size = [ #medium | #small ]

@module("@mui/material/TextField") @react.component
external make: (
    ~value:string=?,
    ~label:string=?,
    ~size:size=?, 
    ~multiline:bool=?,
    ~minRows:int=?,
    ~maxRows:int=?,
    ~rows:int=?,
    ~onChange:reFormHnd=?,
    ~inputProps:{..}=?,
    ~disabled:bool=?,
    ~autoFocus:bool=?,
) => reElem = "default"