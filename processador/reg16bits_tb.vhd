library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits_tb is
end entity;

architecture a_reg16bits_tb of reg16bits_tb is
	component reg16bits
		port(	clock 			: in std_logic;
				reset 			: in std_logic;
				write_enable	: in std_logic;
				data_in 		: in unsigned(15 downto 0);
				data_out 		: out unsigned(15 downto 0)
		);
	end component;
	signal clock, reset, write_enable	: std_logic				:= '0';
	signal data_in, data_out			: unsigned(15 downto 0)	:= (others => '0');
	signal finished						: std_logic				:= '0';
	constant period_time				: time					:= 100 ns;
begin
	uut: reg16bits port map( 	clock			=> clock,
								reset			=> reset,
								write_enable	=> write_enable,
								data_in			=> data_in,
								data_out		=> data_out);

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
		write_enable <= '0';
		data_in <= "1010101010101010";				-- testa entrada aleatória no data_in sem write_enable
		wait for period_time*2;
		write_enable <= '1';
		data_in <= "0000000100100011";				-- testa escrita
		wait for period_time*2;
		write_enable <= '0';
		data_in <= "1010101010101010";				-- testa se a saída se mantém
		wait for period_time*2;
		finished <= '1';							-- acaba
		wait;
	end process;
end architecture;