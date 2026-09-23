;****************************************************************************
;*
;* JOYSTICK.ASM
;*
;* 08.09.1989 - KJB - Original joystick routines (digital output).
;* 02.04.1991 - KJB - Rewritten to give analogue output.
;* 21.10.1991 - KJB - NPOS equate added.
;* 14.11.1991 - KJB - RECOVER macro added.
;* 07.03.1992 - KJB - "old" vars added.
;* 15.03.1992 - KJB - Timeout code added.
;* 15.04.1992 - KJB - RECOVER placed immediately after all joystick I/O in
;*                    ReadAnalogue subroutine.
;*                    RECOVER "nop" replaced with "jmp $+2".
;* 28.07.1992 - KJB - Joystick sensitivity added (for ThrustMaster fix).
;* 13.11.1992 - KJB - "just" fired flags added.
;* 06.04.1993 - KJB - ThrustMaster routines added.
;* 20.04.1993 - KJB - CH FlightStick Pro mods made.
;* 12.08.1993 - KJB - Rudder pedals & notebook fast gameport support added.
;*
;****************************************************************************

		OPTION	M510		;<<<<< MASM v5.10 <<<<<

		PUBLIC	RecalJoysticks
		PUBLIC	ReadJoysticks
		PUBLIC	ReadRudder

		PUBLIC	JoyA_Flag
		PUBLIC	JoyB_Flag

		PUBLIC	JoyA_XRef
		PUBLIC	JoyA_YRef
		PUBLIC	JoyA_XPos
		PUBLIC	JoyA_YPos
		PUBLIC	JoyA_XVal
		PUBLIC	JoyA_YVal
		PUBLIC	JoyA_Fire1
		PUBLIC	JoyA_Fire2
		PUBLIC	JoyA_JustFired1
		PUBLIC	JoyA_JustFired2

		PUBLIC	OldJoyA_Fire1
		PUBLIC	OldJoyA_Fire2

		PUBLIC	JoyB_XMin
		PUBLIC	JoyB_YMin
		PUBLIC	JoyB_XRef
		PUBLIC	JoyB_YRef
		PUBLIC	JoyB_XMax
		PUBLIC	JoyB_YMax
		PUBLIC	JoyB_XPos
		PUBLIC	JoyB_YPos
		PUBLIC	JoyB_XVal
		PUBLIC	JoyB_YVal
		PUBLIC	JoyB_Fire1
		PUBLIC	JoyB_Fire2
		PUBLIC	JoyB_JustFired1
		PUBLIC	JoyB_JustFired2

		PUBLIC	OldJoyB_Fire1
		PUBLIC	OldJoyB_Fire2

		PUBLIC	JoySensitivity
		PUBLIC	CHStick
		PUBLIC	ThrustMaster
		PUBLIC	RudderPedals

		PUBLIC	RP_Min
		PUBLIC	RP_Mid
		PUBLIC	RP_Max
		PUBLIC	RP_Pos
		PUBLIC	RP_Val

		PUBLIC	TM_CoolieCn
		PUBLIC	TM_CoolieLt
		PUBLIC	TM_CoolieDn
		PUBLIC	TM_CoolieRt
		PUBLIC	TM_CoolieUp

		PUBLIC	TM_CooliePos
		PUBLIC	TM_CoolieHat
		PUBLIC	TM_CoolieVal

		PUBLIC	TM_MinX
		PUBLIC	TM_MinY
		PUBLIC	TM_MidX
		PUBLIC	TM_MidY
		PUBLIC	TM_MaxX
		PUBLIC	TM_MaxY

		PUBLIC	COOLIE_UP
		PUBLIC	COOLIE_DN
		PUBLIC	COOLIE_LT
		PUBLIC	COOLIE_RT

COOLIE_UP	EQU	1
COOLIE_DN	EQU	2
COOLIE_LT	EQU	3
COOLIE_RT	EQU	4

;============================================================================

DATA		SEGMENT PARA PUBLIC 'DATA'

NPOS	 	EQU	32		;number of joystick positions

GAME_PORT	EQU	00201h		;game port address

JOY_A_XPOS	EQU	00000001b
JOY_A_YPOS	EQU	00000010b
JOY_B_XPOS	EQU	00000100b
JOY_B_YPOS	EQU	00001000b
JOY_A_FIRE1	EQU	00010000b
JOY_A_FIRE2	EQU	00100000b
JOY_B_FIRE1	EQU	01000000b
JOY_B_FIRE2	EQU	10000000b

