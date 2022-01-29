: vid_fb_dma_enable_rd ( -- csr_value)
  vid_fb-virt h# 0008 + l@
;
: vid_fb_dma_enable_wr ( csr_value -- )
  vid_fb-virt h# 0008 + l!
;
: vid_fb_vtg_enable_rd ( -- csr_value)
  vid_fb_vtg-virt h# 0000 + l@
;
: vid_fb_vtg_enable_wr ( csr_value -- )
  vid_fb_vtg-virt h# 0000 + l!
;

: fb_init!
  map-in-cg3extraregs
  0 vid_fb_vtg_enable_wr
  0 vid_fb_dma_enable_wr
  1 vid_fb_vtg_enable_wr
  1 vid_fb_dma_enable_wr
  map-out-cg3extraregs
;
