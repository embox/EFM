#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/select.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <stdio.h>
#include <termios.h>
#include <string.h>
#include <stdlib.h>
#include <shadow.h>
#include <crypt.h>
#include <semaphore.h>
#include <errno.h>


static struct termios old, new;

void term_setup(void)
{
    tcgetattr(fileno(stdin), &old);
    new = old;
    new.c_cc[VERASE] = 0x7f; //0x08; dml!!!
    new.c_lflag &= ~ICANON;
    new.c_lflag &= ~ECHO;
    new.c_lflag &= ~ISIG;
    new.c_cc[VMIN] = 1;
    new.c_cc[VTIME] = 0;
    tcsetattr(fileno(stdin), TCSAFLUSH, &new);
}

void term_restore(void)
{
    tcsetattr(fileno(stdin), TCSAFLUSH, &old);
}
