RGBDS=C:\Program Files\RGBDS
ASM=$(RGBDS)\rgbasm.exe
LINK=$(RGBDS)\rgblink.exe
FIX=$(RGBDS)\rgbfix.exe

.SUFFIXES: .o .asm

lightoff.gb: header.o main.o
	rgblink -o $@ -n $*.sym $**
	rgbfix -v -p0 $@

.asm.o:
	rgbasm -o $@ $**

clean:
	del /S /Q *.sym *.o *.gb
