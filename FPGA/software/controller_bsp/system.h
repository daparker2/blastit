/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2_qsys_0' in SOPC Builder design 'controller'
 * SOPC Builder design path: C:/github/blastit/FPGA/controller.sopcinfo
 *
 * Generated: Tue Jul 10 21:13:32 PDT 2018
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_qsys"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00001820
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0xe
#define ALT_CPU_DCACHE_LINE_SIZE 32
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_DCACHE_SIZE 2048
#define ALT_CPU_EXCEPTION_ADDR 0x00000020
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 4096
#define ALT_CPU_INITDA_SUPPORTED
#define ALT_CPU_INST_ADDR_WIDTH 0xe
#define ALT_CPU_NAME "nios2_qsys_0"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_RESET_ADDR 0x00000000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00001820
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0xe
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_SIZE 2048
#define NIOS2_EXCEPTION_ADDR 0x00000020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_INITDA_SUPPORTED
#define NIOS2_INST_ADDR_WIDTH 0xe
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_RESET_ADDR 0x00000000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_NIOS2_QSYS


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone III"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart_0"
#define ALT_STDERR_BASE 0x2138
#define ALT_STDERR_DEV jtag_uart_0
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart_0"
#define ALT_STDIN_BASE 0x2138
#define ALT_STDIN_DEV jtag_uart_0
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart_0"
#define ALT_STDOUT_BASE 0x2138
#define ALT_STDOUT_DEV jtag_uart_0
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "controller"


/*
 * afr configuration
 *
 */

#define AFR_BASE 0x2030
#define AFR_BIT_CLEARING_EDGE_REGISTER 0
#define AFR_BIT_MODIFYING_OUTPUT_REGISTER 0
#define AFR_CAPTURE 0
#define AFR_DATA_WIDTH 12
#define AFR_DO_TEST_BENCH_WIRING 0
#define AFR_DRIVEN_SIM_VALUE 0
#define AFR_EDGE_TYPE "NONE"
#define AFR_FREQ 50000000
#define AFR_HAS_IN 0
#define AFR_HAS_OUT 1
#define AFR_HAS_TRI 0
#define AFR_IRQ -1
#define AFR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define AFR_IRQ_TYPE "NONE"
#define AFR_NAME "/dev/afr"
#define AFR_RESET_VALUE 0
#define AFR_SPAN 16
#define AFR_TYPE "altera_avalon_pio"
#define ALT_MODULE_CLASS_afr altera_avalon_pio


/*
 * afr_wrn configuration
 *
 */

#define AFR_WRN_BASE 0x2060
#define AFR_WRN_BIT_CLEARING_EDGE_REGISTER 0
#define AFR_WRN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define AFR_WRN_CAPTURE 0
#define AFR_WRN_DATA_WIDTH 1
#define AFR_WRN_DO_TEST_BENCH_WIRING 0
#define AFR_WRN_DRIVEN_SIM_VALUE 0
#define AFR_WRN_EDGE_TYPE "NONE"
#define AFR_WRN_FREQ 50000000
#define AFR_WRN_HAS_IN 0
#define AFR_WRN_HAS_OUT 1
#define AFR_WRN_HAS_TRI 0
#define AFR_WRN_IRQ -1
#define AFR_WRN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define AFR_WRN_IRQ_TYPE "NONE"
#define AFR_WRN_NAME "/dev/afr_wrn"
#define AFR_WRN_RESET_VALUE 0
#define AFR_WRN_SPAN 16
#define AFR_WRN_TYPE "altera_avalon_pio"
#define ALT_MODULE_CLASS_afr_wrn altera_avalon_pio


/*
 * boost configuration
 *
 */

