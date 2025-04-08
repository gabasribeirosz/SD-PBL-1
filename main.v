module main (switch, clock);
	input wire [9:0] switch;
	input wire clock;

	reg [7:0] address = 0;
	reg clock_slow;
	reg [24:0] clock_counter = 0;
	reg [7:0] counter = 0;

	reg [199:0] matrix_a;
	reg [199:0] matrix_b;
	reg wren = 0;
	reg start = 0;
	reg read_finished = 0;

	reg [3:0] operation_code;

	wire [255:0] data;
	wire [199:0] sum_result;
	wire [199:0] sub_result;
	wire [199:0] mul_result;
	wire [199:0] scalar_result;
	wire [199:0] transposed_result;
	wire [199:0] opposite_result;
	
	reg [199:0] selected_result; 
	
	wire done;

	reg [7:0] i = 0;

	ram1port (
		.address(address), 
		.clock(clock), 
		.data(selected_result), 
		.wren(wren), 
		.q(data)
	);

	// Instância da Soma
	sum (
		.matrix_a(matrix_a), 
		.matrix_b(matrix_b), 
		.result(sum_result)
	);
	
	// Instância da Subtração
	subtraction (
		.matrix_a(matrix_a), 
		.matrix_b(matrix_b), 
		.result(sub_result)
	);
	
	// Instância da Escalar
	scalar (
		.data(matrix_b[7:0]), 
		.matrix_a(matrix_a), 
		.result(scalar_result)
	);
	
	// Instância da Multiplicação
	multiplication (
		.matrix_a(matrix_a), 
		.matrix_b(matrix_b), 
		.clock(clock), 
		.start(start), 
		.result(result_mul), 
		.done(done)
	);
	
	transposed (
		.matrix_a(matrix_a),
		.matrix_b(matrix_b),
		.result(transposed_result),
	);
	
	opposite (
		.matrix_a(matrix_a),
		.matrix_b(matrix_b),
		.result(opposite_result)
	);

	always @(*) begin
		case (1'b1)
			switch[0]: operation_code = 4'd0; // Soma
			switch[1]: operation_code = 4'd1; // Subtração
			switch[2]: operation_code = 4'd2; // Multiplicação
			switch[3]: operation_code = 4'd3; // Por Escalar
			switch[4]: operation_code = 4'd4; // Transposta
			switch[5]: operation_code = 4'd5; // Oposta
			default: operation_code = 4'd15;  // Nenhuma Operação Ativada
		endcase
	end
	
	always @(*) begin
		case(operation_code)
			4'd0: selected_result = sum_result;
			4'd1: selected_result = sub_result;
			4'd2: selected_result = mul_result;
			4'd3: selected_result = scalar_result;
		   4'd4: selected_result = transposed_result;
			4'd5: selected_result = opposite_result;
			default: selected_result = 200'd0;
		endcase
	end
	 
	always @(posedge clock) begin
		if (clock_counter == 3) begin
			clock_counter <= 0;
			clock_slow <= 1;
		end 
		
		else begin
			clock_counter <= clock_counter + 1;
			clock_slow <= 0;
		end
	end

	always @(posedge clock_slow) begin
		if (operation_code != 4'd15) begin
			case (counter)
				0: begin
					counter <= counter + 1;
				end
				
				1: begin
					matrix_a <= data;
					counter <= counter + 1;
				end
				
				2: begin
					address <= 1;
					counter <= counter + 1;
				end
				
				3: begin
					matrix_b <= data;
					if (operation_code == 4'd2)
						start <= 1;
					counter <= counter + 1;
				end
				
				4: begin
					address <= 2;
					start <= 0;
					counter <= counter + 1;
				end
				
				5: begin
					if (operation_code == 4'd2) begin
						if (done) begin
							wren <= 1;
							counter <= counter + 1;
						end
					end
					
					else begin
						wren <= 1;
						counter <= counter + 1;
					end
				end
				
				6: begin
					counter <= counter + 1;
				end
				
				7: begin
					counter <= counter + 1;
				end
				
				8: begin
					wren <= 0;
					read_finished <= 1;
					counter <= 0;
				end
			endcase
		end
	end

endmodule