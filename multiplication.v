module multiplication (matrix_a, matrix_b, clock, start, result, done);
    input clock;
    input wire start;
    input signed [199:0] matrix_a;
    input signed [199:0] matrix_b;
    output reg signed [199:0] result = 0;
    output reg done;

    reg [2:0] row = 0;
    reg signed [15:0] temporary [0:4];

    always @(posedge clock) begin
        if(start) begin
            integer i;
            for (i = 0; i < 5; i = i + 1) begin
                temporary[i] = (matrix_a[(row * 40) + 7 -: 8]   * matrix_b[(i * 8) +: 8]) +
                (matrix_a[(row * 40) + 15 -: 8]  * matrix_b[(i * 8) + 40 +: 8]) +
                (matrix_a[(row * 40) + 23 -: 8]  * matrix_b[(i * 8) + 80 +: 8]) +
                (matrix_a[(row * 40) + 31 -: 8]  * matrix_b[(i * 8) + 120 +: 8]) +
                (matrix_a[(row * 40) + 39 -: 8]  * matrix_b[(i * 8) + 160 +: 8]);
            end

            for (i = 0; i < 5; i = i + 1) begin
                result[(row * 40) + (i * 8) + 7 -: 8] <= temporary[i][7:0];
            end

            if (row == 4) begin
                row <= 0;
                done <= 1;
            end else begin
                row <= row + 1;
                done <= 0;
            end
        end
    end
endmodule
