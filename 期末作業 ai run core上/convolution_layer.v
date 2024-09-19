module convolution_layer(
    input clk,
    input reset,
    input [31:0] data_in,
    input valid,
    output reg [31:0] conv_out
);

    // 假设使用3x3卷积核
    reg signed [7:0] kernel [0:2][0:2];
    reg signed [31:0] data_window [0:2][0:2];
    reg signed [31:0] conv_sum;
    integer i, j;

    initial begin
        // 初始化卷积核
        kernel[0][0] = 1; kernel[0][1] = 0; kernel[0][2] = -1;
        kernel[1][0] = 1; kernel[1][1] = 0; kernel[1][2] = -1;
        kernel[2][0] = 1; kernel[2][1] = 0; kernel[2][2] = -1;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            conv_sum <= 0;
            conv_out <= 0;
            for (i = 0; i < 3; i = i + 1) begin
                for (j = 0; j < 3; j = j + 1) begin
                    data_window[i][j] <= 0;
                end
            end
        end else if (valid) begin
            // Shift the data window
            for (i = 0; i < 2; i = i + 1) begin
                for (j = 0; j < 3; j = j + 1) begin
                    data_window[i][j] <= data_window[i+1][j];
                end
            end
            for (j = 0; j < 2; j = j + 1) begin
                data_window[2][j] <= data_window[2][j+1];
            end
            data_window[2][2] <= data_in;

            // 重置 conv_sum 进行新计算
            conv_sum <= 0;

            // 卷积计算
            for (i = 0; i < 3; i = i + 1) begin
                for (j = 0; j < 3; j = j + 1) begin
                    conv_sum = conv_sum + data_window[i][j] * kernel[i][j];
                end
            end

            // 更新卷积输出
            conv_out <= conv_sum;
        end
    end
endmodule

