;****************************************************************************
;*
;* PALETTES.ASM
;*
;* Palette data for screen drivers.
;*
;* See also PALETTES.INC.
;*
;* 03.08.1989 - KJB
;* 27.07.1992 - KJB - HGC / CGA / TAN palettes removed.
;* 04.10.1992 - KJB - SwapPalettes added.
;* 28.10.1992 - KJB - Night mode palettes sorted.
;* 18.11.1992 - KJB - Night mode palettes now loaded from disk.
;* 18.11.1992 - KJB - Night mode external text palette modified.
;* 17.01.1993 - KJB - Preview mode palette added.
;*
;****************************************************************************

		OPTION	M510		;<<<<< MASM v5.10 <<<<<

		PUBLIC	FixIRPalette
		PUBLIC	SetIRPalette
		PUBLIC	FixGMRPalette
		PUBLIC	SetGMRPalette
		PUBLIC	InitPalettes
		PUBLIC	SwapPalettes
		PUBLIC	SetHUDLevel

		PUBLIC	HGC_Palette1
		PUBLIC	CGA_Palette1
		PUBLIC	TAN_Palette1
		PUBLIC	VGA_Palette1

		PUBLIC	V16_RGB_Data
		PUBLIC	VGA_RGB_Data
		PUBLIC	VGA_RGB_Fade

		PUBLIC	VGA_Panel
		PUBLIC	VGA_Panel1
		PUBLIC	VGA_Panel2
		PUBLIC	VGA_GND
		PUBLIC	VGA_GND1
		PUBLIC	VGA_GND2
		PUBLIC	VGA_SKY
		PUBLIC	VGA_SKY1
		PUBLIC	VGA_SKY2
		PUBLIC	VGA_EXT_TEXT
		PUBLIC	VGA_EXT_TEXT1
		PUBLIC	VGA_EXT_TEXT2
		PUBLIC	VGA_INFRA_RED

		PUBLIC	PanelLight
		PUBLIC	HUDLevel

		PUBLIC	R_GREY_CLOUD
		PUBLIC	G_GREY_CLOUD
		PUBLIC	B_GREY_CLOUD
		PUBLIC	R_WHITE_CLOUD
		PUBLIC	G_WHITE_CLOUD
		PUBLIC	B_WHITE_CLOUD

		EXTRN	LoadFile:FAR

		EXTRN	SetPaletteFlag:BYTE
		EXTRN	Palette:BYTE
		EXTRN	Night:BYTE
		EXTRN	PreviewMode:BYTE

;============================================================================

		INCLUDE	PALETTES.INC

		INCLUDE	\TORNADO\CONFIG.INC

		INCLUDE	\LIB8086\USEFUL.INC

;============================================================================

PALDATA		SEGMENT PARA PUBLIC 'DATA'
		ASSUME DS:PALDATA

