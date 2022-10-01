ARCH ?= x86
OS_LINUX = yes

ifeq ($(ARCH),arm)
DEFS=-DARCH_ARM
else
DEFS=-DARCH_I386
endif

CC ?= gcc
CP = /usr/bin/sudo /bin/cp
MKFILE = Makefile
SRC = dav.c EFM.c efm_c.c cport.c

ifeq ($(OS_LINUX),yes)
DEFS += -DOS_LINUX
SRC += term.c
endif

CPFLAGS = $(MAKEFLAGS) $(DEFS) -g -O2 -Wall -m32
LDFLAGS = $(MAKEFLAGS) -g -O2 -m32

OBJS = $(SRC:.c=.o)
DEPS = $(SRC:.c=.d)

DEL = /bin/rm -f

.PHONY: all target
target: all

all: $(OBJS) $(MAKEFILE)
	$(CC) $(OBJS) -o efm $(LDFLAGS)
	
%.d: %.c $(MKFILE)
	@echo "Building dependencies for '$<'"
	$(CC) -E -MM -MQ $(<:.c=.o) $(CPFLAGS) $< -o $@
	$(DEL) $(<:.c=.o)

%.o: %.c $(MKFILE)
	@echo "Compiling '$<'"
	$(CC) -c $(CPFLAGS) -I . $< -o $@

clean:
	-$(DEL) $(OBJS:/=\)
	-$(DEL) $(DEPS:/=\)

.PHONY: dep
dep: $(DEPS) $(SRC)
	@echo "##########################"
	@echo "### Dependencies built ###"
	@echo "##########################"

-include $(DEPS)