JoyA_Flag	DB	0		;1 = joystick fitted
JoyB_Flag	DB	0		;1 = joystick fitted

JoySensitivity	DB	0		;0 = normal, 1 = high sensitivity
ThrustMaster	DB	0		;1 = ThrustMaster joystick fitted
CHStick		DB	0		;1 = CH FlightStick Pro fitted
RudderPedals	DB	0		;1 = Rudder Pedals fitted
GameportChecked	DB	0		;1 = gameport check done
FastGameport	DB	0		;1 = notebook fast gameport supported

TM_MinX		LABEL	WORD
JoyA_XMin	DW	0
TM_MinY		LABEL	WORD
JoyA_YMin	DW	0
TM_MidX		LABEL	WORD
JoyA_XRef	DW	0		;x ref = centre x * 2
TM_MidY		LABEL	WORD
JoyA_YRef	DW	0		;y ref = centre y * 2
TM_MaxX		LABEL	WORD
JoyA_XMax	DW	0
TM_MaxY		LABEL	WORD
JoyA_YMax	DW	0
JoyA_XPos	DW	0		;x pos = current x position
JoyA_YPos	DW	0		;y pos = current y position
JoyA_XVal	DW	0		;x val = x pos * x scale (0 .. NPOS)
JoyA_YVal	DW	0		;y val = y pos * y scale (0 .. NPOS)
JoyA_Fire1	DB	0		;1 = fire pressed
JoyA_Fire2	DB	0		;1 = fire pressed
JoyA_JustFired1	DB	0		;1 = fire just pressed
JoyA_JustFired2	DB	0		;1 = fire just pressed
OldJoyA_Fire1	DB	0		;) previous values of
OldJoyA_Fire2	DB	0		;) joystick variables

JoyB_XMin	DW	0
JoyB_YMin	DW	0
JoyB_XRef	DW	0		;x ref = centre x * 2
JoyB_YRef	DW	0		;y ref = centre y * 2
JoyB_XMax	DW	0
JoyB_YMax	DW	0
JoyB_XPos	DW	0		;x pos = current x position
JoyB_YPos	DW	0		;y pos = current y position
JoyB_XVal	DW	0		;x val = x pos * x scale (0 .. NPOS)
JoyB_YVal	DW	0		;y val = y pos * y scale (0 .. NPOS)
JoyB_Fire1	DB	0		;1 = fire pressed
JoyB_Fire2	DB	0		;1 = fire pressed
JoyB_JustFired1	DB	0		;1 = fire just pressed
JoyB_JustFired2	DB	0		;1 = fire just pressed
OldJoyB_Fire1	DB	0		;) previous values of
OldJoyB_Fire2	DB	0		;) joystick variables

;* Rudder Pedals calibration values
RP_Min		DW	0
RP_Mid		DW	0
RP_Max		DW	0
RP_Pos		DW	0
RP_Val		DW	0

;* ThrustMaster calibration values
TM_CoolieUp	DW	0
TM_CoolieRt	DW	0
TM_CoolieDn	DW	0
TM_CoolieLt	DW	0
TM_CoolieCn	DW	0
TM_CooliePos	DW	0
TM_CoolieHat	DB	0
TM_CoolieVal	DB	0
OldTM_CoolieVal	DB	0

		EVEN

;* Fast Gameport support
GameportDelay	DW	0
GameportJoyAX	DW	0
GameportJoyAY	DW	0
GameportJoyBX	DW	0
GameportJoyBY	DW	0
GameportButtons	DB	0

;* Unused equates and dummies for backwards compatibility
JoyA_XScale	EQU	JoyA_XRef
JoyA_YScale	EQU	JoyA_YRef
OldJoyA_XVal	EQU	JoyA_XVal
OldJoyA_YVal	EQU	JoyA_YVal
JoyB_XScale	EQU	JoyB_XRef
JoyB_YScale	EQU	JoyB_YRef
OldJoyB_XVal	EQU	JoyB_XVal
OldJoyB_YVal	EQU	JoyB_YVal
TM_XPos		EQU	JoyA_XPos
TM_YPos		EQU	JoyA_YPos
TM_XVal		EQU	JoyA_XVal
TM_YVal		EQU	JoyA_YVal
TM_CoolieNew	EQU	TM_CoolieVal
TM_CoolieOld	EQU	OldTM_CoolieVal

