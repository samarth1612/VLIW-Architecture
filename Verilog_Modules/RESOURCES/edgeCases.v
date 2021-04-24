/*
    A module to modify the outputs with respect to the edge cases
    -- Infinty
    -- Zero
    -- NaN
*/
module zeroInf (input [7:0]e1, input [22:0]m1, input [7:0]e2, input [22:0]m2, input [7:0] e3I, input [22:0] m3I, output reg [7:0]e3, output reg [22:0]m3);

    /*
        Helper function for checking if the modulus of the given representation is infinity
    */
    function isInf (input [7:0] e, input [22:0] m);
    begin
        /*
            If the exponent is 255 and the mantissa is 0,
            the representation is inf
        */
        if (&e == 1'b1 && |m == 1'b0) begin
            isInf = 1'b1;
        end
        else begin
            isInf = 1'b0;
        end
    end
    endfunction
    /*
        Helper function for checking if the modulus of the given representation is zero
    */
    function isZero (input [7:0] e, input [22:0] m);
    begin

        /*
            If the exponent is 0 and the mantissa is 0,
            the representation is zero
        */
        if (|e == 1'b0 && |m == 1'b0) begin
            isZero = 1'b1;
        end
        else begin
            isZero = 1'b0;
        end

    end
    endfunction
    /*
        Helper function for checking if the modulus of the given representation is NaN
    */
    function isNaN (input [7:0] e, input [22:0] m);
    begin
        /*
            If the exponent is 255 and the mantissa is not 0,
            the representation is NaN
        */
        if (&e == 1'b1 && |m != 1'b0) begin
            isNaN = 1'b1;
        end
        else begin
            isNaN = 1'b0;
        end

    end
    endfunction

    always @* begin
        /*
            If the first representation is infinty
        */
        if (isInf (e1, m1) == 1'b1) begin
            /*
                If the second representation is zero,
                then the output is NaN
                Ref: https://en.wikipedia.org/wiki/NaN#Operations_generating_NaN
            */
            if (isZero (e2, m2)) begin
                e3 = 8'b11111111;
                m3 = 23'b00000000000000000000001;
            end
            /*
                Else,
                the output is infinity
            */
            else begin
                e3 = 8'b11111111;
                m3 = 23'b00000000000000000000000;
            end
        end
        /*
            If the first representation is zero
        */
        else if (isZero (e1, m1) == 1'b1) begin
            /*
                If the second reprsentation is infinity,
                then the output is NaN
                Ref: https://en.wikipedia.org/wiki/NaN#Operations_generating_NaN
            */
            if (isInf (e2, m2)) begin
                e3 = 8'b11111111;
                m3 = 23'b00000000000000000000001;
            end
            /*
                Else,
                the output is zero
            */
            else begin
                e3 = 8'b00000000;
                m3 = 23'b00000000000000000000000;
            end
        end
        /*
            Else, if not zero nor infinity
        */
        else begin
            /*
                If the second reprsentation is infinity,
                then the output is infinity
            */
            if (isInf (e2, m2)) begin
                e3 = 8'b11111111;
                m3 = 23'b00000000000000000000000;
            end
            /*
                If the second reprsentation is zero,
                then the output is zero
            */
            else if (isZero (e2, m2)) begin
                e3 = 8'b00000000;
                m3 = 23'b00000000000000000000000;
            end
            /*
                If any of the two reprsentations are NaN,
                then the output is NaN
            */
            else if (isNaN (e1, m1) == 1'b1 || isNaN (e2, m2) == 1'b1) begin
                e3 = 8'b11111111;
                m3 = m3I;
            end
            /*
                If the represtations are normal or denormal,
                copy the output from the wallace multiplier
            */
            else begin
                e3 = e3I;
                m3 = m3I;
            end
        end
    end

endmodule
