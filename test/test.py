import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles
import random
from cocotb.result import TestFailure

clocks_per_phase = 10

async def reset(dut):
    dut.rst_n.value   = 1
    dut.rst_n.value   = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1;
    await ClockCycles(dut.clk, 5) # how long to wait for the debouncers to clear

@cocotb.test()
async def test_all(dut):

    clock = Clock(dut.clk, 10, units="ns")
    
    #dut.VGND.value = 0
    #dut.VPWR.value = 1
    dut.ena.value=0
    dut.uio_in[0].value=0
    dut.uio_in[1].value=0
    dut.uio_in[2].value=0
    dut.uio_in[3].value=0
    dut.uio_in[4].value=0            
    dut.uio_in[5].value=0
    dut.uio_in[6].value=0
    dut.uio_in[7].value=0
    
    dut.uio_out[0].value=0
    dut.uio_out[1].value=0
    dut.uio_out[2].value=0
    dut.uio_out[3].value=0
    dut.uio_out[4].value=0            
    dut.uio_out[5].value=0
    dut.uio_out[6].value=0
    dut.uio_out[7].value=0
    
    dut.uio_oe[0].value=0
    dut.uio_oe[1].value=0
    dut.uio_oe[2].value=0
    dut.uio_oe[3].value=0
    dut.uio_oe[4].value=0            
    dut.uio_oe[5].value=0
    dut.uio_oe[6].value=0
    dut.uio_oe[7].value=0

    dut.ui_in[0].value=0
    dut.ui_in[1].value=0
    dut.ui_in[2].value=0
    dut.ui_in[3].value=0
    dut.ui_in[4].value=0            
    dut.ui_in[5].value=0
    dut.ui_in[6].value=0
    dut.ui_in[7].value=0
         
                
    cocotb.start_soon(clock.start())
    
    await ClockCycles(dut.clk,5)
    # Reset the DUT
    dut.rst_n.value = 0
    await ClockCycles(dut.clk,5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk,50)

    dut.ui_in.value = 0xAA

    # Wait for less than the timeout period
    await ClockCycles(dut.clk,80000)
    assert dut.uo_out[0].value == 0
    assert dut.uo_out[1].value == 0
    assert dut.uo_out[2].value == 0

    dut.ui_in.value = 0xBB
      
    await ClockCycles(dut.clk,120000)
    assert dut.uo_out[0].value == 1
    assert dut.uo_out[1].value == 1
    assert dut.uo_out[2].value == 1   
    
