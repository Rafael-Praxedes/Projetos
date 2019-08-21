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

		;NOVAS VARIÁVEIS
		DUTY_CYCLE_BASE ;VARIÁVEL DE CONTROLE DO DUTY CYCLE
		COUNT_TMR1	;VARIÁVEL CONTADORA AUXILIAR DO TMR1

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA
	
	#DEFINE ENTRADA_ANALOGICA	GPIO, GP0
	#DEFINE SAIDA_TENSAO_MOSFET	GPIO, GP2 

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
	
	REFERENCIA_40_GRAUS	EQU	.146

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

	ORG	0x00		;ENDEREÇO INICIAL DE PROCESSAMENTO
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
	
	    BTFSC   PIR1, TMR1IF	    ;Verifica se a interrupção foi gerada pelo TMR1
	    GOTO    TIMER_1		    ;Se sim, configure TMR1
	
	    BCF	    INTCON, T0IF
	    
	    BTFSS   SAIDA_TENSAO_MOSFET	    ;Testa o nível lógico da saída GP2
	    GOTO    SETA_SAIDA		    ;Se a saída estiver em nível baixo, coloca-a para nível alto
					    ;Senão, coloca-a para nível baixo
LIMPA_SAIDA
	    BCF	    SAIDA_TENSAO_MOSFET	    ;Coloca a tensão de saída que irá ao MOSFET em nível baixo
	    COMF    DUTY_CYCLE_BASE, W	    ;Complementa o valor da variável que será atribuida ao TMR0
	    GOTO    CONFIG_DUTY_CYCLE	    ;Dirigi-se à configuração do duty_cycle, isto é, à atribuição 
					    ;do valor inicial do contador TMR0 
	    
SETA_SAIDA
	    BSF	    SAIDA_TENSAO_MOSFET	    ;Coloca a tensão de saída que irá ao MOSFET em nível alto
	    MOVFW   DUTY_CYCLE_BASE	    ;Atribui-se o valor da varíavel DUTY_CYCLE_BASE para o W,
					    ;a fim de que ele possa ser atribuido ao TMR0, em CONFIG_DUTY_CYCLE
	    GOTO    CONFIG_DUTY_CYCLE	    ;Dirigi-se à configuração do duty_cycle, isto é, à atribuição 
					    ;do valor inicial do contador TMR0
TIMER_1
	    BCF	    PIR1, TMR1IF	    
	    
	    DECFSZ  COUNT_TMR1		    ;Checa se o tempo de verificação da temperatura foi esgotado, ou seja,
					    ;se o tempo de 3 segundos desde a última verificação foi atingido 
	    GOTO    SAI_INT		    ;Se não se esgotou, sai da interrupção 
	    
	    MOVLW   0XDC		    ;Ocorreu a interrupção do TMR1, ou seja, os 3 segundos acima citados foram
	    MOVWF   TMR1L		    ;atingidos. Reinicializa o contador TMR1
	    MOVLW   0X0B
	    MOVWF   TMR1H
	    
	    MOVLW   .6
	    MOVWF   COUNT_TMR1		    ;Reinicializa a variável contadora, garantindo que o tempo de verificação 
					    ;correto seja atingido
	    BSF	    ADCON0, 1		    ;Inicia a conversão Analógica/Digital - Bit GO/DONE setado 
ESPERA	    BTFSC   ADCON0, 1		    ;Verifica se a conversão terminou
	    GOTO    ESPERA		    ;Aguarda o fim da conversão
	
TESTE_40    MOVLW   REFERENCIA_40_GRAUS	    ;Verifica se a temperatura está acima ou abaixo da referência: 40 °C 
	    SUBWF   ADRESH		    
	
	    BTFSC   STATUS, C		    ;Temperatura verficada - Temperatura de referência
	    GOTO    DIMINUI_DUTY_CYCLE	    ;Se a temperatura estiver acima da referência, o duty cycle é reduzido,
					    ;isto é, a tensão de saída sem mantém em nível alto por menos tempo. Dessa forma, 
					    ;o resistor será resfriado, a fim de estabilizar sua temperatura em 40 °C
					    
	    GOTO    AUMENTA_DUTY_CYCLE	    ;Se a temperatura estiver abaixo da referência, o duty cycle é aumentado. Dessa forma,
					    ;o resistor será aquecido, a fim de estabilizar sua temperatura em 40 °C
					     
