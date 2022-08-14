let {describe, it, assertEq, assertEqNum} = module(Expln_test)
open Expln_2d

let precision = 0.000001

let assertEqNum = (a, b) => assertEqNum(a, b, precision)

let assertEqPnt = (p1:point,p2:point) => {
    assertEqNum(p1.x, p2.x)
    assertEqNum(p1.y, p2.y)
}

let assertEqVec = (v1:vector, v2:vector) => {
    assertEqPnt(v1.b, v2.b)
    assertEqPnt(v1.e, v2.e)
}

describe("Expln_2d", (.) => {
    it("test all", (.) => {
        //let deg: float => angle
        //let rad: float => angle
        //let toDeg: angle => float
        //let toRad: angle => float
        assertEqNum(deg(45.) -> toRad, 0.785398)
        assertEqNum(rad(2.14675) -> toDeg, 122.9997147)
        
        //let pntLen: point => float
        assertEqNum({x:3., y:4.} -> pntLen, 5.)

        //let pntSub: (point,point) => point
        assertEqPnt({x:1., y:7.}->pntSub({x:6.,y:-2.}), {x:-5., y:9.})

        //let pntAdd: (point,point) => point
        assertEqPnt({x:1., y:7.}->pntAdd({x:6.,y:-2.}), {x:7., y:5.})

        //let pntTr: (point,float,float) => point
        assertEqPnt({x:1., y:7.}->pntTr(9., -3.), {x:10., y:4.})

        //let pntTrVec: (point, vector) => point
        assertEqPnt({x:1., y:7.}->pntTrVec({b:{x:-3., y:7.}, e:{x:4., y:-1.}}), {x:8., y:-1.})

        //let pntTrDir: (point, vector, float) => point
        assertEqPnt({x:3., y:2.} -> pntTrDir({b:{x:100., y:-50.}, e:{x:104., y:-53.}}, 5.), {x:7., y:-1.})

        //let pntMult: (point, float) => point
        assertEqPnt({x:-6., y:9.} -> pntMult(2.), {x:-12., y:18.})

        //let pntDiv: (point, float) => point
        assertEqPnt({x:-12., y:18.} -> pntDiv(2.), {x:-6., y:9.})

        //let pntVec: (point,point) => vector
        assertEqVec({x:7., y:10.} -> pntVec({x:-7., y:100.}), {b:{x:7., y:10.}, e:{x:-7., y:100.}})

        //let pntRot: (point, angle) => point
        assertEqPnt({x:Js.Math.sqrt(3.) /. 2., y: 0.5} -> pntRot(deg(-150.)), {x:-0.5, y:-.Js.Math.sqrt(3.) /. 2.})
        
       let testVec = {b:{x:3., y:4.}, e:{x:6., y:8.}} 

        //let vecLen: vector => float
        assertEq(testVec -> vecLen, 5.)
        //let vecRev: vector => vector
        //let vecMult: (vector, float) => vector
        //let vecMultVec: (vector, vector) => float
        //let vecDiv: (vector, float) => vector
        //let vecAdd: (vector, vector) => vector
        //let vecRot: (vector, angle) => vector
        //let vecNorm: vector => vector
        //let vecSwapEnds: vector => vector
        //let vecBeginAt: (vector, point) => vector
        //let vecEndAt: (vector, point) => vector
        //let vecTr: (vector, float, float) => vector
        //let vecTrVec: (vector, vector) => vector
        //let vecTrDir: (vector, vector, float) => vector
    })
})