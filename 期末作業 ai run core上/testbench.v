module testbench;
    reg clk;
    reg reset;
    reg [31:0] data_in;
    reg valid;
    wire [31:0] conv_out;

    // 实例化卷积层模块
    convolution_layer uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .valid(valid),
        .conv_out(conv_out)
    );

    // 生成时钟信号
    always #5 clk = ~clk;

    initial begin
        // 初始化信号
        clk = 0;
        reset = 1;
        data_in = 0;
        valid = 0;

        // 释放复位
        #10 reset = 0;

        // 启用变量转储到VCD文件
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);

        // 测试卷积操作
        valid = 1;

        // 提供输入数据
        #10 data_in = 32'h00000001; // 输入数据1
        #10 data_in = 32'h00000002; // 输入数据2
        #10 data_in = 32'h00000003; // 输入数据3
        #10 data_in = 32'h00000004; // 输入数据4
        #10 data_in = 32'h00000005; // 输入数据5
        #10 data_in = 32'h00000006; // 输入数据6
        #10 data_in = 32'h00000007; // 输入数据7
        #10 data_in = 32'h00000008; // 输入数据8
        #10 data_in = 32'h00000009; // 输入数据9

        // 停止有效输入
        #10 valid = 0;

        // 结束仿真
        #100 $finish;
    end
endmodule

