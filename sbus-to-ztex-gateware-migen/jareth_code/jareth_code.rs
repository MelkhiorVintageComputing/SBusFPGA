#![recursion_limit="768"]

extern crate jareth_as;
use jareth_as::*;

fn main() -> std::io::Result<()> {
    let mcode = assemble_jareth!(
	// 0..0 $DST / $DST / $SRC in %0
	// 0..0 $DST / $SRC / $DST in %1
	// size in %2
	// pattern in %3
	// -----
	// size & 7 in %5
	// size rounded down in %6
	// input in %16
	// output in %17
	// 0 in %31
         start:
				resm %31
				setadr %31, %0
				load256inc %16, %0
				load256inc %17, %1
				// slow
				setma %31, %0, #16
				// slow
				setmq %31, %1, #16
				and %5, %2, #15
				sub %6, %2, %5
				brz done, %6
		loop:
			psa %18, %16
			psa %19, %17
				psa* %17, %16
			psa %20, %17
				store128inc %31, %2, %17
				sub %6, %6, #16
				brz last, %6
				loadh128inc %16, %0, %16
				loadh128inc %17, %1, %17
				brz loop, #0
		last:
				// FIXME: not if Q is aligned
				loadh128inc %17, %1, %17
				store128inc %31, %2, %17
		done:
				getadr %3
				getm %2
				fin
				fin
	);
    let _mcode3 = assemble_jareth!(
	// 0..0 / $DST / $SRC in %0
	// size in %2
	// pattern in %3
               start:
			   resm %31
			   psa %31, #0
			   psa %30, #1
			   sub %30, %31, %30
			   psa %29, #2
			   setmq %31, %29, %2
			   setma %31, %0, %2
			   psa* %30, %3
			   getm %3
			   resm %31
			   psa %2, %30
			   setadr %31 , %0
			   load256 %1, %0
			   load128 %0, %0
			   fin
			   fin
	);
    let _mcode2 = assemble_jareth!(
				psa %1, %3
			    setma %31, %0, %2
				psa %2, %3
				getm %3
				fin
				fin
			    resm %31
				psa %0, %3
				setmq %31, %1, %2
				psa %1, %3
				fin
				fin
				fin
				setma %31, %0, %2
				setma %31, %0, %2
			    resm %31
				fin
				fin
				fin
				fin
    );

    let mut pos;

	pos = 0;
	println!("test code:");
    while pos < mcode.len() {
		  print!("0x{:08x},", mcode[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode.len());

	Ok(())
}
