RCC_BASE	EQU		0x40023800
RCC_AHB1ENR	EQU		0x4002381C	; RCC_BASE + 0x1C
GPIOA_BASE	EQU		0x40020000	; page 47 in RM
GPIOA_MODER	EQU		0x40020000
GPIOA_ODR	EQU		0x40020014	; GPIOA_BASE + 0x14 

GPIOA_EN	EQU		1 << 0
MODER5_OUT	EQU		1 << 10
LED_GREEN	EQU		1 << 5
LED_GREEN_OFF	EQU		~0x20

DELAY		EQU		0x000F
ONESEC		EQU		5333333
HSEC		EQU		266667
FSEC		EQU		106667


				AREA |.text|,CODE,READONLY,ALIGN=2
				THUMB
				EXPORT	__main

__main
			BL		GPIOA_Init

GPIOA_Init
			LDR		R0,=RCC_AHB1ENR	; R0 points to peripheral clock register
			LDR		R1,[R0]			; load peripheral clock register is into R1
			ORR		R1, R1, #GPIOA_EN		; R1 = R1|GPIOA_EN
			STR		R1,[R0]			;		Store R1 into RCC_AHB1ENR
			
			LDR		R0,=GPIOA_MODER	; 	R0 points to GPIOA_MODER
			LDR		R1,[R0]			;	load MODER value into register R1
			ORR		R1,R1, #MODER5_OUT		;	R1 = R1 | MODER5_OUT configure PA5 as output
			STR		R1,[R0]					;	store R1 into GPIOA_MODER
			MOV 	R1,#0					;  	R0 = 0
			LDR		R2,=GPIOA_ODR			; R2 points to GPIOA_ODR
			
			
Blink
			MOV		R1,#LED_GREEN		; R1 = LED_GREEN
			STR 	R1,[R2]				; GPIOA_ODR = LED_GREEN
			LDR		R3,=HSEC			; R3 = HSEC
			BL		Delay				; Branch to Delay function
			MOV		R1,#0				; set R1 to 0
			ORR		R1,R1,#LED_GREEN_OFF ; R1 = R1|LED_GREEN_OFF
			LDR		R4,[R2]				 ; R4 = GPIOA_ODR
			AND		R4,R4,R1			 ; R4 = R4 & R1
			STR		R4,[R2]				 ; GPIOA_ODR + R4
			LDR		R3,=HSEC			 ; for delay
			BL		Delay
			
			B		Blink
			

			
Delay
			SUBS	R3,R3,#1		; R3--
			BNE		Delay			; if(R3 != 0) branch to Delay 
			BX		LR				; Return
			ALIGN			
			END
			
			