HGC_Palette1	LABEL	BYTE
CGA_Palette1	LABEL	BYTE
TAN_Palette1	LABEL	BYTE
VGA_Palette1	LABEL	BYTE
V16_RGB_Data	EQU	VGA_Palette1 + 0100h
VGA_RGB_Data	EQU	VGA_Palette1 + 0130h
VGA_EXT_TEXT	EQU	VGA_Palette1 + 013Fh
VGA_MiscPanel	EQU	VGA_Palette1 + 0280h
VGA_HUD		EQU	VGA_Palette1 + 02BFh
VGA_GND		EQU	VGA_Palette1 + 0211h
VGA_SKY		EQU	VGA_Palette1 + 0250h
VGA_Panel	EQU	VGA_Palette1 + 0340h
VGA_Panel1	EQU	VGA_Palette1 + 0430h
VGA_HUD_COLS	EQU	VGA_Palette1 + 0610h
VGA_Preview	EQU	VGA_Palette1 + 06E2h
VGA_Panel2	EQU	VGA_Palette1 + 0520h
VGA_GND1	EQU	VGA_Palette1 + 061Ch
VGA_GND2	EQU	VGA_Palette1 + 0622h
VGA_SKY1	EQU	VGA_Palette1 + 0628h
VGA_SKY2	EQU	VGA_Palette1 + 0658h
VGA_EXT_TEXT1	EQU	VGA_Palette1 + 0688h
VGA_EXT_TEXT2	EQU	VGA_Palette1 + 06B5h
VGA_RGB_Fade	EQU	VGA_Palette1 + 0742h
VGA_INFRA_RED	EQU	VGA_Palette1 + 0A42h

		DB	000h,001h,002h,003h,004h,005h,006h,007h,008h,009h,00Ah,00Bh,00Ch,00Dh,00Eh,00Fh
		DB	010h,011h,012h,013h,014h,015h,016h,017h,018h,019h,01Ah,01Bh,01Ch,01Dh,01Eh,01Fh
		DB	020h,021h,022h,023h,024h,025h,026h,027h,028h,029h,02Ah,02Bh,02Ch,02Dh,02Eh,02Fh
		DB	030h,031h,032h,033h,034h,035h,036h,037h,038h,039h,03Ah,03Bh,03Ch,03Dh,03Eh,03Fh
		DB	040h,041h,042h,043h,044h,045h,046h,047h,048h,049h,04Ah,04Bh,04Ch,04Dh,04Eh,04Fh
		DB	050h,051h,052h,053h,054h,055h,056h,057h,058h,059h,05Ah,05Bh,05Ch,05Dh,05Eh,05Fh
		DB	060h,061h,062h,063h,064h,065h,066h,067h,068h,069h,06Ah,06Bh,06Ch,06Dh,06Eh,06Fh
		DB	070h,071h,072h,073h,074h,075h,076h,077h,078h,079h,07Ah,07Bh,07Ch,07Dh,07Eh,07Fh
		DB	080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08Ah,08Bh,08Ch,08Dh,08Eh,08Fh
		DB	090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09Ah,09Bh,09Ch,09Dh,09Eh,09Fh
		DB	0A0h,0A1h,0A2h,0A3h,0A4h,0A5h,0A6h,0A7h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh
		DB	0B0h,0B1h,0B2h,0B3h,0B4h,0B5h,0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh
		DB	0C0h,0C1h,0C2h,0C3h,0C4h,0C5h,0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh
		DB	0D0h,0D1h,0D2h,0D3h,0D4h,0D5h,0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh
		DB	0E0h,0E1h,0E2h,0E3h,0E4h,0E5h,0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh
		DB	0F0h,0F1h,0F2h,0F3h,0F4h,0F5h,0F6h,0F7h,0F8h,0F9h,0FAh,0FBh,0FCh,0FDh,0FEh,0FFh
		DB	000h,000h,000h,000h,000h,02Ah,000h,02Ah,000h,000h,02Ah,02Ah,02Ah,000h,000h,02Ah
		DB	000h,02Ah,02Ah,015h,000h,02Ah,02Ah,02Ah,015h,015h,015h,015h,015h,03Fh,015h,03Fh
		DB	015h,015h,03Fh,03Fh,03Fh,015h,015h,03Fh,015h,03Fh,03Fh,03Fh,015h,03Fh,03Fh,03Fh
		DB	000h,000h,000h,03Fh,015h,015h,03Fh,03Fh,015h,015h,03Fh,03Fh,03Fh,03Fh,03Fh,000h
		DB	01Ah,02Ah,020h,02Ch,039h,03Fh,023h,005h,03Fh,03Fh,03Fh,033h,033h,033h,028h,028h
		DB	028h,01Ch,01Ch,01Ch,011h,011h,011h,03Fh,010h,014h,032h,003h,007h,029h,000h,000h
		DB	010h,01Ah,028h,009h,010h,019h,03Fh,03Ah,025h,03Fh,02Eh,000h,03Fh,025h,000h,014h
		DB	03Fh,021h,03Fh,033h,033h,033h,033h,03Fh,03Fh,03Fh,03Fh,032h,032h,032h,025h,025h
		DB	025h,01Fh,01Fh,01Fh,018h,018h,018h,000h,000h,000h,023h,029h,029h,020h,027h,027h
		DB	01Eh,025h,025h,01Bh,023h,023h,019h,021h,021h,017h,01Fh,01Fh,038h,02Ch,024h,034h
		DB	029h,021h,031h,026h,01Fh,02Eh,023h,01Dh,02Bh,021h,01Bh,02Fh,022h,01Ch,02Dh,01Fh
		DB	019h,02Ch,01Dh,016h,02Bh,01Ah,014h,02Ah,018h,012h,038h,038h,038h,02Bh,02Bh,02Bh
		DB	013h,013h,013h,00Ch,00Ch,00Ch,03Eh,03Fh,000h,03Fh,037h,000h,03Fh,02Eh,000h,03Fh
		DB	026h,000h,03Fh,020h,000h,03Fh,018h,000h,000h,032h,022h,000h,02Eh,01Eh,000h,029h
		DB	01Ch,000h,021h,019h,000h,032h,031h,000h,02Ch,02Bh,000h,028h,026h,000h,025h,023h
		DB	023h,025h,01Ch,020h,023h,01Ah,01Ch,021h,017h,019h,020h,015h,016h,01Eh,014h,013h
		DB	01Dh,012h,03Dh,03Dh,03Dh,010h,012h,018h,000h,000h,004h,030h,02Ch,027h,028h,028h
		DB	028h,03Eh,02Dh,022h,036h,02Bh,024h,02Fh,029h,025h,01Fh,023h,023h,000h,01Eh,01Dh
		DB	036h,027h,01Dh,037h,028h,01Dh,038h,028h,01Eh,039h,029h,01Fh,03Ah,02Ah,020h,03Bh
		DB	02Bh,020h,03Ch,02Ch,021h,03Eh,02Dh,022h,03Eh,02Eh,023h,03Eh,02Eh,024h,03Eh,02Fh
		DB	026h,03Eh,030h,027h,03Eh,031h,029h,03Eh,032h,02Ah,03Eh,033h,02Bh,03Fh,034h,02Dh
		DB	03Fh,03Fh,03Fh,03Bh,03Dh,03Fh,037h,03Bh,03Fh,034h,03Ah,03Fh,031h,038h,03Fh,02Dh
		DB	037h,03Fh,02Ah,035h,03Fh,026h,033h,03Fh,023h,032h,03Fh,01Fh,030h,03Fh,01Ch,02Fh
		DB	03Fh,018h,02Dh,03Fh,015h,02Bh,03Fh,012h,02Ah,03Fh,00Eh,028h,03Fh,00Bh,027h,03Fh
		DB	036h,027h,01Dh,037h,028h,01Dh,038h,028h,01Eh,039h,029h,01Fh,03Ah,02Ah,020h,03Bh
		DB	02Bh,020h,03Ch,02Ch,021h,03Eh,02Dh,022h,03Eh,02Eh,023h,03Eh,02Eh,024h,03Eh,02Fh
		DB	026h,03Eh,030h,027h,03Eh,031h,029h,03Eh,032h,02Ah,03Eh,033h,02Bh,03Fh,034h,02Dh
		DB	028h,028h,02Bh,01Ch,01Ch,020h,02Ah,005h,005h,01Eh,01Eh,021h,00Bh,00Bh,00Fh,009h
		DB	03Ah,011h,03Fh,022h,008h,01Ch,01Ch,021h,038h,03Ah,03Bh,000h,000h,000h,02Bh,02Bh
		DB	02Bh,00Ah,013h,022h,025h,000h,000h,02Dh,007h,000h,000h,030h,000h,000h,036h,000h
		DB	03Eh,02Dh,022h,030h,02Ch,027h,01Fh,023h,023h,00Bh,016h,037h,03Fh,015h,03Fh,03Fh
		DB	015h,03Fh,03Fh,015h,03Fh,03Fh,015h,03Fh,03Fh,015h,03Fh,013h,026h,037h,02Ah,015h
		DB	000h,000h,000h,000h,03Fh,00Ah,005h,03Fh,03Fh,03Fh,03Eh,019h,005h,033h,00Ah,000h
		DB	000h,009h,001h,000h,00Ch,000h,000h,00Fh,000h,000h,012h,000h,000h,015h,000h,000h
		DB	018h,000h,000h,01Bh,000h,000h,01Eh,000h,000h,021h,000h,000h,024h,000h,000h,027h
		DB	000h,000h,02Ah,000h,000h,02Dh,000h,000h,030h,000h,000h,033h,000h,000h,036h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	036h,03Bh,039h,031h,038h,036h,02Dh,036h,033h,028h,033h,031h,025h,031h,02Fh,021h
		DB	02Eh,02Dh,01Dh,02Ch,02Bh,01Ah,029h,029h,016h,026h,027h,013h,022h,024h,011h,01Eh
		DB	022h,00Eh,01Bh,01Fh,00Ch,018h,01Dh,009h,014h,01Bh,007h,011h,018h,006h,00Eh,016h
		DB	000h,000h,002h,003h,003h,006h,005h,005h,008h,007h,007h,00Bh,009h,009h,00Dh,00Bh
		DB	00Bh,00Fh,00Dh,00Dh,011h,00Fh,00Fh,013h,011h,011h,015h,013h,013h,017h,015h,015h
		DB	019h,017h,017h,01Bh,01Ah,01Ah,01Eh,01Ch,01Ch,020h,01Eh,01Eh,022h,020h,020h,024h
		DB	022h,022h,026h,024h,024h,028h,026h,026h,02Ah,028h,028h,02Bh,02Ah,02Ah,02Dh,02Ch
		DB	02Ch,02Fh,02Eh,02Eh,031h,030h,030h,034h,032h,032h,036h,034h,034h,038h,036h,036h
		DB	039h,038h,038h,03Bh,03Ah,03Ah,03Dh,009h,000h,000h,010h,001h,001h,01Ch,007h,007h
		DB	024h,003h,003h,02Ah,005h,005h,033h,009h,007h,038h,009h,009h,03Fh,00Ch,007h,000h
		DB	007h,000h,00Bh,00Bh,00Fh,00Dh,00Dh,012h,010h,010h,015h,013h,013h,018h,015h,015h
		DB	019h,026h,026h,02Ah,02Eh,02Eh,031h,036h,022h,000h,03Fh,028h,005h,033h,020h,000h
		DB	036h,022h,000h,012h,00Ah,000h,019h,00Eh,001h,027h,01Bh,000h,02Bh,01Ch,000h,000h
		DB	01Eh,000h,039h,026h,000h,015h,001h,001h,03Fh,028h,005h,023h,01Fh,01Bh,01Fh,01Ch
		DB	01Ch,025h,01Fh,020h,027h,022h,01Eh,01Eh,01Ah,016h,03Fh,015h,03Fh,032h,032h,036h
		DB	038h,03Ah,03Bh,036h,037h,038h,034h,036h,036h,032h,033h,034h,030h,031h,032h,02Eh
		DB	02Fh,030h,02Ch,02Dh,02Eh,02Ah,02Bh,02Ch,028h,029h,02Ah,025h,027h,027h,024h,025h
		DB	025h,021h,023h,023h,020h,021h,021h,01Dh,01Eh,01Fh,01Bh,01Ch,01Dh,019h,01Ah,01Bh
		DB	017h,018h,018h,015h,016h,016h,013h,014h,014h,011h,012h,012h,00Fh,010h,010h,00Dh
		DB	00Eh,00Eh,00Bh,00Bh,00Ch,009h,009h,00Ah,007h,007h,007h,005h,005h,005h,003h,003h
		DB	003h,000h,000h,000h,003h,006h,002h,005h,007h,003h,006h,008h,004h,007h,009h,004h
		DB	007h,00Ah,005h,008h,00Bh,005h,009h,00Bh,006h,009h,00Ch,006h,00Ah,00Dh,007h,00Bh
		DB	00Eh,007h,00Bh,00Eh,008h,00Ch,00Fh,008h,00Dh,010h,009h,00Eh,011h,009h,00Eh,012h
		DB	00Ah,00Fh,012h,00Bh,010h,013h,00Bh,011h,014h,00Ch,011h,015h,00Ch,012h,015h,00Dh
		DB	013h,016h,00Eh,014h,017h,00Fh,015h,018h,00Fh,015h,019h,010h,016h,019h,011h,017h
		DB	01Ah,011h,018h,01Bh,012h,018h,01Ch,013h,019h,01Dh,014h,01Ah,01Dh,014h,01Bh,01Eh
		DB	015h,01Ch,01Fh,016h,020h,023h,019h,002h,005h,006h,004h,008h,00Eh,004h,00Ah,00Dh
		DB	03Fh,03Dh,01Ah,037h,035h,016h,030h,02Eh,013h,029h,027h,010h,021h,01Fh,00Dh,01Ah
		DB	018h,00Ah,013h,011h,007h,00Ch,00Bh,004h,00Dh,006h,006h,011h,006h,006h,015h,006h
		DB	006h,019h,005h,005h,01Dh,004h,004h,021h,001h,001h,025h,000h,000h,03Fh,03Fh,03Fh
		DB	009h,03Ah,011h,006h,02Ah,00Ch,003h,01Bh,007h,001h,00Ch,003h,03Eh,02Dh,022h,036h
		DB	02Bh,024h,03Fh,03Fh,03Fh,03Fh,03Fh,03Fh,03Fh,03Fh,03Fh,03Bh,03Dh,03Fh,037h,03Bh
		DB	03Fh,034h,03Ah,03Fh,031h,038h,03Fh,02Dh,037h,03Fh,02Ah,035h,03Fh,026h,033h,03Fh
		DB	023h,032h,03Fh,01Fh,030h,03Fh,01Ch,02Fh,03Fh,018h,02Dh,03Fh,015h,02Bh,03Fh,012h
		DB	02Ah,03Fh,00Eh,028h,03Fh,00Bh,027h,03Fh,03Fh,03Fh,03Fh,03Eh,03Eh,03Eh,03Dh,03Dh
		DB	03Dh,03Ch,03Ch,03Ch,03Bh,03Bh,03Bh,03Ah,03Ah,03Ah,039h,039h,039h,038h,038h,038h
		DB	037h,037h,037h,036h,036h,036h,035h,035h,035h,034h,034h,034h,033h,033h,033h,032h
		DB	032h,032h,031h,031h,031h,030h,030h,030h,000h,01Ah,02Ah,020h,02Ch,039h,03Fh,023h
		DB	005h,000h,013h,021h,016h,01Eh,029h,02Eh,018h,002h,000h,011h,01Eh,014h,01Bh,026h
		DB	027h,013h,001h,000h,00Bh,016h,00Eh,012h,01Bh,01Dh,00Dh,001h,000h,009h,012h,00Ch
		DB	00Eh,017h,016h,009h,001h,023h,015h,00Ah,033h,017h,000h,03Fh,03Fh,000h,019h,00Ch
		DB	001h,03Ch,021h,000h,033h,02Eh,000h,013h,008h,000h,036h,01Bh,000h,02Ch,027h,000h
		DB	010h,006h,000h,033h,018h,000h,029h,024h,000h,00Dh,004h,000h,02Dh,011h,000h,027h
		DB	021h,000h,005h,012h,012h,005h,012h,012h,006h,013h,013h,007h,013h,013h,008h,014h
		DB	014h,009h,014h,014h,00Ah,015h,015h,00Bh,015h,015h,00Bh,016h,016h,00Dh,017h,017h
		DB	00Eh,017h,017h,00Fh,018h,018h,014h,01Ch,01Ch,015h,01Eh,01Eh,006h,009h,009h,019h
		DB	023h,023h,021h,021h,021h,00Fh,018h,018h,03Fh,022h,000h,000h,000h,000h,004h,00Fh
		DB	00Fh,03Fh,003h,000h,03Fh,003h,000h,03Fh,003h,000h,03Fh,003h,000h,03Fh,003h,000h
		DB	03Fh,003h,000h,03Fh,003h,000h,03Fh,003h,000h,03Fh,003h,000h,03Fh,003h,000h,03Fh
		DB	003h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
		DB	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h

