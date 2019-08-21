;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 16F628A                  *
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
;*   MODELO PARA O PIC 16F628A                                     *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p16f628.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
    
    BANK0 EQU 0X00
    BANK1 EQU 0X80
    BANK2 EQU 0X100
    BANK3 EQU 0X180
 
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20		;ENDEREÇO INICIAL DA MEMÓRIA DE USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;NOVAS VARIÁVEIS
		TEMPO_L		;VARIÁVEL RESPONSÁVEL POR ARMAZENAR O VALOR CONTIDO EM CCPR1L
		TEMPO_H		;VARIÁVEL RESPONSÁVEL POR ARMAZENAR O VALOR CONTIDO EM CCPR1H
		
		opr1		;OPERANDO UTILIZADO NAS OPERAÇÕES DE MULTIPLICAÇÃO OU DIVISÃO
		opr2		;OPERANDO UTILIZADO NAS OPERAÇÕES DE MULTIPLICAÇÃO OU DIVISÃO
		resultL		;RESULTADO DA OPERAÇÃO DE DIVISÃO/MULTIPLICAÇÃO - BYTE MENOS SIGNIFICATIVO 
		resultH		;RESULTADO DA OPERAÇÃO DE MULTIPLICAÇÃO - BYTE MAIS SIGNIFICATIVO
				;A SEGUNDA VARIÁVEL DE RESULTADO NÃO É UTILIZADA NA DIVISÃO,
				;POIS O RESULTADO DESSA OPERAÇÃO PARA DOIS NÚMEROS DE 1 BYTE NÃO ULTRAPASSA 
				;TAL ESPAÇO DE MEMÓRIA 
		COUNT_TMR1	;VARIÁVEL CONTADORA DO NÚMERO DE ESTOUROS DO TMR1
		i
		j
		NUM_ROTACOES
		
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

	ORG	0x04		;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES
	
	BTFSC PIR1, TMR1IF	;Verifica se a interrupção ocorrida se refere ao TMR1
	GOTO CONFIG_TMR1	;Se sim, dirija-se ao tratamento desse tipo de interrupção
				;Se não, sabe-se que a interrupção ocorrida se refere ao módulo CCP
	BCF PIR1, CCP1IF	
	
	MOVFW CCPR1L
	MOVWF TEMPO_L
	
	MOVFW CCPR1H
	MOVWF TEMPO_H
	
;	MOVLW .7
;	MOVWF i
	
;LABEL_1	BTFSS COUNT_TMR1, i
;	GOTO DEC_IT_COUNT_TMR1
	
;	CALL spin_1
;	GOTO LABEL_3

;LABEL_2 BTFSC COUNT_TMR1, i
;	CALL spin_1
	
;LABEL_3	MOVLW .7
;	MOVWF i
	
;LABEL_4	BTFSS TEMPO_H, i
;	GOTO DEC_IT_TEMPO_H
	
;	CALL spin_2
;	GOTO SAI_INT

;LABEL_5 BTFSC TEMPO_H, i
;	CALL spin_2
	
;	GOTO SAI_INT
	
;DEC_IT_COUNT_TMR1	
	
;	DECFSZ i
;	GOTO LABEL_1	
;	GOTO LABEL_2
	
;DEC_IT_TEMPO_H
	
;	DECFSZ i
;	GOTO LABEL_4	
;	GOTO LABEL_5
	
CONFIG_TMR1
	
	BCF PIR1, TMR1IF
	INCF COUNT_TMR1
	
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

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
;* As subrotinas de multiplicação e divisão abaixo foram extraídas *
;* das vídeos aulas do professor Wagner Rambo do canal WR Kits	   *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
;COMENTAR SOBRE OS PARÂMETROS DE CADA FUNÇÃO EO SEUS VALORES DE RETORNO
	
mult
	;CORPO DA ROTINA
	
	CLRF	resultL
	CLRF	resultH
	
	MOVFW	opr1	
	MOVWF	resultL
	
loop_mult
	DECF	opr2, F
	BTFSC	STATUS, Z
	RETURN
	
	MOVFW	opr1
	ADDWF	resultL, F
	
	BTFSC	STATUS, C
	INCF	resultH, F
	
	goto	loop_mult
	
div
	;CORPO DA ROTINA
	
	CLRF	resultL
	
loop_div
	MOVFW	opr2
	SUBWF	opr1, F
	
	BTFSS	STATUS, C
	RETURN
	
	INCF	resultL, F
	GOTO	loop_div
	
spin_1
	;CORPO DA ROTINA
	INCF i, W
	MOVWF j
		
