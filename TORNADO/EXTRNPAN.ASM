;****************************************************************************
;*
;* EXTRNPAN.ASM
;*
;* External panel driver.
;*
;* 10.12.1991 - KJB
;* 13.04.1992 - KJB - External panel modified for VIEW_MAP.
;* 24.06.1992 - KJB - External panel modified for VIEW_DRONE.
;* 26.06.1992 - KJB - External panel modified for VIEW_SPECTATOR.
;* 08.07.1992 - KJB - External panel modified for VIEW_REMOTE.
;* 13.08.1992 - KJB - "VIEW = DRONE" change text colour wrt side.
;* 18.08.1992 - KJB - Text palette switching wrt view mode.
;* 27.09.1992 - KJB - External panel modified for VIEW_DEMO.
;* 14.11.1992 - KJB - External panel modified for VIEW_DESTROYED.
;* 21.11.1992 - KJB - External panel modified for VIEW_WEAPON.
;*
;****************************************************************************

		OPTION	M510		;<<<<< MASM v5.10 <<<<<

		PUBLIC	LoadExtrnPan
		PUBLIC	UpdateExtrn

		EXTRN	BlockFill:FAR
		EXTRN	Print$:FAR

		EXTRN	Vkts:WORD
		EXTRN	DispBarAlt:WORD
		EXTRN	TrueRadAlt:WORD
		EXTRN	DispHdg:WORD
		EXTRN	DispVSI:WORD
		EXTRN	FuelWt:WORD
		EXTRN	GameViewMode:WORD
		EXTRN	PrtCl:WORD
		EXTRN	DroneMode:WORD
		EXTRN	DroneCrntPtrs:WORD

		EXTRN	Callsign:BYTE
		EXTRN	PrintOver:BYTE
		EXTRN	VGA_RGB_Data:BYTE
		EXTRN	VGA_EXT_TEXT:BYTE
		EXTRN	VGA_EXT_TEXT1:BYTE
		EXTRN	VGA_EXT_TEXT2:BYTE
		EXTRN	SetPaletteFlag:BYTE
		EXTRN	DemoMode:BYTE

;============================================================================

		INCLUDE	MAINDATA.INC
		INCLUDE	CONFIG.INC

		INCLUDE	\VISUAL\PALETTES.INC

		INCLUDE	\LIB8086\PRINT.INC
		INCLUDE	\LIB8086\USEFUL.INC
 		INCLUDE	\LIB8086\PALMACRO.INC

;============================================================================

DATA		SEGMENT PARA PUBLIC 'DATA'

VSIVal		DW	0		;abs(DispVSI)

VSICol		DW	OFFSET TextCol2	;VSI colour

FuelCol		DW	OFFSET TextCol2	;fuel colour

ViewCol		DW	OFFSET TextCol2	;view colour (drone allied / enemy)

AltValPtr  	DW	OFFSET BarAlt$

TextRGBPtr	DW	OFFSET VGA_EXT_TEXT1

TextCol1	DB	0ffh,000h,0ffh,000h,00bh,000h,COL_TEXT_NORM1,COL_BLACK
TextCol2	DB	0ffh,000h,055h,000h,00eh,000h,COL_TEXT_NORM2,COL_BLACK
AlertCol	DB	0ffh,000h,0aah,000h,00ch,000h,COL_TEXT_ALERT,COL_BLACK

Info$		LABEL	BYTE
		P_OVER1
		P_CHAR2
		PV_ATTR	TextCol1
		PD_XY	0*4,193
		DB	"SPEED=    KTS "
		DB	"HDG=   ~ "
		DB	"ALT=     FT "
		DB	"VSI=      FT/MIN "
		DB	"FUEL=     LBS "
		DB	"VIEW="
		P_END

