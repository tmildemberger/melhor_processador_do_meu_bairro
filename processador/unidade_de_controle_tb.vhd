library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.estados_package.all;

entity unidade_de_controle_tb is
end entity;

architecture a_unidade_de_controle_tb of unidade_de_controle_tb is
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
	signal clock, reset							: std_logic				:= '0';
	
	signal instrucao							: unsigned(17 downto 0)	:= (others => '0');
	
	signal estado								: tipo_estado			:= instruction_fetch;
	
	signal ula_1_selection						: unsigned(1 downto 0)	:= (others => '0');
	signal ula_2_selection						: std_logic				:= '0';
	signal pc_write_enable						: std_logic				:= '0';
	signal ir_write_enable						: std_logic				:= '0';
	signal immediate_selection					: unsigned(1 downto 0)	:= (others => '0');
	signal banco_regs_write_register_selection	: std_logic				:= '0';
	signal banco_regs_write_data_selection		: unsigned(1 downto 0)	:= (others => '0');
	signal banco_regs_write_enable				: std_logic				:= '0';
	signal ula_operation_control_selection		: std_logic				:= '0';
	signal ula_operation_control				: unsigned(2 downto 0)	:= (others => '0');
	signal ula_out_reg_write_enable				: std_logic				:= '0';
	signal pc_input_selection					: unsigned(1 downto 0)	:= (others => '0');
	
	signal finished								: std_logic				:= '0';
	constant period_time						: time					:= 100 ns;
begin
	uut: unidade_de_controle port map(	clock								=> clock,
										reset								=> reset,
										instrucao							=> instrucao,
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
		
		---------------------------------------------------------------------------
		-- Testa sinais gerados para MOV R6, #0x3579
		instrucao 	<= "100000000000000000";		-- instrução aleatória
		estado		<= instruction_fetch;
		wait for period_time;
		
		-- só agora a instrução pode ser lida: 
		instrucao 	<= "110011010101111001";		-- MOV R6, #0x3579
		estado		<= instruction_decode;
		wait for period_time;
		estado		<= formato_X;
		wait for period_time;
		
		---------------------------------------------------------------------------
		-- Testa sinais gerados para XOR R3, R6
		instrucao 	<= "100000000000000000";		-- instrução aleatória
		estado		<= instruction_fetch;
		wait for period_time;
		
		-- só agora a instrução pode ser lida: 
		instrucao 	<= "101100010000110011";		-- XOR R3, R6
		estado		<= instruction_decode;
		wait for period_time;
		estado		<= formato_R_parte_1;
		wait for period_time;
		estado		<= formato_R_parte_2;
		wait for period_time;
		
		---------------------------------------------------------------------------
		-- Testa sinais gerados para JMPR UC, #0xff
		instrucao 	<= "100000000000000000";		-- instrução aleatória
		estado		<= instruction_fetch;
		wait for period_time;
		
		-- só agora a instrução pode ser lida: 
		instrucao 	<= "101011111111100000";		-- JMPR UC, #0xff
		estado		<= instruction_decode;
		wait for period_time;
		estado		<= formato_J_parte_1;
		wait for period_time;
		estado		<= formato_J_parte_2;
		wait for period_time;
		
		---------------------------------------------------------------------------
		-- Testa sinais gerados para SHL R4, #8
		instrucao 	<= "100000000000000000";		-- instrução aleatória
		estado		<= instruction_fetch;
		wait for period_time;
		
		-- só agora a instrução pode ser lida: 
		instrucao 	<= "000000010101000100";		-- SHL R4, #8
		estado		<= instruction_decode;
		wait for period_time;
		estado		<= formato_I_parte_1;
		wait for period_time;
		estado		<= formato_I_parte_2;
		wait for period_time;
		estado		<= instruction_fetch;
		finished <= '1';							-- acaba
		wait;
	end process;
end architecture;