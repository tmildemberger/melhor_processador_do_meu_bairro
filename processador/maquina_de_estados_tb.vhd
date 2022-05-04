library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_de_estados_tb is
end entity;

architecture a_maquina_de_estados_tb of maquina_de_estados_tb is
	component maquina_de_estados
		port( 	clock, reset		: in std_logic;
				estado				: out std_logic
		);
	end component;
	signal clock, reset, estado			: std_logic				:= '0';
	signal finished						: std_logic				:= '0';
	constant period_time				: time					:= 100 ns;
begin
	uut: maquina_de_estados port map( 	clock			=> clock,
										reset			=> reset,
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
		wait for period_time*16;					-- testa algumas mudanças de estado
		finished <= '1';							-- acaba
		wait;
	end process;
end architecture;