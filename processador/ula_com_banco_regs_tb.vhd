library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_com_banco_regs_tb is
end entity;

architecture a_ula_com_banco_regs_tb of ula_com_banco_regs_tb is
    component ula_com_banco_regs
        port(	clock 				: in std_logic;
                reset 				: in std_logic;
                write_enable		: in std_logic;
                ula_input_selection : in std_logic;
                operation_selection : in unsigned(2 downto 0);
                read_register_1		: in unsigned(2 downto 0);
                read_register_2		: in unsigned(2 downto 0);
                write_register		: in unsigned(2 downto 0);
                data_input			: in unsigned(15 downto 0);
                ula_output			: out unsigned(15 downto 0);
                carry_flag			: out std_logic;
                zero_flag			: out std_logic;
                negative_flag		: out std_logic;
                overflow_flag		: out std_logic
	    );
    end component;
    signal clock, reset, write_enable           : std_logic				:= '0';
    signal ula_input_selection                  : std_logic             := '0';
    signal operation_selection                  : unsigned(2 downto 0)  := (others => '0');
	signal read_register_1, read_register_2     : unsigned(2 downto 0)  := (others => '0');
    signal write_register                       : unsigned(2 downto 0)  := (others => '0');
	signal data_input, ula_output               : unsigned(15 downto 0)	:= (others => '0');
    signal carry_flag                           : std_logic             := '0';
    signal zero_flag                            : std_logic             := '0';
    signal negative_flag                        : std_logic             := '0';
    signal overflow_flag                        : std_logic             := '0';
    signal finished						        : std_logic				:= '0';
	constant period_time				        : time					:= 100 ns;
begin
    uut: ula_com_banco_regs port map( 	clock			    => clock,
                                        reset			    => reset,
                                        write_enable	    => write_enable,
                                        write_register      => write_register,
                                        read_register_1     => read_register_1,
                                        read_register_2     => read_register_2,
                                        ula_input_selection => ula_input_selection,
                                        operation_selection => operation_selection,
                                        data_input          => data_input,
                                        ula_output          => ula_output,
                                        carry_flag          => carry_flag,
                                        zero_flag           => zero_flag,
                                        negative_flag       => negative_flag,
                                        overflow_flag       => overflow_flag);

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
        write_enable <= '1';
        write_register <= "001";
        read_register_1 <= "000";
        ula_input_selection <= '1';
        operation_selection <= "000";
        data_input <= "1010101010101010";   -- testa operação de soma da ula entre o 
                                            -- valor do registrador 0 e uma constante,
                                            -- armazenando o valor no registrador 1 
                                            -- (equivalente a uma instrução addi)
        wait for period_time*2;
        write_enable <= '1';
        write_register <= "100";
        read_register_1 <= "001";
        read_register_2 <= "011";
        ula_input_selection <= '0';
        operation_selection <= "000";       -- testa operação de soma da ula entre o 
                                            -- valor do registrador 1 e o valor do
                                            -- registrador 3, armazenando o valor no
                                            -- registrador 4 (equivalente a uma instrução add)
        wait for period_time*2;
        write_enable <= '0';
        write_register <= "100";
        read_register_1 <= "100";
        read_register_2 <= "001";
        ula_input_selection <= '0';
        operation_selection <= "001";       -- testa operação de subtração da ula entre o 
                                            -- valor do registrador 4 e o valor do
                                            -- registrador 1, mas sem o write_enable
        wait for period_time*2;
        finished <= '1';                    -- acaba
        wait;
    end process;
    
end architecture a_ula_com_banco_regs_tb;