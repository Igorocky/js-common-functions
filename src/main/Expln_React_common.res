type reCmp<'a> = React.component<'a>
type reElem = React.element
type reStyle = ReactDOM.Style.t

type reClipboardHnd = ReactEvent.Clipboard.t=>unit
type reCompositionHnd = ReactEvent.Composition.t=>unit
type reKeyboardHnd = ReactEvent.Keyboard.t=>unit
type reFocusHnd = ReactEvent.Focus.t=>unit
type reFormHnd = ReactEvent.Form.t=>unit
type reMouseHnd = ReactEvent.Mouse.t=>unit
type rePointerHnd = ReactEvent.Pointer.t=>unit
type reSelectionHnd = ReactEvent.Selection.t=>unit
type reTouchHnd = ReactEvent.Touch.t=>unit
type reUIHnd = ReactEvent.UI.t=>unit
type reWheelHnd = ReactEvent.Wheel.t=>unit
type reMediaHnd = ReactEvent.Media.t=>unit
type reImageHnd = ReactEvent.Image.t=>unit
type reAnimationHnd = ReactEvent.Animation.t=>unit
type reTransitionHnd = ReactEvent.Transition.t=>unit

let evt2Str = strConsumer => e => strConsumer(ReactEvent.Form.target(e)["value"])
let evt2Bool = boolConsumer => e => boolConsumer(ReactEvent.Form.target(e)["checked"])

@module("react")
external useState: 'a => ('a, 'a => unit) = "useState"
