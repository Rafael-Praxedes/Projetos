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
#INCLUDE <p16f628.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 16F628A

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_ON & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		
		TEMPO1		;CONTADOR P/DELAY
		TEMPO0		;CONTADOR P/DELAY
		FILTRO_BOTOES	;FILTRO PARA RUÍDOS
		FLAG		;FLAG DE USO GERAL

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA
	
	#DEFINE TELA_PRINCIPAL FLAG, 0	;FLAG P/ INDICAR QUE DEVE
					;SER MOSTRADA A TELA PRINCIPAL
					;1 -> MOSTRA TELA PRINCIPAL
					;0 -> TELA PRINCIPAL JÁ FOI MOSTRADA
					
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
	
	FILTRO_TECLA EQU .200		;FILTRO P/ EVITAR RUÍDOS DOS BOTÕES

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
 
	#DEFINE DISPLAY PORTB		;BARRAMENTO DE DADOS DO DISPLAY
	#DEFINE RS PORTA, 0		;INDICA P/DISPLAY UM DADO OU COMANDO
					;1-> DADO
					;2-> COMANDO
	#DEFINE ENABLE PORTA, 1		;SINAL DE ENABLE P/ DISPLAY
					;ATIVO NA BORDA DE DESCIDA

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

;AS ROTINAS REFERENTES À MANIPULAÇÃO DO DISPLAY LCD FORAM OBTIDAS COM
;BASE NO LIVRO "CONECTANDO O PIC - RECURSOS AVANÇADOS" DOS AUTORES 
;DAVID JOSÉ DE SOUZA E NICOLAS CÉSAR LAVINIA
	
;* * * * * * * * * * * * * * * *;
;* ROTINA DE DELAY	       *;
;* * * * * * * * * * * * * * * *;
DELAY_MS
;ESTA É UMA ROTINA DE DELAY VARIÁVEL, COM DURAÇÃO DE 1 MS x O VALOR PASSADO EM WORK (W)

	MOVWF TEMPO1		;CARREGA TEMPO1 COM O VALOR CONTIDO EM W (UNIDADE: MS)
	MOVLW .250		
	MOVWF TEMPO0		;CARREGA TEMPO0 (P/CONTAR 1 MS)
	
	CLRWDT			;LIMPA WDT (PERDE TEMPO)
	DECFSZ TEMPO0, F	;FIM DE TEMPO0?
	GOTO $-2		;NAO - VOLTA 2 INSTRUÇÕES 
	
	DECFSZ TEMPO1, F	;FIM DE TEMPO1?
	GOTO $-6		;NÃO - VOLTA 6 INSTRUÇÕES
				;SIM, O TEMPO ACABOU
	RETURN			;RETORNA 

;* * * * * * * * * * * * * * * *;
;* ROTINA DE ESCRITA NO LCD    *;
;* * * * * * * * * * * * * * * *;	
ESCREVE
;ESTA ROTINA ENVIA UM CARACTERE PARA O MÓDULO DE LCD. O CARACTER A SER ESCRITO DEVE SER COLOCADO
;EM WORK (W), ANTES DA ROTINA SER CHAMADA
	
	MOVWF DISPLAY		;ATUALIZA DISPLAY (PORTB)
	NOP			;1 MICROSEGUNDO PARA ESTABILIZAÇÃO
	BSF ENABLE		;ENIVA UM PULSO DE ENABLE AO DISPLAY
	GOTO $+1
	
	MOVLW .1
	CALL DELAY_MS		;DELAY DE 1MS
	
	RETURN			;RETORNA