DATA		ENDS

;============================================================================

LIBCODE		SEGMENT BYTE PUBLIC 'CODE'
		ASSUME CS:LIBCODE, DS:DATA

RecalJoysticks PROC FAR
		xor	ax, ax
		mov	JoyA_Flag, al
		mov	JoyB_Flag, al
		mov	JoyA_XPos, ax
		mov	JoyA_YPos, ax
		mov	JoyA_XVal, ax
		mov	JoyA_YVal, ax
		mov	JoyA_Fire1, al
		mov	JoyA_Fire2, al
		mov	JoyA_JustFired1, al
		mov	JoyA_JustFired2, al
		mov	JoyB_XPos, ax
		mov	JoyB_YPos, ax
		mov	JoyB_XVal, ax
		mov	JoyB_YVal, ax
		mov	JoyB_Fire1, al
		mov	JoyB_Fire2, al
		mov	JoyB_JustFired1, al
		mov	JoyB_JustFired2, al
		mov	RP_Pos, ax
		mov	RP_Val, ax
		mov	TM_CooliePos, ax
		mov	TM_CoolieHat, al
		mov	TM_CoolieVal, al
		mov	OldTM_CoolieVal, al
		cmp	GameportChecked, 0
		jne	L_0685
		mov	ah, 84h
		mov	dx, 0F0h
		int	15h
		cmp	ax, 5347h
		jne	L_0680
		or	bx, bx
		je	L_0680
		mov	FastGameport, 1
		mov	GameportDelay, bx
L_0680:
		mov	GameportChecked, 1
L_0685:
		call	PollGameport
		mov	ah, 1
		call	ReadAnalogue
		jb	L_06BF
		mov	JoyA_XRef, ax
		mov	dx, JoyA_XMin
		or	dx, JoyA_XMax
		jne	L_06A1
		shl	ax, 1
		mov	JoyA_XMax, ax
L_06A1:
		mov	ah, 2
		call	ReadAnalogue
		jb	L_06BF
		mov	JoyA_YRef, ax
		mov	dx, JoyA_YMin
		or	dx, JoyA_YMax
		jne	L_06BA
		shl	ax, 1
		mov	JoyA_YMax, ax
L_06BA:
		mov	JoyA_Flag, 1
L_06BF:
		mov	al, ThrustMaster
		or	al, CHStick
		or	al, RudderPedals
		jne	L_0703
		mov	ah, 4
		call	ReadAnalogue
		jb	L_0703
		mov	JoyB_XRef, ax
		mov	dx, JoyB_XMin
		or	dx, JoyB_XMax
		jne	L_06E5
		shl	ax, 1
		mov	JoyB_XMax, ax
L_06E5:
		mov	ah, 8
		call	ReadAnalogue
		jb	L_0703
		mov	JoyB_YRef, ax
		mov	dx, JoyB_YMin
		or	dx, JoyB_YMax
		jne	L_06FE
		shl	ax, 1
		mov	JoyB_YMax, ax
L_06FE:
		mov	JoyB_Flag, 1
L_0703:
		test	RudderPedals, 1
		je	L_072D
		mov	RudderPedals, 0
		mov	ah, 4
		call	ReadAnalogue
		jb	L_072D
		mov	RP_Mid, ax
		mov	dx, RP_Min
		or	dx, RP_Max
		jne	L_0728
		shl	ax, 1
		mov	RP_Max, ax
L_0728:
		mov	RudderPedals, 1
L_072D:
		ret
RecalJoysticks ENDP

ReadJoysticks PROC FAR
		call	PollGameport
		mov	al, JoyA_Fire1
		mov	OldJoyA_Fire1, al
		mov	al, JoyA_Fire2
		mov	OldJoyA_Fire2, al
		mov	al, JoyB_Fire1
		mov	OldJoyB_Fire1, al
		mov	al, JoyB_Fire2
		mov	OldJoyB_Fire2, al
		xor	al, al
		mov	JoyA_Fire1, al
		mov	JoyA_Fire2, al
		mov	JoyA_JustFired1, al
		mov	JoyA_JustFired2, al
		mov	JoyB_Fire1, al
		mov	JoyB_Fire2, al
		mov	JoyB_JustFired1, al
		mov	JoyB_JustFired2, al
		test	CHStick, 1
		jne	L_07D1
		cmp	FastGameport, 0
		je	L_0776
		mov	al, GameportButtons
		jmp	L_077A
