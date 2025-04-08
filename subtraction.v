module subtraction (matrix_a, matrix_b, result);
	input [199:0] matrix_a;
	input [199:0] matrix_b;
	output wire [199:0] result;
	
	genvar i;
	
	generate
		for (i = 0; i < 25; i = i + 1) begin : matrix_subtraction
			assign result[i*8 +: 8] = matrix_a[i*8 +: 8] - matrix_b[i*8 +: 8];
		end
		
	endgenerate



endmodule 