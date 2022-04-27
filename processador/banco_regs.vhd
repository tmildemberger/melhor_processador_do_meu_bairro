library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is
	port(	clock 			: in std_logic;
			reset 			: in std_logic;
			write_enable	: in std_logic;
			read_register_1	: in unsigned(2 downto 0);
			read_register_2	: in unsigned(2 downto 0);
			write_register	: in unsigned(2 downto 0);
			write_data 		: in unsigned(15 downto 0);
			read_data_1		: out unsigned(15 downto 0);
			read_data_2		: out unsigned(15 downto 0)
	);
end entity;

architecture a_banco_regs of banco_regs is
	component reg16bits
		port(	clock 			: in std_logic;
				reset 			: in std_logic;
				write_enable	: in std_logic;
				data_in 		: in unsigned(15 downto 0);
				data_out 		: out unsigned(15 downto 0)
		);
	end component;
	signal out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7	: unsigned(15 downto 0);
	signal        wre_1, wre_2, wre_3, wre_4, wre_5, wre_6, wre_7	: std_logic;
begin
	r0 : reg16bits port map(	clock 			=> clock,
								reset 			=> reset,
								write_enable 	=> '0',
								data_in			=> write_data,
								data_out		=> out_0);
	
	r1 : reg16bits port map(	clock 			=> clock,
								reset 			=> reset,
								write_enable 	=> wre_1,
								data_in			=> write_data,
								data_out		=> out_1);
	
	r2 : reg16bits port map(	clock 			=> clock,
								reset 			=> reset,
								write_enable 	=> wre_2,
								data_in			=> write_data,
								data_out		=> out_2);
	
	r3 : reg16bits port map(	clock 			=> clock,
								reset 			=> reset,
								write_enable 	=> wre_3,
								data_in			=> write_data,
								data_out		=> out_3);
	
	r4 : reg16bits port map(	clock 			=> clock,
								reset 			=> reset,
								write_enable 	=> wre_4,
								data_in			=> write_data,
								data_out		=> out_4);
	
	r5 : reg16bits port map(	clock 			=> clock,
								reset 			=> reset,
								write_enable 	=> wre_5,
								data_in			=> write_data,
								data_out		=> out_5);
	
	r6 : reg16bits port map(	clock 			=> clock,
								reset 			=> reset,
								write_enable 	=> wre_6,
								data_in			=> write_data,
								data_out		=> out_6);
	
	r7 : reg16bits port map(	clock 			=> clock,
								reset 			=> reset,
								write_enable 	=> wre_7,
								data_in			=> write_data,
								data_out		=> out_7);
	
	read_data_1		<=  out_0 when read_register_1="000" else
						out_1 when read_register_1="001" else
						out_2 when read_register_1="010" else
						out_3 when read_register_1="011" else
						out_4 when read_register_1="100" else
						out_5 when read_register_1="101" else
						out_6 when read_register_1="110" else
						out_7 when read_register_1="111" else
						"0000000000000000";
	
	read_data_2		<=  out_0 when read_register_2="000" else
						out_1 when read_register_2="001" else
						out_2 when read_register_2="010" else
						out_3 when read_register_2="011" else
						out_4 when read_register_2="100" else
						out_5 when read_register_2="101" else
						out_6 when read_register_2="110" else
						out_7 when read_register_2="111" else
						"0000000000000000";
	
	wre_1			<=	'1' when write_enable='1' and write_register="001" else '0';
	wre_2			<=	'1' when write_enable='1' and write_register="010" else '0';
	wre_3			<=	'1' when write_enable='1' and write_register="011" else '0';
	wre_4			<=	'1' when write_enable='1' and write_register="100" else '0';
	wre_5			<=	'1' when write_enable='1' and write_register="101" else '0';
	wre_6			<=	'1' when write_enable='1' and write_register="110" else '0';
	wre_7			<=	'1' when write_enable='1' and write_register="111" else '0';
end architecture;