library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_com_jump is
	port( 	clock, reset		: in std_logic;
			estado_atual		: out std_logic;
			program_counter_out	: out unsigned(6 downto 0);
			rom_out				: out unsigned(17 downto 0)
	);
end entity;

architecture a_uc_com_jump of uc_com_jump is
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
	component maquina_de_estados
		port( 	clock, reset		: in std_logic;
				estado				: out std_logic
		);
	end component;
	signal estado, pc_write_enable		: std_logic				:= '0';
	signal pc_data_out, pc_data_in		: unsigned(6 downto 0)	:= (others => '0');
	signal instrucao					: unsigned(17 downto 0)	:= (others => '0');
	
	signal opcode						: unsigned(4 downto 0)	:= (others => '0');
	signal endereco_do_salto			: unsigned(6 downto 0)	:= (others => '0');
begin
	maq_estados : maquina_de_estados port map(	clock 	=> clock,
												reset	=> reset,
												estado  => estado);

	uc_rom : rom port map(	clock 	 => clock,
							endereco => pc_data_out,
							dado	 => instrucao);

	pc : program_counter port map(	clock		 => clock,
									reset		 => reset,
									write_enable => pc_write_enable,
									data_in		 => pc_data_in,
									data_out	 => pc_data_out);


	opcode 				<= 	instrucao(17 downto 13);
	endereco_do_salto 	<=	instrucao(6 downto 0);
	
	-- opcode do jump é 00001, opcode do nop é "00000" (ignorado por enquanto)
	pc_data_in 			<= 	endereco_do_salto when opcode="00001" else
							pc_data_out + 1;

	pc_write_enable		<= 	estado;

	estado_atual 		<= 	estado;
	program_counter_out <= 	pc_data_out;
	rom_out 			<= 	instrucao;
end architecture;