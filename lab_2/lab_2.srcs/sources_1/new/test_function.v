`timescale 1ns / 1ps

module test_function;

    reg clk = 0;
    reg rst = 0;
    reg [7:0] a = 0;
    reg [7:0] b = 0;
    reg start = 0;
    wire [9:0] res;
    wire busy;
    
    integer raw_a;
    integer raw_b;
    integer raw_res;
    integer raw_iter;
    
    func func(
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .res(res),
        .busy(busy)
    );
    
    task test_func;
        input [15:0] iter;
        input [7:0] test_a;
        input [7:0] test_b;
        input [23:0] test_res;
        begin
            a = test_a;
            b = test_b;
            start = 1;
            #20
            start = 0;
            while (!busy) begin
                #5;
            end
            if(res != test_res) begin 
                $display("Test on a:%d, b:%d: Failed", test_a, test_b);
                $display("Expected:%d, Current:%d", test_res, res);
            end else begin
                //$display("Test success:%d", iter);
            end
        end
    endtask
    
    initial begin
        rst = 1;
        #20;
        rst = 0;
        //test_func(1, 1, 1, 5);
        for (raw_a = 0; raw_a < 256; raw_a = raw_a + 1) 
            for (raw_b = 0; raw_b < 256; raw_b = raw_b + 1) begin
                raw_res = raw_b >= 216 ? 6 : (
                    raw_b >= 125 ? 5 : (
                        raw_b >= 64 ? 4 : (
                            raw_b >= 27 ? 3 : (
                                raw_b >= 8 ? 2 : (
                                    raw_b >= 1 ? 1 : 0)))));
                raw_res = 2 * raw_res + 3 * raw_a; 
                raw_iter = raw_a * 256 + raw_b;
                test_func(raw_iter, raw_a, raw_b, raw_res);
            end
        $finish;
    end

    always begin
        #5  clk =  ! clk;    //создание clk
    end 
endmodule