PALDATA		ENDS

;============================================================================

DATA		SEGMENT PARA PUBLIC 'DATA'

PanelLight	DB	0		;0 = red, 1 = green

HUDLevel	DB	0		;0 .. 3

InitNightHUD	DB	1		;night 1
		DB	1		;night 2
		DB	2		;night 3
		DB	2		;night 4

		EVEN

;---------------------------------
;* night palette overlay filenames
;---------------------------------

;* replace x with G or R (wrt panel light)
;* replace y with 1, 2, 3 or 4 (wrt night mode)

		IFDEF	DESERT
PanelOverlay	DB	"GPANL_xy.RGB",0
		ELSE
PanelOverlay	DB	"GPANL_xy.RGB",0
		ENDIF
KneesOverlay	DB	"KNEES_xy.RGB",0

		EVEN

;---------------------------
RGBFadeColours	LABEL	BYTE
;---------------------------

;* fade into grey clouds (should match overcast COL_SKY16)

R_GREY_CLOUD	DB	48
G_GREY_CLOUD	DB	48
B_GREY_CLOUD	DB	48

;* fade into pure white clouds

R_WHITE_CLOUD	DB	63
G_WHITE_CLOUD	DB	63
B_WHITE_CLOUD	DB	63

		EVEN

DATA		ENDS

