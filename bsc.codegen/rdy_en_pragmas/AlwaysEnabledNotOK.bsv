interface Test;
  method Action inc;
  method Bit#(32) count;
endinterface

(* always_enabled *)
(* synthesize *)
module mkTest(Test);

  Reg#(Bool) rdy <- mkReg(False);

  Reg#(Bit#(32)) countReg <- mkReg(0);
  
  rule flip;
    rdy <= !rdy;
  endrule

  method Action inc if(rdy);
    countReg <= countReg + 1;
  endmethod

  method count = countReg;

endmodule

(* synthesize *)
module sysAlwaysEnabledNotOK();

  Reg#(Bit#(32)) cycle <- mkReg(0);

  Test dut <- mkTest;

  rule test;
    $display("Cycle: %0d, Count: %0d", cycle, dut.count);
    dut.inc;
    if(cycle == 20) $finish(0);
    cycle <= cycle + 1;
  endrule

endmodule


