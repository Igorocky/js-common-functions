open Expln_React_common

module TextField = Expln_React_TextField
module Grid = Expln_React_Grid
module Col = Expln_React_Column
module Row = Expln_React_Row
module Paper = Expln_React_Paper
module Button = Expln_React_Button
module Checkbox = Expln_React_Checkbox
module FormControl = Expln_React_FormControl
module InputLabel = Expln_React_InputLabel
module Select = Expln_React_Select
module MenuItem = Expln_React_MenuItem



module List = {
  @module("@mui/material/List") @react.component
  external make: (~children: React.element) => React.element = "default"
}

module ListItem = {
  @module("@mui/material/ListItem") @react.component
  external make: (~children: React.element) => React.element = "default"
}

module ListItemButton = {
  @module("@mui/material/ListItemButton") @react.component
  external make: (~onClick: _ => () =?, ~children: React.element) => React.element = "default"
}

module ListItemText = {
  @module("@mui/material/ListItemText") @react.component
  external make: (~children: React.element) => React.element = "default"
}

module ListItemIcon = {
  @module("@mui/material/ListItemIcon") @react.component
  external make: (~children: React.element) => React.element = "default"
}

module Icons = {

  module Delete = {
    @module("@mui/icons-material/Delete") @react.component
    external make: () => React.element = "default"
  }

  module BrightnessLow = {
    @module("@mui/icons-material/BrightnessLow") @react.component
    external make: () => React.element = "default"
  }
}

module RE = {

  let textField = ( ~key=?, ~value=?, ~label=?, ~size=?, ~multiline=?, ~maxRows=?, ~rows=?, ~onChange=?, ()) => 
    <TextField key=?key value=?value label=?label size=?size multiline=?multiline maxRows=?maxRows rows=?rows onChange=?onChange />


  @module("@mui/material/TextField")
  external textField2Cmp: reCmp<'a> = "default"
  let textField2 = (~value:option<string>=?, ()) => React.createElement(textField2Cmp, {
    "value":value
  })
  
  @module("@mui/material/Paper")
  external paperCmp: reCmp<'a> = "default"
  let paper = (children:array<reElem>) => React.createElement(paperCmp, {"children":children})

  @module("react")
  external re: (reCmp<'a>, {..}) => reElem = "createElement"
  @module("react")
  external reDom: (string, {..}) => reElem = "createElement"

  let paper2 = (children:array<reElem>) => re(paperCmp, {"children":children})
  let div = (children:array<reElem>) => reDom("div", {"children":children})
}