;* * * * * * * * * * * * * * * * * * * * * *;
;* ROTINA DE ESCRITA DA TELA PRINCIPAL     *;
;* * * * * * * * * * * * * * * * * * * * * *;
MOSTRA_TELA_PRINCIPAL
;ESTA ROTINA ESCREVE NA TELA PRINCIPAL DO PROGRAMA AS SEGUINTES FRASES:
;LINHA 1 - "MOSAICO ENG."
;LINHA 2 - "CURSO MODULO 2"
	
	BCF TELA_PRINCIPAL
	
	BCF RS			;SELECIONA O DISPLAY P/ COMANDOS
	MOVLW 0x01		
	CALL ESCREVE		;ESCREVE COMANDO P/ LIMPAR A TELA
	MOVLW .1
	CALL DELAY_MS		;DELAY DE 1MS
	
	MOVLW 0x82		;COMANDO PARA ROTACIONAR O CURSOR
	CALL ESCREVE		;LINHA 0 / COLUNA 2
	BSF RS			;SELECIONA O DISPLAY P/ DADOS 
		
	MOVLW 'M'		;COMANDOS PARA ESCREVER AS LETRAS DE "MOSAICO ENG."
	CALL ESCREVE		
	MOVLW 'O'
	CALL ESCREVE
	MOVLW 'S'
	CALL ESCREVE
	MOVLW 'A'
	CALL ESCREVE
	MOVLW 'I'
	CALL ESCREVE
	MOVLW 'C'
	CALL ESCREVE
	MOVLW 'O'
	CALL ESCREVE		
	
	MOVLW ' '
	CALL ESCREVE
	
	MOVLW 'E'
	CALL ESCREVE
	MOVLW 'N'
	CALL ESCREVE
	MOVLW 'G'
	CALL ESCREVE
	MOVLW '.'
	CALL ESCREVE
	
	BCF RS			;SELECIONA O DISPLAY P/ COMANDOS
	MOVLW 0XC1		;COMANDO PARA ROTACIONAR O CURSOR
	CALL ESCREVE		;LINHA 1 / COLUNA 0
	BSF RS			;SELECIONA O DISPLAY P/ DADOS
	
	MOVLW 'C'		;COMANDOS PARA ESCREVER AS LETRAS DE "CURSO MODULO 2"
	CALL ESCREVE
	MOVLW 'U'
	CALL ESCREVE
	MOVLW 'R'
	CALL ESCREVE
	MOVLW 'S'
	CALL ESCREVE
	MOVLW 'O'
	CALL ESCREVE
	MOVLW ' '
	CALL ESCREVE
	MOVLW 'M'
	CALL ESCREVE
	MOVLW 'O'
	CALL ESCREVE
	MOVLW 'D'
	CALL ESCREVE
	MOVLW 'U'
	CALL ESCREVE
	MOVLW 'L'
	CALL ESCREVE
	MOVLW 'O'
	CALL ESCREVE
	MOVLW ' '
	CALL ESCREVE
	MOVLW '2'
	CALL ESCREVE
	
	RETURN
	
;* * * * * * * * * * * * * * * * * * * * * *;
;* ROTINA DE INICIALIZAÇAO DO DISPLAY      *;
;* * * * * * * * * * * * * * * * * * * * * *;
INICIALIZACAO_DISPLAY
;ESTA ROTINA INICIALIZA O DISPLAY P/ COMUNICAÇAO DE 8 VIAS, DISPLAY PARA 2
;LINHAS, CURSO APAGADO E DESLOCAMENTO DO CURSOR À DIREITA
	
	BCF RS			;SELECIONA O DISPLAY P/ COMANDOS 
	
	MOVLW 0x30		
	CALL ESCREVE		;ESCREVE COMANDO 0x30 PARA INICIALIZAÇÃO DO DISPLAY
	
	MOVLW .3
	CALL DELAY_MS		;DELAY DE 3 MS (EXIGIDO PELO DISPLAY)
	
	MOVLW 0x30
	CALL ESCREVE		;ESCREVE COMANDO 0x30 PARA INICIALIZAÇÃO DO DISPLAY
	
	MOVLW 0x30
	CALL ESCREVE		;ESCREVE COMANDO 0x30 PARA INICIALIZAÇÃO DO DISPLAY
	
	MOVLW B'00111000'
	CALL ESCREVE		;ESCREVE COMANDO DE INTERFACE DE 8 VIAS DE DADOS
	
	MOVLW B'00000001'
	CALL ESCREVE		;ESCREVE COMANDO PARA LIMPAR TODO O DISPLAY
	
	MOVLW .1
	CALL DELAY_MS		;DELAY DE 1 MS
	
	MOVLW B'00001100'
	CALL ESCREVE		;ESCREVE COMANDO PARA LIGAR O DISPLAY SEM O CURSOR
	
	MOVLW B'00000110'
	CALL ESCREVE		;ESCREVE COMANDO PARA INCREMENTO AUTOMÁTICO À DIREITA
	
	BSF RS
	
	RETURN
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANKSEL	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'11111100'		
	MOVWF	TRISA			;DEFINE ENTTRADAS E SAÍDAS DO PORTA
	MOVLW	B'00000000'		
	MOVWF	TRISB			;DEFINE ENTTRADAS E SAÍDAS DO PORTB
	
	MOVLW	B'11011111'
	MOVWF	OPTION_REG		;DEFINE OPÇÕES DE OPERAÇÃO
					;PULL-UPs DESABILITADOS
					;WDT - 1:128
	MOVLW	B'00000000'
	MOVWF	INTCON			;DESABILITA TODAS AS INTERRUPÇÕES
	
	BANKSEL	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON			;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	
	BTFSC	STATUS, NOT_TO
	GOTO	$
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF PORTA
	CLRF PORTB
	
	BSF TELA_PRINCIPAL
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL

	GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
