@module("fs")
external readFileSync: string => {..} = "readFileSync"

let readStringFromFile = path => readFileSync(path)["toString"](.)