AUMENTA_DUTY_CYCLE
	    
	    MOVLW   .17			    ;Define-se um decremento de 17 unidades ao valor que sera atribuiodo ao TMR0
	    SUBWF   DUTY_CYCLE_BASE, W	    ;Tal valor faz com que o duty cycle seja decrementado na ordem 6,67%, aproximadamente,
					    ;sempre que for necesario realizar algum ajuste na temperatura 
	    BTFSS   STATUS, C
	    GOTO    UNDERFLOW_OVERFLOW	    ;Teste a ocorrência de underflow, ou seja, verifica se o valor do duty cycle, após o 
					    ;decremento, é menor do que 0 (valor mínimo possível). Se sim, o valor da variável
					    ;DUTY_CYCLE_BASE não é atualizado com o resultado da operação de decremento
	    
	    MOVWF   DUTY_CYCLE_BASE	    ;Se não houve underflow, atualiza-se o valor da variável DUTY_CYCLE_BASE com o	    
	    MOVFW   DUTY_CYCLE_BASE	    ;resultado da operação de decremento
	    GOTO    CONFIG_DUTY_CYCLE	    ;Dirigi-se à configuração do duty_cycle, isto é, à atribuição 
					    ;do valor inicial do contador TMR0
	    
DIMINUI_DUTY_CYCLE
	    
	    MOVLW   .17			    ;Define-se um incremento de 17 unidades ao valor que sera atribuiodo ao TMR0
	    ADDWF   DUTY_CYCLE_BASE, W	    ;Tal valor faz com que o duty cycle seja incrementado na ordem 6,67%, aproximadamente,
					    ;sempre que for necesario realizar algum ajuste na temperatura
	    BTFSC   STATUS, C
	    GOTO    UNDERFLOW_OVERFLOW	    ;Teste a ocorrência de overflow, ou seja, verifica se o valor do duty cycle, após o
					    ;incremento, é maior do que 255 (valor máximo possível). Se sim, o valor da variável
					    ;DUTY_CYCLE_BASE não é atualizado com o resultado da operação de incremento
	    
	    MOVWF   DUTY_CYCLE_BASE	    ;Se não houver overflow, atualiza-se o valor da variável DUTY_CYCLE_BASE com o
	    MOVFW   DUTY_CYCLE_BASE	    ;resultado da operação de incremento
	    GOTO    CONFIG_DUTY_CYCLE	    ;Dirigi-se à configuração do duty_cycle, isto é, à atribuição 
					    ;do valor inicial do contador TMR0

UNDERFLOW_OVERFLOW   
	    
	    MOVFW   DUTY_CYCLE_BASE
	    
CONFIG_DUTY_CYCLE
	    
	    MOVWF   TMR0
	

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
	MOVLW	B'00000011'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS, EXCETO GP0 (AN0) E GP1 (AN1) QUE SERÃO ENTRADAS ANALÓGICAS
	MOVLW	B'00010011'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O, EXCETO GP0 (AN0) E GP1 (AN1), 
				;QUE SÃO DEFINIDAS COMO ENTRADAS ANALÓGICAS
	MOVLW	B'10000011'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO, SENDO UMA DELAS A CONFIGURAÇÃO DE PS 1:16
	MOVLW	B'11100000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	MOVLW   B'00000001'
	MOVWF   PIE1
	
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	B'01000001'	;DEFINE AS CONFIGURAÇÕES REFERENTES AO CONVERSOR A/D
	MOVWF	ADCON0
	MOVLW   B'00110001'	;DEFINE AS CONFIGURAÇÕES DO TMR1
	MOVWF   T1CON

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	BSF	SAIDA_TENSAO_MOSFET	;Inicializa a tensão de saída destinada ao MOSFET,
					;colocando-a em nível alto
	MOVLW	.0			;Inicializa a variável de controle do duty cycle 
	MOVWF	DUTY_CYCLE_BASE		;e o contador TMR0 com o valor 0
	MOVWF	TMR0
	
	MOVLW	0xDC
	MOVWF	TMR1L			;Inicializa os 8 bits menos significativos do contador TMR1
	MOVLW   0X0B
	MOVWF   TMR1H			;Inicializa os 8 bits mais significativos do contador TMR1
	
	MOVLW	.6
	MOVWF	COUNT_TMR1		;Inicializa a variável contadora auxiliar do TMR1
	
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
	

	GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