PFI$		LABEL	BYTE
		P_CHAR2
		PV_ATTR	TextCol2
		P_DECAT	00100100b	;(unsigned, 4 digits, leading zeroes)
		PD_XY	6*4,193
		PV_DECW	Vkts
		P_DECAT	00100011b	;(unsigned, 3 digits, leading zeroes)
		PD_X	18*4
		PV_DECW	DispHdg
		P_DECAT	00100100b	;(unsigned, 4 digits, leading zeroes)
		PD_X	27*4
		PP_STR	AltValPtr
		PP_ATTR	VSICol
		P_DECAT	00100101b	;(unsigned, 5 digits, leading zeroes)
		PD_X	39*4
		PV_DECW	VSIVal
		DB	'0'
		PP_ATTR	FuelCol
		P_DECAT	00100101b	;(unsigned, 5 digits, leading zeroes)
		PD_X	57*4
		PV_DECW	FuelWt
		PP_ATTR	ViewCol		;(set colour for view mode text)
		PD_X	71*4		;(set x pos for view mode text)
		P_DECAT	00000000b	;(default)
		P_END

BarAlt$		LABEL	BYTE
		PV_DECW	DispBarAlt
		DB	'0'
		P_END

RadAlt$		LABEL	BYTE
		PV_ATTR	AlertCol
		DB	'R'
		PV_DECW	TrueRadAlt
		P_END

Tracking$	LABEL	BYTE
		DB	"TRACKING"
		P_END

Satellite$	LABEL	BYTE
		DB	"SATELLITE"
		P_END

Map$		LABEL	BYTE
		DB	"MAP"
		P_END

Drone$		LABEL	BYTE
		DB	"123456789"
		P_END

Spectator$	LABEL	BYTE
		DB	"SPECTATOR"
		P_END

Remote$		LABEL	BYTE
		DB	"REMOTE"
		P_END

Demo$		LABEL	BYTE
		P_OVER1
		P_CHAR2
		PV_ATTR	TextCol1
		PD_XY	0*4,193

	IF	OPT_HOLOBYTE EQ 1

		DB	"   TORNADO - CALL SPECTRUM HOLOBYTE DIRECT SALES AT 510-522-3584 FOR DETAILS.   "

	ELSEIF	OPT_COKTEL EQ 1

		DB	"      TORNADO (c) 1993 DI LTD. PHONE COKTEL VISION TEL. 33 (1) 46.30.99.57      "

	ELSEIF	OPT_LEADER EQ 1

		DB	"  TORNADO (c) 1993 DI LTD. PHONE LEADER DISTRIBUZIONE S.R.L. TEL. 0332/874111   "

	ELSEIF	OPT_SYSTEM4 EQ 1

		DB	"     TORNADO (c) 1993 DI LTD. PHONE SYSTEM 4 DE ESPANA, S.A. TELF. 610 57 12    "

	ELSE

	IF	0

		DB	"TORNADO (c) 1993 DIGITAL INTEGRATION LIMITED. CALL (UK) 0276-684959 FOR DETAILS."

	ELSE

		DB	"                  TORNADO (c) 1993 DIGITAL INTEGRATION LIMITED                  "

	ENDIF

	ENDIF

		P_END

Destroyed$	LABEL	BYTE
		DB	"DESTROYED"
		P_END

Weapon$		LABEL	BYTE
		DB	"WEAPON"
		P_END

		EVEN

DATA		ENDS

;============================================================================

PREVDATA	SEGMENT PARA PUBLIC 'DATA'
PREVDATA	ENDS

;============================================================================

PANCODE		SEGMENT BYTE PUBLIC 'CODE'
		ASSUME CS:PANCODE
		ASSUME DS:DATA

;* LoadExtrnPan - load external panel (any screen mode)
;*
;* pass: nothing
;* ret : nothing
;* kill: assume all

LoadExtrnPan	PROC	NEAR

;* sort text RGB colours

		mov	si,OFFSET VGA_EXT_TEXT1

		cmp	si,TextRGBPtr	;palette colours ok?
		je	@F		;yes ->

		mov	TextRGBPtr,si

		OVLYRGB	VGA_EXT_TEXT,si,3

		mov	SetPaletteFlag,1

;* clear text area

@@:		mov	al,COL_BLACK
		mov	bl,192
		mov	bh,199
		mov	cx,0
		mov	dx,319
		call	BlockFill

