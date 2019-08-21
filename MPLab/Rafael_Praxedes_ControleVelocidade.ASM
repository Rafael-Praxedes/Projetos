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
		opr2_aux
		resto
		resultL		;RESULTADO DA OPERAÇÃO DE DIVISÃO/MULTIPLICAÇÃO - BYTE MENOS SIGNIFICATIVO 
		resultH		;RESULTADO DA OPERAÇÃO DE MULTIPLICAÇÃO - BYTE MAIS SIGNIFICATIVO
				;A SEGUNDA VARIÁVEL DE RESULTADO NÃO É UTILIZADA NA DIVISÃO,
				;POIS O RESULTADO DESSA OPERAÇÃO PARA DOIS NÚMEROS DE 1 BYTE NÃO ULTRAPASSA 
				;TAL ESPAÇO DE MEMÓRIA 
		COUNT_TMR1	;VARIÁVEL CONTADORA DO NÚMERO DE ESTOUROS DO TMR1
		
		i		;FUNÇÃO SEMELHANTE A DE UM ITERADOR
		j		;FUNÇÃO SEMELHANTE A DE UM ITERADOR
		k		;FUNÇÃO SEMELHANTE A DE UM ITERADOR
		
		NUM_ROTACOES_AUX ;AS TR?S VARIÁVEIS NUM_ROTACOES INDICAM A QUANTIDADE DE BITS DESLOCADOS
		NUM_ROTACOES_1	 ;PORÉM, A PRIMEIRA É UTILIZADA INTERNAMENTE NAS FUNÇOES "desloca" E "spin"
		NUM_ROTACOES_2	 ;ENQUANTO QUE NUM_ROTACOES_1 E NUM_ROTACOES_2 SÃO UTILIZADAS EM DIFERENTES MOMENTOS   
				 ;DE DESLOCAMENTO, COMO SERÃO VISTOS MAIS ADIANTES
		
		N_DIV_10	 ;INDICA A QUANTIDADE DE VEZES QUE FOI FEITA UMA DIVISÃO POR 10, UTILIZADA PARA REPRESENTAR
				 ;NÚMEROS DA SEGUINTE FORMA: 1400 = 14 * 10^2, POR EXEMPLO 
		
		VELOCIDADE	 ;REGISTRADOR RESPONSÁVEL POR ARMAZENAR A VELOCIDADE CALCULADA, SEJA ELA EM M/S OU KM/H
		
		COMPENSACAO_ESCALA ;VARIÁVEL RESPONSÁVEL POR ARMAZENAR O VALOR 6, O QUAL REPRESENTA A COMPENSAÇO DA MEDIÇÃO DO 
				   ;TEMPO SER FEITA EM MICROSEGUNDOS
		
		VAR1		   ;VAR1, VAR2, VAR3 - OPERANDOS DA FUNÇÃO "spin"
		VAR2
		VAR3
		
		INDEX_AUX	  ;REGISTRADOR RESPONSÁVEL POR GUARDAR O VALOR ADCIONAL À QUANTIDADE DE DESLOCAMENTOS DE BITS   
				  ;REALIZADOS, DEPENDENDO SE O DESLOCAMENTO É FEITO LEVENDO EM CONSIDERAÇÃO TRÊS OU DOIS 
				  ;REGISTRADORES
				  
	ENDC			;FIM DO BLOCO DE MEMÓRIA
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA
	
	;DISPLAY 1 - UNIDADES
	;DISPLAY 2 - DEZENAS
	
	#DEFINE DISPLAY_1_BIT_0 PORTA, RA4
	#DEFINE DISPLAY_1_BIT_1 PORTA, RA5
	#DEFINE DISPLAY_1_BIT_2 PORTA, RA6
	#DEFINE DISPLAY_1_BIT_3 PORTA, RA7
	
	#DEFINE DISPLAY_2_BIT_0 PORTB, RB4
	#DEFINE DISPLAY_2_BIT_1 PORTB, RB5
	#DEFINE DISPLAY_2_BIT_2 PORTB, RB6
	#DEFINE DISPLAY_2_BIT_3 PORTB, RB7

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
	
	BCF PIR1, CCP1IF	;Limpa a flag de interrupção do módulo CCP
	CLRF TMR1L
	CLRF TMR1H
	
	MOVFW CCPR1L
	MOVWF TEMPO_L
	
	MOVFW CCPR1H
	MOVWF TEMPO_H
	
	MOVLW B'00000001'	;Sabe-se que, caso a variável COUNT_TMR1 seja iguala zero, o tempo obtido é inferior
	SUBWF COUNT_TMR1, W	;ao que implica a velocidade máxima de 99 Km/h, logo, é atribuido o valor 99 à variável
				;que indica a velocidade medida (Label VELOCIDADE_99)
	BTFSS STATUS, C
	GOTO  VELOCIDADE_99
				
	BTFSC COUNT_TMR1, 7	;Testa-se o bit 7 da varíavel COUNT_TMR1. Caso ele seja igual a 1, sabe-se que o tempo obtido
	GOTO  VELOCIDADE_1	;é superior ao que implica a velocidade mínima de 1 Km/h, logo, é atribuido o valor 1 à variável
				;que indica a velocidade medida (Label VELOCIDADE_1)
	MOVLW .9
	MOVWF INDEX_AUX		;INDEX_AUX igual a 9 implica a quantidade mínima de deslocamentos necessários a fim de que 
				;um número com no mínimo 17 bits possa caber em 1 byte
	MOVFW COUNT_TMR1
	MOVWF VAR1		;Parâmetro da função "desloca"
	
	MOVFW TEMPO_H
	MOVWF VAR2		;Parâmetro da função "desloca"
	
	MOVFW TEMPO_L
	MOVWF VAR3		;Parâmetro da função "desloca"
	
	CALL desloca		;Realiza-se o deslocamento de bits, de modo a permitir que o tempo obtido seja representável em
				;apenas 1 byte
	MOVFW VAR1
	MOVWF COUNT_TMR1
	
	MOVFW VAR2
	MOVWF TEMPO_H
	
	MOVFW VAR3
	MOVWF TEMPO_L
	
	MOVFW NUM_ROTACOES_AUX	;Parâmetro da função "desloca" - Indica a quantidade total de bits desclocados, resultante da 
				;soma entre a posição do primeiro bit, diferente de zero, da variável de estouro do TMR1, a partir 
	MOVWF NUM_ROTACOES_1	;da qual houve início o deslocamento de bits para à direita e a variável INDEX_AUX	
	
