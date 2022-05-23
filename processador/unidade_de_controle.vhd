library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.estados_package.all;

entity unidade_de_controle is
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
			pc_input_selection						: out unsigned(1 downto 0);
			flags_write_enable						: out std_logic
	);
end entity;

architecture a_unidade_de_controle of unidade_de_controle is
begin
	ula_1_selection							<=	"00" when estado=instruction_fetch else
												"00" when estado=instruction_decode else
												"01" when estado=formato_I_parte_1 else
												"01" when estado=formato_R_parte_1 else
												"00";
												
	ula_2_selection							<=	'0' when estado=instruction_fetch else
												'0' when estado=instruction_decode else
												'0' when estado=formato_I_parte_1 else
												'1' when estado=formato_R_parte_1 else
												'0';
												
	pc_write_enable							<=	'1' when estado=instruction_fetch else
												'1' when estado=formato_J_parte_1 else
												'0';
												
	ir_write_enable							<=	'1' when estado=instruction_fetch else
												'0';
												
	immediate_selection						<=	"00" when estado=instruction_fetch else
												"01" when estado=instruction_decode else
												"11" when estado=formato_X else
												"10" when estado=formato_I_parte_1 else
												"10" when estado=formato_I_parte_2 else
												"00";
												
	banco_regs_write_register_selection		<=	'1' when estado=formato_X else
												'0';
												
	banco_regs_write_data_selection			<=	"00" when estado=formato_X else
												((not instrucao(11)) or (not instrucao(9))) & '0' when estado=formato_I_parte_2 else
												resize("" & ((not instrucao(11)) or (not instrucao(9))), 2)
												+ 1 when estado=formato_R_parte_2 else
												"00";
												
	banco_regs_write_enable					<=	'1' when estado=formato_X else
												(not (instrucao(11) and instrucao(8))) when estado=formato_I_parte_2 else
												(not (instrucao(11) and instrucao(8))) when estado=formato_R_parte_2 else
												'0';
												
	ula_operation_control_selection			<=	'0' when estado=instruction_fetch else
												'0' when estado=instruction_decode else
												'1' when estado=formato_I_parte_1 else
												'1' when estado=formato_R_parte_1 else
												'0';
												
	ula_operation_control					<=	"000" when estado=instruction_fetch else
												"000" when estado=instruction_decode else
												"000";
												
	ula_out_reg_write_enable				<=	'1' when estado=instruction_decode else
												'1' when estado=formato_I_parte_1 else
												'1' when estado=formato_R_parte_1 else
												'0';
												
	pc_input_selection						<=	"00" when estado=instruction_fetch else
												(not instrucao(5)) & '1' when estado=formato_J_parte_1 else
												"00";

	flags_write_enable						<=	(not (instrucao(11) and instrucao(9))) when estado=formato_I_parte_1 and instrucao(17 downto 0)/="000000000000000000" else
												(not (instrucao(11) and instrucao(9))) when estado=formato_R_parte_1 and instrucao(17 downto 0)/="000000000000000000" else
												'0';
end architecture;