module sum (matrix_a, matrix_b, result);
    // Entradas: duas matrizes 5x5 representadas em um vetor de 200 bits (25 elementos de 8 bits)
    input [199:0] matrix_a;
    input [199:0] matrix_b;

    // Saída: matriz resultante da soma, também 200 bits (25 elementos de 8 bits)
    output wire [199:0] result;

    // Variável gerada em tempo de síntese para criar múltiplas conexões de soma
    genvar i;

    generate
        // Geração de 25 operações de soma (uma para cada elemento da matriz 5x5)
        for (i = 0; i < 25; i = i + 1) begin : matrix_sum
            // Para cada elemento da matriz:
            // - Soma o elemento i da matrix_a com o elemento i da matrix_b
            // - O resultado é colocado na posição correspondente da matriz de saída
            // i*8 +: 8 representa o slice de 8 bits correspondente ao elemento i
            assign result[i*8 +: 8] = matrix_a[i*8 +: 8] + matrix_b[i*8 +: 8];
        end
    endgenerate
endmodule