L_0776:
		mov	dx, 201h
		in	al, dx
L_077A:
		test	al, 10h
		jne	L_078F
		mov	JoyA_Fire1, 1
		test	OldJoyA_Fire1, 1
		jne	L_078F
		mov	JoyA_JustFired1, 1
L_078F:
		test	al, 20h
		jne	L_07A4
		mov	JoyA_Fire2, 1
		test	OldJoyA_Fire2, 1
		jne	L_07A4
		mov	JoyA_JustFired2, 1
L_07A4:
		test	al, 40h
		jne	L_07B9
		mov	JoyB_Fire1, 1
		test	OldJoyB_Fire1, 1
		jne	L_07B9
		mov	JoyB_JustFired1, 1
L_07B9:
		test	al, 80h
		jne	L_07CE
		mov	JoyB_Fire2, 1
		test	OldJoyB_Fire2, 1
		jne	L_07CE
		mov	JoyB_JustFired2, 1
L_07CE:
		jmp	L_087B
L_07D1:
		mov	TM_CoolieHat, 0
		mov	al, TM_CoolieVal
		mov	OldTM_CoolieVal, al
		mov	TM_CoolieVal, 0
		mov	dx, 201h
		in	al, dx
		and	al, 0F0h
		cmp	al, 0E0h
		je	L_0809
		cmp	al, 0D0h
		je	L_081C
		cmp	al, 0B0h
		je	L_082F
		cmp	al, 70h
		je	L_0842
		cmp	al, 0
		je	L_0855
		cmp	al, 80h
		je	L_085C
		cmp	al, 40h
		je	L_086A
		cmp	al, 0C0h
		je	L_0863
		jmp	L_087B
L_0809:
		mov	JoyA_Fire1, 1
		test	OldJoyA_Fire1, 1
		jne	L_081A
		mov	JoyA_JustFired1, 1
L_081A:
		jmp	L_087B
L_081C:
		mov	JoyA_Fire2, 1
		test	OldJoyA_Fire2, 1
		jne	L_082D
		mov	JoyA_JustFired2, 1
L_082D:
		jmp	L_087B
L_082F:
		mov	JoyB_Fire1, 1
		test	OldJoyB_Fire1, 1
		jne	L_0840
		mov	JoyB_JustFired1, 1
L_0840:
		jmp	L_087B
L_0842:
		mov	JoyB_Fire2, 1
		test	OldJoyB_Fire2, 1
		jne	L_0853
		mov	JoyB_JustFired2, 1
L_0853:
		jmp	L_087B
L_0855:
		mov	TM_CoolieVal, 1
		jmp	L_086F
L_085C:
		mov	TM_CoolieVal, 2
		jmp	L_086F
L_0863:
		mov	TM_CoolieVal, 3
		jmp	L_086F
L_086A:
		mov	TM_CoolieVal, 4
L_086F:
		mov	al, TM_CoolieVal
		cmp	al, OldTM_CoolieVal
		je	L_087B
		mov	TM_CoolieHat, al
L_087B:
		test	JoyA_Flag, 1
		jne	L_0885
		jmp	L_0AAC
L_0885:
		mov	ah, 1
		call	ReadAnalogue
		jae	L_088F
		jmp	L_0AA7
L_088F:
		mov	JoyA_XPos, ax
		mov	ah, 2
		call	ReadAnalogue
		jae	L_089C
		jmp	L_0AA7
L_089C:
		mov	JoyA_YPos, ax
		mov	ax, JoyA_XPos
		cmp	ax, JoyA_XRef
		jae	L_08EE
		mov	bp, JoyA_XMin
		test	JoySensitivity, 1
		je	L_08CA
		mov	ax, JoyA_XRef
		sub	ax, JoyA_XMin
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, JoyA_XMin
		mov	bp, ax
L_08CA:
		mov	ax, JoyA_XPos
		sub	ax, bp
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, JoyA_XRef
		sub	bx, bp
		jae	L_08E6
		xor	bx, bx
L_08E6:
		cmp	bx, dx
		jbe	L_0942
		div	bx
		jmp	L_0937
L_08EE:
		mov	bp, JoyA_XMax
		test	JoySensitivity, 1
		je	L_0910
		mov	ax, JoyA_XMax
		sub	ax, JoyA_XRef
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, JoyA_XRef
		mov	bp, ax
