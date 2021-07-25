#![recursion_limit="512"]

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
					fin
    );
    let mut pos = 0;
    while pos < mcode2.len() {
		  println!("0x{:08x},", mcode2[pos]);
		  pos = pos + 1;
    }
	Ok(())
}
