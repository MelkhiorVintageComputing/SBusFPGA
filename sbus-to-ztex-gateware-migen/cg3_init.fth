: cg3_vid_fb_vtg_enable_rd ( -- csr_value)
  cg3-virt h# 0000 + l@
;

: cg3_vid_fb_dma_enable_rd ( -- csr_value)
  cg3-virt h# 002c + l@
;

: cg3_vid_fb_vtg_enable_wr ( value -- )
  cg3-virt h# 0000 + l!
;

: cg3_vid_fb_dma_enable_wr ( value -- )
  cg3-virt h# 002c + l!
;

: cg3_init!
  map-in-cg3extraregs
  0 cg3_vid_fb_vtg_enable_wr
  0 cg3_vid_fb_dma_enable_wr
  1 cg3_vid_fb_vtg_enable_wr
  1 cg3_vid_fb_dma_enable_wr
  map-out-cg3extraregs
;
