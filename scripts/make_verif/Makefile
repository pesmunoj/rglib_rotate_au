#------------------------------------------------------------------------
# Папка проекта
#------------------------------------------------------------------------
PROJECT_DIR = $(realpath  ./../..)
#------------------------------------------------------------------------
# Путь до Questasim
#------------------------------------------------------------------------
# папка с Questasim Windows
#QUESTASIM_PATH = C:/intelFPGA_pro/21.3/questa_fse/win64
# папка с Questasim Linux

#QUESTASIM_PATH ?= /opt/Questa/questasim/linux_x86_64
QUESTASIM_PATH ?= /opt/eda/mgc/questasim/linux_x86_64
#------------------------------------------------------------------------
# UVM директории с исходниками
#------------------------------------------------------------------------
UVM_HOME = $(dir $(QUESTASIM_PATH))verilog_src/uvm-1.2
UVM_DPI_HOME = $(dir $(QUESTASIM_PATH))uvm-1.2/$(notdir $(QUESTASIM_PATH))

#------------------------------------------------------------------------
# Настройки
#------------------------------------------------------------------------

# Файл с исходниками RTL
RTL_FILE ?= $(PROJECT_DIR)/rtl/lst/src.lst

# Файл с исходниками верификационного окружения
TB_FILE ?= $(PROJECT_DIR)/verif/lst/src.lst

# TOP файл верификационного окружения
TOP_FILE ?= $(PROJECT_DIR)/verif/lst/top.lst

# Файл конфигурации
CONFIG ?= $(shell cat $(PROJECT_DIR)/verif/lst/config.lst)

# Название UVM теста
TEST_NAME ?= $(shell cat $(PROJECT_DIR)/verif/lst/testname.lst)

#------------------------------------------------------------------------
# Рабочие папки
#------------------------------------------------------------------------

# Директория с результатами выполнения скрипта
OUT ?= $(PROJECT_DIR)/out

# Директория с результатами компиляции
COMP ?= $(OUT)/$(CONFIG)/$(TEST_NAME)/compile

# Директория с результатами симуляции
SIM ?= $(OUT)/$(CONFIG)/$(TEST_NAME)/sim

#------------------------------------------------------------------------
# опции для компиляции и симуляции
#------------------------------------------------------------------------

# Опции для компиляции
COMP_OPTS ?= -sv -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUPF \
$(UVM_HOME)/src/uvm_pkg.sv +incdir+$(UVM_HOME)/src/ \
+incdir+$(PROJECT_DIR)/verif/src/uvm/cov/ \
+incdir+$(PROJECT_DIR)/verif/src/uvm/test/ \

# Опции для симуляции
SIM_OPTS ?= -c
#SIM_OPTS +=-sv_lib $(UVM_DPI_HOME)/uvm_dpi -voptargs="+acc" \
#+UVM_TESTNAME=$(TEST_NAME) +UVM_NO_RELNOTES \


#------------------------------------------------------------------------
# Переменные
#------------------------------------------------------------------------

# Список всех файлов исходников RTL
rtl_src = $(shell cat $(RTL_FILE))

# Список всех файлов исходников верификационного окр.
tb_src = $(shell cat $(TB_FILE))

# Топ-модуль
tb_top = $(shell cat $(TOP_FILE))

# Вывод комманд на экран
v = @

#------------------------------------------------------------------------
# Цели
#------------------------------------------------------------------------

# Общий запуск
.PHONY: run 
run: clean $(OUT) $(SIM) $(COMP) compile.stamp sim
	$(v)if grep -rnw $(SIM)/sim.log -e "PASSED">/dev/null; then echo "T-E-S-T  P-A-S-S-E-D"; else echo "T-E-S-T   F-A-I-L-E-D"; fi
	$(v)rm -rf *.log *.stamp *.ini

# Симуляция
sim: compile.stamp | $(SIM)
	@echo "Simulation $(notdir $(PROJECT_DIR)) (log file at $(notdir $(SIM))/sim.log) ..."
	$(v)$(QUESTASIM_PATH)/vsim work.$(tb_top) -do "run -all; quit" $(SIM_OPTS) \
	-sv_lib $(UVM_DPI_HOME)/uvm_dpi -voptargs="+acc" +UVM_TESTNAME=$(TEST_NAME) +UVM_NO_RELNOTES \
        -l $(SIM)/sim.log -wlf $(SIM)/sim.wlf > $(SIM)/sim.log
	

# Компиляция
compile.stamp: $(COMP)
	$(v)echo "Compilation $(notdir $(PROJECT_DIR)) (log file at $(notdir $(COMP))/compile.log) ..."
	$(v)$(QUESTASIM_PATH)/vlib $(COMP)/work > $(COMP)/compile.log
	$(v)$(QUESTASIM_PATH)/vmap work $(COMP)/work >> $(COMP)/compile.log
	$(v)$(QUESTASIM_PATH)/vlog -sv $(COMP_OPTS) -work work $(rtl_src) $(tb_src) >> $(COMP)/compile.log
	@touch $@

# Директория для результатов симуляции
$(SIM): | $(OUT)
	@mkdir -p $@

# Директория для результатов компиляции
$(COMP): | $(OUT)
	@mkdir -p $@

# Директория результатов
$(OUT):
	@mkdir -p $@

# Очистка дирекетории OUT
clean:
	@echo "Removing $(OUT) ..."
	$(v)rm -rf $(OUT)git
	$(v)rm -rf *.log *.stamp *.ini