library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
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
			-- ** 1 se um bit diferente do bit de sinal do resultado foi deslocado para fora do operando no caso de deslocamento para a esquerda
			-- ** 1 se um bit diferente de zero foi deslocado para fora do operando no caso de deslocamento para a direita
			-- ** 0 caso contrário
			-- * a flag é zerada se outra operação estiver sendo realizada
			-- assim, é possível observar que essa flag não sinaliza somente uma inconsistência de sinal,
			-- mas de forma mais geral avisa sobre uma possível possível perda não intencional de informação na operação
	);
end entity;

architecture a_ula of ula is
	signal ula_out: unsigned(15 downto 0);
	signal zero : unsigned(15 downto 0);
	signal ones : unsigned(15 downto 0);
	signal shift_amount : unsigned(3 downto 0);
begin
	zero   <= 	"0000000000000000";
	ones   <= 	"1111111111111111";
	shift_amount <= input_b(3 downto 0);
	ula_out <= 	input_a + input_b when operation_selection="000" else
				input_a - input_b when operation_selection="001" else
				input_a(15 downto 0) and input_b(15 downto 0) when operation_selection="010" else
				input_a(15 downto 0) or input_b(15 downto 0) when operation_selection="011" else
				input_a(15 downto 0) xor input_b(15 downto 0) when operation_selection="100" else
				input_a((15 - to_integer(input_b(3 downto 0))) downto 0) & zero(to_integer(input_b(3 downto 0))-1 downto 0) when operation_selection="101" and input_b <= 15 else
				zero(to_integer(input_b(3 downto 0))-1 downto 0) & input_a(15 downto to_integer(input_b(3 downto 0))) when operation_selection="110" and input_b <= 15 and input_a(15)='0' else
				ones(to_integer(input_b(3 downto 0))-1 downto 0) & input_a(15 downto to_integer(input_b(3 downto 0))) when operation_selection="110" and input_b <= 15 and input_a(15)='1' else
				"1111111111111111" when operation_selection="110" and input_b >= 16 and input_a(15)='1' else
				input_a(15 - to_integer(input_b(3 downto 0)) downto 0) & input_a(15 downto 16 - to_integer(input_b(3 downto 0))) when operation_selection="111" else
				"0000000000000000";
	
	carry_flag   	<=	'1' when input_a(15)='1' and input_b(15)='1' and operation_selection="000" else
						'1' when input_a(15)='1' and ula_out(15)='0' and operation_selection="000" else
						'1' when input_a(15)='0' and ula_out(15)='1' and operation_selection="001" else
						'1' when shift_amount/="0000" and input_a(15 - (to_integer(shift_amount) - 1))='1' and input_b<16 and operation_selection="101" else
						'1' when shift_amount/="0000" and input_a(to_integer(shift_amount) - 1)='1' and input_b<16 and operation_selection="110" else
						'1' when shift_amount/="0000" and input_a(15)='1' and input_b>15 and operation_selection="110" else
						'1' when shift_amount/="0000" and input_a(15 - (to_integer(shift_amount) - 1))='1' and operation_selection="111" else
						'0';
				
	zero_flag   	<=	'1' when ula_out="0000000000000000" else
						'0';
	
	negative_flag   <=	'1' when ula_out(15)='1' else
						'0';
	
	overflow_flag	<=	'1' when ula_out(15)='1' and input_a(15)='0' and input_b(15)='0' and operation_selection="000" else
						'1' when ula_out(15)='0' and input_a(15)='1' and input_b(15)='1' and operation_selection="000" else
						'1' when ula_out(15)='0' and input_b(15)='1' and operation_selection="001" else
						'1' when ula_out(15)='0' and input_a(15)='1' and input_b(15)='0' and operation_selection="001" else
						'1' when ula_out(15)='1' and input_a(15)='0' and input_b(15)='1' and operation_selection="001" else
						'1' when shift_amount/="0000" and input_a(15)='0' and input_a(15 downto (15 - (to_integer(shift_amount) - 1)))/=zero((15 - (to_integer(shift_amount) - 1)) downto 0) and input_b<16 and operation_selection="101" else
						'1' when shift_amount/="0000" and input_a(15)/=ula_out(15) and input_b<16 and operation_selection="101" else
						'1' when shift_amount/="0000" and input_a/=zero and input_b>15 and operation_selection="101" else
						'1' when shift_amount/="0000" and input_a(15)='1' and input_a(15 downto (15 - (to_integer(shift_amount) - 1)))/=ones(15 - (to_integer(shift_amount) - 1) downto 0) and input_b<16 and operation_selection="101" else
						'1' when shift_amount/="0000" and input_a((to_integer(shift_amount) - 1) downto 0)/=zero((to_integer(shift_amount) - 1) downto 0) and input_b<16 and operation_selection="110" else
						'0';
					
	output <= 	ula_out;
end architecture;