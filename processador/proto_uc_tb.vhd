library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proto_uc_tb is
end entity;

architecture a_proto_uc_tb of proto_uc_tb is
	component proto_uc
		port( 	clock, reset		: in std_logic;
				program_counter_out	: out unsigned(6 downto 0)
		);
	end component;
	signal clock, reset					: std_logic				:= '0';
	signal program_counter_out			: unsigned(6 downto 0)	:= (others => '0');
	signal finished						: std_logic				:= '0';
	constant period_time				: time					:= 100 ns;
begin
	uut: proto_uc port map( clock				=> clock,
							reset				=> reset,
							program_counter_out	=> program_counter_out);
	
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
		wait for period_time*16;					-- testa contagem por alguns ciclos
		finished <= '1';							-- acaba
		wait;
	end process;
end architecture;