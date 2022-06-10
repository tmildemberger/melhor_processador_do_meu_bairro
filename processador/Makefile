ifeq ($(OS),Windows_NT)
	RM = del
	quiet_fork = (start /b $(1) >NUL 2>&1)
else
	RM = rm -f
	quiet_fork = ($(1) >/dev/null 2>&1 &)
endif

INPUTS := ula reg16bits banco_regs ula_com_banco_regs rom maquina_de_estados program_counter proto_uc proto_uc_rom uc_com_jump rom2 instruction_register unidade_de_controle processador reg_flags rom3 rom_novos_formatos stack_pointer ram rom_heap_sort
PRE_INPUTS := estados_package

.DELETE_ON_ERROR:

.PHONY: sim-top-level
sim-top-level: sim-processador

.PHONY: all
all: $(INPUTS:%=%_tb.ghw)

.PHONY: pre_inputs
pre_inputs: $(PRE_INPUTS:%=%.vhd)
	ghdl -a $^

work-obj93.cf: pre_inputs $(INPUTS:%=%.vhd) $(INPUTS:%=%_tb.vhd)
	ghdl -a $(^:pre_inputs=)

.PHONY: $(INPUTS:%=sim-%)
$(INPUTS:%=sim-%): sim-%: %_tb.ghw
	@$(call quiet_fork, gtkwave $< $(<:.ghw=.gtkw) --rcfile gtkwaverc)

$(INPUTS:%=%_tb.ghw): %_tb.ghw: work-obj93.cf
	ghdl -r $(@:.ghw=) --wave=$@ --ieee-asserts=disable-at-0

.PHONY: clean
clean:
	$(RM) work-obj93.cf
