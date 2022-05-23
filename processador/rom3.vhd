library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom3 is
	port( 	clock				: in std_logic;
			endereco			: in unsigned(6 downto 0);
			dado				: out unsigned(17 downto 0)
	);
end entity;

architecture a_rom3 of rom3 is
	type mem is array(0 to 127) of unsigned(17 downto 0);
	constant conteudo_rom : mem := (-- END. - INSTRUCAO
		0  => "101100101000000011",	-- 0x00 - MOV  R3, R0
		1  => "000000101000000100",	-- 0x01 - MOV  R4, #0x000
		2  => "101100000000011100",	-- 0x02 - ADD  R4, R3
		3  => "000000000000001011",	-- 0x03 - ADD  R3, #0x001
		4  => "000000100111110011",	-- 0x04 - CMP  R3, #0x01e
		5  => "101011111100101000",	-- 0x05 - JMPR ULT, #0xfc (-4)
		6  => "101100101000100101", -- 0x06 - MOV R5, R4
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
		20 => "000000000000000000",
		21 => "000000000000000000",
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