library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.estados_package.all;

entity processador is
	port( 	clock, reset				: in std_logic;
			estado_atual				: out tipo_estado;
			program_counter_out			: out unsigned(6 downto 0);
			instruction_register_out	: out unsigned(17 downto 0);
			read_register_1				: out unsigned(15 downto 0);
			read_register_2				: out unsigned(15 downto 0);
			ula_out						: out unsigned(15 downto 0)
	);
end entity;

architecture a_processador of processador is
	component program_counter
		port(	clock 			: in std_logic;
				reset 			: in std_logic;
				write_enable	: in std_logic;
				data_in 		: in unsigned(6 downto 0);
				data_out 		: out unsigned(6 downto 0)
		);
	end component;
	component rom
		port( 	clock				: in std_logic;
				endereco			: in unsigned(6 downto 0);
				dado				: out unsigned(17 downto 0)
		);
	end component;
	component instruction_register
		port(	clock 			: in std_logic;
				reset 			: in std_logic;
				write_enable	: in std_logic;
				data_in 		: in unsigned(17 downto 0);
				data_out 		: out unsigned(17 downto 0)
		);
	end component;
	component maquina_de_estados
		port( 	clock, reset		: in std_logic;
				instrucao			: in unsigned(17 downto 0);
				estado				: out tipo_estado
		);
	end component;
	component unidade_de_controle
		port( 	clock, reset							: in std_logic;
				instrucao								: in unsigned(17 downto 0);
				estado									: in tipo_estado;
				ula_1_selection							: out unsigned(1 downto 0);
				ula_2_selection							: out std_logic;
				pc_write_enable							: out std_logic;
				ir_write_enable							: out std_logic;
				immediate_selection						: out unsigned(1 downto 0);
				banco_regs_write_register_selection		: out std_logic;
				banco_regs_write_data_selection			: out unsigned(1 downto 0);
				banco_regs_write_enable					: out std_logic;
				ula_operation_control_selection			: out std_logic;
				ula_operation_control					: out unsigned(2 downto 0);
				ula_out_reg_write_enable				: out std_logic;
				pc_input_selection						: out unsigned(1 downto 0)
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
	-- para o ula_out_reg
	component reg16bits
		port(	clock 			: in std_logic;
				reset 			: in std_logic;
				write_enable	: in std_logic;
				data_in 		: in unsigned(15 downto 0);
				data_out 		: out unsigned(15 downto 0)
		);
	end component;
	
	signal pc_input								: unsigned(6 downto 0)	:= (others => '0');
	signal pc_output							: unsigned(6 downto 0)	:= (others => '0');
	signal pc_write_enable						: std_logic				:= '0';
	
	signal rom_endereco							: unsigned(6 downto 0)	:= (others => '0');
	signal rom_dado								: unsigned(17 downto 0)	:= (others => '0');
	
	signal ir_input								: unsigned(17 downto 0)	:= (others => '0');
	signal ir_output							: unsigned(17 downto 0)	:= (others => '0');
	signal ir_write_enable						: std_logic				:= '0';
	
	signal estado								: tipo_estado			:= instruction_fetch;
	
	signal ula_1_selection						: unsigned(1 downto 0)	:= (others => '0');
	signal ula_2_selection						: std_logic				:= '0';
	signal immediate_selection					: unsigned(1 downto 0)	:= (others => '0');
	signal banco_regs_write_register_selection	: std_logic				:= '0';
	signal banco_regs_write_data_selection		: unsigned(1 downto 0)	:= (others => '0');
	signal ula_operation_control_selection		: std_logic				:= '0';
	signal ula_operation_control				: unsigned(2 downto 0)	:= (others => '0');
	signal pc_input_selection					: unsigned(1 downto 0)	:= (others => '0');
	
	signal banco_regs_write_enable				: std_logic				:= '0';
	signal banco_regs_write_register			: unsigned(2 downto 0)	:= (others => '0');
	signal banco_regs_write_data				: unsigned(15 downto 0)	:= (others => '0');
	signal read_register_1_data					: unsigned(15 downto 0)	:= (others => '0');
	signal read_register_2_data					: unsigned(15 downto 0)	:= (others => '0');
	
	signal ula_1_input							: unsigned(15 downto 0)	:= (others => '0');
	signal ula_2_input							: unsigned(15 downto 0)	:= (others => '0');
	signal ula_operation_selection				: unsigned(2 downto 0)	:= (others => '0');
	signal ula_output							: unsigned(15 downto 0)	:= (others => '0');
	signal ula_carry_flag						: std_logic				:= '0';
	signal ula_zero_flag						: std_logic				:= '0';
	signal ula_negative_flag					: std_logic				:= '0';
	signal ula_overflow_flag					: std_logic				:= '0';
	
	signal ula_out_reg_write_enable				: std_logic				:= '0';
	signal ula_out_reg_output					: unsigned(15 downto 0)	:= (others => '0');
	
	
	signal immediate_output						: unsigned(15 downto 0)	:= (others => '0');
	
begin
	pc : program_counter port map(	clock		 => clock,
									reset		 => reset,
									write_enable => pc_write_enable,
									data_in		 => pc_input,
									data_out	 => pc_output);

	memoria_rom : rom port map(	clock 	 => clock,
								endereco => rom_endereco,
								dado	 => rom_dado);

	ir : instruction_register port map(	clock		 => clock,
										reset		 => reset,
										write_enable => ir_write_enable,
										data_in		 => ir_input,
										data_out	 => ir_output);

	maq_estados : maquina_de_estados port map(	clock		=> clock,
												reset		=> reset,
												instrucao	=> ir_output,
												estado  	=> estado);

	uc : unidade_de_controle port map(	clock								=> clock,
										reset								=> reset,
										instrucao							=> ir_output,
										estado								=> estado,
										ula_1_selection						=> ula_1_selection,
										ula_2_selection						=> ula_2_selection,
										pc_write_enable						=> pc_write_enable,
										ir_write_enable						=> ir_write_enable,
										immediate_selection					=> immediate_selection,
										banco_regs_write_register_selection	=> banco_regs_write_register_selection,
										banco_regs_write_data_selection		=> banco_regs_write_data_selection,
										banco_regs_write_enable				=> banco_regs_write_enable,
										ula_operation_control_selection		=> ula_operation_control_selection,
										ula_operation_control				=> ula_operation_control,
										ula_out_reg_write_enable			=> ula_out_reg_write_enable,
										pc_input_selection					=> pc_input_selection);

	banco_de_regs : banco_regs port map (	clock 				=> clock,
											reset				=> reset,
											write_enable		=> banco_regs_write_enable,
											read_register_1		=> ir_output(2 downto 0),
											read_register_2		=> ir_output(5 downto 3),
											write_register		=> banco_regs_write_register,
											write_data			=> banco_regs_write_data,
											read_data_1			=> read_register_1_data,
											read_data_2			=> read_register_2_data);

	unidade_logica_aritmetica : ula port map(	input_a				=> ula_1_input,
												input_b				=> ula_2_input,
												operation_selection	=> ula_operation_selection,
												output				=> ula_output,
												carry_flag			=> ula_carry_flag,
												zero_flag			=> ula_zero_flag,
												negative_flag		=> ula_negative_flag,
												overflow_flag		=> ula_overflow_flag);

	ula_out_reg : reg16bits port map(	clock		 => clock,
										reset		 => reset,
										write_enable => ula_out_reg_write_enable,
										data_in		 => ula_output,
										data_out	 => ula_out_reg_output);


	immediate_output	<=	resize("1", 16) when immediate_selection="00" else
							unsigned(resize(signed(ir_output(13 downto 6)), 16)) when immediate_selection="01" else
							unsigned(resize(signed(ir_output(16 downto 12) & ir_output(7 downto 3)), 16)) when immediate_selection="10" else
							ir_output(15 downto 0) when immediate_selection="11" else
							resize("1", 16);


	banco_regs_write_register	<=	ir_output(2 downto 0) when banco_regs_write_register_selection='0' else
									ir_output(17 downto 15) when banco_regs_write_register_selection='1' else
									ir_output(2 downto 0);


	banco_regs_write_data	<=	immediate_output when banco_regs_write_data_selection="00" else
								read_register_2_data when banco_regs_write_data_selection="01" else
								ula_out_reg_output when banco_regs_write_data_selection="10" else
								resize("0", 16) when banco_regs_write_data_selection="11" else
								immediate_output;


	ula_1_input	<=	"000000000" & pc_output when ula_1_selection="00" else
					read_register_1_data when ula_1_selection="01" else
					read_register_2_data when ula_1_selection="10" else
					resize("0", 16) when ula_1_selection="11" else
					"000000000" & pc_output;


	ula_2_input	<=	immediate_output when ula_2_selection='0' else
					read_register_2_data when ula_2_selection='1' else
					immediate_output;


	ula_operation_selection	<=	ula_operation_control when ula_operation_control_selection='0' else
								ir_output(10 downto 8) when ula_operation_control_selection='1' else
								ula_operation_control;


	pc_input	<=	ula_output(6 downto 0) when pc_input_selection="00" else
					ula_out_reg_output(6 downto 0) when pc_input_selection="01" else
					resize("0", 16) when pc_input_selection="10" else
					ir_output(12 downto 6) when pc_input_selection="11" else
					ula_output(6 downto 0);


	rom_endereco	<=	pc_output;
	ir_input		<=	rom_dado;


	estado_atual				<= estado;
	program_counter_out			<= pc_output;
	instruction_register_out	<= ir_output;
	read_register_1				<= read_register_1_data;
	read_register_2				<= read_register_1_data;
	ula_out						<= ula_output;
end architecture;