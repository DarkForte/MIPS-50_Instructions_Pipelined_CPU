
module mini_machine(sys_clk, sys_rst, din, dout1, dout2, sel1, sel2);
    input sys_clk;
	input sys_rst;
	input [31:0] din;
	output [7:0] dout1;
	output [7:0] dout2;
	output [4:1] sel1;
	output [4:1] sel2;
	
	wire clk;
	wire rst;
	//clk_50to10 u_clk_changer(sys_clk, clk);
	assign clk = sys_clk;
	
	assign rst = ~sys_rst;
	wire [31:2] CPUAddr;
	wire [3:0] BE;
	wire [31:0] CPUIn;
	wire [31:0] CPUOut;
	wire IOWe;
	wire clk_out;
	wire [7:2] HardInt_in;
	mips U_MIPS(clk, rst, CPUAddr, BE, CPUIn, CPUOut, IOWe, clk_out, HardInt_in);
	
	wire [31:2] CPU_addr;
	wire [31:0] CPU_din;
	wire CPUWe;
	wire [3:0] CPU_be;
	wire [31:0] CPU_dout;
	wire [31:0] deviceCounter_din;
	wire [31:0] deviceSwitch_din;
	wire [3:2] device_addr;
	wire [31:0] device_dout;
	wire weCounter;
	wire weNumber;
	wire [3:0] device_BE;
	Bridge U_BRIDGE(CPU_addr, CPU_din, CPUWe, CPU_be, CPU_dout, deviceCounter_din, deviceSwitch_din, device_addr, device_dout, weCounter, weNumber, device_BE);
	
	wire CLK_I, RST_I;
	wire [3:2] ADD_I;
	wire WE_I;
	wire [31:0] DAT_I;
	wire [31:0] DAT_O;
	wire IRQ;
	timecounter U_TIMER(CLK_I, RST_I, ADD_I, WE_I, DAT_I, DAT_O, IRQ, device_BE);
	
	wire [31:0] switch_din;
	wire [31:0] switch_dout;
	Switches switches(switch_din, switch_dout);
	
	wire [31:0] numbers_din;
	wire numbers_we;
	Numbers numbers(clk, numbers_din, numbers_we, dout1, dout2, sel1, sel2);
	
	//mips U_MIPS(clk, rst, CPUAddr, BE, CPUIn, CPUOut, IOWe, clk_out, HardInt_in);
	assign CPUIn = CPU_dout;
	assign HardInt_in = {5'b0, IRQ};
	
	//Bridge (CPU_addr, CPU_din, CPUWe, CPU_be, CPU_dout, deviceCounter_din, deviceSwitch_din, device_addr, device_dout, weCounter, weNumber, device_BE);
	
	assign CPU_addr = CPUAddr;
	assign CPU_din = CPUOut;
	assign CPU_be = BE;
	assign CPUWe = IOWe;
	assign deviceCounter_din = DAT_O;
	assign deviceSwitch_din = switch_dout;
	
	//timecounter U_TIMER(CLK_I, RST_I, ADD_I, WE_I, DAT_I, DAT_O, IRQ)
	assign CLK_I = clk_out;
	assign RST_I = rst;
	assign ADD_I = device_addr[3:2];
	assign WE_I = weCounter;
	assign DAT_I = device_dout;
	
	//Switches switches(switch_din, switch_dout);
	assign switch_din = din;
	
	//Numbers numbers(clk, numbers_din, numbers_we, dout1, dout2, sel1, sel2);
	assign numbers_din = device_dout;
	assign numbers_we = weNumber;
	
endmodule















