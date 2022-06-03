library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_tb is
end entity;

architecture a_ram_tb of ram_tb is
	component ram
		port( 	clock				: in std_logic;
				endereco			: in unsigned(6 downto 0);
				write_enable        : in std_logic;
                dado_in             : in unsigned(15 downto 0);
                dado_out            : out unsigned(15 downto 0)
		);
	end component;
    signal clock,write_enable	        : std_logic				:= '0';
	signal dado_in, dado_out			: unsigned(15 downto 0)	:= (others => '0');
    signal endereco                     : unsigned(6 downto 0)  := (others => '0');
	signal finished						: std_logic				:= '0';
	constant period_time				: time					:= 100 ns;
begin
	uut: ram port map( 	clock			=> clock,
                        endereco		=> endereco,
                        write_enable	=> write_enable,
                        dado_in			=> dado_in,
                        dado_out		=> dado_out);
	
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
		wait for period_time*2;
		write_enable <= '0';
		dado_in <= "1010101010101010";				-- testa entrada aleatória no dado_in sem write_enable
		wait for period_time*2;
		write_enable <= '1';
		dado_in <= "0000000100100011";				-- testa escrita
		wait for period_time*2;
		write_enable <= '0';
		dado_in <= "1010101010101010";				-- testa se a saída se mantém
		wait for period_time*2;
		finished <= '1';							-- acaba
		wait;
	end process;
end architecture;