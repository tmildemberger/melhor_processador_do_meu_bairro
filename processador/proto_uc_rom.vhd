library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proto_uc_rom is
	port( 	clock, reset		: in std_logic;
			program_counter_out	: out unsigned(6 downto 0);
			rom_out				: out unsigned(17 downto 0)
	);
end entity;

architecture a_proto_uc_rom of proto_uc_rom is
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
	signal pc_data_out, pc_data_in		: unsigned(6 downto 0) := (others => '0');
begin
	pc : program_counter port map(	clock			=> clock,
									reset			=> reset,
									write_enable	=> '1',
									data_in			=> pc_data_in,
									data_out		=> pc_data_out);

	nossa_rom : rom port map(	clock		=> clock,
								endereco	=> pc_data_out,
								dado		=> rom_out);
	
	pc_data_in			<= pc_data_out + 1;
	
	program_counter_out	<= pc_data_out;
end architecture;