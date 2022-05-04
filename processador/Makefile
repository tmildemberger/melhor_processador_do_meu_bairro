ifeq ($(OS),Windows_NT)
	RM = del
	quiet_fork = (start /b $(1) >NUL 2>&1)
else
	RM = rm -f
	quiet_fork = ($(1) >/dev/null 2>&1 &)
endif

INPUTS := ula reg16bits banco_regs ula_com_banco_regs rom maquina_de_estados program_counter proto_uc proto_uc_rom uc_com_jump

.DELETE_ON_ERROR:

.PHONY: all
all: $(INPUTS:%=%_tb.ghw)

work-obj93.cf: $(INPUTS:%=%.vhd) $(INPUTS:%=%_tb.vhd)
	ghdl -a $^

.PHONY: $(INPUTS:%=sim-%)
$(INPUTS:%=sim-%): sim-%: %_tb.ghw
	@$(call quiet_fork, gtkwave $< $(<:.ghw=.gtkw) --rcfile gtkwaverc)

$(INPUTS:%=%_tb.ghw): %_tb.ghw: work-obj93.cf
	ghdl -r $(@:.ghw=) --wave=$@

.PHONY: clean
clean:
	$(RM) work-obj93.cf
