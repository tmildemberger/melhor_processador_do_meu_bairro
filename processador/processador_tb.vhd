library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.estados_package.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
	component processador
		port( 	clock, reset				: in std_logic;
				estado_atual				: out tipo_estado;
				program_counter_out			: out unsigned(6 downto 0);
				instruction_register_out	: out unsigned(17 downto 0);
				read_register_1				: out unsigned(15 downto 0);
				read_register_2				: out unsigned(15 downto 0);
				ula_out						: out unsigned(15 downto 0)
		);
	end component;
	signal clock, reset					: std_logic				:= '0';
	signal estado_atual					: tipo_estado			:= instruction_fetch;
	signal program_counter_out			: unsigned(6 downto 0)	:= (others => '0');
	signal instruction_register_out		: unsigned(17 downto 0)	:= (others => '0');
	signal read_register_1				: unsigned(15 downto 0)	:= (others => '0');
	signal read_register_2				: unsigned(15 downto 0)	:= (others => '0');
	signal ula_out						: unsigned(15 downto 0)	:= (others => '0');
	
	signal finished						: std_logic				:= '0';
	constant period_time				: time					:= 100 ns;
begin
	uut: processador port map( 	clock			    		=> clock,
								reset			    		=> reset,
								estado_atual				=> estado_atual,
								program_counter_out			=> program_counter_out,
								instruction_register_out	=> instruction_register_out,
								read_register_1				=> read_register_1,
								read_register_2				=> read_register_2,
								ula_out						=> ula_out);
	
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
		wait for period_time*1000;					-- testa o funcionamento por alguns ciclos
		finished <= '1';							-- acaba
		wait;
	end process;
end architecture;