;* print info bar

		mov	si,OFFSET Info$		;assume not demo view

		cmp	DemoMode,0		;demo mode?
		je	@F			;no ->

		mov	si,OFFSET Demo$

@@:		call	Print$

		ret

LoadExtrnPan	ENDP

;----------------------------------------------------------------------------

;* UpdateExtrn - update external panel
;*
;* pass: nothing
;* ret : nothing
;* kill: assume all

UpdateExtrn	PROC	NEAR

		cmp	DemoMode,0	;demo mode?
		_JNE	ExitUpdate   	;yes ->

;* if VIEW_MAP then
;*    sort text RGB colours
;*    print Info$
;*    print over = on
;* else
;*    print over = off
;* endif

		xor	al,al		;assume not VIEW_MAP

		cmp	GameViewMode,VIEW_MAP	;map view?
		jne	SkipMap			;no ->

;* sort text RGB colours

		mov	si,OFFSET VGA_EXT_TEXT2

		cmp	si,TextRGBPtr	;palette colours ok?
		je	@F		;yes ->

		mov	TextRGBPtr,si

		OVLYRGB	VGA_EXT_TEXT,si,3

		mov	SetPaletteFlag,1

;* print Info$

@@:		mov	si,OFFSET Info$
		call	Print$

		mov	al,1				

SkipMap:	mov	PrintOver,al

;* sort altitude display (barometric or radar)

		mov	ax,OFFSET BarAlt$

		cmp	TrueRadAlt,5000	;disp bar alt?
		jae	@F		;yes ->

		mov	ax,OFFSET RadAlt$

@@:		mov	AltValPtr,ax

;* sort VSI text col (display -ve VSI in ALERT colour)

		mov	si,OFFSET TextCol2	;assume VSI +ve

		mov	ax,DispVSI
		test	ax,ax		;VSI +ve?
		jns	@F		;yes ->

		mov	si,OFFSET AlertCol

@@:		mov	VSICol,si

		ABSV	ax

		mov	VSIVal,ax

;* sort fuel text col (display <= 1000lbs fuel in ALERT colour)

		mov	si,OFFSET TextCol2	;assume > 1000lbs fuel

		cmp	FuelWt,1000	;> 1000lbs fuel?
		ja	@F		;yes ->

		mov	si,OFFSET AlertCol

@@:		mov	FuelCol,si

;* view mode text colour

		mov	ViewCol,OFFSET TextCol2	;assume not drone mode

		cmp	GameViewMode,VIEW_DRONE	;drone?
		jne	@F	       		;no ->

		call	FormatDroneName

		test	DroneMode,010b		;enemy?
		jz	@F			;no ->

		mov	ViewCol,OFFSET AlertCol	

;* print primary flight information

@@:		mov	si,OFFSET PFI$
		call	Print$

;* sort view mode

		mov	ax,GameViewMode

		mov	si,OFFSET Tracking$
		cmp	ax,VIEW_TRACKING	;tracking?
		je	ViewOk			;yes ->

		mov	si,OFFSET Satellite$
		cmp	ax,VIEW_SATELLITE	;satellite?
		je	ViewOk			;yes ->

		mov	si,OFFSET Map$
		cmp	ax,VIEW_MAP		;map?
		je	ViewOk			;yes ->

		mov	si,OFFSET Spectator$
		cmp	ax,VIEW_SPECTATOR	;spectator?
		je	ViewOk			;yes ->

		mov	si,OFFSET Remote$
		cmp	ax,VIEW_REMOTE		;remote?
		je	ViewOk			;yes ->

		mov	si,OFFSET Drone$
		cmp	ax,VIEW_DRONE		;drone?
		je	ViewOk			;yes ->

		mov	si,OFFSET Destroyed$
		cmp	ax,VIEW_DESTROYED	;destroyed?
		je	ViewOk			;yes ->

		mov	si,OFFSET Weapon$

ViewOk:		call	Print$

ExitUpdate:	ret

UpdateExtrn	ENDP

