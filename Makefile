RGBDS="C:\Program Files\RGBDS"
ASM="$(RGBDS)\rgbasm.exe"
LINK="$(RGBDS)\rgblink.exe"
FIX="$(RGBDS)\rgbfix.exe"
GFX="$(RGBDS)\rgbgfx.exe"

.SUFFIXES: .o .asm .png .bin

lightoff.gb: header.o main.o sound.o tileset.o utils.o intro.o
	$(LINK) -o $@ -n $*.sym $**
	$(FIX) -v -p0 $@

.asm.o:
	$(ASM) -i hardware -o $@ $**

tileset.asm: tileset.bin
intro.asm: intro.tilemap

.png.bin:
	$(GFX) -o $@ $**

clean:
	del /S /Q *.sym *.o *.gb *.bin
