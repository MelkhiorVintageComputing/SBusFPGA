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
				sub32v %6, %2, %5
				brz done, %6
		loop:
			psa %18, %16
			psa %19, %17
				psa* %17, %16
			psa %20, %17
				store128inc %31, %2, %17
				sub32v %6, %6, #16
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
	
    let mcode_scroll256 = assemble_jareth!(
	// x..x / $DST / $SRC in %0, aligned on 128 bits ; $DST < $SRC
	// x..x / X size in %2, multiple of 256 bits (32 bytes)
	// x..x / Y size in %3, arbitrary
	// x..x / dst_stride / src_stride in %4 (screen width)
	// -----
	// live X count in %5
	// // live Y count in %3
	// data in %7
	// 0/scrap in %31
         start:
				// reset masks (probably not necessary with the starred-instruction)
				// resm %31
		loop_y:
				// set source and destination addresses for current Y, X=first
				setadr %31, %0
				psa %5, %2
		loop_x:
				// load from SRC w/ post-increment
				load256inc %7, %0
				// store to DST w/ post-increment
				store256inc %31, %1, %7
				// sub 32 (#5 is 32...) from live X count
				sub32v %5, %5, #5
				// if X count is not 0, keep looping
				brnz32 loop_x, %5

				// decrement Y count
				sub32v %3, %3, #1
				// if 0, finished
				brz done, %3
				// add strides to initial addresses
				add32v %0, %0, %4
				// loop to do next line
				brz loop_y, #0
		done:
				fin
				fin
	);
	
    let mcode_scroll128 = assemble_jareth!(
	// x..x / $DST / $SRC in %0, aligned on 128 bits ; $DST < $SRC
	// x..x / X size in %2, multiple of 128 bits (16 bytes)
	// x..x / Y size in %3, arbitrary
	// x..x / dst_stride / src_stride in %4 (screen width)
	// -----
	// live X count in %5
	// // live Y count in %3
	// data in %7
	// 0/scrap in %31
         start:
				// reset masks (probably not necessary with the starred-instruction)
				// resm %31
		loop_y:
				// set source and destination addresses for current Y, X=first
				setadr %31, %0
				psa %5, %2
		loop_x:
				// load from SRC w/ post-increment
				load128inc %7, %0
				// store to DST w/ post-increment
				store128inc %31, %1, %7
				// sub 16 (#16 is 16) from live X count
				sub32v %5, %5, #16
				// if X count is not 0, keep looping
				brnz32 loop_x, %5

				// decrement Y count
				sub32v %3, %3, #1
				// if 0, finished
				brz done, %3
				// add strides to initial addresses
				add32v %0, %0, %4
				// loop to do next line
				brz loop_y, #0
		done:
				fin
				fin
	);
	
    let mcode_fill128 = assemble_jareth!(
	// x..x / $DST in %0, aligned on 128 bits
	// 128-bits pattern in %1
	// x..x / X size in %2, multiple of 128 bits (16 bytes)
	// x..x / Y size in %3, arbitrary
	// x..x / dst_stride in %4 (screen width)
	// -----
	// live X count in %5
	// // live Y count in %3
	// data in %7
	// 0/scrap in %31
         start:
				// reset masks (probably not necessary with the starred-instruction)
				// resm %31
		loop_y:
				// set source and destination addresses for current Y, X=first
				setadr %31, %0
				psa %5, %2
		loop_x:
				// store to DST w/ post-increment
				store128inc %31, %0, %1
				// sub 16 (#16 is 16) from live X count
				sub32v %5, %5, #16
				// if X count is not 0, keep looping
				brnz32 loop_x, %5

				// decrement Y count
				sub32v %3, %3, #1
				// if 0, finished
				brz done, %3
				// add strides to initial addresses
				add32v %0, %0, %4
				// loop to do next line
				brz loop_y, #0
		done:
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

	pos = 0;
	println!("scroll256:");
    while pos < mcode_scroll256.len() {
		  print!("0x{:08x},", mcode_scroll256[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode_scroll256.len());

	pos = 0;
	println!("scroll128:");
    while pos < mcode_scroll128.len() {
		  print!("0x{:08x},", mcode_scroll128[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode_scroll128.len());

	pos = 0;
	println!("fill128:");
    while pos < mcode_fill128.len() {
		  print!("0x{:08x},", mcode_fill128[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode_fill128.len());

	Ok(())
}