CALCULA_VELOCIDADE
		
	MOVFW TEMPO_L		;TEMPO_L: armazenda a representação em 1 byte do tempo obtido com o módulo CCP, isto é, o valor
	MOVWF opr1		;resultante da aplicação do deslocamento de bits
	
	MOVLW .10
	MOVWF opr2
	
	CALL div		;Efetua-se o cálculo da divisão do tempo(1 byte) por 10, de modo a aumentar a precisão do   
				;cálculo da velocidade
	BCF STATUS, C
	RRF opr2		;Dividi-se por 2 o divisor utilizado no cálculo da divisão anterior, de modo a ser feito o   
				;arredondamento, de maneira semelhante aos seguintes exemplos:
				;0.8 > 0.5, implicando a aproximação de 0.8 para 1.
				;0.2 < 0.5, implicando a aproximação de 0.2 para 0.
	MOVFW opr2
	SUBWF resto, W		;Subtrai-se do resto da divisão a metade do divisor, de modo a fazer as aproximações "para cima"
				;ou "para baixo", exemplificadas acima. O arrendomanto para baixo é feito automaticamente pela 
	BTFSC STATUS, C		;operação de divisão, através do truncamento. Dessa forma, tal verificação tem como objetivo 
	INCF resultL		;analisar se o tempo poderia ser melhor aproximado caso aplicado o arrendondamento "para cima"
	
	INCF N_DIV_10		;O incremento dessa variável se deve ao fato do denominador ter sido dividido por 10, 
				;sendo tal operação explicada acima 
	MOVLW .200
	MOVWF opr1		;Ao invés dos 2 m especificados, serão considerados 200 m, a fim de tornar o numerador maior do
				;que o denominador, viabilizando a realização da divisão pelo PIC, uma vez que ele não trabalha,
	MOVFW resultL		;internamente, com representação em ponto flutuante
	MOVWF opr2
	
	MOVLW .2
	ADDWF N_DIV_10		;2 m = 200 * 10^-2 m, por isso adiciona-se o valor 2 a essa variável 
	
	CALL div		;A varíavel resultL representa o resultado da divisão e seu valor se refere ao seguinte calculo:
				;opr1 = 200, opr2 = (tempoDeslocado / 10) -> resultL = opr1/opr2 = 200/(tempoDeslocado/10)
	
	;***********************************************************************************;
	;** Realização da verificação da melhor aproximação ("para cima" ou "para baixo") **;
	;***********************************************************************************;
	BCF STATUS, C			
	RRF opr2
	
	MOVFW opr2
	SUBWF resto, W
	
	BTFSC STATUS, C
	INCF resultL
	;***********************************************************************************;
	
	MOVFW N_DIV_10
	SUBWF COMPENSACAO_ESCALA, W ;A variável COMPENSACAO_ESCALA contém o valor 6, já que o tempo é dado em microsegundos
				    ;e, assim, o 10^-6 presente no denominador é transferido na forma 10^6 para o numerador.
	MOVWF k			    ;No entanto, as divisões por 10 do denominadr e multiplicação por 100 do numerador,
				    ;efetuadas anteriormente, devem ser compensadas, o que é feito na operação de subtração entre
				    ;COMPENSACAO_ESCALA - N_DIV_10. O resultado de tal operação é armazenado em work e depois
				    ;atribuído a varáivel k.
