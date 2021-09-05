#![recursion_limit="768"]

extern crate engine25519_as;
use engine25519_as::*;

fn main() -> std::io::Result<()> {
    let mcode = assemble_engine25519!(
               start:
                    // P.U in %20
                    // P.W in %21
                    // Q.U in %22
                    // Q.W in %23
                    // affine_PmQ in %24 // I
                    // %30 is the TRD scratch register and cswap dummy
                    // %29 is the subtraction temporary value register and k_t
                    // x0.U in %25 // I
                    // x0.W in %26 // I
                    // x1.U in %27 // I
                    // x1.W in %28 /// I
                    // %19 is the loop counter, starts with 254 (if 0, loop runs exactly once) // I
                    // %31 is the scalar // I
                    // %18 is the swap variable
                    psa %18, #0

                    // for i in (0..255).rev()
                mainloop:
                    // let choice: u8 = (bits[i + 1] ^ bits[i]) as u8;
                    // ProjectivePoint::conditional_swap(&mut x0, &mut x1, choice.into());
                    xbt %29, %31        // orignally[k_t = (k>>t) & 1] now[k_t = k[254]]
                    shl %31, %31        // k = k<<1
                    xor %18, %18, %29   // swap ^= k_t

                    // cswap x0.U (%25), x1.U (%27)
                    xor %30, %25, %27
                    msk %30, %18, %30
                    xor %25, %30, %25
                    xor %27, %30, %27
                    // cswap x0.W (%26), x1.W (%28)
                    xor %30, %26, %28
                    msk %30, %18, %30
                    xor %26, %30, %26
                    xor %28, %30, %28

                    psa %18, %29  // swap = k_t

                        // differential_add_and_double(&mut x0, &mut x1, &affine_u);
                        psa %20, %25
                        psa %21, %26
                        psa %22, %27
                        psa %23, %28
                        // affine_u is already in %24

                        // let t0 = &P.U + &P.W;
                        add %0, %20, %21
                        trd %30, %0
                        sub %0, %0, %30
                        // let t1 = &P.U - &P.W;
                        sub %21, #3, %21    // negate &P.W using #FIELDPRIME (#3)
                        add %1, %20, %21
                        trd %30, %1
                        sub %1, %1, %30
                        // let t2 = &Q.U + &Q.W;
                        add %2, %22, %23
                        trd %30, %2
                        sub %2, %2, %30
                        // let t3 = &Q.U - &Q.W;
                        sub %23, #3, %23
                        add %3, %22, %23
                        trd %30, %3
                        sub %3, %3, %30
                        // let t4 = t0.square();   // (U_P + W_P)^2 = U_P^2 + 2 U_P W_P + W_P^2
                        mul %4, %0, %0
                        // let t5 = t1.square();   // (U_P - W_P)^2 = U_P^2 - 2 U_P W_P + W_P^2
                        mul %5, %1, %1
                        // let t6 = &t4 - &t5;     // 4 U_P W_P
                        sub %29, #3, %5
                        add %6, %4, %29
                        trd %30, %6
                        sub %6, %6, %30
                        // let t7 = &t0 * &t3;     // (U_P + W_P) (U_Q - W_Q) = U_P U_Q + W_P U_Q - U_P W_Q - W_P W_Q
                        mul %7, %0, %3
                        // let t8 = &t1 * &t2;     // (U_P - W_P) (U_Q + W_Q) = U_P U_Q - W_P U_Q + U_P W_Q - W_P W_Q
                        mul %8, %1, %2
                        // let t9  = &t7 + &t8;    // 2 (U_P U_Q - W_P W_Q)
                        add %9, %7, %8
                        trd %30, %9
                        sub %9, %9, %30
                        // let t10 = &t7 - &t8;    // 2 (W_P U_Q - U_P W_Q)
                        sub %29, #3, %8
                        add %10, %7, %29
                        trd %30, %10
                        sub %10, %10, %30
                        // let t11 =  t9.square(); // 4 (U_P U_Q - W_P W_Q)^2
                        mul %11, %9, %9
                        // let t12 = t10.square(); // 4 (W_P U_Q - U_P W_Q)^2
                        mul %12, %10, %10
                        // let t13 = &APLUS2_OVER_FOUR * &t6; // (A + 2) U_P U_Q
                        mul %13, #4, %6   // #4 is A+2/4
                        // let t14 = &t4 * &t5;    // ((U_P + W_P)(U_P - W_P))^2 = (U_P^2 - W_P^2)^2
                        mul %14, %4, %5
                        // let t15 = &t13 + &t5;   // (U_P - W_P)^2 + (A + 2) U_P W_P
                        add %15, %13, %5
                        trd %30, %15
                        sub %15, %15, %30
                        // let t16 = &t6 * &t15;   // 4 (U_P W_P) ((U_P - W_P)^2 + (A + 2) U_P W_P)
                        mul %16, %6, %15
                        // let t17 = affine_PmQ * &t12; // U_D * 4 (W_P U_Q - U_P W_Q)^2
                        mul %17, %24, %12    // affine_PmQ loaded into %24

                        ///// these can be eliminated down the road, but included for 1:1 algorithm correspodence to reference in early testing
                        // P.U = t14;  // U_{P'} = (U_P + W_P)^2 (U_P - W_P)^2
                        psa %20, %14
                        // P.W = t16;  // W_{P'} = (4 U_P W_P) ((U_P - W_P)^2 + ((A + 2)/4) 4 U_P W_P)
                        psa %21, %16
                        // let t18 = t11;               // W_D * 4 (U_P U_Q - W_P W_Q)^2
                        // Q.U = t18;  // U_{Q'} = W_D * 4 (U_P U_Q - W_P W_Q)^2
                        psa %22, %11   // collapsed two to save a register
                        // Q.W = t17;  // W_{Q'} = U_D * 4 (W_P U_Q - U_P W_Q)^2
                        psa %23, %17

                        ///// 'return' arguments for next iteration, can be optimized out later
                        psa %25, %20
                        psa %26, %21
                        psa %27, %22
                        psa %28, %23

                    brz end, %19     // if loop counter is 0, quit
                    sub %19, %19, #1 // subtract one from the loop counter and run again
                    brz mainloop, #0    // go back to the top
                end:
                    // ProjectivePoint::conditional_swap(&mut x0, &mut x1, Choice::from(bits[0] as u8));
                    // cswap x0.U (%25), x1.U (%27)
                    xor %30, %25, %27
                    msk %30, %18, %30
                    xor %25, %30, %25
                    xor %27, %30, %27
                    // cswap x0.W (%26), x1.W (%28)
                    xor %30, %26, %28
                    msk %30, %18, %30
                    xor %26, %30, %26
                    xor %28, %30, %28

                    // AFFINE SPLICE -- pass arguments to the affine block
                    psa %29, %25
                    psa %30, %26
                    // W.invert() in %21
                    // U in %29
                    // W in %30
                    // result in %31
                    // loop counter in %28

                    // from FieldElement.invert()
                        // let (t19, t3) = self.pow22501();   // t19: 249..0 ; t3: 3,1,0
                        // let t0  = self.square();           // 1         e_0 = 2^1
                        mul %0, %30, %30  // self is W, e.g. %30
                        // let t1  = t0.square().square();    // 3         e_1 = 2^3
                        mul %1, %0, %0
                        mul %1, %1, %1
                        // let t2  = self * &t1;              // 3,0       e_2 = 2^3 + 2^0
                        mul %2, %30, %1
                        // let t3  = &t0 * &t2;               // 3,1,0
                        mul %3, %0, %2
                        // let t4  = t3.square();             // 4,2,1
                        mul %4, %3, %3
                        // let t5  = &t2 * &t4;               // 4,3,2,1,0
                        mul %5, %2, %4

                        // let t6  = t5.pow2k(5);             // 9,8,7,6,5
                        psa %28, #5       // coincidentally, constant #5 is the number 5
                        mul %6, %5, %5
                    pow2k_5:
                        sub %28, %28, #1  // %28 = %28 - 1
                        brz pow2k_5_exit, %28
                        mul %6, %6, %6
                        brz pow2k_5, #0
                    pow2k_5_exit:
                        // let t7  = &t6 * &t5;               // 9,8,7,6,5,4,3,2,1,0
                        mul %7, %6, %5

                        // let t8  = t7.pow2k(10);            // 19..10
                        psa %28, #6        // constant #6 is the number 10
                        mul %8, %7, %7
                    pow2k_10:
                        sub %28, %28, #1
                        brz pow2k_10_exit, %28
                        mul %8, %8, %8
                        brz pow2k_10, #0
                    pow2k_10_exit:
                        // let t9  = &t8 * &t7;               // 19..0
                        mul %9, %8, %7

                        // let t10 = t9.pow2k(20);            // 39..20
                        psa %28, #7         // constant #7 is the number 20
                        mul %10, %9, %9
                    pow2k_20:
                        sub %28, %28, #1
                        brz pow2k_20_exit, %28
                        mul %10, %10, %10
                        brz pow2k_20, #0
                    pow2k_20_exit:
                        // let t11 = &t10 * &t9;              // 39..0
                        mul %11, %10, %9

                        // let t12 = t11.pow2k(10);           // 49..10
                        psa %28, #6         // constant #6 is the number 10
                        mul %12, %11, %11
                    pow2k_10b:
                        sub %28, %28, #1
                        brz pow2k_10b_exit, %28
                        mul %12, %12, %12
                        brz pow2k_10b, #0
                    pow2k_10b_exit:
                        // let t13 = &t12 * &t7;              // 49..0
                        mul %13, %12, %7

                        // let t14 = t13.pow2k(50);           // 99..50
                        psa %28, #8         // constant #8 is the number 50
                        mul %14, %13, %13
                    pow2k_50a:
                        sub %28, %28, #1
                        brz pow2k_50a_exit, %28
                        mul %14, %14, %14
                        brz pow2k_50a, #0
                    pow2k_50a_exit:
                        // let t15 = &t14 * &t13;             // 99..0
                        mul %15, %14, %13

                        // let t16 = t15.pow2k(100);          // 199..100
                        psa %28, #9         // constant #9 is the number 100
                        mul %16, %15, %15
                    pow2k_100:
                        sub %28, %28, #1
                        brz pow2k_100_exit, %28
                        mul %16, %16, %16
                        brz pow2k_100, #0
                    pow2k_100_exit:
                        // let t17 = &t16 * &t15;             // 199..0
                        mul %17, %16, %15

                        // let t18 = t17.pow2k(50);           // 249..50
                        psa %28, #8         // constant #8 is the number 50
                        mul %18, %17, %17
                    pow2k_50b:
                        sub %28, %28, #1
                        brz pow2k_50b_exit, %28
                        mul %18, %18, %18
                        brz pow2k_50b, #0
                    pow2k_50b_exit:
                        // let t19 = &t18 * &t13;             // 249..0
                        mul %19, %18, %13
                        //(t19, t3) // just a return value, values are already there, do nothing

                        //let t20 = t19.pow2k(5);            // 254..5
                        psa %28, #5
                        mul %20, %19, %19
                    pow2k_5_last:
                        sub %28, %28, #1
                        brz pow2k_5_last_exit, %28
                        mul %20, %20, %20
                        brz pow2k_5_last, #0
                    pow2k_5_last_exit:

                        //let t21 = &t20 * &t3;              // 254..5,3,1,0
                        mul %21, %20, %3

                    // u = &self.U * &self.W.invert()
                    mul %31, %29, %21
                    fin  // finish execution
    );
    let mcode_upd = assemble_engine25519!(
               start:
                    // P.U in %20
                    // P.W in %21
                    // Q.U in %22
                    // Q.W in %23
                    // affine_PmQ in %24 // I
                    // %30 is the TRD scratch register and cswap dummy
                    // %29 is the subtraction temporary value register and k_t
                    // x0.U in %25 // !I
                    // x0.W in %26 // !I
                    // x1.U in %27 // !I
                    // x1.W in %28 // !I
                    // %19 is the loop counter, starts with 254 (if 0, loop runs exactly once) // I
                    // %31 is the scalar // I
                    // %18 is the swap variable
					psa %25, #1
					psa %26, #0
					psa %27, %24
					psa %28, #1
					// #10 is 254 in my Engine
					psa %19, #10
                    psa %18, #0

                    // for i in (0..255).rev()
                mainloop:
                    // let choice: u8 = (bits[i + 1] ^ bits[i]) as u8;
                    // ProjectivePoint::conditional_swap(&mut x0, &mut x1, choice.into());
                    xbt %29, %31        // orignally[k_t = (k>>t) & 1] now[k_t = k[254]]
                    shl %31, %31        // k = k<<1
                    xor %18, %18, %29   // swap ^= k_t

                    // cswap x0.U (%25), x1.U (%27)
                    xor %30, %25, %27
                    msk %30, %18, %30
                    xor %25, %30, %25
                    xor %27, %30, %27
                    // cswap x0.W (%26), x1.W (%28)
                    xor %30, %26, %28
                    msk %30, %18, %30
                    xor %26, %30, %26
                    xor %28, %30, %28

                    psa %18, %29  // swap = k_t

                        // differential_add_and_double(&mut x0, &mut x1, &affine_u);
                        // affine_u is already in %24

                        // let t0 = &P.U + &P.W;
                        add %0, %25, %26
                        trd %30, %0
                        sub %0, %0, %30
                        // let t1 = &P.U - &P.W;
                        sub %26, #3, %26    // negate &P.W using #FIELDPRIME (#3)
                        add %1, %25, %26
                        trd %30, %1
                        sub %1, %1, %30
                        // let t2 = &Q.U + &Q.W;
                        add %2, %27, %28
                        trd %30, %2
                        sub %2, %2, %30
                        // let t3 = &Q.U - &Q.W;
                        sub %28, #3, %28
                        add %3, %27, %28
                        trd %30, %3
                        sub %3, %3, %30
                        // let t4 = t0.square();   // (U_P + W_P)^2 = U_P^2 + 2 U_P W_P + W_P^2
                        mul %4, %0, %0
                        // let t5 = t1.square();   // (U_P - W_P)^2 = U_P^2 - 2 U_P W_P + W_P^2
                        mul %5, %1, %1
                        // let t6 = &t4 - &t5;     // 4 U_P W_P
                        sub %29, #3, %5
                        add %6, %4, %29
                        trd %30, %6
                        sub %6, %6, %30
                        // let t7 = &t0 * &t3;     // (U_P + W_P) (U_Q - W_Q) = U_P U_Q + W_P U_Q - U_P W_Q - W_P W_Q
                        mul %7, %0, %3
                        // let t8 = &t1 * &t2;     // (U_P - W_P) (U_Q + W_Q) = U_P U_Q - W_P U_Q + U_P W_Q - W_P W_Q
                        mul %8, %1, %2
                        // let t9  = &t7 + &t8;    // 2 (U_P U_Q - W_P W_Q)
                        add %9, %7, %8
                        trd %30, %9
                        sub %9, %9, %30
                        // let t10 = &t7 - &t8;    // 2 (W_P U_Q - U_P W_Q)
                        sub %29, #3, %8
                        add %10, %7, %29
                        trd %30, %10
                        sub %10, %10, %30
                        // let t11 =  t9.square(); // 4 (U_P U_Q - W_P W_Q)^2
                        mul %27, %9, %9
                        // let t12 = t10.square(); // 4 (W_P U_Q - U_P W_Q)^2
                        mul %12, %10, %10
                        // let t13 = &APLUS2_OVER_FOUR * &t6; // (A + 2) U_P U_Q
                        mul %13, #4, %6   // #4 is A+2/4
                        // let t14 = &t4 * &t5;    // ((U_P + W_P)(U_P - W_P))^2 = (U_P^2 - W_P^2)^2
                        mul %25, %4, %5
                        // let t15 = &t13 + &t5;   // (U_P - W_P)^2 + (A + 2) U_P W_P
                        add %15, %13, %5
                        trd %30, %15
                        sub %15, %15, %30
                        // let t16 = &t6 * &t15;   // 4 (U_P W_P) ((U_P - W_P)^2 + (A + 2) U_P W_P)
                        mul %26, %6, %15
                        // let t17 = affine_PmQ * &t12; // U_D * 4 (W_P U_Q - U_P W_Q)^2
                        mul %28, %24, %12    // affine_PmQ loaded into %24

                    brz end, %19     // if loop counter is 0, quit
                    sub %19, %19, #1 // subtract one from the loop counter and run again
                    brz mainloop, #0    // go back to the top
                end:
                    // ProjectivePoint::conditional_swap(&mut x0, &mut x1, Choice::from(bits[0] as u8));
                    // cswap x0.U (%25), x1.U (%27)
                    xor %30, %25, %27
                    msk %30, %18, %30
                    xor %25, %30, %25
                    xor %27, %30, %27
                    // cswap x0.W (%26), x1.W (%28)
                    xor %30, %26, %28
                    msk %30, %18, %30
                    xor %26, %30, %26
                    xor %28, %30, %28

                    // AFFINE SPLICE -- pass arguments to the affine block
                    psa %29, %25
                    psa %30, %26
                    // W.invert() in %21
                    // U in %29
                    // W in %30
                    // result in %31
                    // loop counter in %28

                    // from FieldElement.invert()
                        // let (t19, t3) = self.pow22501();   // t19: 249..0 ; t3: 3,1,0
                        // let t0  = self.square();           // 1         e_0 = 2^1
                        mul %0, %30, %30  // self is W, e.g. %30
                        // let t1  = t0.square().square();    // 3         e_1 = 2^3
                        mul %1, %0, %0
                        mul %1, %1, %1
                        // let t2  = self * &t1;              // 3,0       e_2 = 2^3 + 2^0
                        mul %2, %30, %1
                        // let t3  = &t0 * &t2;               // 3,1,0
                        mul %3, %0, %2
                        // let t4  = t3.square();             // 4,2,1
                        mul %4, %3, %3
                        // let t5  = &t2 * &t4;               // 4,3,2,1,0
                        mul %5, %2, %4

                        // let t6  = t5.pow2k(5);             // 9,8,7,6,5
                        psa %28, #5       // coincidentally, constant #5 is the number 5
                        mul %6, %5, %5
                    pow2k_5:
                        sub %28, %28, #1  // %28 = %28 - 1
                        brz pow2k_5_exit, %28
                        mul %6, %6, %6
                        brz pow2k_5, #0
                    pow2k_5_exit:
                        // let t7  = &t6 * &t5;               // 9,8,7,6,5,4,3,2,1,0
                        mul %7, %6, %5

                        // let t8  = t7.pow2k(10);            // 19..10
                        psa %28, #6        // constant #6 is the number 10
                        mul %8, %7, %7
                    pow2k_10:
                        sub %28, %28, #1
                        brz pow2k_10_exit, %28
                        mul %8, %8, %8
                        brz pow2k_10, #0
                    pow2k_10_exit:
                        // let t9  = &t8 * &t7;               // 19..0
                        mul %9, %8, %7

                        // let t10 = t9.pow2k(20);            // 39..20
                        psa %28, #7         // constant #7 is the number 20
                        mul %10, %9, %9
                    pow2k_20:
                        sub %28, %28, #1
                        brz pow2k_20_exit, %28
                        mul %10, %10, %10
                        brz pow2k_20, #0
                    pow2k_20_exit:
                        // let t11 = &t10 * &t9;              // 39..0
                        mul %11, %10, %9

                        // let t12 = t11.pow2k(10);           // 49..10
                        psa %28, #6         // constant #6 is the number 10
                        mul %12, %11, %11
                    pow2k_10b:
                        sub %28, %28, #1
                        brz pow2k_10b_exit, %28
                        mul %12, %12, %12
                        brz pow2k_10b, #0
                    pow2k_10b_exit:
                        // let t13 = &t12 * &t7;              // 49..0
                        mul %13, %12, %7

                        // let t14 = t13.pow2k(50);           // 99..50
                        psa %28, #8         // constant #8 is the number 50
                        mul %14, %13, %13
                    pow2k_50a:
                        sub %28, %28, #1
                        brz pow2k_50a_exit, %28
                        mul %14, %14, %14
                        brz pow2k_50a, #0
                    pow2k_50a_exit:
                        // let t15 = &t14 * &t13;             // 99..0
                        mul %15, %14, %13

                        // let t16 = t15.pow2k(100);          // 199..100
                        psa %28, #9         // constant #9 is the number 100
                        mul %16, %15, %15
                    pow2k_100:
                        sub %28, %28, #1
                        brz pow2k_100_exit, %28
                        mul %16, %16, %16
                        brz pow2k_100, #0
                    pow2k_100_exit:
                        // let t17 = &t16 * &t15;             // 199..0
                        mul %17, %16, %15

                        // let t18 = t17.pow2k(50);           // 249..50
                        psa %28, #8         // constant #8 is the number 50
                        mul %18, %17, %17
                    pow2k_50b:
                        sub %28, %28, #1
                        brz pow2k_50b_exit, %28
                        mul %18, %18, %18
                        brz pow2k_50b, #0
                    pow2k_50b_exit:
                        // let t19 = &t18 * &t13;             // 249..0
                        mul %19, %18, %13
                        //(t19, t3) // just a return value, values are already there, do nothing

                        //let t20 = t19.pow2k(5);            // 254..5
                        psa %28, #5
                        mul %20, %19, %19
                    pow2k_5_last:
                        sub %28, %28, #1
                        brz pow2k_5_last_exit, %28
                        mul %20, %20, %20
                        brz pow2k_5_last, #0
                    pow2k_5_last_exit:

                        //let t21 = &t20 * &t3;              // 254..5,3,1,0
                        mul %21, %20, %3

                    // u = &self.U * &self.W.invert()
                    mul %31, %29, %21
                    fin  // finish execution
    );
	
    let mcode2 = assemble_engine25519!(
               start:
                    // P.U in %20
                    // P.W in %21
                    // Q.U in %22
                    // Q.W in %23
                    // affine_PmQ in %24 // I
                    // %30 is the TRD scratch register and cswap dummy
                    // %29 is the subtraction temporary value register and k_t
                    // x0.U in %25 // I
                    // x0.W in %26 // I
                    // x1.U in %27 // I
                    // x1.W in %28 /// I
                    // %19 is the loop counter, starts with 254 (if 0, loop runs exactly once) // I
                    // %31 is the scalar // I
                    // %18 is the swap variable
					psa %25, #9
					psa %26, #1
					mul %27, %25, %26
					mul %28, %25, %25
					mul %31, %24, %24
					fin
    );

	let gcmcode_test = assemble_engine25519!(
               start:
                    // A in %0
					// B in %1
					clmul %4, %0, %1, #0
					clmul %5, %0, %1, #1
					clmul %6, %0, %1, #2
					clmul %7, %0, %1, #3
					//gcm_sl1ai %8, %0, %1
					//gcm_sl1ai %9, %0, #0
					//gcm_sl1ai %10, %1, %0
					//gcm_sl1ai %11, %1, #0
					gcm_cmpd %12, %0
					gcm_cmpd %13, %1
					//gcm_sri %14, %0, #0
					//gcm_sri %15, %0, #1
					//gcm_sri %16, %0, #2
					//gcm_sri %17, %0, #3
					//gcm_sri %18, %0, #4
					//gcm_sri %19, %0, #5
					//gcm_sri %20, %0, #6
					//gcm_sri %21, %0, #7
					fin
    );
	let gcmcode = assemble_engine25519!(
               start:
                    // A in %0
					// B in %1
					
					// // poly mult
					// C
					clmul %4, %0, %1, #0
					// E
					clmul %5, %0, %1, #1
					// F
					clmul %6, %0, %1, #2
					// D
					clmul %7, %0, %1, #3
					// E ^ F
					xor %6, %5, %6
					// put low64 of E^F in high64
					gcm_swap64 %5, %6, #0
					// put high64 of E^F in low64
					gcm_swap64 %6, #0, %6
					// D xor low
					xor %7, %7, %6
					// C xor high
					xor %4, %4, %5
					
					// // reduction
					// X1:X0 in %4
					// X3:X2 in %7
					// shift everybody by 1 to the left
					// high shifting in 1 bit from low
					gcm_shlmi %1, %7, %4, #1
					// low
					gcm_shlmi %0, %4, #0, #1
					// post-shift
					// X1:X0 in %0
					// X3:X2 in %1
					// compute D
					gcm_cmpd %2, %0
					// compute E, F, G
					gcm_shrmi %3, %2, #0, #1
					gcm_shrmi %4, %2, #0, #2
					gcm_shrmi %5, %2, #0, #7
					// XOR everybody
					xor %2, %2, %3
					xor %4, %4, %5
					xor %2, %2, %4
					xor %0, %2, %1
					// output in %0
					fin
    );
	let aescode = assemble_engine25519!(
               start:
                    // X in %0
					// KEY in %31-%17 (backward)
					// one  full round demo
					xor %0, %0, %31

					aesesmi %1, %0, %30
					
					aesesmi %0, %1, %29
					
					aesesmi %1, %0, %28
					
					aesesmi %0, %1, %27

					aesesmi %1, %0, %26
					
					aesesmi %0, %1, %25
					
					aesesmi %1, %0, %24
					
					aesesmi %0, %1, %23

					aesesmi %1, %0, %22
					
					aesesmi %0, %1, %21
					
					aesesmi %1, %0, %20
					
					aesesmi %0, %1, %19

					aesesmi %1, %0, %18
					
					aesesi %0, %1, %17

					fin
    );
	let gcm_pfx_code = assemble_engine25519!(
    start:
					// Input: rkeys in %31-%17 (backward, LE)
					//        pub in %16 (0-11, 12-15 are ctr so 0, LE)
					//        RD_PTR in %3
					//		  ADLEN in %12 (in 16-byte-blocks)
					// Transient:
					//  %0, %1, %2 are tmp
					// Output:
					//    all inputs preserved
					//    H will go in %15 (byte-reverted)
					//    T will go in %14
					//    accum (0) will go in %13
					gcm_brev32 %16, %16
					// use %2 as a flag
					psa %2, #1
					psa %1, #0
	genht:
					xor %0, %1, %31

					aesesmi %1, %0, %30
					
					aesesmi %0, %1, %29
					
					aesesmi %1, %0, %28
					
					aesesmi %0, %1, %27

					aesesmi %1, %0, %26
					
					aesesmi %0, %1, %25
					
					aesesmi %1, %0, %24
					
					aesesmi %0, %1, %23

					aesesmi %1, %0, %22
					
					aesesmi %0, %1, %21
					
					aesesmi %1, %0, %20
					
					aesesmi %0, %1, %19

					aesesmi %1, %0, %18
					
					aesesi %0, %1, %17

					// if the %2 flag is cleared, we've just computed T
					brz afterht, %2
					// store H in %15
					psa %15, %0
					// increment counter; should we have a gcm_inc_be ?
					// for now byterev + special constant
					gcm_brev32 %16, %16
					add %16, %16, #11
					gcm_brev32 %16, %16
					// clear flag & go encrypt t
					psa %2, #0
					psa %1, %16
					brz genht, #0
					
		afterht:
					// store T in %14
					psa %14, %0
					
					// fully byte-revert H (first byte-in-dword, then dword-in-64bit)
					gcm_brev64 %15, %15
					gcm_swap64 %15, %15, %15

					psa %13, #0
					
					// no fin; we fall directly into the AD code
					//fin
    );
	let gcm_ad_code = assemble_engine25519!(
	// Input: rkeys in %31-%17 (backward, LE)
					//        pub in %16 (0-11, 12-15 are ctr so 0, LE)
					//        RD_PTR in %3
					//		  ADLEN in %12 (in 16-byte-blocks)
					//        H in %15 (byte-reverted)
					//        T in %14
					//        accum in %13
					// Transient:
					//  %0, %1, %4, %5, %6, %7 are tmp
					// Output:
					//    all inputs preserved except ADLEN (%12) & RD_PTR (%3)
					//    Updated accum is in %13
					
					// if no ad, finish
					brz done, %12
					// do one block, repeat
		do_ad:		load %0, %3
				gcm_brev64 %0, %0
				gcm_swap64 %0, %0, %0
				
					xor %0, %0, %13
					add %3, %3, #16
					sub %12, %12, #1

					// // poly mult accum = ((accum^ad) * H)
					// C
					clmul %4, %0, %15, #0
					// E
					clmul %5, %0, %15, #1
					// F
					clmul %6, %0, %15, #2
					// D
					clmul %7, %0, %15, #3
					// E ^ F
					xor %6, %5, %6
					// put low64 of E^F in high64
					gcm_swap64 %5, %6, #0
					// put high64 of E^F in low64
					gcm_swap64 %6, #0, %6
					// D xor low
					xor %7, %7, %6
					// C xor high
					xor %4, %4, %5
					
					// // reduction
					// X1:X0 in %4
					// X3:X2 in %7
					// shift everybody by 1 to the left
					// high shifting in 1 bit from low
					gcm_shlmi %1, %7, %4, #1
					// low
					gcm_shlmi %0, %4, #0, #1
					// post-shift
					// X1:X0 in %0
					// X3:X2 in %1
					// compute D
					gcm_cmpd %2, %0
					// compute E, F, G
					gcm_shrmi %6, %2, #0, #1
					gcm_shrmi %4, %2, #0, #2
					gcm_shrmi %5, %2, #0, #7
					// XOR everybody
					xor %2, %2, %6
					xor %4, %4, %5
					xor %2, %2, %4
					xor %13, %2, %1
						
					brz done, %12
					brz do_ad, #0
					
		done:
					fin
	);
	let gcm_aes_code = assemble_engine25519!(
					//        pub in %16 (0-11, 12-15 are ctr so 0, LE)
					//        RD_PTR in %3
					//        WR_PTR in %11
					//		  MLEN in %12 (in *complete* 16-byte-blocks)
					//        H in %15 (byte-reverted)
					//        T in %14
					//        accum in %13
					// Transient:
					//  %0, %1, %4, %5, %6, %7 are tmp
					// Output:
					//    all inputs preserved except RD_PTR (%3), WR_PTR (%11), MLEN (%12)
					//    accum is in %13
					
					// if no msg, finish
					brz done, %12
					// do one block, repeat
		do_msg:
					// increment counter
					gcm_brev32 %16, %16
					add %16, %16, #11
					gcm_brev32 %16, %16
					
					xor %0, %16, %31

					aesesmi %1, %0, %30
					
					aesesmi %0, %1, %29
					
					aesesmi %1, %0, %28
					
					aesesmi %0, %1, %27

					aesesmi %1, %0, %26
					
					aesesmi %0, %1, %25
					
					aesesmi %1, %0, %24
					
					aesesmi %0, %1, %23

					aesesmi %1, %0, %22
					
					aesesmi %0, %1, %21
					
					aesesmi %1, %0, %20
					
					aesesmi %0, %1, %19

					aesesmi %1, %0, %18
					
					aesesi %1, %1, %17
					
					//gcm_brev64 %1, %0
					//gcm_swap64 %1, %1, %1

					load %0, %3
					xor %0, %0, %1
					store %11, %11, %0
					
				gcm_brev64 %0, %0
				gcm_swap64 %0, %0, %0

					xor %0, %0, %13
					add %3, %3, #16
					add %11, %11, #16
					
					sub %12, %12, #1
					
					// // poly mult accum = ((accum^ad) * H)
					// C
					clmul %4, %0, %15, #0
					// E
					clmul %5, %0, %15, #1
					// F
					clmul %6, %0, %15, #2
					// D
					clmul %7, %0, %15, #3
					// E ^ F
					xor %6, %5, %6
					// put low64 of E^F in high64
					gcm_swap64 %5, %6, #0
					// put high64 of E^F in low64
					gcm_swap64 %6, #0, %6
					// D xor low
					xor %7, %7, %6
					// C xor high
					xor %4, %4, %5
					
					// // reduction
					// X1:X0 in %4
					// X3:X2 in %7
					// shift everybody by 1 to the left
					// high shifting in 1 bit from low
					gcm_shlmi %1, %7, %4, #1
					// low
					gcm_shlmi %0, %4, #0, #1
					// post-shift
					// X1:X0 in %0
					// X3:X2 in %1
					// compute D
					gcm_cmpd %2, %0
					// compute E, F, G
					gcm_shrmi %6, %2, #0, #1
					gcm_shrmi %4, %2, #0, #2
					gcm_shrmi %5, %2, #0, #7
					// XOR everybody
					xor %2, %2, %6
					xor %4, %4, %5
					xor %2, %2, %4
					xor %13, %2, %1
						
					brz done, %12
					brz do_msg, #0
		done:
					fin
					
	);
	let gcm_finish_code = assemble_engine25519!(
					//        pub in %16 (0-11, 12-15 are ctr so 0, LE)
					//        RD_PTR in %3
					//        WR_PTR in %11
					//		  MLEN in %12 (do one *partial* 16-byte-blocks, so 0 or non-zero)
					//		  MMASK in %10 (could be computed from MLEN%16 but we don't have an instruction for it yet)
					// 		  finalblock in %9 (could be computed but we'd need to know the exact value of adlen)
					//        H in %15 (byte-reverted)
					//        T in %14
					//        accum in %13
					// Transient:
					//  %0, %1, %4, %5, %6, %7 are tmp
					// Output:
					//    all inputs preserved except RD_PTR (%3), WR_PTR (%11), MLEN (%12)
					//    accum is in %13
					//    accum ^ T is in %8
					brz last, %12
					
		finish_mlen:
					// increment counter
					gcm_brev32 %16, %16
					add %16, %16, #11
					gcm_brev32 %16, %16
					
					xor %0, %16, %31

					aesesmi %1, %0, %30
					
					aesesmi %0, %1, %29
					
					aesesmi %1, %0, %28
					
					aesesmi %0, %1, %27

					aesesmi %1, %0, %26
					
					aesesmi %0, %1, %25
					
					aesesmi %1, %0, %24
					
					aesesmi %0, %1, %23

					aesesmi %1, %0, %22
					
					aesesmi %0, %1, %21
					
					aesesmi %1, %0, %20
					
					aesesmi %0, %1, %19

					aesesmi %1, %0, %18
					
					aesesi %1, %1, %17
					
					//gcm_brev64 %1, %0
					//gcm_swap64 %1, %1, %1

					and %1, %1, %10
					load %0, %3
					xor %0, %0, %1
					
					store %11, %11, %0
					
				gcm_brev64 %0, %0
				gcm_swap64 %0, %0, %0

					xor %0, %0, %13
					//add %3, %3, #16
					//add %11, %11, #16
					
					//sub %12, %12, #1
					
					// // poly mult accum = ((accum^ad) * H)
					// C
					clmul %4, %0, %15, #0
					// E
					clmul %5, %0, %15, #1
					// F
					clmul %6, %0, %15, #2
					// D
					clmul %7, %0, %15, #3
					// E ^ F
					xor %6, %5, %6
					// put low64 of E^F in high64
					gcm_swap64 %5, %6, #0
					// put high64 of E^F in low64
					gcm_swap64 %6, #0, %6
					// D xor low
					xor %7, %7, %6
					// C xor high
					xor %4, %4, %5
					
					// // reduction
					// X1:X0 in %4
					// X3:X2 in %7
					// shift everybody by 1 to the left
					// high shifting in 1 bit from low
					gcm_shlmi %1, %7, %4, #1
					// low
					gcm_shlmi %0, %4, #0, #1
					// post-shift
					// X1:X0 in %0
					// X3:X2 in %1
					// compute D
					gcm_cmpd %2, %0
					// compute E, F, G
					gcm_shrmi %6, %2, #0, #1
					gcm_shrmi %4, %2, #0, #2
					gcm_shrmi %5, %2, #0, #7
					// XOR everybody
					xor %2, %2, %6
					xor %4, %4, %5
					xor %2, %2, %4
					xor %13, %2, %1
		last:
					// addmul of finalblock
					
				gcm_brev64 %9, %9
				gcm_swap64 %9, %9, %9
					xor %0, %9, %13
					//add %3, %3, #16
					//add %11, %11, #16
					//sub %12, %12, #1
					
					// // poly mult accum = ((accum^ad) * H)
					// C
					clmul %4, %0, %15, #0
					// E
					clmul %5, %0, %15, #1
					// F
					clmul %6, %0, %15, #2
					// D
					clmul %7, %0, %15, #3
					// E ^ F
					xor %6, %5, %6
					// put low64 of E^F in high64
					gcm_swap64 %5, %6, #0
					// put high64 of E^F in low64
					gcm_swap64 %6, #0, %6
					// D xor low
					xor %7, %7, %6
					// C xor high
					xor %4, %4, %5
					
					// // reduction
					// X1:X0 in %4
					// X3:X2 in %7
					// shift everybody by 1 to the left
					// high shifting in 1 bit from low
					gcm_shlmi %1, %7, %4, #1
					// low
					gcm_shlmi %0, %4, #0, #1
					// post-shift
					// X1:X0 in %0
					// X3:X2 in %1
					// compute D
					gcm_cmpd %2, %0
					// compute E, F, G
					gcm_shrmi %6, %2, #0, #1
					gcm_shrmi %4, %2, #0, #2
					gcm_shrmi %5, %2, #0, #7
					// XOR everybody
					xor %2, %2, %6
					xor %4, %4, %5
					xor %2, %2, %4
					xor %13, %2, %1
					
				gcm_brev64 %13, %13
				gcm_swap64 %13, %13, %13

					xor %8, %13, %14

					fin
	);


    let mut pos = 0;

	pos = 0;
	println!("test AES:");
    while pos < aescode.len() {
		  print!("0x{:08x},", aescode[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", aescode.len());

	pos = 0;
	println!("GCM PFX:");
    while pos < gcm_pfx_code.len() {
		  print!("0x{:08x},", gcm_pfx_code[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", gcm_pfx_code.len());

	pos = 0;
	println!("GCM AD:");
    while pos < gcm_ad_code.len() {
		  print!("0x{:08x},", gcm_ad_code[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", gcm_ad_code.len());

	pos = 0;
	println!("GCM AES:");
    while pos < gcm_aes_code.len() {
		  print!("0x{:08x},", gcm_aes_code[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", gcm_aes_code.len());

	pos = 0;
	println!("GCM FINISH:");
    while pos < gcm_finish_code.len() {
		  print!("0x{:08x},", gcm_finish_code[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", gcm_finish_code.len());


	Ok(())
}
