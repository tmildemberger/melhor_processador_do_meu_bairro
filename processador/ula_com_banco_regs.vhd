library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_com_banco_regs is
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
end entity;

architecture a_ula_com_banco_regs of ula_com_banco_regs is
	component ula
		port( 	input_a,input_b			: in unsigned(15 downto 0);
				operation_selection		: in unsigned(2 downto 0);
				output					: out unsigned(15 downto 0);
				carry_flag				: out std_logic;
				zero_flag				: out std_logic;
				negative_flag			: out std_logic;
				overflow_flag			: out std_logic
		);
	end component;
	
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
	
	signal ula_output_signal, bank_out_1, bank_out_2, ula_input_b	: unsigned(15 downto 0);
begin
	ula_banco 	: ula port map(			input_a				=> bank_out_1,
										input_b				=> ula_input_b,
										operation_selection	=> operation_selection,
										output				=> ula_output_signal,
										carry_flag			=> carry_flag,
										zero_flag			=> zero_flag,
										negative_flag		=> negative_flag,
										overflow_flag		=> overflow_flag);
	
	banco 		: banco_regs port map (	clock 				=> clock,
										reset				=> reset,
										write_enable		=> write_enable,
										read_register_1		=> read_register_1,
										read_register_2		=> read_register_2,
										write_register		=> write_register,
										write_data			=> ula_output_signal,
										read_data_1			=> bank_out_1,
										read_data_2			=> bank_out_2);
	
	ula_input_b		<=  bank_out_2 when ula_input_selection='0' else
						data_input when ula_input_selection='1' else
						"0000000000000000";
	
	ula_output		<= ula_output_signal;
end architecture;