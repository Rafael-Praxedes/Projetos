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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		COUNTER_BASE
		FLAG

		;NOVAS VARIÁVEIS

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA
	
	#DEFINE  DO  FLAG,1   ;FLAG referente a nota musical DO
			      ;1 - DO é a nota musical atual
			      ;0 - DO não é a nota musical atual
			     
	#DEFINE  RE  FLAG,2   ;FLAG referente a nota musical RE
			      ;1 - RE é a nota musical atual
			      ;0 - RE não é a nota musical atual
	
	#DEFINE  MI  FLAG,3   ;FLAG referente a nota musical MI
			      ;1 - MI é a nota musical atual
			      ;0 - MI não é a nota musical atual
	
	#DEFINE  FA  FLAG,4   ;FLAG referente a nota musical FA
			      ;1 - FA é a nota musical atual
			      ;0 - FA não é a nota musical atual
	
	#DEFINE  SOL  FLAG,5  ;FLAG referente a nota musical SOL
			      ;1 - SOL é a nota musical atual
			      ;0 - SOL não é a nota musical atual
			
	#DEFINE  LA  FLAG,6   ;FLAG referente a nota musical LA
			      ;1 - LA é a nota musical atual
			      ;0 - LA não é a nota musical atual
			     
	#DEFINE  SI  FLAG,7   ;FLAG referente a nota musical SI
			      ;1 - SI é a nota musical atual
			      ;0 - SI não é a nota musical atual

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

	ORG	0x04		;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES
	
BTFSC PIR1, TMR1IF	    ;Verifica se a interrupção foi gerada pelo TMR1
GOTO TIMER_UM		    ;Se sim, configure TMR1
	
TIMER_ZERO		    ;Se não, configure TMR0
	
	MOVFW COUNTER_BASE  ;Base da contagem (valor inicial do TMR0)
	MOVWF TMR0	    
	BCF   INTCON, T0IF  ;Limpa a flag de interrupção do TMR0
	
	COMF GPIO           ;Complementa todas as portas (Breakpoint)
	
			    ;Tal instrução pode ser aplicada devido ao fato
			    ;de GPO ser entrada, logo, não é alterada por ela,
			    ;como também por não serem utilizadas as demais 
			    ;portas, com exceção do próprio GP0 e do GP5
	GOTO SAI_INT
	
TIMER_UM
	
	MOVLW 0x04	    ;Base da contagem (valor inicial do TMR1 - LOW)
	MOVWF TMR1L
	
	MOVLW 0x0C	    ;Base da contagem (valor inicial do TMR1 - HIGH)
	MOVWF TMR1H
	
	BCF PIR1, TMR1IF    ;Limpa a flag de interrupção do TMR1 (Breakpoint)
	
NOTAS			    ;A cada estouro do TMR1, uma nova nota musical 
			    ;será configurada
			    
	BTFSC DO	    ;Se a nota corrente for DO
	GOTO CONFIG_RE	    ;Modifique para a nota RE
	
	BTFSC RE	    ;Se a nota corrente for RE
	GOTO CONFIG_MI	    ;Modifique para a nota MI
	
	BTFSC MI	    ;Se a nota corrente for MI
	GOTO CONFIG_FA	    ;Modifique para a nota FA
	
	BTFSC FA	    ;Se a nota corrente for FA
	GOTO CONFIG_SOL	    ;Modifique para a nota SOL
	
	BTFSC SOL	    ;Se a nota corrente for SOL
	GOTO CONFIG_LA	    ;Modifique para a nota LA
	
	BTFSC LA	    ;Se a nota corrente for LA
	GOTO CONFIG_SI	    ;Modifique para a nota SI
	
	BTFSC SI	    ;Se a nota corrente for SI
	GOTO CONFIG_DO	    ;Modifique para a nota DO (novo ciclo)
	
