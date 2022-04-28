library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_tb is
end entity;

architecture a_banco_regs_tb of banco_regs_tb is
    component banco_regs
        port(	clock 			: in std_logic;
                reset 			: in std_logic;
                write_enable	: in std_logic;
                read_register_1	: in unsigned(2 downto 0);
                read_register_2	: in unsigned(2 downto 0);
                write_register	: in unsigned(2 downto 0);
                write_data 		: in unsigned(15 downto 0);
                read_data_1		: out unsigned(15 downto 0);
                read_data_2		: out unsigned(15 downto 0)
	    );
    end component;
    signal clock, reset, write_enable           : std_logic				:= '0';
	signal write_data, read_data_1, read_data_2	: unsigned(15 downto 0)	:= (others => '0');
	signal read_register_1, read_register_2     : unsigned(2 downto 0)  := (others => '0');
    signal write_register                       : unsigned(2 downto 0)  := (others => '0');
    signal finished						        : std_logic				:= '0';
	constant period_time				        : time					:= 100 ns;
begin
    uut: banco_regs port map( 	clock			=> clock,
								reset			=> reset,
								write_enable	=> write_enable,
								write_data		=> write_data,
								read_data_1		=> read_data_1,
                                read_data_2     => read_data_2,
                                write_register  => write_register,
                                read_register_1 => read_register_1,
                                read_register_2 => read_register_2);

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
        write_register <= "001";
        write_data <= "1010101010101010";   -- testa entrada aleatória no write_data
                                            -- e com um registrador aleatório sem write_enable
        wait for period_time*2;
        write_enable <= '1';
        write_register <= "000";
        write_data <= "1010101010101010";   -- testa entrada aleatória no write_data
                                            -- e com o registrador 0 selecionado 
                                            -- com write_enable (não escreve mesmo assim pois é o registrador 0)
        wait for period_time*2;
        write_enable <= '1';
        write_register <= "001";
        write_data <= "0000000000000001";   -- testa escrita no registrador 1

        wait for period_time*2;
        write_enable <= '1';
        write_register <= "010";
        write_data <= "0000000000000010";   -- testa escrita no registrador 2
        
        wait for period_time*2;
        write_enable <= '1';
        write_register <= "011";
        write_data <= "0000000000000011";   -- testa escrita no registrador 3

        wait for period_time*2;
        write_enable <= '1';
        write_register <= "100";
        write_data <= "0000000000000100";   -- testa escrita no registrador 4

        wait for period_time*2;
        write_enable <= '1';
        write_register <= "101";
        write_data <= "0000000000000101";   -- testa escrita no registrador 5

        wait for period_time*2;
        write_enable <= '1';
        write_register <= "110";
        write_data <= "0000000000000110";   -- testa escrita no registrador 6

        wait for period_time*2;
        write_enable <= '1';
        write_register <= "111";
        write_data <= "0000000000000111";   -- testa escrita no registrador 7

        wait for period_time*2;
        write_enable <= '0';
        read_register_1 <= "000";           -- testa leitura do registrador 0
                                            -- com o read_register_1
        wait for period_time*2;
        read_register_1 <= "001";           -- testa leitura do registrador 1
                                            -- com o read_register_1
        wait for period_time*2;
        read_register_1 <= "010";           -- testa leitura do registrador 2
                                            -- com o read_register_1
        wait for period_time*2;
        read_register_1 <= "011";           -- testa leitura do registrador 3
                                            -- com o read_register_1
        wait for period_time*2;
        read_register_1 <= "100";           -- testa leitura do registrador 4
                                            -- com o read_register_1
        wait for period_time*2;
        read_register_1 <= "101";           -- testa leitura do registrador 5
                                            -- com o read_register_1
        wait for period_time*2;
        read_register_1 <= "110";           -- testa leitura do registrador 6
                                            -- com o read_register_1
        wait for period_time*2;
        read_register_1 <= "111";           -- testa leitura do registrador 7
                                            -- com o read_register_1
        wait for period_time*2;
        read_register_2 <= "000";           -- testa leitura do registrador 0
                                            -- com o read_register_2
        wait for period_time*2;
        read_register_2 <= "001";           -- testa leitura do registrador 1
                                            -- com o read_register_2
        wait for period_time*2;
        read_register_2 <= "010";           -- testa leitura do registrador 2
                                            -- com o read_register_2
        wait for period_time*2;
        read_register_2 <= "011";           -- testa leitura do registrador 3
                                            -- com o read_register_2
        wait for period_time*2;
        read_register_2 <= "100";           -- testa leitura do registrador 4
                                            -- com o read_register_2
        wait for period_time*2;
        read_register_2 <= "101";           -- testa leitura do registrador 5
                                            -- com o read_register_2
        wait for period_time*2;
        read_register_2 <= "110";           -- testa leitura do registrador 6
                                            -- com o read_register_2
        wait for period_time*2;
        read_register_2 <= "111";           -- testa leitura do registrador 7
                                            -- com o read_register_2
        wait for period_time*2;
        write_enable <= '1';
        write_data <= read_data_2;
        write_register <= "101";
        read_register_1 <= "101";           -- testa escrita e leitura

        wait for period_time*2;
        finished <= '1';                    -- acaba
        wait;
    end process;
    
end architecture a_banco_regs_tb;