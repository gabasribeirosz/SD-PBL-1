module opposite (matrix_a, matrix_b, result);
    // Entrada: matriz A com 25 elementos de 8 bits (total de 200 bits)
    input [199:0] matrix_a;

    // Entrada não utilizada neste módulo (poderia ser removida para evitar confusão)
    input [199:0] matrix_b;

    // Saída: matriz oposta de A (mesma dimensão, mas com sinais invertidos)
    output wire [199:0] result;

    // Índice de iteração para o generate
    genvar i;

    generate
        // Loop que percorre os bits da matriz de 8 em 8 (25 elementos x 8 bits = 200 bits)
        for (i = 0; i < 199; i = i + 8) begin : opposite_matrix
            // Para cada elemento da matriz A, inverte o sinal (gera o oposto)
            assign result[i +: 8] = -matrix_a[i +: 8];
        end
    endgenerate 

endmodule
