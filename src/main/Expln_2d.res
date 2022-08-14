type point = {x: float, y: float}
type vector = {begin: point, end: point}
type angle = float

let ex = {begin:{x:0., y:0.}, end:{x:1., y:0.}}
let ey = {begin:{x:0., y:0.}, end:{x:0., y:1.}}

let deg: float => angle = d => d /. 180. *. Js.Math._PI
let rad: float => angle = r => r
let toDeg: angle => float = a => a /. Js.Math._PI *. 180.
let toRad: angle => float = a => a


let pntLen: point => float = p => Js.Math.sqrt(p.x *. p.x +. p.y *. p.y)
let pntSub: (point,point) => point = (a,b) => {x: a.x -. b.x, y: a.y -. b.y}
let pntAdd: (point,point) => point = (a,b) => {x: a.x +. b.x, y: a.y +. b.y}
let pntTr: (point,float,float) => point = (p,dx,dy) => {x: p.x +. dx, y: p.y +. dy}
let pntTrVec: (point, vector) => point = (p,v) => p->pntTr(v.end.x -. v.begin.x, v.end.y -. v.begin.y)
let pntMult: (point, float) => point = (p, x) => {x: p.x *. x, y: p.y *. x}
let pntDiv: (point, float) => point = (p, x) => {x: p.x /. x, y: p.y /. x}
let pntVec: (point,point) => vector = (b,e) => {begin:b, end:e}
let pntRot: (point, angle) => point = (p,a) => {
    x: p.x *. Js.Math.cos(a) -. p.y *. Js.Math.sin(a),
    y: p.x *. Js.Math.sin(a) +. p.y *. Js.Math.cos(a),
}


let vecLen: vector => float = v => v.end -> pntSub(v.begin) -> pntLen
let vecMult: (vector, float) => vector = (v,x) => {begin: v.begin -> pntMult(x), end: v.end -> pntMult(x)}
let vecMultVec: (vector, vector) => float = (v1, v2) => {
    let a = v1.end -> pntSub(v1.begin)
    let b = v2.end -> pntSub(v2.begin)
    a.x *. b.x +. a.y *. b.y
}
let vecDiv: (vector, float) => vector = (v,x) => {begin: v.begin -> pntDiv(x), end: v.end -> pntDiv(x)}
let vecAdd: (vector, vector) => vector = (a,b) => {begin: a.begin -> pntAdd(b.begin), end: a.end -> pntAdd(b.end)}
let vecRot: (vector, angle) => vector = (v,a) => {
    begin: v.begin,
    end: v.begin -> pntAdd(v.end -> pntSub(v.begin) -> pntRot(a))
}
let vecNorm: vector => vector = v => v -> vecDiv(v -> vecLen)
let vecSwapEnds: vector => vector = v => {begin: v.end, end:v.begin}
let vecBeginAt: (vector, point) => vector = (v,p) => {begin: p, end: p -> pntTrVec(v)}
let vecEndAt: (vector, point) => vector = (v,p) => v -> vecSwapEnds -> vecBeginAt(p) -> vecSwapEnds
let vecTr: (vector, float, float) => vector = (v,dx,dy) => {begin: v.begin->pntTr(dx,dy), end: v.end->pntTr(dx,dy)}
let vecTrVec: (vector, vector) => vector = (v,t) => {
    let dx = t.end.x -. t.begin.x
    let dy = t.end.y -. t.begin.y
    v -> vecTr(dx,dy)
}
let vecTrDir: (vector, vector, float) => vector = (v,dir,x) => v -> vecTrVec(dir -> vecNorm -> vecMult(x))

let pntTrDir: (point, vector, float) => point = (p, dir, dist) => p -> pntTrVec(dir -> vecNorm -> vecMult(dist))
let vecRev: vector => vector = vecRot(_, deg(180.))