;****************************************************************************
;*
;* VOICE.ASM
;*
;* Creative Voice Interface and Driver for Tornado 1.0e.
;*
;****************************************************************************

		OPTION	M510

		PUBLIC	InstallVoice
		PUBLIC	RestoreVoice
		PUBLIC	EnableVoice
		PUBLIC	DisableVoice
		PUBLIC	PlayVoiceSample1
		PUBLIC	PlayVoiceSample2
		PUBLIC	StopVoice
		PUBLIC	SetVoiceVolume
		PUBLIC	PlayVoiceSample3
		PUBLIC	PlayVoiceSample4
		PUBLIC	PlayVoiceSample5
		PUBLIC	PlayVoiceSample6
		PUBLIC	PlayVoiceSample7

		PUBLIC	VoiceInit
		PUBLIC	VoiceFault
		PUBLIC	VoiceVolume

				
		EXTRN	VocDataStart:BYTE
		EXTRN	VoiceLibStart:FAR
		EXTRN	VcdDataStart:BYTE

DATA		SEGMENT PARA PUBLIC 'DATA'

VoiceInit	DW	0
VoiceFault	DB	0
VoiceVolume	DB	0

DATA		ENDS

IFDEF DESERT
VOICE_INIT_LO	EQU	0D0h
VOICE_FAULT_LO	EQU	0D2h
VOICE_VOL_LO	EQU	0D3h
ELSE
VOICE_INIT_LO	EQU	0E0h
VOICE_FAULT_LO	EQU	0E2h
VOICE_VOL_LO	EQU	0E3h
ENDIF

VOICETEXT	SEGMENT BYTE PUBLIC 'CODE'
		ASSUME	CS:VOICETEXT, DS:DATA

;---------------------------
InstallVoice	PROC	FAR
;---------------------------
		DB	9Ah,0F2h,1
		DW	SEG VoiceLibStart
		DB	83h,0E0h,6,83h,0F8h,6,75h,1Fh,9Ah,0E6h,0
		DW	SEG VoiceLibStart
		DB	83h,0F8h,0,74h,15h,9Ah,0D1h,3
		DW	SEG VoiceLibStart
		DB	83h,0F8h,0,75h,0Bh,0B8h,0,0,0C7h,6,VOICE_INIT_LO,0FCh,1,0,0EBh,9
		DB	0B8h,1,0,0C7h,6,VOICE_INIT_LO,0FCh,0,0,0CBh
InstallVoice	ENDP

;---------------------------
RestoreVoice	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,5,9Ah,38h,4
		DW	SEG VoiceLibStart
		DB	0CBh
RestoreVoice	ENDP

;---------------------------
EnableVoice	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,0Ch,0B8h,1,0,50h,9Ah,0Bh,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,2,0CBh
EnableVoice	ENDP

;---------------------------
DisableVoice	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,0Ch,0B8h,0,0,50h,9Ah,0Bh,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,2,0CBh
DisableVoice	ENDP

;---------------------------
PlayVoiceSample1	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,13h,0BAh
		DW	SEG VocDataStart
		DB	0B8h,0,0,83h,0C0h,1Ah,52h,50h,9Ah,5Eh,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,4,0CBh
PlayVoiceSample1	ENDP

;---------------------------
PlayVoiceSample2	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,13h,0BAh
		DW	SEG VocDataStart
		DB	0B8h,0AFh,0Fh,83h,0C0h,1Ah,52h,50h,9Ah,5Eh,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,4,0CBh
PlayVoiceSample2	ENDP

;---------------------------
StopVoice	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,11h,0B8h,1,0,50h,9Ah,84h,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,2,9Ah,2Fh,4
		DW	SEG VoiceLibStart
		DB	0CBh
StopVoice	ENDP

;---------------------------
SetVoiceVolume	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,0Fh,1Eh,0B8h
		DW	SEG VocDataStart
		DB	8Eh,0D8h,88h,16h,24h,0,88h,16h,0D3h,0Fh,1Fh,0CBh
SetVoiceVolume	ENDP

;---------------------------
PlayVoiceSample3	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,13h,0BAh
		DW	SEG VocDataStart
		DB	0B8h,1Ah,2Fh,83h,0C0h,1Ah,52h,50h,9Ah,5Eh,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,4,0CBh
PlayVoiceSample3	ENDP

;---------------------------
PlayVoiceSample4	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,13h,0BAh
		DW	SEG VocDataStart
		DB	0B8h,86h,3Ch,83h,0C0h,1Ah,52h,50h,9Ah,5Eh,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,4,0CBh
PlayVoiceSample4	ENDP

;---------------------------
PlayVoiceSample5	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,13h,0BAh
		DW	SEG VocDataStart
		DB	0B8h,0F2h,49h,83h,0C0h,1Ah,52h,50h,9Ah,5Eh,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,4,0CBh
PlayVoiceSample5	ENDP

;---------------------------
PlayVoiceSample6	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,13h,0BAh
		DW	SEG VocDataStart
		DB	0B8h,97h,51h,83h,0C0h,1Ah,52h,50h,9Ah,5Eh,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,4,0CBh
PlayVoiceSample6	ENDP

;---------------------------
PlayVoiceSample7	PROC	FAR
;---------------------------
		DB	83h,3Eh,VOICE_INIT_LO,0FCh,0,74h,13h,0BAh
		DW	SEG VocDataStart
		DB	0B8h,0BEh,52h,83h,0C0h,1Ah,52h,50h,9Ah,5Eh,4
		DW	SEG VoiceLibStart
		DB	83h,0C4h,4,0CBh
PlayVoiceSample7	ENDP

;---------------------------
VoiceWriteDsp	PROC	NEAR
;---------------------------
		DB	0A2h,VOICE_VOL_LO,0FCh,1Eh,0B8h
		DW	SEG VcdDataStart
		DB	8Eh,0D8h,8Bh,16h,0Ah,0,1Fh,83h,0C2h,0Ch,0B9h,0,0,0ECh,0A8h,80h
		DB	74h,9,0E2h,0F9h,0C6h,6,VOICE_FAULT_LO,0FCh,1,0EBh,4,0A0h,VOICE_VOL_LO,0FCh,0EEh,0C3h
		DB	0
VoiceWriteDsp	ENDP

VOICETEXT	ENDS

		END