CONFIG_DO
	MOVLW B'00000010'   ;Seta a flag correspondente a nota DO
	MOVWF FLAG
	
	MOVLW .19
	MOVWF COUNTER_BASE  
	MOVWF TMR0	    ;Move para o TMR0 o valor inicial correspondente
			    ;a nota musical em questão
	BCF INTCON, T0IF
	GOTO SAI_INT
	
CONFIG_RE
	MOVLW B'00000100'   ;Seta a flag correspondente a nota RE
	MOVWF FLAG
	
	MOVLW .45
	MOVWF COUNTER_BASE
	MOVWF TMR0	    ;Move para o TMR0 o valor inicial correspondente
			    ;a nota musical em questão
	BCF INTCON, T0IF
	GOTO SAI_INT
	
CONFIG_MI
	MOVLW B'00001000'   ;Seta a flag correspondente a nota MI
	MOVWF FLAG
	
	MOVLW .68
	MOVWF COUNTER_BASE
	MOVWF TMR0	    ;Move para o TMR0 o valor inicial correspondente
			    ;a nota musical em questão
	BCF INTCON, T0IF
	GOTO SAI_INT
	
CONFIG_FA
	MOVLW B'00010000'   ;Seta a flag correspondente a nota FA
	MOVWF FLAG
	
	MOVLW .79 
	MOVWF COUNTER_BASE
	MOVWF TMR0	    ;Move para o TMR0 o valor inicial correspondente
			    ;a nota musical em questão
	BCF INTCON, T0IF
	GOTO SAI_INT
	
CONFIG_SOL
	MOVLW B'00100000'   ;Seta a flag correspondente a nota SOL
	MOVWF FLAG
	
	MOVLW .98
	MOVWF COUNTER_BASE
	MOVWF TMR0	    ;Move para o TMR0 o valor inicial correspondente
			    ;a nota musical em questão
	BCF INTCON, T0IF
	GOTO SAI_INT
	
CONFIG_LA
	MOVLW B'01000000'   ;Seta a flag correspondente a nota LA
	MOVWF FLAG
	
	MOVLW .115
	MOVWF COUNTER_BASE
	MOVWF TMR0	    ;Move para o TMR0 o valor inicial correspondente
			    ;a nota musical em questão
	BCF INTCON, T0IF
	GOTO SAI_INT

CONFIG_SI
	MOVLW B'10000000'   ;Seta a flag correspondente a nota SI
	MOVWF FLAG
	
	MOVLW .131
	MOVWF COUNTER_BASE
	MOVWF TMR0	    ;Move para o TMR0 o valor inicial correspondente
			    ;a nota musical em questão
	BCF INTCON, T0IF
	GOTO SAI_INT

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
	BANK1				;ALTERA PARA O BANCO 1
	
	MOVLW	B'00000001'     ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS, EXCETO O GP0
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000010'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'11100000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	MOVLW   B'00000001'
	MOVWF   PIE1
	
	BANK0			;RETORNA PARA O BANCO
	
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW   B'00110001'
	MOVWF   T1CON

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	MOVLW B'00000010'
	MOVWF FLAG
	
	MOVLW .19
	MOVWF COUNTER_BASE
	MOVWF TMR0
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

MAIN
	BTFSC GPIO, GP0	    ;Verifica o nível lógico da porta GP0
	GOTO  DESLIGA	    ;Se for nível alto, vá para DESLIGA		
	
	BTFSS INTCON, GIE   ;Verifica se a chave geral está habilitada
	GOTO LIGA	    ;Se não estiver, habilite (Ligue)

	GOTO MAIN

DESLIGA
	BCF GPIO, GP5	    ;Limpa a porta GP5, deixando-a em nível lógico baixo        
	
	BANK1
	BCF INTCON, GIE	    ;Desabilita a chave geral (GIE), enquanto GP0 
	BANK0		    ;estiver em nível lógico alto
	
	GOTO MAIN

LIGA
	BANK1
	BSF INTCON, GIE	    ;Habilita a chave geral (GIE), enquanto GP0 
	BANK0		    ;estiver em nível lógico baixo
	
	GOTO MAIN
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
