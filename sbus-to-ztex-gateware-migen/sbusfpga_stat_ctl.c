#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/ioccom.h>
#include <errno.h>

#define SBUSFPGA_STAT_ON    _IO(0, 1)
#define SBUSFPGA_STAT_OFF   _IO(0, 0)

int main(int argc, char **argv) {
	const char const * device = "/dev/sbusfpga_stat0";
	int devfd;
	int onoff;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s on|off\n", argv[0]);
		return -1;
	}

	if (strncmp("on", argv[1], 2) == 0) {
		onoff = 1;
	} else if (strncmp("off", argv[1], 3) == 0) {
		onoff = 0;
	} else {
		fprintf(stderr, "Usage: %s on|off\n", argv[0]);
		return -1;
	}
	
	if ( (devfd = open(device, O_RDWR)) == -1) {
		perror("can't open device file");
		return -1;
	}

	switch (onoff) {
	case 0:
		if (ioctl(devfd, SBUSFPGA_STAT_OFF, NULL)) {
			perror("Turning statistics off failed.");
			close(devfd);
			return -1;
		}
		break;
	case 1:
		if (ioctl(devfd, SBUSFPGA_STAT_ON, NULL)) {
			perror("Turning statistics on failed.");
			close(devfd);
			return -1;
		}
		break;
	}

	return 0;
}
