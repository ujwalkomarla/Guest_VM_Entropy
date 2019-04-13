//http://www.linuxinsight.com/how_fast_is_your_disk.html
#define _LARGEFILE64_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>
#include <signal.h>
#include <sys/fcntl.h>
#include <sys/ioctl.h>
#include <linux/fs.h>
#define BLOCKSIZE 512

time_t start;
int count;

void handle(const char *string, int error)
{
	if (error) {
		time_t end;
		perror(string);
		time(&end);
 		printf(".\nResults: %d seeks/second, %.2f ms random access time\n",
		 count /(int) (end-start), 1000.0 * (int)(end-start) / count);
		exit(EXIT_FAILURE);
	
	}
}

int main(int argc, char **argv)
{



	char buffer[BLOCKSIZE];
	int fd, retval;
	unsigned long numblocks;
	off64_t offset;

	setvbuf(stdout, NULL, _IONBF, 0);

	if (argc != 2) {
		printf("Usage: seeker <raw disk device>\n");
		exit(EXIT_SUCCESS);
	}

	fd = open(argv[1], O_RDONLY);
	handle("open", fd < 0);

	retval = ioctl(fd, BLKGETSIZE, &numblocks);
	handle("ioctl", retval == -1);
	printf("Benchmarking %s [%luMB]",
	       argv[1], numblocks / 2048);

	time(&start);
	//srand(start);

	while(1){
		//offset = (off64_t) numblocks * random() / RAND_MAX;
		//retval = lseek64(fd, BLOCKSIZE * offset, SEEK_SET);
		//handle("lseek64", retval == (off64_t) -1);
		retval = read(fd, buffer, BLOCKSIZE);
		handle("read", retval < 0);
		count++;
	}
	/* notreached */
}
