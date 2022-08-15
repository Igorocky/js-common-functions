
type point
type vector
type angle

let ex: vector
let ey: vector

let deg: float => angle
let rad: float => angle
let toDeg: angle => float
let toRad: angle => float

let pntX: point => float
let pntY: point => float
let pntLen: point => float
let pntSub: (point,point) => point
let pntAdd: (point,point) => point
//let pntTr: (point,float,float) => point
let pntTrVec: (point, vector) => point
let pntTrDir: (point, vector, float) => point
let pntMult: (point, float) => point
let pntDiv: (point, float) => point
let pntVec: (point,point) => vector
let pntRot: (point, angle) => point

let vecBegin: vector => point
let vecEnd: vector => point
let vecLen: vector => float
let vecRev: vector => vector
let vecMult: (vector, float) => vector
let vecMultVec: (vector, vector) => float
let vecDiv: (vector, float) => vector
let vecAdd: (vector, vector) => vector
let vecRot: (vector, angle) => vector
let vecNorm: vector => vector
let vecSwapEnds: vector => vector
let vecBeginAt: (vector, point) => vector
let vecEndAt: (vector, point) => vector
//let vecTr: (vector, float, float) => vector
let vecTrVec: (vector, vector) => vector
let vecTrDir: (vector, vector, float) => vector