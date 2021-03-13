# HECSA

**HECSA** is a human-enumerated cube-solving algorithm.

[God's Number](https://www.cube20.org/) has been known for some time now, but computer-generated solutions are pretty much inscrutable. With a little help from a curated database of algorithms (in the cubing sense), HECSA finds "human-readable" solutions like the following:

    ./hecsa "U' R2 B2 F2 D U2 L2 R2 F2 R2 B U' B2 F' R' F D B' F' R'"
    x y2 // inspection
    L U R2 F R B' R' // blue cross
    U2 R' U' R // F2L 1
    U2 L U' L' // F2L 2
    U2 r' U2 R2 U R2 U r // F2L 3
    y2 R' U' R U' R' U R // F2L 4
    f R U R' U' f' // OLL 44
    x R' U R' D2 R U' R' D2 R2 x' U2 // Aa-perm
