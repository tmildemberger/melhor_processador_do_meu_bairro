library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------------------------------------
entity ram is
    port(
        clock : in std_logic;
        endereco : in unsigned(6 downto 0);
        write_enable : in std_logic;
        dado_in : in unsigned(15 downto 0);
        dado_out : out unsigned(15 downto 0)
    );
end entity;
------------------------------------------------------------------------
architecture a_ram of ram is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    signal conteudo_ram : mem;
begin
    process(clk,wr_en)
    begin
        if rising_edge(clk) then
            if wr_en='1' then
                conteudo_ram(to_integer(endereco)) <= dado_in;
            end if;
        end if;
    end process;

    dado_out <= conteudo_ram(to_integer(endereco));
end architecture;