FormatDroneName PROC NEAR
IFDEF DESERT
        mov     al, 020h
        mov     cx, 9
        mov     di, OFFSET Drone$
        rep stosb
        mov     bx, DroneMode
        mov     bx, DroneCrntPtrs[bx]
        mov     bx, [bx]
        mov     si, 03cch
        cmp     bx, 0911eh
        jne     Loc_0020
        jmp     Loc_0206
Loc_0020:
        cmp     bx, 09276h
        jne     Loc_0029
        jmp     Loc_0206
Loc_0029:
        cmp     bx, 093ceh
        jne     Loc_0032
        jmp     Loc_0206
Loc_0032:
        cmp     bx, 09526h
        jne     Loc_003B
        jmp     Loc_0206
Loc_003B:
        cmp     bx, 0967eh
        jne     Loc_0044
        jmp     Loc_0206
Loc_0044:
        cmp     bx, 097d6h
        jne     Loc_004D
        jmp     Loc_0206
Loc_004D:
        mov     si, 03d7h
        cmp     bx, 0992eh
        jne     Loc_0059
        jmp     Loc_0206
Loc_0059:
        cmp     bx, 09a86h
        jne     Loc_0062
        jmp     Loc_0206
Loc_0062:
        mov     si, 03e1h
        cmp     bx, 09bdeh
        jne     Loc_006E
        jmp     Loc_0206
Loc_006E:
        cmp     bx, 09cc6h
        jne     Loc_0077
        jmp     Loc_0206
Loc_0077:
        mov     si, 03e9h
        cmp     bx, 09daeh
        jne     Loc_0083
        jmp     Loc_0206
Loc_0083:
        cmp     bx, 09e96h
        jne     Loc_008C
        jmp     Loc_0206
Loc_008C:
        mov     si, 03f5h
        cmp     bx, 09f7eh
        jne     Loc_0098
        jmp     Loc_0206
Loc_0098:
        cmp     bx, 0a066h
        jne     Loc_00A1
        jmp     Loc_0206
Loc_00A1:
        mov     si, 0400h
        cmp     bx, 0a14eh
        jne     Loc_00AD
        jmp     Loc_0206
Loc_00AD:
        cmp     bx, 0a236h
        jne     Loc_00B6
        jmp     Loc_0206
Loc_00B6:
        mov     si, 040ch
        cmp     bx, 0a31eh
        jne     Loc_00C2
        jmp     Loc_0206
Loc_00C2:
        mov     si, 0416h
        cmp     bx, 0a406h
        jne     Loc_00CE
        jmp     Loc_0206
Loc_00CE:
        cmp     bx, 0a4d6h
        jne     Loc_00D7
        jmp     Loc_0206
Loc_00D7:
        mov     si, 0422h
        cmp     bx, 0a5a6h
        jne     Loc_00E3
        jmp     Loc_0206
Loc_00E3:
        cmp     bx, 0a676h
        jne     Loc_00EC
        jmp     Loc_0206
Loc_00EC:
        mov     si, 03d0h
        cmp     bx, 0a746h
        jne     Loc_00F8
        jmp     Loc_0206
Loc_00F8:
        cmp     bx, 0a89eh
        jne     Loc_0101
        jmp     Loc_0206
Loc_0101:
        cmp     bx, 0a9f6h
        jne     Loc_010A
        jmp     Loc_0206
Loc_010A:
        cmp     bx, 0ab4eh
        jne     Loc_0113
        jmp     Loc_0206
Loc_0113:
        cmp     bx, 0aca6h
        jne     Loc_011C
        jmp     Loc_0206
Loc_011C:
        cmp     bx, 0adfeh
        jne     Loc_0125
        jmp     Loc_0206
Loc_0125:
        mov     si, 03dah
        cmp     bx, 0af56h
        jne     Loc_0131
        jmp     Loc_0206
Loc_0131:
        cmp     bx, 0b0aeh
        jne     Loc_013A
        jmp     Loc_0206
Loc_013A:
        mov     si, 03e6h
        cmp     bx, 0b206h
        jne     Loc_0146
        jmp     Loc_0206
Loc_0146:
        cmp     bx, 0b2eeh
        jne     Loc_014F
        jmp     Loc_0206
