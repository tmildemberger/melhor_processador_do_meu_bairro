library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity;
architecture a_ula_tb of ula_tb is
	component ula
		port( 	input_a,input_b			: in unsigned(15 downto 0);
				operation_selection		: in unsigned(2 downto 0);
				-- 8 operações suportadas (chamando o operation_selection de OP):
				-- OP=000 => operação adição
				-- OP=001 => operação subtração
				-- OP=010 => operação and
				-- OP=011 => operação or
				-- OP=100 => operação xor
				-- OP=101 => operação deslocamento lógico para a esquerda
				-- OP=110 => operação deslocamento aritmético para a direita
				-- OP=111 => operação rotação para a esquerda
				output					: out unsigned(15 downto 0);
				carry_flag				: out std_logic;
				-- a flag carry (ou C) vai ser definida como:
				-- * 1 se houve um "vai um" em uma operação de adição (e 0 se não houve)
				-- * 1 se houve um "empresta um" em uma operação de subtração (e 0 se não houve)
				-- * o último bit deslocado para fora do operando no caso de operações de deslocamento ou rotação
				-- * a flag é zerada se outra operação estiver sendo realizada
				zero_flag				: out std_logic;
				-- a flag zero (ou Z) indica se o resultado foi zero em qualquer uma das operações
				negative_flag			: out std_logic;
				-- a flag negative (ou N) indica se o resultado tem bit mais significativo igual a 1 em qualquer uma das operações
				overflow_flag			: out std_logic
				-- a flag overflow (ou V) vai ser definida como:
				-- * em uma adição ou subtração:
				-- ** 1 se houve resultado negativo ao se aumentar um número positivo (overflow propriamente dito)
				-- ** 1 se houve resultado positivo ao se diminuir um número negativo (underflow)
				-- ** 0 caso contrário
				-- * em uma operação de deslocamento (rotação não):
				-- ** 1 se um bit diferente do bit de sinal foi deslocado para fora do operando no caso de deslocamento para a esquerda
				-- ** 1 se um bit diferente de zero foi deslocado para fora do operando no caso de deslocamento para a direita
				-- ** 0 caso contrário
				-- * a flag é zerada se outra operação estiver sendo realizada
				-- assim, é possível observar que essa flag não sinaliza somente uma inconsistência de sinal,
				-- mas de forma mais geral avisa sobre uma possível possível perda não intencional de informação na operação
		);
	end component;
	signal input_a, input_b, output								: unsigned(15 downto 0);
	signal operation_selection									: unsigned(2 downto 0);
	signal carry_flag, zero_flag, negative_flag, overflow_flag	: std_logic;
