module multiplication (matrix_a, matrix_b, clock, start, result, done);
    input clock;                      // Clock do sistema
    input wire start;                // Sinal para iniciar a multiplicação
    input signed [199:0] matrix_a;   // Matriz A (5x5 elementos de 8 bits)
    input signed [199:0] matrix_b;   // Matriz B (5x5 elementos de 8 bits)
    
    output reg signed [199:0] result = 0; // Resultado da multiplicação (matriz 5x5)
    output reg done;                      // Sinaliza quando a multiplicação terminou

    reg [2:0] row = 0;                    // Índice da linha atual de A
    reg signed [15:0] temporary [0:4];    // Armazena os 5 resultados parciais da linha atual (cada valor pode exceder 8 bits)

    always @(posedge clock) begin
        if(start) begin
            integer i;

            // Calcula a linha `row` do resultado
            for (i = 0; i < 5; i = i + 1) begin
                // Produto escalar da linha `row` de A com a coluna `i` de B
                temporary[i] = 
                    (matrix_a[(row * 40) + 7  -: 8] * matrix_b[(i * 8) +     0 +: 8]) +  // A[row][0] * B[0][i]
                    (matrix_a[(row * 40) + 15 -: 8] * matrix_b[(i * 8) +    40 +: 8]) +  // A[row][1] * B[1][i]
                    (matrix_a[(row * 40) + 23 -: 8] * matrix_b[(i * 8) +    80 +: 8]) +  // A[row][2] * B[2][i]
                    (matrix_a[(row * 40) + 31 -: 8] * matrix_b[(i * 8) +   120 +: 8]) +  // A[row][3] * B[3][i]
                    (matrix_a[(row * 40) + 39 -: 8] * matrix_b[(i * 8) +   160 +: 8]);   // A[row][4] * B[4][i]
            end

            // Armazena os resultados da linha `row` na matriz final `result`
            for (i = 0; i < 5; i = i + 1) begin
                result[(row * 40) + (i * 8) + 7 -: 8] <= temporary[i][7:0]; // Guarda apenas os 8 bits menos significativos
            end

            // Verifica se chegou à última linha
            if (row == 4) begin
                row <= 0;      // Reinicia para a primeira linha
                done <= 1;     // Sinaliza que a operação foi concluída
            end else begin
                row <= row + 1; // Avança para a próxima linha
                done <= 0;      // Ainda não terminou
            end
        end
    end
endmodule