Loc_014F:
        mov     si, 03eeh
        cmp     bx, 0b3d6h
        jne     Loc_015B
        jmp     Loc_0206
Loc_015B:
        cmp     bx, 0b4beh
        jne     Loc_0164
        jmp     Loc_0206
Loc_0164:
        mov     si, 03fah
        cmp     bx, 0b5a6h
        jne     Loc_0170
        jmp     Loc_0206
Loc_0170:
        cmp     bx, 0b68eh
        jne     Loc_0179
        jmp     Loc_0206
Loc_0179:
        mov     si, 0406h
        cmp     bx, 0b776h
        jne     Loc_0185
        jmp     Loc_0206
Loc_0185:
        cmp     bx, 0b85eh
        jne     Loc_018D
        jmp     Loc_0206
Loc_018D:
        mov     si, 0411h
        cmp     bx, 0b946h
        jne     Loc_0198
        jmp     Loc_0206
Loc_0198:
        mov     si, 041ch
        cmp     bx, 0ba2eh
        jne     Loc_01A3
        jmp     Loc_0206
Loc_01A3:
        cmp     bx, 0bafeh
        jne     Loc_01AB
        jmp     Loc_0206
Loc_01AB:
        mov     si, 0428h
        cmp     bx, 0bbceh
        jne     Loc_01B6
        jmp     Loc_0206
Loc_01B6:
        cmp     bx, 0bc9eh
        jne     Loc_01BE
        jmp     Loc_0206
Loc_01BE:
        mov     si, 0
        cmp     bx, 0bd78h
        jne     Loc_01C9
        jmp     Loc_0206
Loc_01C9:
        cmp     bx, 0be22h
        jne     Loc_01D1
        jmp     Loc_0206
Loc_01D1:
        cmp     bx, 0becch
        jne     Loc_01D9
        jmp     Loc_0206
Loc_01D9:
        cmp     bx, 0bf76h
        jne     Loc_01E1
        jmp     Loc_0206
Loc_01E1:
        mov     si, 6
        cmp     bx, 0c020h
        jne     Loc_01EC
        jmp     Loc_0206
Loc_01EC:
        cmp     bx, 0c16ah
        jne     Loc_01F4
        jmp     Loc_0206
Loc_01F4:
        cmp     bx, 0c2b4h
        jne     Loc_01FC
        jmp     Loc_0206
Loc_01FC:
        cmp     bx, 0c3feh
        jne     Loc_0204
        jmp     Loc_0206
Loc_0204:
        jmp     Loc_027B
Loc_0206:
        push    bx
        mov     ax, SEG PREVDATA
        mov     ds, ax
        mov     di, OFFSET Drone$
Loc_020F:
        lodsb
        test    al, al
        je      Loc_0217
        stosb
        jmp     Loc_020F
Loc_0217:
        mov     ax, SEG DATA
        mov     ds, ax
        pop     bx
        mov     di, OFFSET Drone$ + 4
        mov     al, Callsign[0]
        cmp     bx, 0911eh
        je      Loc_026D
        mov     al, Callsign[1]
        cmp     bx, 09276h
        je      Loc_026D
        mov     al, Callsign[2]
        cmp     bx, 093ceh
        je      Loc_026D
        mov     al, Callsign[3]
        cmp     bx, 09526h
        je      Loc_026D
        mov     al, Callsign[4]
        cmp     bx, 0967eh
        je      Loc_026D
        mov     al, Callsign[5]
        cmp     bx, 097d6h
        je      Loc_026D
        mov     di, OFFSET Drone$ + 3
        mov     al, Callsign[6]
        cmp     bx, 0992eh
        je      Loc_026D
        mov     al, Callsign[7]
        cmp     bx, 09a86h
        je      Loc_026D
        jmp     Loc_027B
Loc_026D:
        cmp     al, 20h
        je      Loc_027B
        mov     byte ptr [di], 28h
        mov     byte ptr [di + 1], al
        mov     byte ptr [di + 2], 29h
Loc_027B:
        ret     