begin
	uut: ula port map( 	input_a 			=> input_a,
						input_b 			=> input_b,
						operation_selection => operation_selection,
						output  			=> output,
						carry_flag 			=> carry_flag,
						zero_flag  			=> zero_flag,
						negative_flag		=> negative_flag,
						overflow_flag		=> overflow_flag);
	process
	begin
		input_a <= "0000000000011001";
		input_b <= "0000000001010110";
		operation_selection <= "000";
		wait for 50 ns;	-- testa soma (OP=0) entre 25 e 86 
						-- deve resultar em 111 										com flags C=0, Z=0, N=0 e V=0
						-- objetivo: testar soma sem carry nem overflow
		input_a <= "1111101011011010";
		input_b <= "1111000011111010";
		operation_selection <= "000";
		wait for 50 ns;	-- testa soma (OP=0) entre 0xfada (U:64218,S:-1318) e 0xf0fa (U:61690,S:-3846)
						-- deve resultar em 0xebd4 (U:60372,S:-5164) 					com flags C=1, Z=0, N=1 e V=0
						-- objetivo: testar soma com carry
		input_a <= "1100101011011110";
		input_b <= "0011010100100010";
		operation_selection <= "000";
		wait for 50 ns;	-- testa soma (OP=0) entre 0xcade (U:51934,S:-13602) e 0x3522 (U=S:13602)
						-- deve resultar em 0 											com flags C=1, Z=1, N=0 e V=0
						-- objetivo: testar soma com resultado zero
		input_a <= "0101010101010101";
		input_b <= "0011001100110011";
		operation_selection <= "000";
		wait for 50 ns;	-- testa soma (OP=0) entre 0x5555 (U=S:21845) e 0x3333 (U=S:13107)
						-- deve resultar em 0x8888 (U:34952,S:-30584, houve overflow) 	com flags C=0, Z=0, N=1 e V=1
						-- objetivo: testar soma com overflow
		input_a <= "1000100010001000";
		input_b <= "1010101010101010";
		operation_selection <= "000";
		wait for 50 ns;	-- testa soma (OP=0) entre 0x8888 (U:34952,S:-30584) e 0xAAAA (U:43690,S:-21846)
						-- deve resultar em 0x3332 (U=S:13106, houve underflow) 		com flags C=1, Z=0, N=0 e V=1
						-- objetivo: testar soma com underflow
		-----------------------------fim dos testes de adição-----------------------------
		input_a <= "0000000001010110";
		input_b <= "0000000000011001";
		operation_selection <= "001";
		wait for 50 ns;	-- testa subtração (OP=1) entre 86 e 25
						-- deve resultar em 61 											com flags C=0, Z=0, N=0, V=0
						-- objetivo: testar subtração sem carry nem overflow
		input_a <= "0000000001010110";
		input_b <= "0000000001010110";
		operation_selection <= "001";
		wait for 50 ns;	-- testa subtração (OP=1) entre 86 e 86
						-- deve resultar em 0 											com flags C=0, Z=1, N=0, V=0
						-- objetivo: testar subtração com resultado zero
		input_a <= "0000000000011001";
		input_b <= "0000000001010110";
		operation_selection <= "001";
		wait for 50 ns;	-- testa subtração (OP=1) entre 25 e 86
						-- deve resultar em 0xffc3 (U:65475,S=-61) 						com flags C=1, Z=0, N=1, V=0
						-- objetivo: testar subtração com carry
		input_a <= "0100010001000100";
		input_b <= "1010101010101010";
		operation_selection <= "001";
		wait for 50 ns;	-- testa subtração (OP=1) entre 0x4444 (U=S:17476) e 0xaaaa (U:43690,S:-21846)
						-- deve resultar em 0x999a (U:39322,S=-26214, houve overflow) 	com flags C=1, Z=0, N=1, V=1
						-- objetivo: testar subtração com overflow
		input_a <= "1101110111011101";
		input_b <= "0111011001010100";
		operation_selection <= "001";
		wait for 50 ns;	-- testa subtração (OP=1) entre 0xdddd (U:56797,S:-8739) e 0x7654 (U=S:30292)
						-- deve resultar em 0x6789 (U=S:26505, houve underflow) 		com flags C=0, Z=0, N=0 e V=1
						-- objetivo: testar subtração com underflow
		---------------------------fim dos testes de subtração---------------------------
		input_a <= "1111111110101010";
		input_b <= "0101010101010101";
		operation_selection <= "010";
		wait for 50 ns;	-- testa operação AND (OP=2) entre 0xffaa e 0x5555
						-- deve resultar em 0x5500 										com flags C=0, Z=0, N=0, V=0
						-- objetivo: testar operação AND
		input_a <= "1111111110100000";
		input_b <= "0000000001010101";
		operation_selection <= "010";
		wait for 50 ns;	-- testa operação AND (OP=2) entre 0xffa0 e 0x0055
						-- deve resultar em 0x0000 										com flags C=0, Z=1, N=0, V=0
						-- objetivo: testar operação AND com resultado zero
		---------------------------fim dos testes da função AND---------------------------
		input_a <= "0000000010101111";
		input_b <= "0101010101010101";
		operation_selection <= "011";
		wait for 50 ns;	-- testa operação OR (OP=3) entre 0x00af e 0x5555
						-- deve resultar em 0x55ff 										com flags C=0, Z=0, N=0, V=0
						-- objetivo: testar operação OR
		---------------------------fim dos testes da função OR----------------------------
		input_a <= "0000000010101111";
		input_b <= "0101010101010101";
		operation_selection <= "100";
		wait for 50 ns;	-- testa operação XOR (OP=4) entre 0x00af e 0x5555
						-- deve resultar em 0x55fa 										com flags C=0, Z=0, N=0, V=0
						-- objetivo: testar operação XOR
		---------------------------fim dos testes da função XOR---------------------------
		input_a <= "0000010101011111";
		input_b <= "0000000000000100";
		operation_selection <= "101";
		wait for 50 ns;	-- testa operação deslocamento lógico para a esquerda (OP=5) entre 0x055f e 0x0004
						-- deve resultar em 0x55f0 										com flags C=0, Z=0, N=0, V=0
						-- objetivo: testar a operação sem carry nem overflow
		input_a <= "0000010101011111";
		input_b <= "0000000000000101";
		operation_selection <= "101";
		wait for 50 ns;	-- testa operação deslocamento lógico para a esquerda (OP=5) entre 0x055f e 0x0005
						-- deve resultar em 0xabe0 										com flags C=0, Z=0, N=1, V=1
						-- objetivo: testar mudança de sinal, causando overflow
		input_a <= "0000010101011111";
		input_b <= "0000000000000110";
		operation_selection <= "101";
		wait for 50 ns;	-- testa operação deslocamento lógico para a esquerda (OP=5) entre 0x055f e 0x0006
						-- deve resultar em 0x57c0 										com flags C=1, Z=0, N=0, V=1
						-- objetivo: testar carry e perda de 1s e 0s misturados, causando overflow
		input_a <= "0000010101011111";
		input_b <= "0000000000000111";
		operation_selection <= "101";
		wait for 50 ns;	-- testa operação deslocamento lógico para a esquerda (OP=5) entre 0x055f e 0x0007
						-- deve resultar em 0xaf80 										com flags C=0, Z=0, N=1, V=1
						-- objetivo: testar perda de um bit 1 sem carry, ainda causando overflow
		input_a <= "0000010101011111";
		input_b <= "1101101011010000";
		operation_selection <= "101";
		wait for 50 ns;	-- testa operação deslocamento lógico para a esquerda (OP=5) entre 0x055f e 0xdad0
						-- deve resultar em 0x0000 										com flags C=0, Z=1, N=0, V=1
						-- objetivo: testar perda da palavra toda, causando overflow
		input_a <= "0000000000000000";
		input_b <= "1101101011010000";
		operation_selection <= "101";
		wait for 50 ns;	-- testa operação deslocamento lógico para a esquerda (OP=5) entre 0x0000 e 0xdad0
						-- deve resultar em 0x0000 										com flags C=0, Z=1, N=0, V=0
						-- objetivo: testar perda da palavra toda, que por ser zero não causa overflow
		input_a <= "1001101011010000";
		input_b <= "0000000000000001";
		operation_selection <= "101";
		wait for 50 ns;	-- testa operação deslocamento lógico para a esquerda (OP=5) entre 0x9ad0 e 0x0001
						-- deve resultar em 0x35a0 										com flags C=1, Z=0, N=0, V=1
						-- objetivo: testar carry e perda de um bit 1 com mudança de sinal, causando overflow
		input_a <= "1111101000000000";
		input_b <= "0000000000000010";
		operation_selection <= "101";
		wait for 50 ns;	-- testa operação deslocamento lógico para a esquerda (OP=5) entre 0xfa00 e 0x0002
						-- deve resultar em 0xe800 										com flags C=1, Z=0, N=1, V=0
						-- objetivo: testar perda de "11" sem mudança de sinal, portanto sem overflow
		input_a <= "1101101011010000";
		input_b <= "0000000000000000";
		operation_selection <= "101";
		wait for 50 ns;	-- testa operação deslocamento lógico para a esquerda (OP=5) entre 0xdad0 e 0x0000
						-- deve resultar em 0xdad0 										com flags C=0, Z=0, N=1, V=0
						-- objetivo: testar segundo operando igual a zero
		---------------fim dos testes do deslocamento lógico para a esquerda--------------
		input_a <= "0000010101011111";
		input_b <= "0000000000000101";
		operation_selection <= "110";
		wait for 50 ns;	-- testa operação deslocamento aritmético para a direita (OP=6) entre 0x055f e 0x0005
						-- deve resultar em 0x002a 										com flags C=1, Z=0, N=0, V=1
						-- objetivo: testar carry e perda de bits 1
		input_a <= "1111111111111111";
		input_b <= "0000000000000101";
		operation_selection <= "110";
		wait for 50 ns;	-- testa operação deslocamento aritmético para a direita (OP=6) entre 0xffff e 0x0005
						-- deve resultar em 0xffff 										com flags C=1, Z=0, N=1, V=0
						-- objetivo: será que aqui deveria ter overflow ou não?????????????????
		input_a <= "1111111100000000";
		input_b <= "0000000000000100";
		operation_selection <= "110";
		wait for 50 ns;	-- testa operação deslocamento aritmético para a direita (OP=6) entre 0xff00 e 0x0004
						-- deve resultar em 0xfff0 										com flags C=0, Z=0, N=1, V=0
						-- objetivo: testar o deslocamento preenchendo o resultado com bits 1, perdendo somente zeros
		input_a <= "1111111100000000";
		input_b <= "1101101011010000";
		operation_selection <= "110";
		wait for 50 ns;	-- testa operação deslocamento aritmético para a direita (OP=6) entre 0xff00 e 0xdad0
						-- deve resultar em 0xffff 										com flags C=1, Z=0, N=1, V=1
						-- objetivo: testar perda completa da palavra negativa
		input_a <= "0000111100000000";
		input_b <= "1101101011010000";
		operation_selection <= "110";
		wait for 50 ns;	-- testa operação deslocamento aritmético para a direita (OP=6) entre 0x0f00 e 0xdad0
						-- deve resultar em 0x0000 										com flags C=0, Z=1, N=0, V=1
						-- objetivo: testar perda completa da palavra positiva
		input_a <= "0000111100000000";
		input_b <= "0000000000000000";
		operation_selection <= "110";
		wait for 50 ns;	-- testa operação deslocamento aritmético para a direita (OP=6) entre 0x0f00 e 0x0000
						-- deve resultar em 0x0f00 										com flags C=0, Z=0, N=0, V=0
						-- objetivo: testar segundo operando igual a zero
		--------------fim dos testes do deslocamento aritmético para a direita------------
		input_a <= "0001001000110100";
		input_b <= "0000000000000100";
		operation_selection <= "111";
		wait for 50 ns;	-- testa operação rotação para a esquerda (OP=7) entre 0x1234 e 0x0004
						-- deve resultar em 0x2341 										com flags C=1, Z=0, N=0, V=0
						-- objetivo: testar rotação em geral e flag carry
		input_a <= "0001001000110100";
		input_b <= "1111000000000100";
		operation_selection <= "111";
		wait for 50 ns;	-- testa operação rotação para a esquerda (OP=7) entre 0x1234 e 0xf004
						-- deve resultar em 0x2341 										com flags C=1, Z=0, N=0, V=0
						-- objetivo: testar rotação com segundo operando maior que 15
		input_a <= "0001001000110100";
		input_b <= "0000000000000000";
		operation_selection <= "111";
		wait for 50 ns;	-- testa operação rotação para a esquerda (OP=7) entre 0x1234 e 0x0000
						-- deve resultar em 0x1234 										com flags C=0, Z=0, N=0, V=0
						-- objetivo: testar segundo operando igual a zero
		---------------------fim dos testes da rotação para a esquerda--------------------
		wait;
	end process;
end architecture;