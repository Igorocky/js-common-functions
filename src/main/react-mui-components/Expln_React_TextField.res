open Expln_React_common

type size = [ #medium | #small ]
type variant = [ #filled | #outlined | #standard ]

@module("@mui/material/TextField") @react.component
external make: (
    ~value:string=?,
    ~label:string=?,
    ~size:size=?,
    ~variant:variant=?,
    ~multiline:bool=?,
    ~minRows:int=?,
    ~maxRows:int=?,
    ~rows:int=?,
    ~onChange:reFormHnd=?,
    ~inputProps:{..}=?,
    ~disabled:bool=?,
    ~autoFocus:bool=?,
) => reElem = "default"