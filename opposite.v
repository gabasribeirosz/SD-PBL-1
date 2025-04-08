module opposite (matrix_a, matrix_b, result);
	input [199:0] matrix_a;
	input [199:0] matrix_b;
	output wire [199:0] result;
	
	
	genvar i;
	generate 
		for (i = 0; i < 199; i = i + 8) begin : opposite_matrix
			assign result[i +: 8] = -matrix_a[i +: 8];
		end
	endgenerate 
	
endmodule 