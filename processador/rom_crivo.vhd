library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_crivo is
	port( 	clock				: in std_logic;
			endereco			: in unsigned(6 downto 0);
			dado				: out unsigned(17 downto 0)
	);
end entity;

architecture a_rom_crivo of rom_crivo is
	type mem is array(0 to 127) of unsigned(17 downto 0);
	constant conteudo_rom : mem := (-- END. - INSTRUCAO
		0  => "000000101000001001",	-- 0x00 - MOV R1, #0x001
		1  => "100100000000001001",	-- 0x01 - MOV [R1], R1
		2  => "000000000000001001",	-- 0x02 - ADD R1, #0x001
		3  => "000011100100100001",	-- 0x03 - CMP R1, #0x064
		4  => "101011111100100011",	-- 0x04 - JMPR NE, #0xFC
		5  => "000000101000001010",	-- 0x05 - MOV R2, #0x001
		6  => "000000000000001010", -- 0x06 - ADD R2, #0x001
		7  => "100000000000010011", -- 0x07 - MOV R3, [R2]
		8  => "101100100100010011", -- 0x08 - CMP R3, R2
		9  => "101011111100100011", -- 0x09 - JMPR NE, #0xFC
		10 => "101100101000011100", -- 0x0A - MOV R4, R3
		11 => "101100000000011100", -- 0x0B - ADD R4, R3
		12 => "100100000000100000", -- 0x0C - MOV [R4], R0
		13 => "000011100100100100", -- 0x0D - CMP R4, #0x064
		14 => "101011111100101000", -- 0x0E - JMPR ULT, #0xFC
		15 => "000000100101010011", -- 0x0F - CMP R3, #0x00A
		16 => "101000000110001111", -- 0x10 - JMPA ULE, #0x06
		17 => "000000101000010101", -- 0x11 - MOV R5, #0x002
		18 => "100000000000101110", -- 0x12 - MOV R6, [R5]
		19 => "000000100100000110", -- 0x13 - CMP R6, #0x000
		20 => "101000000001100010",	-- 0x14 - JPMR EQ, #0x01 
		21 => "101100101000110111",	-- 0x15 - MOV R7, R6
		22 => "000000000000001101", -- 0x16 - ADD R5, #0x001
		23 => "000011100100100101", -- 0x17 - CMP R5, #0x064
		24 => "101000010010000011", -- 0x18 - JMPA NE, #0x12
		25 => "101011111111100000", -- 0x19 - JMPR UC, #0xFF
		26 => "000000000000000000", -- 0x1A - NOP
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