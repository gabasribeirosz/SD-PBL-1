module scalar (data, matrix_a, result);
	input [7:0] data;
	input [199:0] matrix_a;
	output wire [199:0] result;

	genvar i;
	
	generate 
		for (i = 0; i < 25; i = i + 1) begin : scalar_matrix
				assign result[i*8 +: 8] = data * matrix_a[i*8+: 8];
		end
	endgenerate
	
endmodule 