L_0910:
		mov	ax, JoyA_XPos
		sub	ax, JoyA_XRef
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, bp
		sub	bx, JoyA_XRef
		jae	L_092E
		xor	bx, bx
L_092E:
		cmp	bx, dx
		jbe	L_0942
		div	bx
		add	ax, 10h
L_0937:
		cmp	ax, 20h
		jbe	L_093F
		mov	ax, 20h
L_093F:
		mov	JoyA_XVal, ax
L_0942:
		mov	ax, JoyA_YPos
		cmp	ax, JoyA_YRef
		jae	L_0991
		mov	bp, JoyA_YMin
		test	JoySensitivity, 1
		je	L_096D
		mov	ax, JoyA_YRef
		sub	ax, JoyA_YMin
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, JoyA_YMin
		mov	bp, ax
L_096D:
		mov	ax, JoyA_YPos
		sub	ax, bp
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, JoyA_YRef
		sub	bx, bp
		jae	L_0989
		xor	bx, bx
L_0989:
		cmp	bx, dx
		jbe	L_09E5
		div	bx
		jmp	L_09DA
L_0991:
		mov	bp, JoyA_YMax
		test	JoySensitivity, 1
		je	L_09B3
		mov	ax, JoyA_YMax
		sub	ax, JoyA_YRef
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, JoyA_YRef
		mov	bp, ax
L_09B3:
		mov	ax, JoyA_YPos
		sub	ax, JoyA_YRef
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, bp
		sub	bx, JoyA_YRef
		jae	L_09D1
		xor	bx, bx
L_09D1:
		cmp	bx, dx
		jbe	L_09E5
		div	bx
		add	ax, 10h
L_09DA:
		cmp	ax, 20h
		jbe	L_09E2
		mov	ax, 20h
L_09E2:
		mov	JoyA_YVal, ax
L_09E5:
		test	ThrustMaster, 1
		jne	L_09EF
		jmp	L_0ABA
L_09EF:
		mov	al, TM_CoolieVal
		mov	OldTM_CoolieVal, al
		mov	TM_CooliePos, 0
		mov	TM_CoolieHat, 0
		mov	TM_CoolieVal, 0
		mov	ah, 8
		call	ReadAnalogue
		jae	L_0A0F
		jmp	L_0AA7
L_0A0F:
		mov	TM_CooliePos, ax
		mov	ax, TM_CoolieLt
		sub	ax, TM_CoolieCn
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		add	ax, TM_CoolieCn
		cmp	TM_CooliePos, ax
		ja	L_0A34
		mov	TM_CoolieVal, 1
		jmp	L_0A98
L_0A34:
		mov	ax, TM_CoolieDn
		sub	ax, TM_CoolieLt
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		add	ax, TM_CoolieLt
		cmp	TM_CooliePos, ax
		ja	L_0A56
		mov	TM_CoolieVal, 4
		jmp	L_0A98
L_0A56:
		mov	ax, TM_CoolieRt
		sub	ax, TM_CoolieDn
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		add	ax, TM_CoolieDn
		cmp	TM_CooliePos, ax
		ja	L_0A78
		mov	TM_CoolieVal, 2
		jmp	L_0A98
L_0A78:
		mov	ax, TM_CoolieUp
		sub	ax, TM_CoolieRt
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		add	ax, TM_CoolieRt
		cmp	TM_CooliePos, ax
		ja	L_0A98
		mov	TM_CoolieVal, 3
L_0A98:
		mov	al, TM_CoolieVal
		cmp	al, OldTM_CoolieVal
		je	L_0AA4
		mov	TM_CoolieHat, al
L_0AA4:
		jmp	L_0C39
L_0AA7:
		mov	JoyA_Flag, 0
L_0AAC:
		xor	ax, ax
		mov	JoyA_XPos, ax
		mov	JoyA_YPos, ax
		mov	JoyA_XVal, ax
		mov	JoyA_YVal, ax
L_0ABA:
		test	JoyB_Flag, 1
		jne	L_0AC4
		jmp	L_0C2B
L_0AC4:
		mov	ah, 4
		call	ReadAnalogue
		jae	L_0ACE
		jmp	L_0C26
L_0ACE:
		mov	JoyB_XPos, ax
		mov	ah, 8
		call	ReadAnalogue
		jae	L_0ADB
		jmp	L_0C26
