: bw2_vid_fb_vtg_enable_rd ( -- csr_value)
  bw2-virt h# 0000 + l@
;

: bw2_vid_fb_dma_enable_rd ( -- csr_value)
  bw2-virt h# 002c + l@
;

: bw2_vid_fb_vtg_enable_wr ( value -- )
  bw2-virt h# 0000 + l!
;

: bw2_vid_fb_dma_enable_wr ( value -- )
  bw2-virt h# 002c + l!
;

: bw2_init!
  map-in-bw2extraregs
  0 bw2_vid_fb_vtg_enable_wr
  0 bw2_vid_fb_dma_enable_wr
  1 bw2_vid_fb_vtg_enable_wr
  1 bw2_vid_fb_dma_enable_wr
  map-out-bw2extraregs
;
