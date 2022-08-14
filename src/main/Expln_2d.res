type point = {x: float, y: float}
type vector = {b: point, e: point}
type angle = float

let ex = {b:{x:0., y:0.}, e:{x:1., y:0.}}
let ey = {b:{x:0., y:0.}, e:{x:0., y:1.}}

let deg: float => angle = d => d /. 180. *. Js.Math._PI
let rad: float => angle = r => r
let toDeg: angle => float = a => a /. Js.Math._PI *. 180.
let toRad: angle => float = a => a


let pntLen: point => float = p => Js.Math.sqrt(p.x *. p.x +. p.y *. p.y)
let pntSub: (point,point) => point = (a,b) => {x: a.x -. b.x, y: a.y -. b.y}
let pntAdd: (point,point) => point = (a,b) => {x: a.x +. b.x, y: a.y +. b.y}
let pntTr: (point,float,float) => point = (p,dx,dy) => {x: p.x +. dx, y: p.y +. dy}
let pntTrVec: (point, vector) => point = (p,v) => p->pntTr(v.e.x -. v.b.x, v.e.y -. v.b.y)
let pntMult: (point, float) => point = (p, x) => {x: p.x *. x, y: p.y *. x}
let pntDiv: (point, float) => point = (p, x) => {x: p.x /. x, y: p.y /. x}
let pntVec: (point,point) => vector = (b,e) => {b, e}
let pntRot: (point, angle) => point = (p,a) => {
    x: p.x *. Js.Math.cos(a) -. p.y *. Js.Math.sin(a),
    y: p.x *. Js.Math.sin(a) +. p.y *. Js.Math.cos(a),
}


let vecLen: vector => float = v => v.e -> pntSub(v.b) -> pntLen
let vecMult: (vector, float) => vector = (v,x) => {b: v.b -> pntMult(x), e: v.e -> pntMult(x)}
let vecMultVec: (vector, vector) => float = (v1, v2) => {
    let a = v1.e -> pntSub(v1.b)
    let b = v2.e -> pntSub(v2.b)
    a.x *. b.x +. a.y *. b.y
}
let vecDiv: (vector, float) => vector = (v,x) => {b: v.b -> pntDiv(x), e: v.e -> pntDiv(x)}
let vecAdd: (vector, vector) => vector = (a,b) => {b: a.b -> pntAdd(b.b), e: a.e -> pntAdd(b.e)}
let vecRot: (vector, angle) => vector = (v,a) => {b: v.b, e: v.b -> pntAdd(v.e -> pntSub(v.b) -> pntRot(a))}
let vecNorm: vector => vector = v => v -> vecDiv(v -> vecLen)
let vecSwapEnds: vector => vector = v => {b: v.e, e:v.b}
let vecBeginAt: (vector, point) => vector = (v,p) => {b: p, e: p -> pntTrVec(v)}
let vecEndAt: (vector, point) => vector = (v,p) => v -> vecSwapEnds -> vecBeginAt(p) -> vecSwapEnds
let vecTr: (vector, float, float) => vector = (v,dx,dy) => {b: v.b->pntTr(dx,dy), e: v.e->pntTr(dx,dy)}
let vecTrVec: (vector, vector) => vector = (v,t) => {
    let dx = t.e.x -. t.b.x
    let dy = t.e.y -. t.b.y
    v -> vecTr(dx,dy)
}
let vecTrDir: (vector, vector, float) => vector = (v,dir,x) => v -> vecTrVec(dir -> vecNorm -> vecMult(x))

let pntTrDir: (point, vector, float) => point = (p, dir, dist) => p -> pntTrVec(dir -> vecNorm -> vecMult(dist))
let vecRev: vector => vector = vecRot(_, deg(180.))