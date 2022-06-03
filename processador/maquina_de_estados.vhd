library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.estados_package.all;

entity maquina_de_estados is
	port( 	clock, reset		: in std_logic;
			instrucao			: in unsigned(17 downto 0);
			condicao_ok			: in std_logic;
			estado				: out tipo_estado
	);
end entity;

architecture a_maquina_de_estados of maquina_de_estados is
	signal estado_interno : tipo_estado := instruction_fetch;
begin
	process(clock, reset)
	begin
		if reset = '1' then
			estado_interno <= instruction_fetch;
		elsif rising_edge(clock) then
			case estado_interno is
				when instruction_fetch =>
					estado_interno <= instruction_decode;
				when instruction_decode =>
					if instrucao(17 downto 16)="11" then
						estado_interno <= formato_X;
					elsif instrucao(17)='0' then
						estado_interno <= formato_I_parte_1;
					elsif instrucao(17 downto 13)="10110" then
						estado_interno <= formato_R_parte_1;
					elsif instrucao(17 downto 14)="1010" and condicao_ok='1' then
						estado_interno <= formato_J_parte_1;
					elsif instrucao(17 downto 15)="100" then
						estado_interno <= formato_M_parte_1;
					elsif instrucao(17 downto 13)="10111" then
						estado_interno <= formato_U_parte_1;
					else
						estado_interno <= instruction_fetch;
					end if;
				when formato_X =>
					estado_interno <= instruction_fetch;
				when formato_I_parte_1 =>
					estado_interno <= formato_I_parte_2;
				when formato_I_parte_2 =>
					estado_interno <= instruction_fetch;
				when formato_R_parte_1 =>
					estado_interno <= formato_R_parte_2;
				when formato_R_parte_2 =>
					estado_interno <= instruction_fetch;
				when formato_J_parte_1 =>
					estado_interno <= formato_J_parte_2;
				when formato_J_parte_2 =>
					estado_interno <= instruction_fetch;
				when formato_M_parte_1 =>
					estado_interno <= formato_M_parte_2;
				when formato_M_parte_2 =>
					estado_interno <= instruction_fetch;
				when formato_U_parte_1 =>
					estado_interno <= formato_U_parte_2;
				when formato_U_parte_2 =>
					estado_interno <= instruction_fetch;
				when others =>
					null;
			end case;
		end if;
	end process;
	
	estado <= estado_interno;
end architecture;