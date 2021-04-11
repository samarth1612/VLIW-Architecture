module cases (input ex_or, input [7:0]exp_1, input [7:0]exp_2,input [7:0]exp_3, input[22:0]man_1, input [22:0]man_2, input [22:0]man_3, output reg[31:0]out);
    //If num is INFINITY
    function inf(input [7:0]exp, input [22:0]man);
        begin
            if (&exp == 1'b1 && |man == 1'b0)
            begin
                inf = 1'b1;
            end
            
            else
            begin
                inf = 1'b0;
            end
        end
    endfunction

    //If num is NaN
    function nan(input [7:0]exp, input [22:0]man);
        begin
            if ((&exp == 1'b1 && |man != 1'b0))
            begin
                nan = 1'b1;
            end

            else
            begin
                nan = 1'b0;
            end
        end
    endfunction

    //If num is ZERO
    function zero(input [7:0]exp, input [22:0]man);
        begin
            if ((|exp == 1'b0) && (|man == 1'b0))
            begin
                zero = 1'b1;
            end

            else
            begin
                zero = 1'b0;
            end
        end
    endfunction

    assign inf_1 = inf(exp_1, man_1);
    assign inf_2 = inf(exp_2, man_2);
    assign nan_1 = nan(exp_1, man_1);
    assign nan_2 = nan(exp_2, man_2);
    assign zero_1 = zero(exp_1, man_1);
    assign zero_2 = zero(exp_2, man_2);

always @(*)
begin
    //NaN
    if (nan_1 || nan_2)
    begin
        out = {1'b0,{8{1'b1}},1'b1,22'b0};
    end

    //If 1st num is INFINITY
    else if (inf_1 == 1'b1)
    begin
        out = {ex_or,{8{1'b1}},23'b0};
        //If 2nd num is ZERO
        if (zero_2)
        begin
            out = {1'b0,{8{1'b1}},1'b1,22'b0};
        end
    end

    //If 2nd num is INFINITY
    else if (inf_2)
    begin
        out = {ex_or,{8{1'b1}},23'b0};
        //If 1st num is ZERO
        if (zero_1)
        begin
            out = {1'b0,{8{1'b1}},1'b1,22'b0};
        end
    end

    //If 1st num is ZERO
    else if (zero_1)
    begin
        out = {ex_or,{8{1'b0}},23'b0};
    end

    //If 2nd num is ZERO
    else if (zero_2)
    begin
        out = {ex_or,{8{1'b0}},23'b0};
    end

    else
    begin
        out = {ex_or, exp_3, man_3};
    end
end

endmodule