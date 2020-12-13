#include <stdio.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/ioccom.h>

struct rdfpga_128bits {
	uint32_t x[4];
};

#define RDFPGA_WC   _IOW(0, 1, struct rdfpga_128bits)
#define RDFPGA_WH   _IOW(0, 2, struct rdfpga_128bits)
#define RDFPGA_WI   _IOW(0, 3, struct rdfpga_128bits)
#define RDFPGA_RC   _IOR(0, 4, struct rdfpga_128bits)
#define RDFPGA_WL   _IOW(0, 1, uint32_t)

static const char* rdfpga_device = "/dev/rdfpga0";

int
main(int argc, char *argv[])
{
	int devfd;
	struct rdfpga_128bits data;
	int pattern = 0xF00FF00F;

	if (argc > 1)
		pattern = atoi(argv[1]);

	if ( (devfd = open(rdfpga_device, O_RDWR)) == -1) {
		perror("can't open device file");
		return 1;
	}

	/*
                     x"6b8b4567");
                     x"66334873");
                     x"2ae8944a");
                     x"46e87ccd");

                     x"327b23c6");
                     x"74b0dc51");
                     x"625558ec");
                     x"3d1b58ba");

                     x"643c9869");
                     x"19495cff");
                     x"238e1f29");
                     x"507ed7ab");

 */
       if (ioctl(devfd, RDFPGA_WL, &pattern) == -1) {
	       perror("ioctl failed");
       }

       data.x[0] = 0x327b23c6;
       data.x[1] = 0x74b0dc51;
       data.x[2] = 0x625558ec;
       data.x[3] = 0x3d1b58ba;
       if (ioctl(devfd, RDFPGA_WC, &data) == -1) {
	       perror("ioctl failed");
       }

       data.x[0] = 0x6b8b4567;
       data.x[1] = 0x66334873;
       data.x[2] = 0x2ae8944a;
       data.x[3] = 0x46e87ccd;
       if (ioctl(devfd, RDFPGA_WH, &data) == -1) {
	       perror("ioctl failed");
       }

       data.x[0] = 0x643c9869;
       data.x[1] = 0x19495cff;
       data.x[2] = 0x238e1f29;
       data.x[3] = 0x507ed7ab;
       if (ioctl(devfd, RDFPGA_WI, &data) == -1) {
	       perror("ioctl failed");
       }

       if (ioctl(devfd, RDFPGA_RC, &data) == -1) {
	       perror("ioctl failed");
       }
       printf("0x%08x 0x%08x 0x%08x 0x%08x\n",
	      data.x[0],
	      data.x[1],
	      data.x[2],
	      data.x[3]);

	close(devfd); 
	return 0;
}