rotate_1	
	RRF COUNT_TMR1
	RRF TEMPO_H
	RRF TEMPO_L
	
	INCF NUM_ROTACOES
	
	DECFSZ j
	GOTO rotate_1
	RETURN
	
spin_2
	;CORPO DA ROTINA
	INCF i, W
	MOVWF j
	
rotate_2	
	RRF TEMPO_H
	RRF TEMPO_L
	
	INCF NUM_ROTACOES
	
	DECFSZ j
	GOTO rotate_2
	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANKSEL	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000000'		
	MOVWF	TRISA			;DEFINE ENTTRADAS E SAÍDAS DO PORTA
	MOVLW	B'00001000'		
	MOVWF	TRISB			;DEFINE ENTTRADAS E SAÍDAS DO PORTB
	MOVLW	B'10000000'
	MOVWF	OPTION_REG		;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'01000000'		;habilitar gie
	MOVWF	INTCON			;DEFINE OPÇÕES DE INTERRUPÇÕES
	MOVLW	B'00000101'		
	MOVWF	PIE1			;HABILITA AS INTERRUPÇÕES PARA O TMR1 E O MÓDULO CCP
	
	BANKSEL	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00000001'		;CONFIGURA O TMR1 COM UM PS 1:1  
	MOVWF	T1CON
	MOVLW	B'00000111'
	MOVWF	CMCON			;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	B'00000101'
	MOVWF	CCP1CON

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF	NUM_ROTACOES
	CLRF	j
	
	MOVLW .7
	MOVWF i
	
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
	;CORPO DA ROTINA PRINCIPAL
	
	MOVLW B'01101101'
	MOVWF COUNT_TMR1
	
	MOVLW B'00011101'
	MOVWF TEMPO_H
	
	MOVLW B'00101000'
	MOVWF TEMPO_L
	
TESTE_1_7
	BTFSS COUNT_TMR1, 7	
	GOTO TESTE_1_6
	
	CALL spin_1
	GOTO INIT_I
	
TESTE_1_6	
	DECF i
	
	BTFSS COUNT_TMR1, 6	
	GOTO TESTE_1_5
	
	CALL spin_1
	GOTO INIT_I
	
TESTE_1_5	
	DECF i
	
	BTFSS COUNT_TMR1, 5	
	GOTO TESTE_1_4
	
	CALL spin_1
	GOTO INIT_I
	
TESTE_1_4	
	DECF i
	
	BTFSS COUNT_TMR1, 4	
	GOTO TESTE_1_3
	
	CALL spin_1
	GOTO INIT_I

TESTE_1_3	
	DECF i
	
	BTFSS COUNT_TMR1, 3	
	GOTO TESTE_1_2
	
	CALL spin_1
	GOTO INIT_I
	
TESTE_1_2	
	DECF i
	
	BTFSS COUNT_TMR1, 2	
	GOTO TESTE_1_1
	
	CALL spin_1
	GOTO INIT_I

TESTE_1_1	
	DECF i
	
	BTFSS COUNT_TMR1, 1	
	GOTO TESTE_1_0
	
	CALL spin_1
	GOTO INIT_I
	
TESTE_1_0	
	DECF i
	
	BTFSC COUNT_TMR1, 0	
	CALL spin_1
	GOTO INIT_I
	
INIT_I	MOVLW .7
	MOVWF i
	
TESTE_2_7	
	BTFSS TEMPO_H, 7	
	GOTO TESTE_2_6
	
	CALL spin_2
	GOTO FIM

TESTE_2_6
	DECF i
	
	BTFSS TEMPO_H, 6	
	GOTO TESTE_2_5
	
	CALL spin_2
	GOTO FIM
	
TESTE_2_5
	DECF i
	
	BTFSS TEMPO_H, 5	
	GOTO TESTE_2_4
	
	CALL spin_2
	GOTO FIM

TESTE_2_4
	DECF i
	
	BTFSS TEMPO_H, 4	
	GOTO TESTE_2_3
	
	CALL spin_2
	GOTO FIM
	
TESTE_2_3
	DECF i
	
	BTFSS TEMPO_H, 3	
	GOTO TESTE_2_2
	
	CALL spin_2
	GOTO FIM
	
TESTE_2_2
	DECF i
	
	BTFSS TEMPO_H, 2	
	GOTO TESTE_2_1
	
	CALL spin_2
	GOTO FIM
	
TESTE_2_1
	DECF i
	
	BTFSS TEMPO_H, 1	
	GOTO TESTE_2_0
	
	CALL spin_2
	GOTO FIM
	
TESTE_2_0
	DECF i
	
	BTFSC TEMPO_H, 0	
	CALL spin_2
	GOTO FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
FIM
	GOTO FIM
	
	END
