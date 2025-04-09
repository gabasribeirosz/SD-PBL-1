module main (switch, clock);
    input wire [9:0] switch;    // Entradas de chave para selecionar a operação
    input wire clock;           // Clock principal

    // Sinais de controle e variáveis internas
    reg [7:0] address = 0;               // Endereço da RAM
    reg clock_slow;                      // Clock dividido para desacelerar a FSM
    reg [24:0] clock_counter = 0;        // Contador para gerar clock_slow
    reg [7:0] counter = 0;               // Contador da máquina de estados

    // Matrizes de entrada A e B
    reg [199:0] matrix_a;
    reg [199:0] matrix_b;

    // Sinais de controle para escrita e início de operação
    reg wren = 0;             // Habilita escrita na RAM
    reg start = 0;            // Inicia multiplicação
    reg read_finished = 0;    // Indica fim da leitura

    // Código da operação atual
    reg [3:0] operation_code;

    // Dados da RAM
    wire [255:0] data;

    // Resultados das operações
    wire [199:0] sum_result;
    wire [199:0] sub_result;
    wire [199:0] mul_result;
    wire [199:0] scalar_result;
    wire [199:0] transposed_result;
    wire [199:0] opposite_result;
    wire [7:0] determinant2x2_result;
    wire [7:0] determinant3x3_result;

    // Resultado selecionado conforme a operação
    reg [199:0] selected_result; 

    // Sinal de conclusão da multiplicação
    wire done;

    reg [7:0] i = 0; // Não está sendo usado no momento

    // Instância da memória RAM
    ram1port ram (
        .address(address), 
        .clock(clock), 
        .data(selected_result), 
        .wren(wren), 
        .q(data)
    );

    // Instâncias das operações
    sum s (
        .matrix_a(matrix_a), 
        .matrix_b(matrix_b), 
        .result(sum_result)
    );

    subtraction sub (
        .matrix_a(matrix_a), 
        .matrix_b(matrix_b), 
        .result(sub_result)
    );

    scalar sc (
        .data(matrix_b[7:0]), 
        .matrix_a(matrix_a), 
        .result(scalar_result)
    );

    multiplication mul (
        .matrix_a(matrix_a), 
        .matrix_b(matrix_b), 
        .clock(clock), 
        .start(start), 
        .result(mul_result), 
        .done(done)
    );

    transposed trans (
        .matrix_a(matrix_a),
        .matrix_b(matrix_b),
        .result(transposed_result)
    );

    opposite opp (
        .matrix_a(matrix_a),
        .matrix_b(matrix_b),
        .result(opposite_result)
    );
    
    determinant2x2 det2 (
        .matrix_a(matrix_a),
        .result(determinant2x2_result)
    );

    determinant3x3 det3 (
        .matrix_a(matrix_a),
        .result(determinant3x3_result)
    );

    // Decodificador de operação baseado nos switches
    always @(*) begin
        case (1'b1)
            switch[0]: operation_code = 4'd0; // Soma
            switch[1]: operation_code = 4'd1; // Subtração
            switch[2]: operation_code = 4'd2; // Multiplicação
            switch[3]: operation_code = 4'd3; // Escalar
            switch[4]: operation_code = 4'd4; // Transposta
            switch[5]: operation_code = 4'd5; // Oposta
            switch[6]: operation_code = 4'd6; // Determinante 2x2
            switch[7]: operation_code = 4'd7; // Determinante 3x3
            default: operation_code = 4'd15;  // Nenhuma operação
        endcase
    end

    // Seleciona o resultado conforme a operação escolhida
    always @(*) begin
        case(operation_code)
            4'd0: selected_result = sum_result;
            4'd1: selected_result = sub_result;
            4'd2: selected_result = mul_result;
            4'd3: selected_result = scalar_result;
            4'd4: selected_result = transposed_result;
            4'd5: selected_result = opposite_result;
            4'd6: selected_result = {192'd0, determinant2x2_result}; // Determinante 2x2 em 8 bits
            4'd7: selected_result = {192'd0, determinant3x3_result}; // Determinante 3x3 em 8 bits
            default: selected_result = 200'd0;
        endcase
    end

    // Geração do clock lento (1/4 do clock principal)
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

    // Máquina de estados finitos para controle da leitura/escrita
    always @(posedge clock_slow) begin
        if (operation_code != 4'd15) begin
            case (counter)
                0: begin
                    counter <= counter + 1; // Estado inicial
                end

                1: begin
                    matrix_a <= data; // Lê a matriz A
                    counter <= counter + 1;
                end

                2: begin
                    address <= 1; // Prepara leitura da matriz B
                    counter <= counter + 1;
                end

                3: begin
                    matrix_b <= data; // Lê matriz B
                    if (operation_code == 4'd2)
                        start <= 1; // Inicia multiplicação se necessário
                    counter <= counter + 1;
                end

                4: begin
                    address <= 2; // Prepara endereço de escrita
                    counter <= counter + 1;
                end

                5: begin
                    if (operation_code == 4'd2) begin
                        if (done) begin      // Espera o done para multiplicação
                            wren <= 1;       // Ativa escrita
                            counter <= counter + 1;
                        end
                    end
                    else begin
                        wren <= 1;           // Para outras operações, escreve direto
                        counter <= counter + 1;
                    end
                end

                6: begin
                    counter <= counter + 1; // Delay
                end

                7: begin
                    counter <= counter + 1; // Delay
                end

                8: begin
                    wren <= 0;             // Finaliza escrita
                    read_finished <= 1;    // Marca leitura como concluída
                end
            endcase
        end
    end

endmodule
