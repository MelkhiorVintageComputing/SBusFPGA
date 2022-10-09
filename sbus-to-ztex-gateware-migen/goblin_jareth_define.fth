\ various register support functions
: gar! ( val off -- )
  goblin_accel-virt + l!
;

\ 0: status

: cmd-gar! ( val -- )
  h# 4 gar!
;

\ 8: r5_cmd

\ c: resv0

: width_gar! ( val -- )
  h# 10 gar!
;

: height_gar! ( val -- )
  h# 14 gar!
;

\ 18: fg_color

\ 1c: resv2

: srcx_gar! ( val -- )
  h# 20 gar!
;

: srcy_gar! ( val -- )
  h# 24 gar!
;

: dstx_gar! ( val -- )
  h# 28 gar!
;

: dsty_gar! ( val -- )
  h# 2c gar!
;

: srcstride_gar! ( val -- )
  h# 30 gar!
;

: dststride_gar! ( val -- )
  h# 34 gar!
;

\ 38: src_ptr
\ 3c: dst_ptr

: gar@ ( off -- val )
  goblin_accel-virt + l@
;

: status-gar@ ( val -- )
  0 gar@
;

\ busy-wait on running in status
: jareth-busy-wait ( -- )
    begin
        status-gar@
        h# 1 \ 1 << WORK_IN_PROGRESS_BIT
        and 
        0=
	until
;

h# 8f80000 constant fb-base
