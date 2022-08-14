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

        //let pntAdd: (point,point) => point
        //let pntTr: (point,float,float) => point
        //let pntTrVec: (point, vector) => point
        //let pntTrDir: (point, vector, float) => point
        //let pntMult: (point, float) => point
        //let pntDiv: (point, float) => point
        //let pntVec: (point,point) => vector
        //let pntRot: (point, angle) => point
        
        
        //let vecLen: vector => float
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