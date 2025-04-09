`timescale 1ns/1ps

module test_main;

    reg clock;
    reg [9:0] switch;
    wire [255:0] data_out;

    // Simulando a RAM
    reg [255:0] ram [0:2];  // address 0 = A, 1 = B, 2 = result

    wire [7:0] address;
    wire wren;

    // Instanciando o módulo main
    main uut (
        .switch(switch),
        .clock(clock)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;  // 10ns clock
    end

    // Simular leitura da RAM
    assign uut.data = ram[uut.address];
    
    // Captura escrita na RAM
    always @(posedge clock) begin
        if (wren) begin
            ram[uut.address] <= uut.selected_result;
        end
    end

    integer i;
    initial begin
        // Aguarda estabilização
        #20;

        // ---------- Teste 1: Soma 2x2 ----------
        $display("\n=== Soma 2x2 ===");
        switch = 10'b0000000001;  // Soma
        // A = [1 2; 3 4]
        // B = [5 6; 7 8]
        ram[0] = {8'd1, 8'd2, 8'd3, 8'd4, {192{1'b0}}};
        ram[1] = {8'd5, 8'd6, 8'd7, 8'd8, {192{1'b0}}};

        #500;

        $display("Resultado (Soma 2x2):");
        for (i = 0; i < 4; i = i + 1)
            $write("%d ", ram[2][255 - i*8 -: 8]);
        $display("\n");

        // ---------- Teste 2: Subtração 4x4 ----------
        $display("\n=== Subtração 4x4 ===");
        switch = 10'b0000000010;  // Subtração
        ram[0] = {8'd10, 8'd20, 8'd30, 8'd40,
                  8'd50, 8'd60, 8'd70, 8'd80,
                  8'd90, 8'd100, 8'd110, 8'd120,
                  8'd130, 8'd140, 8'd150, 8'd160,
                  {128{1'b0}}};
        ram[1] = {8'd1, 8'd2, 8'd3, 8'd4,
                  8'd5, 8'd6, 8'd7, 8'd8,
                  8'd9, 8'd10, 8'd11, 8'd12,
                  8'd13, 8'd14, 8'd15, 8'd16,
                  {128{1'b0}}};

        #500;

        $display("Resultado (Subtração 4x4):");
        for (i = 0; i < 16; i = i + 1)
            $write("%d ", $signed(ram[2][255 - i*8 -: 8]));
        $display("\n");

        // ---------- Teste 3: Multiplicação 5x5 ----------
        $display("\n=== Multiplicação 5x5 ===");
        switch = 10'b0000000100;  // Multiplicação
        // A = identidade 5x5
        ram[0] = {
            8'd1, 8'd0, 8'd0, 8'd0, 8'd0,
            8'd0, 8'd1, 8'd0, 8'd0, 8'd0,
            8'd0, 8'd0, 8'd1, 8'd0, 8'd0,
            8'd0, 8'd0, 8'd0, 8'd1, 8'd0,
            8'd0, 8'd0, 8'd0, 8'd0, 8'd1,
            {55{8'd0}} // padding até 200 bits
        };
        // B = matriz de 1s
        ram[1] = {25{8'd1}, {55{8'd0}}};

        #1000;

        $display("Resultado (Multiplicação 5x5):");
        for (i = 0; i < 25; i = i + 1)
            $write("%d ", $signed(ram[2][255 - i*8 -: 8]));
        $display("\n");

        $stop;
    end

endmodule
