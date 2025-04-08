module transposed (matrix_a, matrix_b, result);
	input [199:0] matrix_a;
	input [199:0] matrix_b;
	output wire [199:0] result;
	
	genvar i,j;
	
	generate
		for (j = 0; j < 5; j = j + 1) begin : row
			for (i = 0; i < 5; i = i + 1) begin : column
				assign result[(8*i)+(40*j)+:8] = matrix_a[(40*i)+(8*j) +:8];
			end
		end
	endgenerate

endmodule 