L_0ADB:
		mov	JoyB_YPos, ax
		mov	ax, JoyB_XPos
		cmp	ax, JoyB_XRef
		jae	L_0B2D
		mov	bp, JoyB_XMin
		test	JoySensitivity, 1
		je	L_0B09
		mov	ax, JoyB_XRef
		sub	ax, JoyB_XMin
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, JoyB_XMin
		mov	bp, ax
L_0B09:
		mov	ax, JoyB_XPos
		sub	ax, bp
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, JoyB_XRef
		sub	bx, bp
		jae	L_0B25
		xor	bx, bx
L_0B25:
		cmp	bx, dx
		jbe	L_0B81
		div	bx
		jmp	L_0B76
L_0B2D:
		mov	bp, JoyB_XMax
		test	JoySensitivity, 1
		je	L_0B4F
		mov	ax, JoyB_XMax
		sub	ax, JoyB_XRef
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, JoyB_XRef
		mov	bp, ax
L_0B4F:
		mov	ax, JoyB_XPos
		sub	ax, JoyB_XRef
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, bp
		sub	bx, JoyB_XRef
		jae	L_0B6D
		xor	bx, bx
L_0B6D:
		cmp	bx, dx
		jbe	L_0B81
		div	bx
		add	ax, 10h
L_0B76:
		cmp	ax, 20h
		jbe	L_0B7E
		mov	ax, 20h
L_0B7E:
		mov	JoyB_XVal, ax
L_0B81:
		mov	ax, JoyB_YPos
		cmp	ax, JoyB_YRef
		jae	L_0BD0
		mov	bp, JoyB_YMin
		test	JoySensitivity, 1
		je	L_0BAC
		mov	ax, JoyB_YRef
		sub	ax, JoyB_YMin
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, JoyB_YMin
		mov	bp, ax
L_0BAC:
		mov	ax, JoyB_YPos
		sub	ax, bp
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, JoyB_YRef
		sub	bx, bp
		jae	L_0BC8
		xor	bx, bx
L_0BC8:
		cmp	bx, dx
		jbe	L_0C24
		div	bx
		jmp	L_0C19
L_0BD0:
		mov	bp, JoyB_YMax
		test	JoySensitivity, 1
		je	L_0BF2
		mov	ax, JoyB_YMax
		sub	ax, JoyB_YRef
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, JoyB_YRef
		mov	bp, ax
L_0BF2:
		mov	ax, JoyB_YPos
		sub	ax, JoyB_YRef
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, bp
		sub	bx, JoyB_YRef
		jae	L_0C10
		xor	bx, bx
L_0C10:
		cmp	bx, dx
		jbe	L_0C24
		div	bx
		add	ax, 10h
L_0C19:
		cmp	ax, 20h
		jbe	L_0C21
		mov	ax, 20h
L_0C21:
		mov	JoyB_YVal, ax
L_0C24:
		jmp	L_0C39
L_0C26:
		mov	JoyB_Flag, 0
L_0C2B:
		xor	ax, ax
		mov	JoyB_XPos, ax
		mov	JoyB_YPos, ax
		mov	JoyB_XVal, ax
		mov	JoyB_YVal, ax
L_0C39:
		ret
ReadJoysticks ENDP

ReadRudder PROC FAR
		test	RudderPedals, 1
		jne	L_0C44
		jmp	L_0CF4
L_0C44:
		mov	ah, 4
		call	ReadAnalogue
		jae	L_0C4E
		jmp	L_0CF5
L_0C4E:
		mov	RP_Pos, ax
		mov	ax, RP_Pos
		cmp	ax, RP_Mid
		jae	L_0CA0
		mov	bp, RP_Min
		test	JoySensitivity, 1
		je	L_0C7C
		mov	ax, RP_Mid
		sub	ax, RP_Min
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, RP_Min
		mov	bp, ax
L_0C7C:
		mov	ax, RP_Pos
		sub	ax, bp
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, RP_Mid
		sub	bx, bp
		jae	L_0C98
		xor	bx, bx
L_0C98:
		cmp	bx, dx
		jbe	L_0CF4
		div	bx
		jmp	L_0CE9
L_0CA0:
		mov	bp, RP_Max
		test	JoySensitivity, 1
		je	L_0CC2
		mov	ax, RP_Max
		sub	ax, RP_Mid
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		shr	ax, 1
		adc	ax, RP_Mid
		mov	bp, ax