;============================================================================

VISCODE		SEGMENT BYTE PUBLIC 'CODE'
		ASSUME CS:VISCODE
		ASSUME DS:DATA

;* FixIRPalette - restore palette translate table (after infra-red visual)
;*
;* pass: nothing
;* ret : nothing
;* kill: assume all
;*
;* note: Works for VGA only.

FixIRPalette	PROC	FAR

		push	ds

		mov	ax,PALDATA
		mov	ds,ax
			 
		mov	si,OFFSET VGA_Palette1+IR_COL_START
		mov	di,OFFSET Palette+IR_COL_START

		mov	cx,IR_COL_COUNT

		FAST_MOVE

		pop	ds

		ret

FixIRPalette	ENDP

;----------------------------------------------------------------------------

;* SetIRPalette - set palette translate table for infra-red visual
;*
;* pass: nothing
;* ret : nothing
;* kill: assume all
;*
;* note: Works for VGA only.

SetIRPalette	PROC	FAR

		push	ds

		mov	ax,PALDATA
		mov	ds,ax
			 
		mov	si,OFFSET VGA_INFRA_RED
		mov	di,OFFSET Palette+IR_COL_START

		mov	cx,IR_COL_COUNT

		FAST_MOVE

		pop	ds

		ret

SetIRPalette	ENDP

