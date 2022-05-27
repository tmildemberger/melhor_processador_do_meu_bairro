library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_heap_sort_tb is
end entity;

architecture a_rom_heap_sort_tb of rom_heap_sort_tb is
	component rom_heap_sort
		port( 	clock				: in std_logic;
				endereco			: in unsigned(6 downto 0);
				dado				: out unsigned(17 downto 0)
		);
	end component;
	signal clock						: std_logic				:= '0';
	signal endereco						: unsigned(6 downto 0)	:= (others => '0');
	signal dado							: unsigned(17 downto 0)	:= (others => '0');
	signal finished						: std_logic				:= '0';
	constant period_time				: time					:= 100 ns;
begin
	uut: rom_heap_sort port map( 	clock			=> clock,
									endereco		=> endereco,
									dado			=> dado);
	
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
		endereco <= "0000000";
		wait for period_time*2;
		endereco <= "0000001";
		wait for period_time*2;
		endereco <= "0000010";
		wait for period_time*2;
		endereco <= "0000011";
		wait for period_time*2;
		endereco <= "0000100";
		wait for period_time*2;
		endereco <= "0000101";
		wait for period_time*2;
		endereco <= "0000111";
		wait for period_time*2;
		endereco <= "0000110";
		wait for period_time*2;
		endereco <= "0001000";
		wait for period_time*2;
		finished <= '1';							-- acaba
		wait;
	end process;
end architecture;