LOOP_MULT_10			
	MOVLW B'11111111'	    ;Verifica se os 8 bits mais significativos do resultado da operação correspondem a um número
	ANDWF resultH, W	    ;diferente de zero
	
	BTFSS STATUS, Z		    ;Se o resultado da AND for zero, implica que resultH = 0. Logo, prossegue-se com o fluxo
	GOTO ROTATE		    ;normal da operação. Caso contrário, uma roatação de bits se faz necessária.
	
MULT	MOVFW resultL		    ;O valor contido na variável k representa um expoente de uma potência na base 10, cujo 
	MOVWF opr1		    ;significado do seu valor já foi explicado. Dessa forma, efetua-se tantas multiplicações
				    ;quantas indicadas pela variável em questão. 
	MOVLW .10
	MOVWF opr2
	
	CALL mult
	
	DECFSZ k
	GOTO LOOP_MULT_10	    ;Ainda restam multiplicações a serem efetuadas
	GOTO LABEL		    ;Fim da realização das multiplicações 
ROTATE
	MOVLW .7
	MOVWF i			    ;Varíavel responsável pelo percorrimento bit a bit de um registrador 
	
	MOVLW .1           
	MOVWF INDEX_AUX		    ;INDEX_AUX igual a 1 implica a quantidade mínima de deslocamentos necessários a fim de que 
				    ;um número com no mínimo 9 bits possa caber em 1 byte
	
	MOVWF VAR3		    ;Parâmetro da função "desloca" - Para este caso de deslocamento, tal parâmetro não é tão 
				    ;relevante, uma vez que tal operação é realizada levando em conta dois registradores. São 
	MOVFW resultH		    ;eles: resultL e resultH
	MOVWF VAR1		    ;Parâmetro da função "desloca"
	
	MOVFW resultL
	MOVWF VAR2		    ;Parâmetro da função "desloca"
	
	CALL desloca		    ;Realiza-se o deslocamento de bits, de modo a permitir que o tempo obtido seja 
				    ;representável em apenas 1 byte
	
	MOVFW VAR1     
	MOVWF resultH
	
	MOVFW VAR2
	MOVWF resultL
	
	MOVFW NUM_ROTACOES_AUX	;Parâmetro da função "desloca" - Indica a quantidade total de bits desclocados, resultante da
				;soma entre a posição do primeiro bit, diferente de zero, da variável de estouro do TMR1, a partir
	MOVWF NUM_ROTACOES_2	;da qual teve-se início o deslocamento de bits para à direita e a variável INDEX_AUX
	
	GOTO MULT		;Terminado o deslocamento, volta-se ao cálculo da multiplicação
