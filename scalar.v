module scalar (data, matrix_a, result);
    // Entrada: escalar de 8 bits (valor a multiplicar)
    input [7:0] data;

    // Entrada: matriz 5x5 (25 elementos de 8 bits cada = 200 bits)
    input [199:0] matrix_a;

    // Saída: resultado da multiplicação escalar (mesmo formato que a matriz original)
    output wire [199:0] result;

    // Índice usado no loop de geração
    genvar i;

    generate
        // Laço que percorre os 25 elementos da matriz (de 0 a 24)
        for (i = 0; i < 25; i = i + 1) begin : scalar_matrix
            // Para cada elemento da matriz: multiplica pelo escalar `data`
            // e armazena no mesmo índice de posição na matriz de saída `result`
            assign result[i*8 +: 8] = data * matrix_a[i*8 +: 8];
        end
    endgenerate

endmodule
