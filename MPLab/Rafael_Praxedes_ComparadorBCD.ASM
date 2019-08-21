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

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA
	
#DEFINE BIT_0 GPIO, GP0   ;BIT LSB (0)
#DEFINE BIT_1 GPIO, GP2   ;BIT (1)
#DEFINE BIT_2 GPIO, GP4   ;BIT (2)
#DEFINE BIT_3 GPIO, GP5   ;BIT MSB (3)

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

;LEGENDA
;VIN+ :TENSÃO DE REFERÊNCIA UTILIZADA NO COMPARADOR
;VIN- :TENSÃO DE ENTRADA DO COMPARADOR
	
INICIO
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000010'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS, EXCETO GP1, QUE RECEBERÁ O SINAL A SER COMPARADO 
				;REPRESENTADO NO COMPARADOR COMO VIN-
	
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00010100'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
				;CINV = 1, IMPLICA
				;1 = VIN+ < VIN-
				;0 = VIN+ > VIN-    (Fonte: Datasheet PIC12F675 - Microchip)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

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

;LEGENDA
;LR - LOW RANGE
;HR - HIGH RANGE	

;CONTEXTO: o comparador do PIC 12F675 sofre uma limitação no que se refere a tensão de referecia para a realização da comparação.
;Se for utilizada a escala LR, a tensão máxima de referencia possível equivale a 3.125 V e 3.59375 V na HR. Dessa maneira, 
;montou-se um circuito divisor de tensão, com resistores de 2.2 kOhms e 3.3 kOhms, a fim de transformar a tensão de 5 V em 3 V, 
;respeitando, assim, a limitação do comparador, em ambas a escalas. É requisito da atividade exibir valores de 0 a 9,  
;no display BCD, de acordo com o valor da tensão de entrada. Portanto, o intervalo de tensão de 0V-3V foi dividido em 
;10 sub-intervalos, como mostrado abaixo.

;      0	  1	     2		3	   4	       5	 6	    7	       8	  9
; |----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|
;0.0	    0.3	       0.6        0.9	     1.2        1.5	   1.8        2.1  	 2.4	    2.7	       3.0

MAIN
	;CORPO DA ROTINA PRINCIPAL
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10100001'	;DEFINE A ESCALA COMO LR E (0001) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF   VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_0	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo; 
	GOTO	VALOR_0		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 0.3 V)
				;e, dessa forma, exibe-se o valor 0 no display BCD 
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10100011'	;DEFINE A ESCALA COMO LR E (0011) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_1	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo;
	GOTO	VALOR_1		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 0.6 V)
				;e, dessa forma, exibe-se o valor 1 no display BCD
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10100100'	;DEFINE A ESCALA COMO LR E (0100) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_2	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo;
	GOTO	VALOR_2		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 0.9 V)
				;e, dessa forma, exibe-se o valor 2 no display BCD
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10100110'	;DEFINE A ESCALA COMO LR E (0110) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_3	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo;
	GOTO	VALOR_3		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 1.2 V)
				;e, dessa forma, exibe-se o valor 3 no display BCD
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10100111'	;DEFINE A ESCALA COMO LR E (0111) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_4	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo;
	GOTO	VALOR_4		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 1.5 V)
				;e, dessa forma, exibe-se o valor 4 no display BCD
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10101001'	;DEFINE A ESCALA COMO LR E (1001) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_5	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo;
	GOTO	VALOR_5		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 1.8 V)
				;e, dessa forma, exibe-se o valor 5 no display BCD
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10101010'	;DEFINE A ESCALA COMO LR E (1010) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_6	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo;
	GOTO	VALOR_6		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 2.1 V)
				;e, dessa forma, exibe-se o valor 6 no display BCD
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10000111'	;DEFINE A ESCALA COMO HR E (0111) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_7	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo;
	GOTO	VALOR_7		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 2.4 V)
				;e, dessa forma, exibe-se o valor 7 no display BCD
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10101101'	;DEFINE A ESCALA LR E (1101) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_8	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo;
	GOTO	VALOR_8		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 2.7 V)
				;e, dessa forma, exibe-se o valor 8 no display BCD
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'10101111'	;DEFINE A ESCALA COMO LR E (1111) para VR3:VR0 (TENSÃO DE REFERÊNCIA)
	MOVWF	VRCON
	BANK0			;RETORNA PARA O BANCO 0
	
TESTE_9	BTFSS	CMCON, COUT	;Verifica se o COUT é igual a 1. Se sim, a tensão de entrada é maior
				;do que a tensão de referência definida logo acima e, com isso, deve-se calcular 
				;uma nova referência, que representa o próximo intervalo;
	GOTO	VALOR_9		;Se não, a tensão de entrada é menor do que a tensão de referência (idealmente igual 3.0 V)
				;e, dessa forma, exibe-se o valor 9 no display BCD
	
;BIT_3	BIT_2	BIT_1	BIT_0
;MSB	----	----	LSB
	
VALOR_0				;(0)10 = (0000)2
	BCF	BIT_0		
	BCF	BIT_1
	BCF	BIT_2
	BCF	BIT_3
	
	BCF	CMCON, COUT
	
	GOTO	MAIN
VALOR_1				;(1)10 = (0001)2
	BSF	BIT_0
	BCF	BIT_1
	BCF	BIT_2
	BCF	BIT_3
	
	BCF	CMCON, COUT
	
	GOTO	MAIN
VALOR_2				;(2)10 = (0010)2
	BCF	BIT_0
	BSF	BIT_1
	BCF	BIT_2
	BCF	BIT_3
	
	BCF	CMCON, COUT
	
	GOTO	MAIN
VALOR_3				;(3)10 = (0011)2
	BSF	BIT_0
	BSF	BIT_1
	BCF	BIT_2
	BCF	BIT_3
	
	BCF	CMCON, COUT
	
	GOTO	MAIN
VALOR_4				;(4)10 = (0100)2
	BCF	BIT_0
	BCF	BIT_1
	BSF	BIT_2
	BCF	BIT_3
	
	BCF	CMCON, COUT
	
	GOTO	MAIN
VALOR_5				;(5)10 = (0101)2
	BSF	BIT_0
	BCF	BIT_1
	BSF	BIT_2
	BCF	BIT_3
	
	BCF	CMCON, COUT
	
	GOTO	MAIN
VALOR_6				;(6)10 = (0110)2
	BCF	BIT_0
	BSF	BIT_1
	BSF	BIT_2
	BCF	BIT_3
	
	BCF	CMCON, COUT
	
	GOTO	MAIN
VALOR_7				;(7)10 = (0111)2
	BSF	BIT_0
	BSF	BIT_1
	BSF	BIT_2
	BCF	BIT_3
	
	BCF	CMCON, COUT
	
	GOTO	MAIN
VALOR_8				;(8)10 = (1000)2
	BCF	BIT_0
	BCF	BIT_1
	BCF	BIT_2
	BSF	BIT_3
	
	BCF	CMCON, COUT
	
	GOTO	MAIN
VALOR_9				;(9)10 = (1001)2
	BSF	BIT_0
	BCF	BIT_1
	BCF	BIT_2
	BSF	BIT_3
	
	BCF	CMCON, COUT

	GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
FIM	
	GOTO FIM
	
	END