;----------------------------------------------------------------------------

;* FixGMRPalette - restore palette translate table (after radar draw)
;*
;* pass: nothing
;* ret : nothing
;* kill: assume all
;*
;* note: Works for VGA only.

FixGMRPalette	PROC	FAR

		mov	Palette[COL_MAP_HILL1],COL_MAP_HILL1
		mov	Palette[COL_MAP_HILL2],COL_MAP_HILL2
		mov	Palette[COL_MAP_HILL3],COL_MAP_HILL3
		mov	Palette[COL_MAP_HILL4],COL_MAP_HILL4
		mov	Palette[COL_MAP_HILL5],COL_MAP_HILL5
		mov	Palette[COL_MAP_HILL6],COL_MAP_HILL6
		mov	Palette[COL_MAP_HILL7],COL_MAP_HILL7
		mov	Palette[COL_MAP_HILL8],COL_MAP_HILL8
		mov	Palette[COL_MAP_HILL9],COL_MAP_HILL9
		mov	Palette[COL_MAP_HILL10],COL_MAP_HILL10
		mov	Palette[COL_MAP_HILL11],COL_MAP_HILL11
		mov	Palette[COL_MAP_HILL12],COL_MAP_HILL12
		mov	Palette[COL_MAP_HILL13],COL_MAP_HILL13
		mov	Palette[COL_MAP_HILL14],COL_MAP_HILL14
		mov	Palette[COL_MAP_HILL15],COL_MAP_HILL15
		mov	Palette[COL_MAP_HILL16],COL_MAP_HILL16

		mov	Palette[COL_MAP_GND1],COL_MAP_GND1
		mov	Palette[COL_MAP_ROAD1],COL_MAP_ROAD1
		mov	Palette[COL_MAP_RAIL1],COL_MAP_RAIL1
		mov	Palette[COL_MAP_RWY1],COL_MAP_RWY1
		mov	Palette[COL_MAP_RIVER1],COL_MAP_RIVER1
		mov	Palette[COL_MAP_GREEN1],COL_MAP_GREEN1
		mov	Palette[COL_MAP_GREEN2],COL_MAP_GREEN2
		mov	Palette[COL_MAP_ALLIED],COL_MAP_ALLIED
		mov	Palette[COL_MAP_RWY2],COL_MAP_RWY2
		mov	Palette[COL_MAP_ENEMY],COL_MAP_ENEMY

		ret

