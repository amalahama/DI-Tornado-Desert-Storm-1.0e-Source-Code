;****************************************************************************
;*
;* CHKSUM.ASM - DOS MZ Executable 1's Complement Checksum Utility
;*
;* Computes standard MZ header 1's complement checksum and stamps offset 0x12.
;*
;****************************************************************************

		.MODEL	SMALL
		.STACK	100h

		.DATA

ErrMsg1		DB	"Usage: CHKSUM <filename.exe>", 0Dh, 0Ah, "$"
ErrMsg2		DB	"Error: Cannot open file", 0Dh, 0Ah, "$"
ErrMsg3		DB	"Error: Cannot read/write file", 0Dh, 0Ah, "$"
SuccessMsg	DB	"Checksum updated: $"
Crlf		DB	0Dh, 0Ah, "$"

ZeroWord	DW	0
FileHandle	DW	0
ChkSumVal	DW	0
HexBuf		DB	4 DUP('0'), "$"

Buffer		DB	8192 DUP(0)

		.CODE

Main		PROC	FAR
		mov	ax, @DATA
		mov	es, ax

;* parse command line argument from PSP (at DS:0080h)
		mov	si, 080h
		lodsb			;character count
		cbw
		test	ax, ax
		jz	ShowUsage

		mov	cx, ax
		mov	di, OFFSET Buffer ;use buffer for filename

;* skip leading spaces
SkipSpaces:	lodsb
		cmp	al, ' '
		jne	GotChar
		loop	SkipSpaces
		jmp	ShowUsage

GotChar:	stosb
		dec	cx
		jz	DoneName

CopyName:	lodsb
		cmp	al, 0Dh		;CR?
		je	DoneName
		cmp	al, ' '
		je	DoneName
		stosb
		loop	CopyName

DoneName:	xor	al, al
		stosb			;null terminator

;* set DS to @DATA
		mov	ax, @DATA
		mov	ds, ax

;* open file for read/write (AL=2)
		mov	dx, OFFSET Buffer
		mov	ax, 03D02h
		int	021h
		jc	FileOpenErr
		mov	FileHandle, ax

;* seek to offset 0x12
		mov	bx, FileHandle
		xor	cx, cx
		mov	dx, 012h
		mov	ax, 04200h	;SEEK_SET
		int	021h
		jc	FileRwErr

;* write 0x0000 at offset 0x12
		mov	dx, OFFSET ZeroWord
		mov	cx, 2
		mov	ah, 040h
		int	021h
		jc	FileRwErr

;* seek to beginning of file
		xor	cx, cx
		xor	dx, dx
		mov	ax, 04200h	;SEEK_SET
		int	021h
		jc	FileRwErr

;* read file and compute 16-bit word sum
		xor	bp, bp		;sum = 0

ReadLoop:	mov	dx, OFFSET Buffer
		mov	cx, 8192
		mov	ah, 03Fh
		int	021h
		jc	FileRwErr
		test	ax, ax		;EOF?
		jz	CalcDone

		mov	cx, ax
		shr	cx, 1		;number of words
		mov	si, OFFSET Buffer
		jcxz	CheckOddByte

SumWords:	lodsw
		add	bp, ax
		loop	SumWords

CheckOddByte:	test	al, 1		;odd byte remaining?
		jz	ReadLoop
		lodsb
		xor	ah, ah
		add	bp, ax
		jmp	ReadLoop

CalcDone:
;* 1's complement: NOT sum
		not	bp
		mov	ChkSumVal, bp

;* seek to offset 0x12
		xor	cx, cx
		mov	dx, 012h
		mov	ax, 04200h	;SEEK_SET
		int	021h
		jc	FileRwErr

;* write checksum to offset 0x12
		mov	dx, OFFSET ChkSumVal
		mov	cx, 2
		mov	ah, 040h
		int	021h
		jc	FileRwErr

;* close file
		mov	ah, 03Eh
		int	021h

;* print success
		mov	ah, 09h
		mov	dx, OFFSET SuccessMsg
		int	021h

;* convert ChkSumVal to hex
		mov	ax, ChkSumVal
		mov	di, OFFSET HexBuf
		call	WordToHex
		mov	ah, 09h
		mov	dx, OFFSET HexBuf
		int	021h
		mov	dx, OFFSET Crlf
		int	021h

		mov	ax, 04C00h	;exit 0
		int	021h

ShowUsage:	mov	ax, @DATA
		mov	ds, ax
		mov	ah, 09h
		mov	dx, OFFSET ErrMsg1
		int	021h
		mov	ax, 04C01h
		int	021h

FileOpenErr:	mov	ah, 09h
		mov	dx, OFFSET ErrMsg2
		int	021h
		mov	ax, 04C02h
		int	021h

FileRwErr:	mov	ah, 09h
		mov	dx, OFFSET ErrMsg3
		int	021h
		mov	bx, FileHandle
		mov	ah, 03Eh
		int	021h
		mov	ax, 04C03h
		int	021h

Main		ENDP

WordToHex	PROC	NEAR
		push	ax
		push	cx
		mov	cx, 4
HexDigitLoop:	rol	ax, 1
		rol	ax, 1
		rol	ax, 1
		rol	ax, 1
		push	ax
		and	al, 0Fh
		add	al, '0'
		cmp	al, '9'
		jbe	@F
		add	al, 7
@@:		stosb
		pop	ax
		loop	HexDigitLoop
		pop	cx
		pop	ax
		ret
WordToHex	ENDP

		END	Main
