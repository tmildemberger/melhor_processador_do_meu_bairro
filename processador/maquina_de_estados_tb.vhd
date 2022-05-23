library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.estados_package.all;

entity maquina_de_estados_tb is
end entity;

architecture a_maquina_de_estados_tb of maquina_de_estados_tb is
	component maquina_de_estados
		port( 	clock, reset		: in std_logic;
				instrucao			: in unsigned(17 downto 0);
				condicao_ok			: in std_logic;
				estado				: out tipo_estado
		);
	end component;
	signal clock, reset					: std_logic				:= '0';
	signal instrucao					: unsigned(17 downto 0)	:= (others => '0');
	signal estado						: tipo_estado 			:= instruction_fetch;
	signal finished						: std_logic				:= '0';
	signal condicao_ok					: std_logic				:= '0';
	constant period_time				: time					:= 100 ns;
begin
	uut: maquina_de_estados port map( 	clock			=> clock,
										reset			=> reset,
										instrucao		=> instrucao,
										condicao_ok		=> condicao_ok,
										estado			=> estado);

	reset_global: process
	begin
		reset <= '1';
		wait for period_time*2;
		reset <= '0';
		wait;
	end process reset_global;

	clock_process: process
	begin
		while finished /= '1' loop
			clock <= '0';
			wait for period_time/2;
			clock <= '1';
			wait for period_time/2;
		end loop;
		wait;
	end process clock_process;

	process
	begin
												-- testa reset
		wait for period_time*2;
		instrucao <= "110011010101111001";
		wait for period_time*3;					-- testa trocas de estado para instrução do formato X (3 ciclos de clock)
		
		condicao_ok <= '1';
		instrucao <= "101011111111100000";
		wait for period_time*4;					-- testa trocas de estado para instrução do formato J (4 ciclos de clock)
		
		instrucao <= "000000010101000100";
		wait for period_time*4;					-- testa trocas de estado para instrução do formato I (4 ciclos de clock)
		
		instrucao <= "101100010000110011";
		wait for period_time*4;					-- testa trocas de estado para instrução do formato R (4 ciclos de clock)
		
		condicao_ok <= '0';
		instrucao <= "101011111111100110";
		wait for period_time*4;					-- testa tentativa de troca de estado para instrução do formato J
												-- (volta para instruction fetch)

		finished <= '1';						-- acaba
		wait;
	end process;
end architecture;