FixGMRPalette	ENDP

;----------------------------------------------------------------------------

;* SetGMRPalette - set palette translate table for radar draw
;*
;* pass: nothing
;* ret : nothing
;* kill: assume all
;*
;* note: Works for VGA only.

SetGMRPalette	PROC	FAR

		mov	Palette[COL_MAP_HILL1],COL_CRT2
		mov	Palette[COL_MAP_HILL2],COL_CRT3
		mov	Palette[COL_MAP_HILL3],COL_CRT2
		mov	Palette[COL_MAP_HILL4],COL_CRT3
		mov	Palette[COL_MAP_HILL5],COL_CRT4
		mov	Palette[COL_MAP_HILL6],COL_CRT5
		mov	Palette[COL_MAP_HILL7],COL_CRT4
		mov	Palette[COL_MAP_HILL8],COL_CRT5
		mov	Palette[COL_MAP_HILL9],COL_CRT6
		mov	Palette[COL_MAP_HILL10],COL_CRT7
		mov	Palette[COL_MAP_HILL11],COL_CRT6
		mov	Palette[COL_MAP_HILL12],COL_CRT7
		mov	Palette[COL_MAP_HILL13],COL_CRT8
		mov	Palette[COL_MAP_HILL14],COL_CRT9
		mov	Palette[COL_MAP_HILL15],COL_CRT8
		mov	Palette[COL_MAP_HILL16],COL_CRT9

		mov	Palette[COL_MAP_GND1],COL_CRT1
		mov	Palette[COL_MAP_ROAD1],COL_CRT4
		mov	Palette[COL_MAP_RAIL1],COL_CRT8
		mov	Palette[COL_MAP_RWY1],COL_CRT4
		mov	Palette[COL_MAP_RIVER1],COL_CRT6
		mov	Palette[COL_MAP_GREEN1],COL_CRT2
		mov	Palette[COL_MAP_GREEN2],COL_CRT3
		mov	Palette[COL_MAP_ALLIED],COL_CRT8
		mov	Palette[COL_MAP_RWY2],COL_CRT4
		mov	Palette[COL_MAP_ENEMY],COL_CRT8

		ret

SetGMRPalette	ENDP

;----------------------------------------------------------------------------

;* InitPalettes - init palettes wrt visual configuration
;*
;* pass: nothing
;* ret : cf = 0 = ok
;*       cf = 1 = palette RGB data load error
;* kill: assume all

