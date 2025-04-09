// Módulo para cálculo do determinante de uma submatriz 2x2 da matriz A
module determinant2x2 (matrix_a, result);	
	input wire [199:0] matrix_a;		// Entrada da matriz A como vetor linear de 200 bits (5x5, cada elemento com 8 bits)
	output wire [7:0] result;			// Resultado do determinante da submatriz 2x2

    // Declaração de uma matriz de elementos de 8 bits (5x5) para acessar individualmente os valores de matrix_a
    wire [7:0] element [4:0][4:0];

    genvar i, j;
    generate begin
        // Geração de laços para "desempacotar" matrix_a em elementos individuais na matriz 'element'
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : column
                // Extrai 8 bits de matrix_a correspondentes à posição [i][j]
                assign element[i][j] = matrix_a[(i * 40) + (j * 8) +: 8];
            end
        end
    end
    endgenerate

    // Cálculo do determinante da submatriz 2x2 formada por:
    // | a b |
    // | c d |  =>  (a*d - b*c)
    // Utiliza os elementos: [0][0], [0][1], [1][0], [1][1]
    assign result = (element[0][0] * element[1][1]) - (element[1][0] * element[0][1]);

endmodule
