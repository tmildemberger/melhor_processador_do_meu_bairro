;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; O código no arquivo "rom_heap_sort.vhd" é todo
;; igual a esse, exceto pelo fato de que as duas
;; primeiras instruções (MOV R6... e MOV R7...)
;; precisaram ser movidas para o final e substituidas
;; por uma chamada de subrotina que usa um LFSR
;; (https://en.wikipedia.org/wiki/Linear-feedback_shift_register)
;; para gerar números e colocar na RAM para serem
;; ordenados.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; começo da memória ROM: 
; R6 - endereço base do vetor
; R7 - tamanho do vetor
            MOV  R6, #0x22
            MOV  R7, #50
            CALLA UC, heap_sort
fim         JMPR UC, fim

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; recebe índice em R4 e retorna em R4 pai(R4)
pai
            SUB  R4, #1
            ASHR R4, #1
            RET

; recebe índice em R4 e retorna em R4 esquerda(R4)
esquerda
            SHL  R4, #1
            ADD  R4, #1
            RET

; recebe índice em R4 e retorna em R4 direita(R4)
direita
            SHL  R4, #1
            ADD  R4, #2
            RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; R6 - endereço base do vetor
; R7 - tamanho do vetor
heap_sort
            CALLR UC, build_max_heap
            CMP  R7, #1
            JMPR ULE, fim_heap_sort
            
            MOV  R5, R6
            ADD  R5, R7
            
proximo_heap_sort
            MOV  R3, [R5 + #-1]
            MOV  R2, [R6]
            MOV  [R5 + #-1], R2
            MOV  [R6], R3
            SUB  R7, #1
            MOV  R4, R0
            PUSH R5
            CALLA UC, max_heapify
            POP  R5
            SUB  R5, #1
            CMP  R7, #1
            JMPA UGT, proximo_heap_sort
            
fim_heap_sort
            RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; R6 - endereço base do vetor
; R7 - tamanho do vetor
build_max_heap
            CMP  R7, #1
            JMPA ULE, fim_build_max_heap
            MOV  R4, R7
            SUB  R4, #1
            CALLR UC, pai
            ; começa com R4 igual a pai(TAM - 1)
            
proximo_build_max_heap
            PUSH R4
            CALLA UC, max_heapify
            POP  R4
            ; max_heapify guarda R6 e R7, mas o R4
            ; nós é que temos que guardar
            
            ; caso ainda não tenha feito o max_heapify
            ; com R4 = 0, temos que continuar
            SUB  R4, #1
            JMPA NN, proximo_build_max_heap
            
fim_build_max_heap
            RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; R4 - índice inicial
; R6 - endereço base do vetor
; R7 - tamanho do vetor
max_heapify
            PUSH R7
            PUSH R6
            ; R6 e R7 serão usados pra outras coisas
            ; então precisam ser armazenados
            
            SUB  R7, #1
            MOV  R5, R6
            ADD  R5, R4
            MOV  R3, [R5]
            CALLA UC, esquerda
            ADD  R6, R4
            ; nesse ponto, temos:
            ; R7 - último índice válido do vetor
            ; R6 - endereço do filho da esquerda
            ; R5 - endereço do nó atual
            ; R4 - índice do filho da esquerda
            ; R3 - valor do vetor no índice atual
volta
            ; checa se existe filho à esquerda
            CMP  R4, R7
            JMPR UGT, nao_troca
            
            ; lê o valor do vetor no índice da esquerda
            MOV  R2, [R6]
            
            ; pula se não existe filho à direita
            JMPA EQ, pula_direita
            
            ; lê o valor do vetor no índice da direita
            MOV  R1, [R6 + #1]
            
            ; decide o maior filho
            CMP  R1, R2
            JMPR ULE, pula_direita
            MOV  R2, R1
            ADD  R6, #1
            ADD  R4, #1
            
pula_direita
            ; nesse ponto, temos:
            ; R7 - último índice válido do vetor
            ; R6 - endereço do maior filho
            ; R5 - endereço do nó atual
            ; R4 - índice do maior filho
            ; R3 - valor do vetor no índice atual
            ; R2 - valor do vetor no maior filho
            CMP  R2, R3
            JMPA ULE, nao_troca
            
            ; a "troca" nesse momento é só começada,
            ; pois não é necessário escrever em [R6]
            ; o valor de R3 ainda, pois [R6] pode vir
            ; a ser sobreescrito
            MOV  [R5], R2
            
            MOV  R5, R6
            ; R5 tem o novo endereço do nó atual
            
            CALLR UC, esquerda]
            ; R4 tem o novo índice do filho da esquerda
            
            POP  R6
            PUSH R6
            ADD  R6, R4
            ; R6 tem o endereço do novo filho da esquerda
            
            JMPA UC, volta
            
nao_troca
            ; finaliza a troca, caso tenha começado;
            ; caso nunca tehna começado, coloca em
            ; [R5] o que já tinha em [R5]
            MOV  [R5], R3
            
            ; devolve a R6 e R7 os valores originais
            POP  R6
            POP  R7
            RET
