@new external createFileReader: unit => {..} = "FileReader"

@react.component
let make = (~onChange: string=>'a) => {
   <input type_="file" onChange={ev=>{
        let fr = createFileReader()
        fr["onload"] = () => {
            fr["result"]->onChange
        }
        fr["readAsBinaryString"](. ReactEvent.Synthetic.nativeEvent(ev)["target"]["files"][0])
   }}  /> 
}