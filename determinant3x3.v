module determinant3x3 (matrix_a, result);
    input wire [199:0] matrix_a;  // Entrada da matriz A em forma linearizada (5x5, cada elemento com 8 bits)
    output wire [7:0] result;    // Saída com o valor do determinante da submatriz 3x3

    // Declaração de matriz auxiliar para facilitar o acesso aos elementos individuais
    wire [7:0] element[4:0][4:0];

    genvar i, j;
    generate begin
        // Geração dos elementos da matriz a partir do vetor linear
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : column
                // Cada elemento é extraído da posição correta no vetor de bits matrix_a
                assign element[i][j] = matrix_a[(i * 40) + (j * 8) +: 8];
            end
        end
    end
    endgenerate

    /*
        Cálculo do determinante da submatriz 3x3:
        | a b c |
        | d e f |
        | g h i |

        Fórmula do determinante 3x3:
        det = a(ei − fh) − b(di − fg) + c(dh − eg)

        Aqui os elementos são acessados como:
        a = element[0][0], b = element[0][1], c = element[0][2]
        d = element[1][0], e = element[1][1], f = element[1][2]
        g = element[2][0], h = element[2][1], i = element[2][2]
    */
    assign result = element[0][0] * (element[1][1] * element[2][2] - element[1][2] * element[2][1])
                  - element[0][1] * (element[1][0] * element[2][2] - element[1][2] * element[2][0])
                  + element[0][2] * (element[1][0] * element[2][1] - element[1][1] * element[2][0]);

endmodule