LABEL
	MOVFW NUM_ROTACOES_2	    ;A variável NUM_ROTACOES_2 indica quantos bits foram deslocados durante a operação de 
	SUBWF NUM_ROTACOES_1, W	    ;multiplicação realizada logo acima. Já a NUM_ROTACOES_1, por sua vez, indica qunatos
				    ;bits foram rotacionados no momento da redução para 1 byte do tempo obitdo com o módulo CCP
	MOVWF k			    ;A subtração é feita de modo a compensar a quantidade de deslocamentos necessáiros, conforme
				    ;indicado no exemplo abaixo:
				    ;2000/(8*2^9) = (250*2^3) / (8*2^9) = (250/8) * (2^3/2^9) = (250/8)/2^6
				    ;NUM_ROTACOES_2 - NUM_ROTACOES_1 equivale à subtração dos expoentes das potências de 2
	
	MOVLW .7		    ;Após a realização da subtração acima, tem-se, de fato, o valor de compensação  
	MOVWF i			    ;que deve ser aplicado, referente à quantidade de bits deslocados 
	
	MOVLW .1		    ;No entanto, os resultados das multiplicações acima resultam em um número que ocupa mais de
	MOVWF INDEX_AUX		    ;1 byte. Por essa razão, faz-se necessário um novo deslocamento de bits, pois, ao invés de ser utilizado
				    ;o método de rotação de bits à direita para realizar a divisão por 2^n, prefere-se utilizar o 
	MOVWF VAR3		    ;algoritmo de divisão desenvolvido (função "div"), de modo a considerar o valor do resto dessa
				    ;operação. O exemplo adiante ilustra essa ideia: 
				    ;2000 / 2^6 = 250 * 2^3 / 2^6 = 250 / 2^3 = (250/2), sendo tal divisão simples realizada 3  
				    ;vezes, neste exemplo, de modo a considerar o resto de cada uma das iterações, como já citado
	MOVFW resultH		    
	MOVWF VAR1		    ;Parâmetro da função "desloca". Mais uma vez, o parâmetro VAR3 não é relevante neste 
				    ;deslocamento, uma vez que tal operação é feita apenas levando em consideração dois 
				    ;registradores
	MOVFW resultL
	MOVWF VAR2		    ;Parâmetro da função "desloca"
	
	CALL desloca
	
	MOVFW VAR1		    
	MOVWF resultH
	
	MOVFW VAR2		    
	MOVWF resultL
	
	MOVFW NUM_ROTACOES_AUX	    ;O deslocamento acima deve ser mais uma vez compensado, de forma análoga ao que ocorreu no 
	SUBWF k, W		    ;momento da subtração NUM_ROTACOES_1 - NUM_ROTACOES_2
				    
	MOVWF i			    ;O valor atribuido a i consiste, de fato, na quantidade final de divisões por 2 que precisam 
				    ;ser efetuadas. i = k - NUM_ROTACOES_AUX 

LOOP	MOVFW resultL		    ;LOOP para  a realização da divisão por 2 tantas vezer forem indicadas pelo valor
	MOVWF opr1		    ;contido na variável i
	
	MOVLW .2
	MOVWF opr2
	
	CALL div
	
	;***********************************************************************************;
	;** Realização da verificação da melhor aproximação ("para cima" ou "para baixo") **;
	;***********************************************************************************;
	BCF STATUS, C
	RRF opr2
	
	MOVFW opr2
	SUBWF resto, W
	
	BTFSC STATUS, C
	INCF resultL
	;***********************************************************************************;
	
	DECFSZ i
	GOTO LOOP
	
	MOVFW resultL
	MOVWF VELOCIDADE	    ;O resultado final das tantas divisões por 2 equivale à velocidade, medida em m/s
	
	CALL convert		    ;Converte a velocidade de m/s para Km/h
	
	MOVLW .100
	SUBWF VELOCIDADE, W	    ;VELOCIDADE - 100. 
	
	BTFSC STATUS, C		    ;Verifica se a velocidade convertida é superior ou igual a 100 Km/h
	GOTO VELOCIDADE_99	    ;Se sim, define-a como 99 Km/h
	
	GOTO DISPLAY		    ;Dirija-se à chamada da função de exibição no display de 7 segmentos 
	
VELOCIDADE_1
	MOVLW .1
	MOVWF VELOCIDADE	    ;Define-se a velocidade como sendo 1 Km/h
	
	GOTO DISPLAY		    ;Dirija-se à chamada da função de exibição no display de 7 segmentos
	

VELOCIDADE_99
	MOVLW .99
	MOVWF VELOCIDADE	    ;Define-se a velocidade como sendo 1 Km/h
	
	GOTO DISPLAY		    ;Dirija-se à chamada da função de exibição no display de 7 segmentos
	
DISPLAY
	CALL display		    ;Chamada da função de exibição no display de 7 segmentos

