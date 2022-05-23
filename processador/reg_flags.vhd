library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_flags is
	port(	clock 			: in std_logic;
			reset 			: in std_logic;
			write_enable	: in std_logic;
			data_in 		: in unsigned(3 downto 0);
			data_out 		: out unsigned(3 downto 0)
	);
end entity;

architecture a_reg_flags of reg_flags is
	signal valor_armazenado	: unsigned(3 downto 0);
begin
	
	process(clock, reset, write_enable)
	begin
		if reset='1' then
			valor_armazenado <= "0000";
		elsif write_enable='1' then
			if rising_edge(clock) then
				valor_armazenado <= data_in;
			end if;
		end if;
	end process;
	
	data_out <= valor_armazenado;
end architecture;