#define ALT_MODULE_CLASS_boost altera_avalon_pio
#define BOOST_BASE 0x2040
#define BOOST_BIT_CLEARING_EDGE_REGISTER 0
#define BOOST_BIT_MODIFYING_OUTPUT_REGISTER 0
#define BOOST_CAPTURE 0
#define BOOST_DATA_WIDTH 12
#define BOOST_DO_TEST_BENCH_WIRING 0
#define BOOST_DRIVEN_SIM_VALUE 0
#define BOOST_EDGE_TYPE "NONE"
#define BOOST_FREQ 50000000
#define BOOST_HAS_IN 0
#define BOOST_HAS_OUT 1
#define BOOST_HAS_TRI 0
#define BOOST_IRQ -1
#define BOOST_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BOOST_IRQ_TYPE "NONE"
#define BOOST_NAME "/dev/boost"
#define BOOST_RESET_VALUE 0
#define BOOST_SPAN 16
#define BOOST_TYPE "altera_avalon_pio"


/*
 * boost_wrn configuration
 *
 */

#define ALT_MODULE_CLASS_boost_wrn altera_avalon_pio
#define BOOST_WRN_BASE 0x2070
#define BOOST_WRN_BIT_CLEARING_EDGE_REGISTER 0
#define BOOST_WRN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define BOOST_WRN_CAPTURE 0
#define BOOST_WRN_DATA_WIDTH 1
#define BOOST_WRN_DO_TEST_BENCH_WIRING 0
#define BOOST_WRN_DRIVEN_SIM_VALUE 0
#define BOOST_WRN_EDGE_TYPE "NONE"
#define BOOST_WRN_FREQ 50000000
#define BOOST_WRN_HAS_IN 0
#define BOOST_WRN_HAS_OUT 1
#define BOOST_WRN_HAS_TRI 0
#define BOOST_WRN_IRQ -1
#define BOOST_WRN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BOOST_WRN_IRQ_TYPE "NONE"
#define BOOST_WRN_NAME "/dev/boost_wrn"
#define BOOST_WRN_RESET_VALUE 0
#define BOOST_WRN_SPAN 16
#define BOOST_WRN_TYPE "altera_avalon_pio"


/*
 * command_rx configuration
 *
 */

#define ALT_MODULE_CLASS_command_rx altera_avalon_pio
#define COMMAND_RX_BASE 0x2100
#define COMMAND_RX_BIT_CLEARING_EDGE_REGISTER 0
#define COMMAND_RX_BIT_MODIFYING_OUTPUT_REGISTER 0
#define COMMAND_RX_CAPTURE 0
#define COMMAND_RX_DATA_WIDTH 8
#define COMMAND_RX_DO_TEST_BENCH_WIRING 0
#define COMMAND_RX_DRIVEN_SIM_VALUE 0
#define COMMAND_RX_EDGE_TYPE "NONE"
#define COMMAND_RX_FREQ 50000000
#define COMMAND_RX_HAS_IN 1
#define COMMAND_RX_HAS_OUT 0
#define COMMAND_RX_HAS_TRI 0
#define COMMAND_RX_IRQ -1
#define COMMAND_RX_IRQ_INTERRUPT_CONTROLLER_ID -1
#define COMMAND_RX_IRQ_TYPE "NONE"
#define COMMAND_RX_NAME "/dev/command_rx"
#define COMMAND_RX_RESET_VALUE 0
#define COMMAND_RX_SPAN 16
#define COMMAND_RX_TYPE "altera_avalon_pio"


/*
 * command_rx_en configuration
 *
 */

