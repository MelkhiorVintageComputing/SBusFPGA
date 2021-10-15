: cg6_vid_fb_vtg_enable_rd ( -- csr_value)
  cg6-virt h# 0000 + l@
;

: cg6_vid_fb_dma_enable_rd ( -- csr_value)
  cg6-virt h# 002c + l@
;

: cg6_vid_fb_vtg_enable_wr ( value -- )
  cg6-virt h# 0000 + l!
;

: cg6_vid_fb_dma_enable_wr ( value -- )
  cg6-virt h# 002c + l!
;

: cg6_init!
  map-in-cg6extraregs
  0 cg6_vid_fb_vtg_enable_wr
  0 cg6_vid_fb_dma_enable_wr
  1 cg6_vid_fb_vtg_enable_wr
  1 cg6_vid_fb_dma_enable_wr
  map-out-cg6extraregs
;
