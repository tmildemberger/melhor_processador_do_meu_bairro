library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_de_estados is
	port( 	clock, reset		: in std_logic;
			estado				: out std_logic
	);
end entity;

architecture a_maquina_de_estados of maquina_de_estados is
	signal estado_interno : std_logic := '0';
begin
	process(clock, reset)
	begin
		if reset = '1' then
			estado_interno <= '0';
		elsif rising_edge(clock) then
			estado_interno <= not estado_interno;
		end if;
	end process;
	
	estado <= estado_interno;
end architecture;