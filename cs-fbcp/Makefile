all: cs-fbcp

CFLAGS=-Ofast -fomit-frame-pointer \
 -I/opt/vc/include \
 -I/opt/vc/include/interface/vcos/pthreads \
 -I/opt/vc/include/interface/vmcs_host \
 -I/opt/vc/include/interface/vmcs_host/linux \
 -L/opt/vc/lib
LIBS=-lm -lbcm_host

cs-fbcp: cs-fbcp.c
	cc $(CFLAGS) cs-fbcp.c $(LIBS) -o cs-fbcp
	strip cs-fbcp

install:
	mv cs-fbcp /usr/local/bin

clean:
	rm -f cs-fbcp
