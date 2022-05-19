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
	constant conteudo_rom : mem := (-- END. - INSTRUÇÃO
		0  => "000000101000101011",	-- 0x00 - MOV  R3, #0x005
		1  => "000000101001000100",	-- 0x01 - MOV  R4, #0x008
		2  => "101100101000100101",	-- 0x02 - MOV  R5, R4
		3  => "101100000000011101",	-- 0x03 - ADD  R5, R3
		4  => "000000000100001101",	-- 0x04 - SUB  R5, #0x001
		5  => "101000010100000000",	-- 0x05 - JMPA UC, #0x014
		6  => "000000000000000000",
		7  => "000000000000000000",
		8  => "000000000000000000",
		9  => "000000000000000000",
		10 => "000000000000000000",
		11 => "000000000000000000",
		12 => "000000000000000000",
		13 => "000000000000000000",
		14 => "000000000000000000",
		15 => "000000000000000000",
		16 => "000000000000000000",
		17 => "000000000000000000",
		18 => "000000000000000000",
		19 => "000000000000000000",
		20 => "101100101000101011",	-- 0x14 - MOV  R3, R5
		21 => "101000000010000000",	-- 0x15 - JMPA UC, 0x002
		22 => "000000000000000000",
		23 => "000000000000000000",
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