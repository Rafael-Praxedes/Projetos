;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT 

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;NOVAS VARIÁVEIS

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA
	
	#DEFINE BIT_0 GPIO, GP0   ;BIT LSB (0)
	#DEFINE BIT_1 GPIO, GP1   ;BIT (1)
	#DEFINE BIT_2 GPIO, GP4   ;BIT (2)
	#DEFINE BIT_3 GPIO, GP5   ;BIT MSB (3)
	
	#DEFINE KEY   GPIO, GP3   ;Chave de seleção LOW/HIGH

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00001100'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS, EXCETO GP2 E GP3
	
	MOVLW   B'00010100'	;GP0 = AN0  GP1 = AN1	GP2 = AN2  GP4 = AN3 
	MOVWF	ANSEL		;DEFINE PORTAS GP2 ENTRADA ANALÓGICA E AS DEMAIS 
				;COMO COMO Digital I/O
	MOVLW	B'10000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	MOVLW   B'00001001'	;Ativa o conversor Analógico/Digital
	MOVWF   ADCON0
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;******************************************;
;** Aluno: Rafael Maranhão Rêgo Praxedes **;
;**                                      **;
;** Matrícula: 11503299                  **;
;**                                      **;
;** Disciplina: Microcontroladores       **;
;**                                      **;
;** Professor: Mardson Amorim            **;
;******************************************;
	
;LEGENDA:
;   -MSD: Most Significant Digit - Dígito Mais Significativo
;   -LSD: Less Significant Digit - Dígito Menos Significativo
	
MAIN
	;CORPO DA ROTINA PRINCIPAL
	
	BSF	ADCON0, 1	;Bit GO/DONE - Ativa o processo de conversão A/D  
ESPERA	
	BTFSC	ADCON0, 1	;Testa se o Bit GO/DONE é zero. Se sim, a conversão acabou
	GOTO	ESPERA		;Se não, continua aguardando o fim da conversão 

TESTE_0_0.5
	
	MOVLW	.11
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [0 0.5]
			
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_0.5_1	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 0 para LSD e MSD 
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe 
				;MSD. Caso contrário, exibe LSD  
	GOTO	VALOR_0		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_0.5_1
	
	MOVLW	.21
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [0.5 1]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_1_1.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 1 para LSD e 0 para MSD
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_1		;LSD
	GOTO	VALOR_0		;MSD