#define ALT_MODULE_CLASS_command_rx_en altera_avalon_pio
#define COMMAND_RX_EN_BASE 0x2080
#define COMMAND_RX_EN_BIT_CLEARING_EDGE_REGISTER 0
#define COMMAND_RX_EN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define COMMAND_RX_EN_CAPTURE 0
#define COMMAND_RX_EN_DATA_WIDTH 1
#define COMMAND_RX_EN_DO_TEST_BENCH_WIRING 0
#define COMMAND_RX_EN_DRIVEN_SIM_VALUE 0
#define COMMAND_RX_EN_EDGE_TYPE "NONE"
#define COMMAND_RX_EN_FREQ 50000000
#define COMMAND_RX_EN_HAS_IN 0
#define COMMAND_RX_EN_HAS_OUT 1
#define COMMAND_RX_EN_HAS_TRI 0
#define COMMAND_RX_EN_IRQ -1
#define COMMAND_RX_EN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define COMMAND_RX_EN_IRQ_TYPE "NONE"
#define COMMAND_RX_EN_NAME "/dev/command_rx_en"
#define COMMAND_RX_EN_RESET_VALUE 0
#define COMMAND_RX_EN_SPAN 16
#define COMMAND_RX_EN_TYPE "altera_avalon_pio"


/*
 * command_status configuration
 *
 */

#define ALT_MODULE_CLASS_command_status altera_avalon_pio
#define COMMAND_STATUS_BASE 0x20f0
#define COMMAND_STATUS_BIT_CLEARING_EDGE_REGISTER 0
#define COMMAND_STATUS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define COMMAND_STATUS_CAPTURE 0
#define COMMAND_STATUS_DATA_WIDTH 8
#define COMMAND_STATUS_DO_TEST_BENCH_WIRING 0
#define COMMAND_STATUS_DRIVEN_SIM_VALUE 0
#define COMMAND_STATUS_EDGE_TYPE "NONE"
#define COMMAND_STATUS_FREQ 50000000
#define COMMAND_STATUS_HAS_IN 1
#define COMMAND_STATUS_HAS_OUT 0
#define COMMAND_STATUS_HAS_TRI 0
#define COMMAND_STATUS_IRQ -1
#define COMMAND_STATUS_IRQ_INTERRUPT_CONTROLLER_ID -1
#define COMMAND_STATUS_IRQ_TYPE "NONE"
#define COMMAND_STATUS_NAME "/dev/command_status"
#define COMMAND_STATUS_RESET_VALUE 0
#define COMMAND_STATUS_SPAN 16
#define COMMAND_STATUS_TYPE "altera_avalon_pio"


/*
 * command_tx configuration
 *
 */

#define ALT_MODULE_CLASS_command_tx altera_avalon_pio
#define COMMAND_TX_BASE 0x2110
#define COMMAND_TX_BIT_CLEARING_EDGE_REGISTER 0
#define COMMAND_TX_BIT_MODIFYING_OUTPUT_REGISTER 0
#define COMMAND_TX_CAPTURE 0
#define COMMAND_TX_DATA_WIDTH 8
#define COMMAND_TX_DO_TEST_BENCH_WIRING 0
#define COMMAND_TX_DRIVEN_SIM_VALUE 0
#define COMMAND_TX_EDGE_TYPE "NONE"
#define COMMAND_TX_FREQ 50000000
#define COMMAND_TX_HAS_IN 0
#define COMMAND_TX_HAS_OUT 1
#define COMMAND_TX_HAS_TRI 0
#define COMMAND_TX_IRQ -1
#define COMMAND_TX_IRQ_INTERRUPT_CONTROLLER_ID -1
#define COMMAND_TX_IRQ_TYPE "NONE"
#define COMMAND_TX_NAME "/dev/command_tx"
#define COMMAND_TX_RESET_VALUE 0
#define COMMAND_TX_SPAN 16
#define COMMAND_TX_TYPE "altera_avalon_pio"


/*
 * command_tx_en configuration
 *
 */

