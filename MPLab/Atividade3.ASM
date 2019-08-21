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
;*     NOME: THIAGO WESLEY SANTOS LIMA                             *
;*     MATRICULA: 11501949                                         *
;*     ATIVIDADE 3: 7 NOTAS MUSICAIS DE DÓ A SI                    *
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
		NOTA		;DEFINE A NOTA EXECUTADA
		
	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

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
	
	BTFSS PIR1, TMR1IF  ;VERIFICA SE A INTERRUPÇÃO É DO TMR0 OU TMR1
	GOTO INT_TMR0	    ;INTERRUPÇÃO TMR0
	;INTERRUPÇÃO TMR1
	BCF PIR1, TMR1IF    ;LIMPA A FLAG DE ESTOURO
	;RESETA TMR1
	MOVLW 0X08
	MOVWF TMR1L	    
	MOVLW 0X0C
	MOVWF TMR1H
	INCF NOTA           ;ATINGIU APROXIMADAMENTE 0.5 SEGUNDOS
			    ;SELECIONA A PRÓXIMA NOTA
    
INT_TMR0
	BCF INTCON, T0IF     ;LIMPA A FLAG DE ESTOURO
	COMF GPIO	     ;INVERTE GP5 PARA GERAR O SINAL DA NOTA
	MOVLW .0	     ;NOTA DÓ = 0
	SUBWF NOTA, W
	BTFSC STATUS, Z	     ;VERIFICA SE A NOTA É DÓ
	GOTO DO
	MOVLW .1	     ;NOTA RÉ = 1
	SUBWF NOTA, W
	BTFSC STATUS, Z	     ;VERIFICA SE A NOTA É RÉ
	GOTO RE
	MOVLW .2	     ;NOTA MI = 2
	SUBWF NOTA, W
	BTFSC STATUS, Z	     ;VERIFICA SE A NOTA É MI
	GOTO MI
	MOVLW .3             ;NOTA FÁ = 3
	SUBWF NOTA, W    
	BTFSC STATUS, Z      ;VERIFICA SE A NOTA É FÁ
	GOTO FA
	MOVLW .4             ;NOTA SOL = 4
	SUBWF NOTA, W
	BTFSC STATUS, Z	     ;VERIFICA SE A NOTA É SOL
	GOTO SOL
	MOVLW .5             ;NOTA LÁ = 5
	SUBWF NOTA, W
	BTFSC STATUS, Z	     ;VERIFICA SE A NOTA É LÁ
	GOTO LA
	MOVLW .6	     ;NOTA SI = 6
	SUBWF NOTA, W
	BTFSC STATUS, Z	     ;VERIFICA SE A NOTA É SI
	GOTO SI
	;NOTA = 7 RETORNA PARA A NOTA DÓ
	MOVLW .0
	MOVWF NOTA
	
DO
	MOVLW .20	;IDEAL = 261,63 Hz
	MOVWF TMR0	;REAL = 261,92 Hz
	GOTO SAI_INT	;EXECUTA DURANTE 499,901 ms

RE
	MOVLW .46       ;IDEAL = 293,66 Hz
	MOVWF TMR0	;REAL = 293,43 Hz
	GOTO SAI_INT	;EXECUTA DURANTE 499,958 ms

MI
	MOVLW .70	;IDEAL = 329,63 Hz
	MOVWF TMR0	;REAL = 329,6 Hz
	GOTO SAI_INT	;EXECUTA DURANTE 499,994 ms
	
FA
	MOVLW .81	;IDEAL = 349,28 Hz
	MOVWF TMR0	;REAL = 349,16 Hz
	GOTO SAI_INT	;EXECUTA DURANTE 500,014 ms

SOL
	MOVLW .101	;IDEAL = 392 Hz
	MOVWF TMR0	;REAL = 391,85 Hz
	GOTO SAI_INT	;EXECUTA DURANTE 500,056 ms
	
LA
	MOVLW .119	;IDEAL = 440 Hz
	MOVWF TMR0	;REAL = 440,14 Hz
	GOTO SAI_INT	;EXECUTA DURANTE 500,105 ms
	
SI
	MOVLW .135	;IDEAL = 493,88 Hz
	MOVWF TMR0	;REAL = 493,58 Hz
	GOTO SAI_INT	;EXECUTA DURANTE 500,155 ms
	
	
	
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
	MOVLW	B'00001001'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;GP3 E GP0 COMO ENTRADAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000010'	;DEFINE O PRESCALER DO TMR0 (1:8)
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW B'000000001'
	MOVWF PIE1		;HABILITA A INTERRUPÇÃO POR PERIFÉRICOS (TMR1IE)
	MOVLW	B'11100000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES (GIE, PEIE, T0IE)
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW B'00110001'
	MOVWF T1CON		;DEFINE O PRESCALER DO TMR1 (1:8) E ATIVA TMR10N

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF GPIO   ;ZERANDO GPIO
	MOVLW .20
	MOVWF TMR0  ;INICIALIZANDO TMR0 PARA COMEÇAR DA NOTA DÓ
	;INICIALIZANDO TMR1
	MOVLW 0X08
	MOVWF TMR1L	    
	MOVLW 0X0C
	MOVWF TMR1H
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BTFSC GPIO, GP0
	GOTO DESATIVA_INT
	BSF INTCON, GIE    ;INTERRUPÇÃO GERAL ATIVADA SE GP0 = 0
	GOTO MAIN
	
DESATIVA_INT
	BCF INTCON, GIE    ;DESATIVA A INTERRUPÇÃO GERAL SE GP0 = 1
	BCF GPIO, GP5	   ;E MANTÉM GP5 = 0
	GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