REINICIALIZA_VARIAVEIS
	
	CLRF NUM_ROTACOES_AUX
	CLRF NUM_ROTACOES_1
	CLRF NUM_ROTACOES_2
	CLRF j
	
	MOVLW .7
	MOVWF i
	
	CLRF N_DIV_10
	
	MOVLW .6
	MOVWF COMPENSACAO_ESCALA
	
	GOTO SAI_INT
	
CONFIG_TMR1			    ;Estouro do TMR1
	
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
;* das vídeos aulas do professor Wagner Rambo do canal WR Kits e   *
;* adaptadas de acordo com a necessidade                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;************************************************;
;* Nome da função: mult                          ;
;*						 ;
;* Parâmetros: opr1 e opr2 - operandos da        ;  
;*			     multiplicação	 ;
;* Valor de retorno: resultL e resultH -         ;
;*             	     resultado da multiplicação	 ;
;************************************************;
mult
	;CORPO DA ROTINA
	
	;opr1 - Valor a ser somado
	;opr2 - Quantidade de vezes em que o opr1 será somando consigo mesmo
	
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
	
;************************************************;

;************************************************;
;* Nome da função: div	                         ;
;*						 ;
;* Parâmetros: opr1 e opr2 - operandos da        ;  
;*			     divisão	         ;
;* Valor de retorno: resultL e resto - resultado ;
;*             	      da divisão e seu resto	 ;
;************************************************;
div
	;CORPO DA ROTINA
	CLRF resultL
	
	MOVLW .1
	SUBWF opr1, W	    
			    
	BTFSS STATUS, C	    ;Testa se o dividendo é igual a zero
	RETURN		    ;Se sim, retorne 
			    ;Se não, prossiga com a operação de divisão
	MOVFW	opr2
	SUBWF	opr1, W
	
	BTFSS	STATUS, C   ;Se houve carry, quer dizer que o divisor é menor do que o dividendo
	GOTO	div_menor   ;Logo, dirija-se o tratamento dessa situação.
	GOTO	loop_div    ;Caso contrário, dirija-se as subtrações sucessivas equivalentes a uma divisão
	
div_menor
	MOVFW	opr1
	MOVWF	resto	    ;O resto equivale ao valor restante do dividendo, do qual a subtração pelo divisor
			    ;ocasiona a ocorrência de carry
	RETURN
	
loop_div		    ;Cálculo das subtrações sucessivas que equivalem a uma operação de divisão
	MOVFW	opr2
	SUBWF	opr1, F
	
	BTFSS	STATUS, C
	RETURN
	
	MOVFW	opr1
	MOVWF	resto	    ;O resto equivale ao valor restante do dividendo, do qual a subtração pelo divisor
			    ;ocasiona a ocorrência de carry
	
	INCF	resultL, F
	GOTO	loop_div

;************************************************;

;************************************************;
;* Nome da função: desloca                       ;
;*						 ;
;* Parâmetros: i - posição do bit mais           ;                          
;*		   significativo (bit 7)    	 ;
;*						 ;
;* Valor de retorno: Posição do bit a partir do  ;                           
;*		     qual se inicializará        ;
;*                   o deslocamento		 ;	
;************************************************;	
desloca 
	;CORPO DA ROTINA
	
	;Busca a posição do primeiro bit diferente de zero, iniciando a procura a partir do mais significativo (bit 7)
	
	TESTE_BIT_7
	BTFSS VAR1, 7	
	GOTO TESTE_BIT_6
	
	CALL spin
	RETURN 
	
TESTE_BIT_6	
	DECF i
	
	BTFSS VAR1, 6	
	GOTO TESTE_BIT_5
	
	CALL spin
	RETURN
	
TESTE_BIT_5	
	DECF i
	
	BTFSS VAR1, 5	
	GOTO TESTE_BIT_4
	
	CALL spin
	RETURN
	
TESTE_BIT_4	
	DECF i
	
	BTFSS VAR1, 4	
	GOTO TESTE_BIT_3
	
	CALL spin
	RETURN

TESTE_BIT_3	
	DECF i
	
	BTFSS VAR1, 3	
	GOTO TESTE_BIT_2
	
	CALL spin
	RETURN
	
TESTE_BIT_2	
	DECF i
	
	BTFSS VAR1, 2	
	GOTO TESTE_BIT_1
	
	CALL spin
	RETURN 

TESTE_BIT_1	
	DECF i
	
	BTFSS VAR1, 1	
	GOTO TESTE_BIT_0
	
	CALL spin
	RETURN
	