InitPalettes	PROC	NEAR

		mov	SetPaletteFlag,1	;reload palette

;-------------------
;* sort preview mode
;-------------------

		cmp	PreviewMode,0		;preview mode?
		je	SkipPreview		;no ->

		mov	ax,PALDATA
		mov	ds,ax
		mov	es,ax

		mov	si,OFFSET VGA_Preview
		mov	di,OFFSET VGA_Panel

		mov	cx,32*3

		rep	movsb

		mov	ax,DATA
		mov	ds,ax
		mov	es,ax

		jmp	PaletteOk

;------------------------
;* sort infra-red colours (must be done before palette is modified for night mode)
;------------------------

SkipPreview:	mov	ax,PALDATA
		mov	ds,ax
		mov	es,ax

		mov	si,OFFSET VGA_RGB_Data+(IR_COL_START*3)
		mov	di,OFFSET VGA_INFRA_RED

		mov	cx,IR_COL_COUNT

;* grey scale = R * 0.3 + G * 0.59 + B * 0.11

IRLoop:		lodsb			;R
		mov	ah,al		;R * 256
		xor	al,al
		mov	dx,9830		;0.3 = 9830 / 32768
		imul	dx		;R * 256 * 0.3

		mov	bx,ax		;(R * 0.3)
		mov	bp,dx

		lodsb			;G
		mov	ah,al		;G * 256
		xor	al,al
		mov	dx,19333	;0.59 = 19333 / 32768
		imul	dx		;G * 256 * 0.59

		add	bx,ax		;(R * 0.3 + G * 0.59)
		adc	bp,dx

		lodsb			;B
		mov	ah,al		;B * 256
		xor	al,al
		mov	dx,3604		;0.11 = 3604 / 32768
		imul	dx		;B * 256 * 0.11

		add	ax,bx		;(R * 0.3 + G * 0.59 + B * 0.11)
		adc	dx,bp

		shl	ax,1		;*2 (adjust after fractional multiply)
		rcl	dx,1

		shl	ax,1
		ROUNDUP	dx		;dh = 0 .. 63

		REPT	2
		shr	dh,1		;0 .. 15
		ENDM

		mov	al,COL_CRT1
		add	al,dh

		stosb

		loop	IRLoop

;--------------------------------------
;* fix some colours which convert badly
;--------------------------------------

		ASSUME	DS:PALDATA

		mov	VGA_INFRA_RED[COL_RWY1-IR_COL_START],COL_CRT5
		mov	VGA_INFRA_RED[COL_RAIL1-IR_COL_START],COL_CRT5
		mov	VGA_INFRA_RED[COL_RAIL2-IR_COL_START],COL_CRT4

		ASSUME	DS:DATA

		mov	ax,DATA
		mov	ds,ax
		mov	es,ax

;---------------------------------------
;* modify palette colours wrt night mode
;---------------------------------------

		mov	cl,Night
		test	cl,cl		;night?
		_JZ	PaletteOk	;no ->

;* modify visual colours (divide wrt night mode)

		mov	ax,PALDATA
		mov	ds,ax
		mov	es,ax

		mov	si,OFFSET VGA_RGB_Data+(NIGHT_COL_START*3)
		mov	bp,NIGHT_COL_COUNT*3
		call	ScaleRGBValues

		mov	si,OFFSET VGA_GND1
		mov	bp,2*3
		call	ScaleRGBValues

		mov	si,OFFSET VGA_GND2
		mov	bp,2*3
		call	ScaleRGBValues

		mov	si,OFFSET VGA_SKY1
		mov	bp,16*3
		call	ScaleRGBValues

		mov	si,OFFSET VGA_SKY2
		mov	bp,16*3
		call	ScaleRGBValues

		mov	ax,DATA
		mov	ds,ax
		mov	es,ax

;* overlay night panel palettes

		call	SetNightPanel
		jc	ExitPalettes	;palette RGB data load error ->

;* modify fade colours (divide wrt night mode)

		mov	si,OFFSET RGBFadeColours
		mov	bp,2*3
		mov	cl,Night
		call	ScaleRGBValues

;* init HUD colour wrt night mode

		mov	al,Night	;1 .. 4
		dec	al		;0 .. 3
		mov	bx,OFFSET InitNightHUD
		xlat
		mov	HUDLevel,al

		call	SetHUDLevel

PaletteOk:	clc			;cf = 0 = ok

ExitPalettes:	ret

InitPalettes	ENDP

;----------------------------------------------------------------------------