#define ALT_MODULE_CLASS_command_tx_en altera_avalon_pio
#define COMMAND_TX_EN_BASE 0x2090
#define COMMAND_TX_EN_BIT_CLEARING_EDGE_REGISTER 0
#define COMMAND_TX_EN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define COMMAND_TX_EN_CAPTURE 0
#define COMMAND_TX_EN_DATA_WIDTH 1
#define COMMAND_TX_EN_DO_TEST_BENCH_WIRING 0
#define COMMAND_TX_EN_DRIVEN_SIM_VALUE 0
#define COMMAND_TX_EN_EDGE_TYPE "NONE"
#define COMMAND_TX_EN_FREQ 50000000
#define COMMAND_TX_EN_HAS_IN 0
#define COMMAND_TX_EN_HAS_OUT 1
#define COMMAND_TX_EN_HAS_TRI 0
#define COMMAND_TX_EN_IRQ -1
#define COMMAND_TX_EN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define COMMAND_TX_EN_IRQ_TYPE "NONE"
#define COMMAND_TX_EN_NAME "/dev/command_tx_en"
#define COMMAND_TX_EN_RESET_VALUE 0
#define COMMAND_TX_EN_SPAN 16
#define COMMAND_TX_EN_TYPE "altera_avalon_pio"


/*
 * conn configuration
 *
 */

#define ALT_MODULE_CLASS_conn altera_avalon_pio
#define CONN_BASE 0x20b0
#define CONN_BIT_CLEARING_EDGE_REGISTER 0
#define CONN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define CONN_CAPTURE 0
#define CONN_DATA_WIDTH 1
#define CONN_DO_TEST_BENCH_WIRING 0
#define CONN_DRIVEN_SIM_VALUE 0
#define CONN_EDGE_TYPE "NONE"
#define CONN_FREQ 50000000
#define CONN_HAS_IN 0
#define CONN_HAS_OUT 1
#define CONN_HAS_TRI 0
#define CONN_IRQ -1
#define CONN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CONN_IRQ_TYPE "NONE"
#define CONN_NAME "/dev/conn"
#define CONN_RESET_VALUE 0
#define CONN_SPAN 16
#define CONN_TYPE "altera_avalon_pio"


/*
 * coolant_temp configuration
 *
 */

#define ALT_MODULE_CLASS_coolant_temp altera_avalon_pio
#define COOLANT_TEMP_BASE 0x2010
#define COOLANT_TEMP_BIT_CLEARING_EDGE_REGISTER 0
#define COOLANT_TEMP_BIT_MODIFYING_OUTPUT_REGISTER 0
#define COOLANT_TEMP_CAPTURE 0
#define COOLANT_TEMP_DATA_WIDTH 12
#define COOLANT_TEMP_DO_TEST_BENCH_WIRING 0
#define COOLANT_TEMP_DRIVEN_SIM_VALUE 0
#define COOLANT_TEMP_EDGE_TYPE "NONE"
#define COOLANT_TEMP_FREQ 50000000
#define COOLANT_TEMP_HAS_IN 0
#define COOLANT_TEMP_HAS_OUT 1
#define COOLANT_TEMP_HAS_TRI 0
#define COOLANT_TEMP_IRQ -1
#define COOLANT_TEMP_IRQ_INTERRUPT_CONTROLLER_ID -1
#define COOLANT_TEMP_IRQ_TYPE "NONE"
#define COOLANT_TEMP_NAME "/dev/coolant_temp"
#define COOLANT_TEMP_RESET_VALUE 0
#define COOLANT_TEMP_SPAN 16
#define COOLANT_TEMP_TYPE "altera_avalon_pio"


/*
 * daylight configuration
 *
 */

#define ALT_MODULE_CLASS_daylight altera_avalon_pio
#define DAYLIGHT_BASE 0x20c0
#define DAYLIGHT_BIT_CLEARING_EDGE_REGISTER 0
#define DAYLIGHT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DAYLIGHT_CAPTURE 0
#define DAYLIGHT_DATA_WIDTH 1
#define DAYLIGHT_DO_TEST_BENCH_WIRING 0
#define DAYLIGHT_DRIVEN_SIM_VALUE 0
#define DAYLIGHT_EDGE_TYPE "NONE"
#define DAYLIGHT_FREQ 50000000
#define DAYLIGHT_HAS_IN 1
#define DAYLIGHT_HAS_OUT 0
#define DAYLIGHT_HAS_TRI 0
#define DAYLIGHT_IRQ -1
#define DAYLIGHT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DAYLIGHT_IRQ_TYPE "NONE"
#define DAYLIGHT_NAME "/dev/daylight"
#define DAYLIGHT_RESET_VALUE 0
#define DAYLIGHT_SPAN 16
#define DAYLIGHT_TYPE "altera_avalon_pio"


