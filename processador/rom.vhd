library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port( 	clock				: in std_logic;
			endereco			: in unsigned(6 downto 0);
			dado				: out unsigned(17 downto 0)
	);
end entity;

architecture a_rom of rom is
	type mem is array(0 to 127) of unsigned(17 downto 0);
	constant conteudo_rom : mem := (
		0 => "000000000000000001",
		1 => "000000000000000010",
		2 => "000010000000000100",
		3 => "000000000000001000",
		4 => "000000000000010000",
		5 => "000000000000100000",
		6 => "000000000001000000",
		7 => "000000000010000000",
		others => (others => '0')
	);
	signal dado_interno			: unsigned(17 downto 0) := conteudo_rom(0);
begin
	process(clock)
	begin
		if (rising_edge(clock)) then
			dado_interno <= conteudo_rom(to_integer(endereco));
		end if;
	end process;
	
	dado <= dado_interno;
end architecture;