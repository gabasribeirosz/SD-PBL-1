module subtraction (matrix_a, matrix_b, result);
    // Entrada: matriz A (25 elementos de 8 bits = 200 bits)
    input [199:0] matrix_a;

    // Entrada: matriz B (25 elementos de 8 bits = 200 bits)
    input [199:0] matrix_b;

    // Saída: resultado da subtração A - B (também 200 bits)
    output wire [199:0] result;

    // Índice de iteração usado para gerar o loop de subtração
    genvar i;

    generate
        // Gera um bloco de subtração para cada um dos 25 elementos (linhas * colunas = 5x5)
        for (i = 0; i < 25; i = i + 1) begin : matrix_subtraction
            // Para cada elemento, subtrai o valor correspondente de matrix_b de matrix_a
            // Cada elemento tem 8 bits, então usamos slicing [i*8 +: 8]
            assign result[i*8 +: 8] = matrix_a[i*8 +: 8] - matrix_b[i*8 +: 8];
        end
    endgenerate

endmodule