TESTE_1_1.5
	
	MOVLW	.32
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [1 1.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_1.5_2	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 1 para LSD e 0 para MSD
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_1		;LSD
	GOTO	VALOR_0		;MSD
	    
TESTE_1.5_2
	
	MOVLW	.42
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [1.5 2]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_2_2.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 2 para LSD e 0 para MSD
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_2		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_2_2.5
	
	MOVLW	.53
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [2 2.5]  
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_2.5_3	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 2 para LSD e 0 para MSD
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_2		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_2.5_3
	
	MOVLW	.63
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [2.5 3]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_3_3.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 3 para LSD e 0 para MSD
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_3		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_3_3.5
	
	MOVLW	.74
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [3 3.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_3.5_4	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 3 para LSD e 0 para MSD
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_3		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_3.5_4
	
	MOVLW	.84
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [3.5 4]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_4_4.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 4 para LSD e 0 para MSD
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_4		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_4_4.5
	
	MOVLW	.95
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [4 4.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_4.5_5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 4 para LSD e 0 para MSD
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_4		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_4.5_5
	
	MOVLW	.105
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [4.5 5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_5_5.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 5 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_5		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_5_5.5
	
	MOVLW	.116
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [5 5.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.  
	GOTO	TESTE_5.5_6	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 5 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_5		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_5.5_6
	
	MOVLW	.126
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [5.5 6]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.  
	GOTO	TESTE_6_6.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 6 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_6		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_6_6.5
	
	MOVLW	.137
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [6 6.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.	  
	GOTO	TESTE_6.5_7	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 6 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_6		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_6.5_7
	
	MOVLW	.147
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [6.5 7]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.	  
	GOTO	TESTE_7_7.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 7 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_7		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_7_7.5
	
	MOVLW	.158
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [7 7.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.  
	GOTO	TESTE_7.5_8	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 7 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_7		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_7.5_8
	
	MOVLW	.168
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [7.5 8]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.	  
	GOTO	TESTE_8_8.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 8 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_8		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_8_8.5
	
	MOVLW	.179
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [8 8.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.	  
	GOTO	TESTE_8.5_9	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 8 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_8		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_8.5_9
	
	MOVLW	.189
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [8.5 9]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_9_9.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 9 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_9		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_9_9.5
	
	MOVLW	.200
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [9 9.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_9.5_10	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 9 para LOW e 0 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_9		;LSD
	GOTO	VALOR_0		;MSD
	
TESTE_9.5_10
	
	MOVLW	.210
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [9.5 10]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_10_10.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 0 para LOW e 1 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_0		;LSD
	GOTO	VALOR_1		;MSD
	
TESTE_10_10.5
	
	MOVLW	.221
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [10 10.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_10.5_11	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 0 para LOW e 1 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_0		;LSD
	GOTO	VALOR_1		;MSD
	
TESTE_10.5_11
	
	MOVLW	.231
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [10.5 11]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_11_11.5	;Se não, testa se pertence ao próximo intervalo
	
	;Manda 1 para LOW e 1 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_1		;LSD
	GOTO	VALOR_1		;MSD
	
TESTE_11_11.5
	
	MOVLW	.242
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [11 11.5]
	
	BTFSC	STATUS, C	;Se o carry = 0, pertence ao intervalo questão.
	GOTO	TESTE_11.5_12	;Se não, pertence ao próximo intervalo, já que ele é o último (valor máximo)
	
	;Manda 1 para LOW e 1 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_1		;LSD
	GOTO	VALOR_1		;MSD
	
TESTE_11.5_12
	
	MOVLW	.252
	SUBWF	ADRESH, W	;Verifica se o valor convertido pertence ao intervalo [11.5 12]
	
				;Não há mais intervalos a serem verificados
	
	;Manda 2 para LOW e 1 para HIGH
	BTFSS	KEY		;Verifica se a chave (KEY - GP3) está ativada. Se sim, exibe
				;MSD. Caso contrário, exibe LSD
	GOTO	VALOR_2		;LSD
	GOTO	VALOR_1		;MSD
	
;BIT_3	BIT_2	BIT_1	BIT_0
;MSB	----	----	LSB
	
VALOR_0				;(0)10 = (0000)2
	BCF	BIT_0		
	BCF	BIT_1
	BCF	BIT_2
	BCF	BIT_3
	
	GOTO	MAIN
VALOR_1				;(1)10 = (0001)2
	BSF	BIT_0
	BCF	BIT_1
	BCF	BIT_2
	BCF	BIT_3
	
	GOTO	MAIN
VALOR_2				;(2)10 = (0010)2
	BCF	BIT_0
	BSF	BIT_1
	BCF	BIT_2
	BCF	BIT_3
	
	GOTO	MAIN
VALOR_3				;(3)10 = (0011)2
	BSF	BIT_0
	BSF	BIT_1
	BCF	BIT_2
	BCF	BIT_3
	
	GOTO	MAIN
VALOR_4				;(4)10 = (0100)2
	BCF	BIT_0
	BCF	BIT_1
	BSF	BIT_2
	BCF	BIT_3
	
	GOTO	MAIN
VALOR_5				;(5)10 = (0101)2
	BSF	BIT_0
	BCF	BIT_1
	BSF	BIT_2
	BCF	BIT_3
	
	GOTO	MAIN
VALOR_6				;(6)10 = (0110)2
	BCF	BIT_0
	BSF	BIT_1
	BSF	BIT_2
	BCF	BIT_3
	
	GOTO	MAIN
VALOR_7				;(7)10 = (0111)2
	BSF	BIT_0
	BSF	BIT_1
	BSF	BIT_2
	BCF	BIT_3
	
	GOTO	MAIN
VALOR_8				;(8)10 = (1000)2
	BCF	BIT_0
	BCF	BIT_1
	BCF	BIT_2
	BSF	BIT_3
	
	GOTO	MAIN
VALOR_9				;(9)10 = (1001)2
	BSF	BIT_0
	BCF	BIT_1
	BCF	BIT_2
	BSF	BIT_3
	
	GOTO	MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
FIM
	GOTO FIM

	END