ELSE
        mov     al, 020h
        mov     cx, 9
        mov     di, OFFSET Drone$
        rep stosb
        mov     bx, DroneMode
        mov     bx, DroneCrntPtrs[bx]
        mov     bx, [bx]
        mov     si, 3f2h
        cmp     bx, 910eh
        jne     Loc_0020
        jmp     Loc_0206
Loc_0020:
        cmp     bx, 9266h
        jne     Loc_0029
        jmp     Loc_0206
Loc_0029:
        cmp     bx, 93beh
        jne     Loc_0032
        jmp     Loc_0206
Loc_0032:
        cmp     bx, 9516h
        jne     Loc_003B
        jmp     Loc_0206
Loc_003B:
        cmp     bx, 966eh
        jne     Loc_0044
        jmp     Loc_0206
Loc_0044:
        cmp     bx, 97c6h
        jne     Loc_004D
        jmp     Loc_0206
Loc_004D:
        mov     si, 3fdh
        cmp     bx, 991eh
        jne     Loc_0059
        jmp     Loc_0206
Loc_0059:
        cmp     bx, 9a76h
        jne     Loc_0062
        jmp     Loc_0206
Loc_0062:
        mov     si, 407h
        cmp     bx, 9bceh
        jne     Loc_006E
        jmp     Loc_0206
Loc_006E:
        cmp     bx, 9cb6h
        jne     Loc_0077
        jmp     Loc_0206
Loc_0077:
        mov     si, 412h
        cmp     bx, 9d9eh
        jne     Loc_0083
        jmp     Loc_0206
Loc_0083:
        cmp     bx, 9e86h
        jne     Loc_008C
        jmp     Loc_0206
Loc_008C:
        mov     si, 41eh
        cmp     bx, 9f6eh
        jne     Loc_0098
        jmp     Loc_0206
Loc_0098:
        cmp     bx, 0a056h
        jne     Loc_00A1
        jmp     Loc_0206
Loc_00A1:
        mov     si, 429h
        cmp     bx, 0a13eh
        jne     Loc_00AD
        jmp     Loc_0206
Loc_00AD:
        cmp     bx, 0a226h
        jne     Loc_00B6
        jmp     Loc_0206
Loc_00B6:
        mov     si, 435h
        cmp     bx, 0a30eh
        jne     Loc_00C2
        jmp     Loc_0206
Loc_00C2:
        mov     si, 43fh
        cmp     bx, 0a3f6h
        jne     Loc_00CE
        jmp     Loc_0206
Loc_00CE:
        cmp     bx, 0a4c6h
        jne     Loc_00D7
        jmp     Loc_0206
Loc_00D7:
        mov     si, 44bh
        cmp     bx, 0a596h
        jne     Loc_00E3
        jmp     Loc_0206
Loc_00E3:
        cmp     bx, 0a666h
        jne     Loc_00EC
        jmp     Loc_0206
Loc_00EC:
        mov     si, 3f6h
        cmp     bx, 0a736h
        jne     Loc_00F8
        jmp     Loc_0206
Loc_00F8:
        cmp     bx, 0a88eh
        jne     Loc_0101
        jmp     Loc_0206
Loc_0101:
        cmp     bx, 0a9e6h
        jne     Loc_010A
        jmp     Loc_0206
Loc_010A:
        cmp     bx, 0ab3eh
        jne     Loc_0113
        jmp     Loc_0206
Loc_0113:
        cmp     bx, 0ac96h
        jne     Loc_011C
        jmp     Loc_0206
Loc_011C:
        cmp     bx, 0adeeh
        jne     Loc_0125
        jmp     Loc_0206
Loc_0125:
        mov     si, 400h
        cmp     bx, 0af46h
        jne     Loc_0131
        jmp     Loc_0206
Loc_0131:
        cmp     bx, 0b09eh
        jne     Loc_013A
        jmp     Loc_0206
Loc_013A:
        mov     si, 40ch
        cmp     bx, 0b1f6h
        jne     Loc_0146
        jmp     Loc_0206
Loc_0146:
        cmp     bx, 0b2deh
        jne     Loc_014F
        jmp     Loc_0206