;* ScaleRGBValues
;*
;* pass: si -> RGB data
;*       bp = count
;*       cl = scale factor
;* ret : nothing
;* kill: si, bp, flags

ScaleRGBValues	PROC	NEAR

@@:		mov	al,[si]
		shr	al,cl
		ROUNDUP	al
		mov	[si],al

		inc	si

		dec	bp
		jnz	@B

		ret

ScaleRGBValues	ENDP

;----------------------------------------------------------------------------

;* SwapPalettes
;*
;* pass: es:di -> new palette
;* ret : nothing
;* kill: assume all

SwapPalettes	PROC	FAR

		mov	SetPaletteFlag,1	;reload palette

		push	ds

		mov	ax,SEG VGA_RGB_Data
		mov	ds,ax

		mov	si,OFFSET VGA_RGB_Data

		mov	cx,256*3

@@:		mov	al,[si]
		xchg	al,es:[di]
		mov	[si],al

		inc	si
		inc	di

		loop	@B

		pop	ds
		
		ret

SwapPalettes	ENDP

;----------------------------------------------------------------------------

;* SetNightPanel
;*
;* pass: PanelLight
;*	 Night
;* ret : cf = 0 = ok
;*       cf = 1 = palette RGB data load error
;* kill: assume all

SetNightPanel	PROC	NEAR

;---------------
;* sort filename (wrt panel lighting and night mode)
;---------------

		mov	al,'R'		;assume red lighting

		cmp	PanelLight,0	;red?
		je	@F		;yes ->

		mov	al,'G'

@@:		mov	PanelOverlay[6],al
		mov	KneesOverlay[6],al

		mov	al,Night
		add	al,'0'
		mov	PanelOverlay[7],al
		mov	KneesOverlay[7],al

;---------------
;* load palettes
;---------------

;* load panel RGB data

		mov	ax,PALDATA
		mov	es,ax

		mov	cx,144*3
		mov	dx,OFFSET PanelOverlay
		mov	di,OFFSET VGA_MiscPanel

	IF	OPT_DEMO EQ 0

		call	LoadFile
		jc	ExitNightPanel	;palette RGB data load error ->

	ENDIF

;* copy VGA_Panel data to VGA_Panel1

		mov	ax,PALDATA
		mov	ds,ax

		mov	cx,80*3
		mov	si,OFFSET VGA_Panel
		mov	di,OFFSET VGA_Panel1
		FAST_MOVE

		mov	ax,DATA
		mov	ds,ax

;* load kneepad RGB data

		mov	cx,80*3
		mov	dx,OFFSET KneesOverlay
		mov	di,OFFSET VGA_Panel2

	IF	OPT_DEMO EQ 0

		call	LoadFile
		jc	ExitNightPanel	;palette RGB data load error ->

	ENDIF

;-----------------------------
;* sort external text palettes (wrt night mode)
;-----------------------------

		mov	al,Night	;1, 2, 3, 4
		mov	ah,3*3
		mul	ah		;9, 18, 27, 36
		mov	bx,ax		

		mov	ax,PALDATA
		mov	ds,ax

		mov	cx,3*3
		mov	si,OFFSET VGA_EXT_TEXT1
		add	si,bx
		mov	di,OFFSET VGA_EXT_TEXT
		FAST_MOVE

		mov	cx,3*3
		mov	si,OFFSET VGA_EXT_TEXT1
		add	si,bx
		mov	di,OFFSET VGA_EXT_TEXT1
		FAST_MOVE

		mov	cx,3*3
		mov	si,OFFSET VGA_EXT_TEXT2
		add	si,bx
		mov	di,OFFSET VGA_EXT_TEXT2
		FAST_MOVE

		clc			;cf = 0 = ok

ExitNightPanel:	mov	ax,DATA
		mov	ds,ax
		mov	es,ax

		ret

SetNightPanel	ENDP

;----------------------------------------------------------------------------

;* SetHUDLevel
;*
;* pass: HUDLevel
;* ret : nothing
;* kill: assume all

SetHUDLevel	PROC	FAR

		mov	SetPaletteFlag,1

		mov	al,HUDLevel
		xor	ah,ah

		mov	dx,ax
		add	ax,ax		;*2
		add	ax,dx		;*3

		mov	si,OFFSET VGA_HUD_COLS

		add	si,ax

		mov	ax,PALDATA
		mov	ds,ax
		mov	es,ax

		mov	di,OFFSET VGA_HUD
		mov	cx,1*3
		rep	movsb

		mov	ax,DATA
		mov	ds,ax
		mov	es,ax

		ret

SetHUDLevel	ENDP

VISCODE		ENDS

;============================================================================

		END

