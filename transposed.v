module transposed (matrix_a, matrix_b, result);
    // Entrada: matriz A representada como vetor de 200 bits (25 elementos de 8 bits)
    input [199:0] matrix_a;

    // matrix_b não é usado nesse módulo, pode ser removido (aparentemente está sobrando)
    input [199:0] matrix_b;

    // Saída: matriz transposta de A, com o mesmo tamanho (200 bits)
    output wire [199:0] result;

    // Variáveis de loop geradas em tempo de síntese para percorrer linhas e colunas
    genvar i, j;

    generate
        // Loop externo percorre as colunas da matriz original (que se tornam linhas da transposta)
        for (j = 0; j < 5; j = j + 1) begin : row
            // Loop interno percorre as linhas da matriz original (que se tornam colunas da transposta)
            for (i = 0; i < 5; i = i + 1) begin : column
                // Cada elemento [i][j] da matriz transposta recebe o elemento [j][i] da matriz original
                // O acesso é feito com slices:
                // - (40*j)+(8*i): posição do elemento [j][i] na matriz original
                // - (40*i)+(8*j): posição onde o elemento transposto será armazenado
                assign result[(8*i)+(40*j)+:8] = matrix_a[(40*i)+(8*j) +:8];
            end
        end
    endgenerate

endmodule