/*
 * disp_brightness configuration
 *
 */

#define ALT_MODULE_CLASS_disp_brightness altera_avalon_pio
#define DISP_BRIGHTNESS_BASE 0x20d0
#define DISP_BRIGHTNESS_BIT_CLEARING_EDGE_REGISTER 0
#define DISP_BRIGHTNESS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DISP_BRIGHTNESS_CAPTURE 0
#define DISP_BRIGHTNESS_DATA_WIDTH 8
#define DISP_BRIGHTNESS_DO_TEST_BENCH_WIRING 0
#define DISP_BRIGHTNESS_DRIVEN_SIM_VALUE 0
#define DISP_BRIGHTNESS_EDGE_TYPE "NONE"
#define DISP_BRIGHTNESS_FREQ 50000000
#define DISP_BRIGHTNESS_HAS_IN 0
#define DISP_BRIGHTNESS_HAS_OUT 1
#define DISP_BRIGHTNESS_HAS_TRI 0
#define DISP_BRIGHTNESS_IRQ -1
#define DISP_BRIGHTNESS_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DISP_BRIGHTNESS_IRQ_TYPE "NONE"
#define DISP_BRIGHTNESS_NAME "/dev/disp_brightness"
#define DISP_BRIGHTNESS_RESET_VALUE 0
#define DISP_BRIGHTNESS_SPAN 16
#define DISP_BRIGHTNESS_TYPE "altera_avalon_pio"


/*
 * disp_en configuration
 *
 */

#define ALT_MODULE_CLASS_disp_en altera_avalon_pio
#define DISP_EN_BASE 0x20e0
#define DISP_EN_BIT_CLEARING_EDGE_REGISTER 0
#define DISP_EN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DISP_EN_CAPTURE 0
#define DISP_EN_DATA_WIDTH 1
#define DISP_EN_DO_TEST_BENCH_WIRING 0
#define DISP_EN_DRIVEN_SIM_VALUE 0
#define DISP_EN_EDGE_TYPE "NONE"
#define DISP_EN_FREQ 50000000
#define DISP_EN_HAS_IN 0
#define DISP_EN_HAS_OUT 1
#define DISP_EN_HAS_TRI 0
#define DISP_EN_IRQ -1
#define DISP_EN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DISP_EN_IRQ_TYPE "NONE"
#define DISP_EN_NAME "/dev/disp_en"
#define DISP_EN_RESET_VALUE 0
#define DISP_EN_SPAN 16
#define DISP_EN_TYPE "altera_avalon_pio"


/*
 * dram configuration
 *
 */

#define ALT_MODULE_CLASS_dram altera_avalon_onchip_memory2
#define DRAM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define DRAM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define DRAM_BASE 0x1000
#define DRAM_CONTENTS_INFO ""
#define DRAM_DUAL_PORT 0
#define DRAM_GUI_RAM_BLOCK_TYPE "AUTO"
#define DRAM_INIT_CONTENTS_FILE "controller_dram"
#define DRAM_INIT_MEM_CONTENT 1
#define DRAM_INSTANCE_ID "NONE"
#define DRAM_IRQ -1
#define DRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DRAM_NAME "/dev/dram"
#define DRAM_NON_DEFAULT_INIT_FILE_ENABLED 0
#define DRAM_RAM_BLOCK_TYPE "AUTO"
#define DRAM_READ_DURING_WRITE_MODE "DONT_CARE"
#define DRAM_SINGLE_CLOCK_OP 0
#define DRAM_SIZE_MULTIPLE 1
#define DRAM_SIZE_VALUE 2048
#define DRAM_SPAN 2048
#define DRAM_TYPE "altera_avalon_onchip_memory2"
#define DRAM_WRITABLE 1