Loc_014F:
        mov     si, 417h
        cmp     bx, 0b3c6h
        jne     Loc_015B
        jmp     Loc_0206
Loc_015B:
        cmp     bx, 0b4aeh
        jne     Loc_0164
        jmp     Loc_0206
Loc_0164:
        mov     si, 423h
        cmp     bx, 0b596h
        jne     Loc_0170
        jmp     Loc_0206
Loc_0170:
        cmp     bx, 0b67eh
        jne     Loc_0179
        jmp     Loc_0206
Loc_0179:
        mov     si, 42fh
        cmp     bx, 0b766h
        jne     Loc_0185
        jmp     Loc_0206
Loc_0185:
        cmp     bx, 0b84eh
        jne     Loc_018D
        jmp     Loc_0206
Loc_018D:
        mov     si, 43ah
        cmp     bx, 0b936h
        jne     Loc_0198
        jmp     Loc_0206
Loc_0198:
        mov     si, 445h
        cmp     bx, 0ba1eh
        jne     Loc_01A3
        jmp     Loc_0206
Loc_01A3:
        cmp     bx, 0baeeh
        jne     Loc_01AB
        jmp     Loc_0206
Loc_01AB:
        mov     si, 451h
        cmp     bx, 0bbbeh
        jne     Loc_01B6
        jmp     Loc_0206
Loc_01B6:
        cmp     bx, 0bc8eh
        jne     Loc_01BE
        jmp     Loc_0206
Loc_01BE:
        mov     si, 0
        cmp     bx, 0bd68h
        jne     Loc_01C9
        jmp     Loc_0206
Loc_01C9:
        cmp     bx, 0be12h
        jne     Loc_01D1
        jmp     Loc_0206
Loc_01D1:
        cmp     bx, 0bebch
        jne     Loc_01D9
        jmp     Loc_0206
Loc_01D9:
        cmp     bx, 0bf66h
        jne     Loc_01E1
        jmp     Loc_0206
Loc_01E1:
        mov     si, 6
        cmp     bx, 0c010h
        jne     Loc_01EC
        jmp     Loc_0206
Loc_01EC:
        cmp     bx, 0c15ah
        jne     Loc_01F4
        jmp     Loc_0206
Loc_01F4:
        cmp     bx, 0c2a4h
        jne     Loc_01FC
        jmp     Loc_0206
Loc_01FC:
        cmp     bx, 0c3eeh
        jne     Loc_0204
        jmp     Loc_0206
Loc_0204:
        jmp     Loc_027B
Loc_0206:
        push    bx
        mov     ax, SEG PREVDATA
        mov     ds, ax
        mov     di, OFFSET Drone$
Loc_020F:
        lodsb
        test    al, al
        je      Loc_0217
        stosb
        jmp     Loc_020F
Loc_0217:
        mov     ax, SEG DATA
        mov     ds, ax
        pop     bx
        mov     di, OFFSET Drone$ + 4
        mov     al, Callsign[0]
        cmp     bx, 910eh
        je      Loc_026D
        mov     al, Callsign[1]
        cmp     bx, 9266h
        je      Loc_026D
        mov     al, Callsign[2]
        cmp     bx, 93beh
        je      Loc_026D
        mov     al, Callsign[3]
        cmp     bx, 9516h
        je      Loc_026D
        mov     al, Callsign[4]
        cmp     bx, 966eh
        je      Loc_026D
        mov     al, Callsign[5]
        cmp     bx, 97c6h
        je      Loc_026D
        mov     di, OFFSET Drone$ + 3
        mov     al, Callsign[6]
        cmp     bx, 991eh
        je      Loc_026D
        mov     al, Callsign[7]
        cmp     bx, 9a76h
        je      Loc_026D
        jmp     Loc_027B
Loc_026D:
        cmp     al, 20h
        je      Loc_027B
        mov     byte ptr [di], 28h
        mov     byte ptr [di + 1], al
        mov     byte ptr [di + 2], 29h
Loc_027B:
        ret     
ENDIF
FormatDroneName ENDP

PANCODE		ENDS

;============================================================================

		END

