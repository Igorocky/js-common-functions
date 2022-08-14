let {describe, it, assertEq, assertEqNum} = module(Expln_test)
open Expln_2d

let precision = 0.000001

let assertEqNum = (a, b) => assertEqNum(a, b, precision)

let assertEqPnt = (p1:point,p2:point) => {
    assertEqNum(p1.x, p2.x)
    assertEqNum(p1.y, p2.y)
}

let assertEqVec = (v1:vector, v2:vector) => {
    assertEqPnt(v1.begin, v2.begin)
    assertEqPnt(v1.end, v2.end)
}

describe("Expln_2d", (.) => {
    it("test all", (.) => {
        //let ex: vector
        //let ey: vector
        assertEqVec(ex->vecRot(rad(Js.Math._PI /. 2.)), ey)

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
        assertEqPnt({x:1., y:7.}->pntTrVec({begin:{x:-3., y:7.}, end:{x:4., y:-1.}}), {x:8., y:-1.})

        //let pntTrDir: (point, vector, float) => point
        assertEqPnt({x:3., y:2.} -> pntTrDir({begin:{x:100., y:-50.}, end:{x:104., y:-53.}}, 5.), {x:7., y:-1.})

        //let pntMult: (point, float) => point
        assertEqPnt({x:-6., y:9.} -> pntMult(2.), {x:-12., y:18.})

        //let pntDiv: (point, float) => point
        assertEqPnt({x:-12., y:18.} -> pntDiv(2.), {x:-6., y:9.})

        //let pntVec: (point,point) => vector
        assertEqVec({x:7., y:10.} -> pntVec({x:-7., y:100.}), {begin:{x:7., y:10.}, end:{x:-7., y:100.}})

        //let pntRot: (point, angle) => point
        assertEqPnt({x:Js.Math.sqrt(3.) /. 2., y: 0.5} -> pntRot(deg(-150.)), {x:-0.5, y:-.Js.Math.sqrt(3.) /. 2.})
        
       let testVec = {begin:{x:3., y:4.}, end:{x:6., y:8.}}

        //let vecLen: vector => float
        assertEq(testVec -> vecLen, 5.)

        //let vecRev: vector => vector
        assertEqVec(testVec->vecRev, {begin:{x:3., y:4.}, end:{x:0., y:0.}})

        //let vecMult: (vector, float) => vector
        assertEqVec(testVec->vecMult(3.), {begin:{x:9., y:12.}, end:{x:18., y:24.}})

        //let vecMultVec: (vector, vector) => float
        assertEqNum(testVec->vecRot(deg(60.))->vecMultVec(testVec), 12.5)

        //let vecDiv: (vector, float) => vector
        assertEqVec(testVec->vecDiv(2.), {begin:{x:1.5, y:2.}, end:{x:3., y:4.}})

        //let vecAdd: (vector, vector) => vector
        assertEqVec(testVec->vecAdd({begin:{x:3., y:4.}, end:{x:6., y:8.}}), {begin:{x:6., y:8.}, end:{x:12., y:16.}})

        //let vecRot: (vector, angle) => vector
        assertEqVec(testVec->vecRot(deg(-90.)), {begin:{x:3., y:4.}, end:{x:7., y:1.}})

        //let vecNorm: vector => vector
        assertEqVec(testVec->vecNorm, {begin:{x:3. /. 5., y:4. /. 5.}, end:{x:6. /. 5., y:8. /. 5.}})

        //let vecSwapEnds: vector => vector
        assertEqVec(testVec->vecSwapEnds, {begin:{x:6., y:8.}, end:{x:3., y:4.}})

        //let vecBeginAt: (vector, point) => vector
        assertEqVec(testVec->vecBeginAt({x:100., y: -30.}), {begin:{x:100., y: -30.}, end:{x:103., y:-26.}})

        //let vecEndAt: (vector, point) => vector
        assertEqVec(testVec->vecEndAt({x:100., y: -30.}), {begin:{x:97., y: -34.}, end:{x:100., y: -30.}})

        //let vecTr: (vector, float, float) => vector
        assertEqVec(testVec->vecTr(-4., 9.), {begin:{x:-1., y:13.}, end:{x:2., y:17.}})

        //let vecTrVec: (vector, vector) => vector
        assertEqVec(
            testVec->vecTrVec({begin:{x:-7., y: 11.}, end:{x:23., y: -1.}}),
            {begin:{x:33., y:-8.}, end:{x:36., y:-4.}}
        )

        //let vecTrDir: (vector, vector, float) => vector
        assertEqVec(testVec->vecTrDir(testVec, 5.), {begin:{x:6., y:8.}, end:{x:9., y:12.}})
    })
})