/*
 * err configuration
 *
 */

#define ALT_MODULE_CLASS_err altera_avalon_pio
#define ERR_BASE 0x20a0
#define ERR_BIT_CLEARING_EDGE_REGISTER 0
#define ERR_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ERR_CAPTURE 0
#define ERR_DATA_WIDTH 1
#define ERR_DO_TEST_BENCH_WIRING 0
#define ERR_DRIVEN_SIM_VALUE 0
#define ERR_EDGE_TYPE "NONE"
#define ERR_FREQ 50000000
#define ERR_HAS_IN 0
#define ERR_HAS_OUT 1
#define ERR_HAS_TRI 0
#define ERR_IRQ -1
#define ERR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ERR_IRQ_TYPE "NONE"
#define ERR_NAME "/dev/err"
#define ERR_RESET_VALUE 0
#define ERR_SPAN 16
#define ERR_TYPE "altera_avalon_pio"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 4
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * ign configuration
 *
 */

#define ALT_MODULE_CLASS_ign altera_avalon_pio
#define IGN_BASE 0x2120
#define IGN_BIT_CLEARING_EDGE_REGISTER 0
#define IGN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define IGN_CAPTURE 0
#define IGN_DATA_WIDTH 1
#define IGN_DO_TEST_BENCH_WIRING 0
#define IGN_DRIVEN_SIM_VALUE 0
#define IGN_EDGE_TYPE "NONE"
#define IGN_FREQ 50000000
#define IGN_HAS_IN 1
#define IGN_HAS_OUT 0
#define IGN_HAS_TRI 0
#define IGN_IRQ -1
#define IGN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IGN_IRQ_TYPE "NONE"
#define IGN_NAME "/dev/ign"
#define IGN_RESET_VALUE 0
#define IGN_SPAN 16
#define IGN_TYPE "altera_avalon_pio"


/*
 * intake_temp configuration
 *
 */

#define ALT_MODULE_CLASS_intake_temp altera_avalon_pio
#define INTAKE_TEMP_BASE 0x2000
#define INTAKE_TEMP_BIT_CLEARING_EDGE_REGISTER 0
#define INTAKE_TEMP_BIT_MODIFYING_OUTPUT_REGISTER 0
#define INTAKE_TEMP_CAPTURE 0
#define INTAKE_TEMP_DATA_WIDTH 12
#define INTAKE_TEMP_DO_TEST_BENCH_WIRING 0
#define INTAKE_TEMP_DRIVEN_SIM_VALUE 0
#define INTAKE_TEMP_EDGE_TYPE "NONE"
#define INTAKE_TEMP_FREQ 50000000
#define INTAKE_TEMP_HAS_IN 0
#define INTAKE_TEMP_HAS_OUT 1
#define INTAKE_TEMP_HAS_TRI 0
#define INTAKE_TEMP_IRQ -1
#define INTAKE_TEMP_IRQ_INTERRUPT_CONTROLLER_ID -1
#define INTAKE_TEMP_IRQ_TYPE "NONE"
#define INTAKE_TEMP_NAME "/dev/intake_temp"
#define INTAKE_TEMP_RESET_VALUE 0
#define INTAKE_TEMP_SPAN 16
#define INTAKE_TEMP_TYPE "altera_avalon_pio"


/*
 * iram configuration
 *
 */

