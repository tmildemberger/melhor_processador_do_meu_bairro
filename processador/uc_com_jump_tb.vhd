library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_com_jump_tb is
end entity;

architecture a_uc_com_jump_tb of uc_com_jump_tb is
	component uc_com_jump
		port( 	clock, reset		: in std_logic;
                estado_atual		: out std_logic;
                program_counter_out	: out unsigned(6 downto 0);
                rom_out				: out unsigned(17 downto 0)
        );
	end component;
	signal clock, reset, estado_atual	: std_logic				:= '0';
    signal program_counter_out			: unsigned(6 downto 0)	:= (others => '0');
    signal rom_out                      : unsigned(17 downto 0) := (others => '0');
	signal finished						: std_logic				:= '0';
	constant period_time				: time					:= 100 ns;
begin
	uut: uc_com_jump port map( 	clock			    => clock,
                                reset			    => reset,
                                program_counter_out	=> program_counter_out,
                                estado_atual        => estado_atual,
                                rom_out             => rom_out);
	
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
		wait for period_time*32;					-- testa algumas mudanças de estado
        -- o programa contém um loop infinito causado por jump pra trás na instrução
        --  de endereço 8 na rom, então ele nunca chega ao final.
		finished <= '1';							-- acaba
		wait;
	end process;
end architecture;