L_0CC2:
		mov	ax, RP_Pos
		sub	ax, RP_Mid
		cmc
		rcr	ax, 1
		cwd
		rcl	ax, 1
		and	ax, dx
		mov	dx, 10h
		mul	dx
		mov	bx, bp
		sub	bx, RP_Mid
		jae	L_0CE0
		xor	bx, bx
L_0CE0:
		cmp	bx, dx
		jbe	L_0CF4
		div	bx
		add	ax, 10h
L_0CE9:
		cmp	ax, 20h
		jbe	L_0CF1
		mov	ax, 20h
L_0CF1:
		mov	RP_Val, ax
L_0CF4:
		ret
L_0CF5:
		mov	RudderPedals, 0
		mov	RP_Pos, 0
		mov	RP_Val, 0
		ret
ReadRudder ENDP

ReadAnalogue PROC NEAR
		cmp	FastGameport, 1
		je	L_0D70
		mov	dx, 201h
		cli
		mov	cx, 0
L_0D15:
		in	al, dx
		jmp	L_0D18
L_0D18:
		jmp	L_0D1A
L_0D1A:
		jmp	L_0D1C
L_0D1C:
		jmp	L_0D1E
L_0D1E:
		jmp	L_0D20
L_0D20:
		jmp	L_0D22
L_0D22:
		jmp	L_0D24
L_0D24:
		jmp	L_0D26
L_0D26:
		jmp	L_0D28
L_0D28:
		jmp	L_0D2A
L_0D2A:
		test	al, ah
		je	L_0D33
		loop	L_0D15
		stc
		jmp	L_0D6E
L_0D33:
		out	dx, al
		jmp	L_0D36
L_0D36:
		jmp	L_0D38
L_0D38:
		jmp	L_0D3A
L_0D3A:
		jmp	L_0D3C
L_0D3C:
		jmp	L_0D3E
L_0D3E:
		jmp	L_0D40
L_0D40:
		jmp	L_0D42
L_0D42:
		jmp	L_0D44
L_0D44:
		jmp	L_0D46
L_0D46:
		jmp	L_0D48
L_0D48:
		mov	cx, 0
L_0D4B:
		in	al, dx
		jmp	L_0D4E
L_0D4E:
		jmp	L_0D50
L_0D50:
		jmp	L_0D52
L_0D52:
		jmp	L_0D54
L_0D54:
		jmp	L_0D56
L_0D56:
		jmp	L_0D58
L_0D58:
		jmp	L_0D5A
L_0D5A:
		jmp	L_0D5C
L_0D5C:
		jmp	L_0D5E
L_0D5E:
		jmp	L_0D60
L_0D60:
		test	al, ah
		je	L_0D69
		loop	L_0D4B
		stc
		jmp	L_0D6E
L_0D69:
		neg	cx
		mov	ax, cx
		clc
L_0D6E:
		sti
		ret
L_0D70:
		cmp	ah, 1
		jne	L_0D7A
		mov	ax, GameportJoyAX
		jmp	L_0D96
L_0D7A:
		cmp	ah, 2
		jne	L_0D84
		mov	ax, GameportJoyAY
		jmp	L_0D96
L_0D84:
		cmp	ah, 4
		jne	L_0D8E
		mov	ax, GameportJoyBX
		jmp	L_0D96
L_0D8E:
		cmp	ah, 8
		jne	L_0D96
		mov	ax, GameportJoyBY
L_0D96:
		clc
		ret
ReadAnalogue ENDP

PollGameport PROC NEAR
		mov	GameportJoyAX, 0
		mov	GameportJoyAY, 0
		mov	GameportJoyBX, 0
		mov	GameportJoyBY, 0
		mov	GameportButtons, 0
		cmp	FastGameport, 0
		je	L_0DFA
		mov	al, 0
		cmp	RudderPedals, 0
		je	L_0DC7
		or	al, 1
L_0DC7:
		cmp	ThrustMaster, 0
		je	L_0DD0
		or	al, 2
L_0DD0:
		inc	al
		mov	ah, 84h
		mov	bx, GameportDelay
		mov	dx, 1
		int	15h
		mov	GameportJoyAX, ax
		mov	GameportJoyAY, bx
		mov	GameportJoyBX, cx
		mov	GameportJoyBY, dx
		mov	ah, 84h
		mov	bx, GameportDelay
		mov	dx, 0
		int	15h
		mov	GameportButtons, al
L_0DFA:
		ret
PollGameport ENDP
LIBCODE		ENDS

		END
