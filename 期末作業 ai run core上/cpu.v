module simple_cpu(
    input clk,
    input reset,
    input [31:0] instruction,
    output reg [31:0] pc,
    output reg [31:0] result
);

    reg [31:0] registers[0:31];  // 32个32位寄存器
    reg [31:0] alu_out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end else begin
            // 简单的指令解码和执行
            case (instruction[31:26])
                6'b000000: begin // R型指令
                    case (instruction[5:0])
                        6'b100000: alu_out <= registers[instruction[25:21]] + registers[instruction[20:16]]; // 加法
                        // 其他R型指令
                    endcase
                end
                // 其他指令类型
            endcase
            result <= alu_out;
            pc <= pc + 4; // 下一条指令
        end
    end
endmodule

module top_module(
    input clk,
    input reset,
    input [31:0] instruction,
    input [31:0] data_in,
    input valid,
    output [31:0] cpu_result,
    output [31:0] conv_result
    // output [31:0] pool_result // 移除对 pooling_layer 的引用
);

    wire [31:0] pc;

    simple_cpu u_cpu(
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .pc(pc),
        .result(cpu_result)
    );

    convolution_layer u_conv(
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .valid(valid),
        .conv_out(conv_result)
    );

    // 移除对 pooling_layer 的引用
    // pooling_layer u_pool(
    //     .clk(clk),
    //     .reset(reset),
    //     .data_in(conv_result),
    //     .valid(valid),
    //     .pool_out(pool_result)
    // );

endmodule