TESTE_BIT_0	
	DECF i
	
	BTFSC VAR1, 0	
	CALL spin
	RETURN 

;************************************************;

;************************************************;
;* Nome da função: spin                          ;    
;*						 ;
;* Parâmetros: VAR1, VAR2, VAR3 - registradores a;
;*                                terem seus bits;
;*				  deslocados	 ;					 
;*		i -  bit inical (resultado da    ;
;*		função "desloca")                ;
;*                                               ;
;*              INDEX_AUX - valor adicional à    ;
;*              quantidade deslocamentos         ;
;*                                               ;
;* Valor de retorno: o valor deslocado contido em;                            
;*		     1 byte			 ;	 
;************************************************;
spin
	;CORPO DA ROTINA
	
	;O tipo de deslocamento realizado é apenas à direita
	
	CLRF NUM_ROTACOES_AUX
	
	MOVFW INDEX_AUX
	ADDWF i, W		;i + INDEX_AUX = Numero de rotações de bits à direita efetuadas, 
	MOVWF j			;em que i é a posição do bit igual a 1, mais significativo
		
rotate
	BCF STATUS, C
	RRF VAR1
	RRF VAR2
	RRF VAR3
	
	INCF NUM_ROTACOES_AUX  ;Variável que indica a quantidade de bits que foram deslocados à direita 
	
	DECFSZ j
	GOTO rotate
	RETURN

;************************************************;

;************************************************;
;* Nome da função: convert                       ;
;*						 ;
;* Parâmetros: VELOCIDADE - m/s                  ;  
;*						 ;
;* Valor de retorno: VELOCIDADE - Km/h           ;
;*						 ;
;************************************************;
convert	
	MOVFW VELOCIDADE
	MOVWF opr1
	
	MOVLW .36
	MOVWF opr2
	
	CALL mult		    ;VELOCIDADE x 36
	
	MOVLW B'11111111'
	ANDWF resultH, W	    ;Verifica se o resultado da multiplicação ocopou mais de 1 byte
	
	BTFSS STATUS, Z		    ;Se sim, efetua-se um deslocamento de bits
	GOTO CONFIG_DESLOCAMENTO
	
	MOVFW resultL		    ;Se não, continua a conversão, dividindo o resultado da multiplicação por 10
	MOVWF opr1
	
	MOVLW .10
	MOVWF opr2
	
	CALL div		    ;(VELOCIDADE X 36) / 1O
	
	MOVFW resultL		    
	MOVWF VELOCIDADE	    ;Velocidade convertida para Km/h
	
	RETURN
	
CONFIG_DESLOCAMENTO		    ;Realiza-se o deslocamento de bits à direita de forma análoga aos outros deslocamentos 
				    ;à direita também realizados
	MOVFW resultH
	MOVWF VAR1
	
	MOVLW .7
	MOVWF i
	
	MOVLW .1           
	MOVWF INDEX_AUX
	
	MOVWF VAR3
	
	MOVFW resultH
	MOVWF VAR1
	
	MOVFW resultL
	MOVWF VAR2
	
	CALL desloca
	
	MOVFW VAR1     
	MOVWF resultH
	
	MOVFW VAR2
	MOVWF resultL
	
	MOVFW NUM_ROTACOES_AUX
	MOVWF NUM_ROTACOES_2		;Quantidade de bits deslocados, os quais deverão ser compensados
	
	MOVFW resultL			
	MOVWF opr1
	
	MOVLW .10
	MOVWF opr2
	
	CALL div			;(VELOCIDADE X 36 deslocada para caber em 1 byte) / 10
		
LOOP_CONVERT				;Compensação dos deslocamentos à direita, através de deslocamentos à esqerda
	BCF STATUS, C			;tantos qunatos indicados pelo valor contido na variável NUM_ROTACOES_2, de modo
	RLF resultL			;a obter o valor correto da conversão da velocidade de m/s para Km/h
	
	DECFSZ NUM_ROTACOES_2
	GOTO LOOP_CONVERT
	
	MOVFW resultL
	MOVWF VELOCIDADE		;Velocidade convertida para Km/h
	
	RETURN
;************************************************;
	
