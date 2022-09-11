
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
module InputAdornment = Expln_React_InputAdornment
module IconButton = Expln_React_IconButton



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
  
  module Clear = {
    @module("@mui/icons-material/Clear") @react.component
    external make: () => React.element = "default"
  }

  module BrightnessLow = {
    @module("@mui/icons-material/BrightnessLow") @react.component
    external make: () => React.element = "default"
  }
}