#define ALT_MODULE_CLASS_iram altera_avalon_onchip_memory2
#define IRAM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define IRAM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define IRAM_BASE 0x0
#define IRAM_CONTENTS_INFO ""
#define IRAM_DUAL_PORT 0
#define IRAM_GUI_RAM_BLOCK_TYPE "AUTO"
#define IRAM_INIT_CONTENTS_FILE "controller_iram"
#define IRAM_INIT_MEM_CONTENT 1
#define IRAM_INSTANCE_ID "NONE"
#define IRAM_IRQ -1
#define IRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IRAM_NAME "/dev/iram"
#define IRAM_NON_DEFAULT_INIT_FILE_ENABLED 0
#define IRAM_RAM_BLOCK_TYPE "AUTO"
#define IRAM_READ_DURING_WRITE_MODE "DONT_CARE"
#define IRAM_SINGLE_CLOCK_OP 0
#define IRAM_SIZE_MULTIPLE 1
#define IRAM_SIZE_VALUE 2048
#define IRAM_SPAN 2048
#define IRAM_TYPE "altera_avalon_onchip_memory2"
#define IRAM_WRITABLE 0


/*
 * jtag_uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart_0 altera_avalon_jtag_uart
#define JTAG_UART_0_BASE 0x2138
#define JTAG_UART_0_IRQ 0
#define JTAG_UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_READ_DEPTH 32
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_WRITE_DEPTH 32
#define JTAG_UART_0_WRITE_THRESHOLD 8


/*
 * oil_temp configuration
 *
 */

#define ALT_MODULE_CLASS_oil_temp altera_avalon_pio
#define OIL_TEMP_BASE 0x2020
#define OIL_TEMP_BIT_CLEARING_EDGE_REGISTER 0
#define OIL_TEMP_BIT_MODIFYING_OUTPUT_REGISTER 0
#define OIL_TEMP_CAPTURE 0
#define OIL_TEMP_DATA_WIDTH 12
#define OIL_TEMP_DO_TEST_BENCH_WIRING 0
#define OIL_TEMP_DRIVEN_SIM_VALUE 0
#define OIL_TEMP_EDGE_TYPE "NONE"
#define OIL_TEMP_FREQ 50000000
#define OIL_TEMP_HAS_IN 0
#define OIL_TEMP_HAS_OUT 1
#define OIL_TEMP_HAS_TRI 0
#define OIL_TEMP_IRQ -1
#define OIL_TEMP_IRQ_INTERRUPT_CONTROLLER_ID -1
#define OIL_TEMP_IRQ_TYPE "NONE"
#define OIL_TEMP_NAME "/dev/oil_temp"
#define OIL_TEMP_RESET_VALUE 0
#define OIL_TEMP_SPAN 16
#define OIL_TEMP_TYPE "altera_avalon_pio"


/*
 * sysid_c001 configuration
 *
 */

#define ALT_MODULE_CLASS_sysid_c001 altera_avalon_sysid_qsys
#define SYSID_C001_BASE 0x2140
#define SYSID_C001_ID 49153
#define SYSID_C001_IRQ -1
#define SYSID_C001_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_C001_NAME "/dev/sysid_c001"
#define SYSID_C001_SPAN 8
#define SYSID_C001_TIMESTAMP 1531282209
#define SYSID_C001_TYPE "altera_avalon_sysid_qsys"


/*
 * wrn configuration
 *
 */

#define ALT_MODULE_CLASS_wrn altera_avalon_pio
#define WRN_BASE 0x2050
#define WRN_BIT_CLEARING_EDGE_REGISTER 0
#define WRN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define WRN_CAPTURE 0
#define WRN_DATA_WIDTH 1
#define WRN_DO_TEST_BENCH_WIRING 0
#define WRN_DRIVEN_SIM_VALUE 0
#define WRN_EDGE_TYPE "NONE"
#define WRN_FREQ 50000000
#define WRN_HAS_IN 0
#define WRN_HAS_OUT 1
#define WRN_HAS_TRI 0
#define WRN_IRQ -1
#define WRN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define WRN_IRQ_TYPE "NONE"
#define WRN_NAME "/dev/wrn"
#define WRN_RESET_VALUE 0
#define WRN_SPAN 16
#define WRN_TYPE "altera_avalon_pio"

#endif /* __SYSTEM_H_ */