;************************************************;
;* Nome da função: display                       ;
;*						 ;
;* Parâmetros: VELOCIDADE - km/h                 ;  
;*						 ;
;* Valor de retorno: Representação em BCD da     ;
;*		     velocidade, já realizando	 ;
;*		     a sua exibição no display de;
;*		     7 segmentos		 ;
;*						 ;		
;************************************************;	
display	
	MOVFW VELOCIDADE
	MOVWF opr1
	
	MOVLW .10
	MOVWF opr2
	
	CALL div    ;A divisão VELOCIDADE / 1O é efetuada de modo a fazer a separação do número em dezenas e unidades 
				 
;DISPLAY_1 - Responsável pelas unidades 
;DISPLAY_2 - Responsável pelas dezenas

DISPLAY_1_0 
	MOVLW .0
	SUBWF resto, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_1_1
	
	BCF DISPLAY_1_BIT_0
	BCF DISPLAY_1_BIT_1
	BCF DISPLAY_1_BIT_2
	BCF DISPLAY_1_BIT_3
	
	GOTO DISPLAY_2
	
DISPLAY_1_1 
	MOVLW .1
	SUBWF resto, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_1_2
	
	BSF DISPLAY_1_BIT_0
	BCF DISPLAY_1_BIT_1
	BCF DISPLAY_1_BIT_2
	BCF DISPLAY_1_BIT_3
	
	GOTO DISPLAY_2
	
DISPLAY_1_2 
	MOVLW .2
	SUBWF resto, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_1_3
	
	BCF DISPLAY_1_BIT_0
	BSF DISPLAY_1_BIT_1
	BCF DISPLAY_1_BIT_2
	BCF DISPLAY_1_BIT_3
	
	GOTO DISPLAY_2
	
DISPLAY_1_3 
	MOVLW .3
	SUBWF resto, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_1_4
	
	BSF DISPLAY_1_BIT_0
	BSF DISPLAY_1_BIT_1
	BCF DISPLAY_1_BIT_2
	BCF DISPLAY_1_BIT_3
	
	GOTO DISPLAY_2
	
DISPLAY_1_4 
	MOVLW .4
	SUBWF resto, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_1_5
	
	BCF DISPLAY_1_BIT_0
	BCF DISPLAY_1_BIT_1
	BSF DISPLAY_1_BIT_2
	BCF DISPLAY_1_BIT_3
	
	GOTO DISPLAY_2
	
DISPLAY_1_5 
	MOVLW .5
	SUBWF resto, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_1_6
	
	BSF DISPLAY_1_BIT_0
	BCF DISPLAY_1_BIT_1
	BSF DISPLAY_1_BIT_2
	BCF DISPLAY_1_BIT_3
	
	GOTO DISPLAY_2
	
DISPLAY_1_6 
	MOVLW .6
	SUBWF resto, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_1_7
	
	BCF DISPLAY_1_BIT_0
	BSF DISPLAY_1_BIT_1
	BSF DISPLAY_1_BIT_2
	BCF DISPLAY_1_BIT_3
	
	GOTO DISPLAY_2
	
DISPLAY_1_7 
	MOVLW .7
	SUBWF resto, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_1_8
	
	BSF DISPLAY_1_BIT_0
	BSF DISPLAY_1_BIT_1
	BSF DISPLAY_1_BIT_2
	BCF DISPLAY_1_BIT_3
	
	GOTO DISPLAY_2
	
DISPLAY_1_8 
	MOVLW .8
	SUBWF resto, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_1_9
	
	BCF DISPLAY_1_BIT_0
	BCF DISPLAY_1_BIT_1
	BCF DISPLAY_1_BIT_2
	BSF DISPLAY_1_BIT_3
	
	GOTO DISPLAY_2
	
DISPLAY_1_9	
	BSF DISPLAY_1_BIT_0
	BCF DISPLAY_1_BIT_1
	BCF DISPLAY_1_BIT_2
	BSF DISPLAY_1_BIT_3

DISPLAY_2 
	NOP
	
DISPLAY_2_0 
	MOVLW .0
	SUBWF resultL, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_2_1
	
	BCF DISPLAY_2_BIT_0
	BCF DISPLAY_2_BIT_1
	BCF DISPLAY_2_BIT_2
	BCF DISPLAY_2_BIT_3
	
	RETURN
	
DISPLAY_2_1 
	MOVLW .1
	SUBWF resultL, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_2_2
	
	BSF DISPLAY_2_BIT_0
	BCF DISPLAY_2_BIT_1
	BCF DISPLAY_2_BIT_2
	BCF DISPLAY_2_BIT_3
	
	RETURN
	
