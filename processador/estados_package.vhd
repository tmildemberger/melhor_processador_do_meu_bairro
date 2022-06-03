package estados_package is
	type tipo_estado is (
		instruction_fetch, instruction_decode,
		formato_X,
		formato_I_parte_1, formato_I_parte_2,
		formato_R_parte_1, formato_R_parte_2,
		formato_J_parte_1, formato_J_parte_2,
		formato_M_parte_1, formato_M_parte_2,
		formato_U_parte_1, formato_U_parte_2
	);
end package;