DISPLAY_2_2 
	MOVLW .2
	SUBWF resultL, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_2_3
	
	BCF DISPLAY_2_BIT_0
	BSF DISPLAY_2_BIT_1
	BCF DISPLAY_2_BIT_2
	BCF DISPLAY_2_BIT_3
	
	RETURN
	
DISPLAY_2_3 
	MOVLW .3
	SUBWF resultL, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_2_4
	
	BSF DISPLAY_2_BIT_0
	BSF DISPLAY_2_BIT_1
	BCF DISPLAY_2_BIT_2
	BCF DISPLAY_2_BIT_3
	
	RETURN
	
DISPLAY_2_4 
	MOVLW .4
	SUBWF resultL, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_2_5
	
	BCF DISPLAY_2_BIT_0
	BCF DISPLAY_2_BIT_1
	BSF DISPLAY_2_BIT_2
	BCF DISPLAY_2_BIT_3
	
	RETURN
	
DISPLAY_2_5 
	MOVLW .5
	SUBWF resultL, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_2_6
	
	BSF DISPLAY_2_BIT_0
	BCF DISPLAY_2_BIT_1
	BSF DISPLAY_2_BIT_2
	BCF DISPLAY_2_BIT_3
	
	RETURN
	
DISPLAY_2_6 
	MOVLW .6
	SUBWF resultL, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_2_7
	
	BCF DISPLAY_2_BIT_0
	BSF DISPLAY_2_BIT_1
	BSF DISPLAY_2_BIT_2
	BCF DISPLAY_2_BIT_3
	
	RETURN
	
DISPLAY_2_7 
	MOVLW .7
	SUBWF resultL, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_2_8
	
	BSF DISPLAY_2_BIT_0
	BSF DISPLAY_2_BIT_1
	BSF DISPLAY_2_BIT_2
	BCF DISPLAY_2_BIT_3
	
	RETURN
	
DISPLAY_2_8 
	MOVLW .8
	SUBWF resultL, W 
	
	BTFSS STATUS, Z
	GOTO DISPLAY_2_9
	
	BCF DISPLAY_2_BIT_0
	BCF DISPLAY_2_BIT_1
	BCF DISPLAY_2_BIT_2
	BSF DISPLAY_2_BIT_3
	
	RETURN
	
DISPLAY_2_9
	BSF DISPLAY_2_BIT_0
	BCF DISPLAY_2_BIT_1
	BCF DISPLAY_2_BIT_2
	BSF DISPLAY_2_BIT_3
	
	RETURN 
	
;************************************************;
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANKSEL	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00100000'		
	MOVWF	TRISA			;DEFINE ENTTRADAS E SAÍDAS DO PORTA
	MOVLW	B'00001000'		
	MOVWF	TRISB			;DEFINE ENTTRADAS E SAÍDAS DO PORTB
	MOVLW	B'00000000'
	MOVWF	OPTION_REG		;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'11000000'		
	MOVWF	INTCON			;DEFINE OPÇÕES DE INTERRUPÇÕES, HABILITANDO AS CHAVES GERAL E DO GRUPO DE PERIFÉRICOS
	MOVLW	B'00000101'		
	MOVWF	PIE1			;HABILITA AS INTERRUPÇÕES PARA O TMR1 E O MÓDULO CCP
	
	BANKSEL	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00000001'		;CONFIGURA O TMR1 COM UM PS 1:1  
	MOVWF	T1CON
	MOVLW	B'00000111'
	MOVWF	CMCON			;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	B'00000100'
	MOVWF	CCP1CON			;DEFINE O MÓDULO DE CAPTURA PARA BORDA DE DESCIDA COM PS 1:1

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF NUM_ROTACOES_AUX
	CLRF NUM_ROTACOES_1
	CLRF NUM_ROTACOES_2
	CLRF j
	
	MOVLW .7
	MOVWF i
	
	CLRF N_DIV_10
	
	MOVLW .6
	MOVWF COMPENSACAO_ESCALA    ;Devido ao fato do tempo capturado estar medido em microsegundos,  
				    ;deve-se efetuar uma compensação de escala, cujo valor indica quantas
				    ;vezes o resultado da divisão referente a velocidade deve ser multiplicado por 10,
				    ;de modo a representá-la na unidade padrão do SI: m/s
		
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
FIM
	GOTO FIM
	
	END
