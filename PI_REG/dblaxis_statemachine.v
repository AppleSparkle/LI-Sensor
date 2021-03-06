// Copyright (C) 1991-2012 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// Generated by Quartus II Version 12.1 Build 177 11/07/2012 SJ Full Version
// Created on Fri Jun 21 15:54:56 2013

// synthesis message_off 10175

`timescale 1ns/1ns

module dblaxis_statemachine (
    reset,clock,PWMEND,SMEND,
    SM_START,GEN_START,AXIS_SEL);

    input reset;
    input clock;
    input PWMEND;
    input SMEND;
    tri0 reset;
    tri0 PWMEND;
    tri0 SMEND;
    output SM_START;
    output GEN_START;
    output AXIS_SEL;
    reg SM_START;
    reg reg_SM_START;
    reg GEN_START;
    reg reg_GEN_START;
    reg AXIS_SEL;
    reg reg_AXIS_SEL;
    reg [5:0] fstate;
    reg [5:0] reg_fstate;
    parameter state1=0,state2=1,state3=2,state4=3,state5=4,state6=5;

    initial
    begin
        reg_SM_START <= 1'b0;
        reg_GEN_START <= 1'b0;
        reg_AXIS_SEL <= 1'b0;
    end

    always @(posedge clock)
    begin
        if (clock) begin
            fstate <= reg_fstate;
            SM_START <= reg_SM_START;
            GEN_START <= reg_GEN_START;
            AXIS_SEL <= reg_AXIS_SEL;
        end
    end

    always @(fstate or reset or PWMEND or SMEND)
    begin
        if (reset) begin
            reg_fstate <= state1;
            reg_SM_START <= 1'b0;
            reg_GEN_START <= 1'b0;
            reg_AXIS_SEL <= 1'b0;
        end
        else begin
            reg_SM_START <= 1'b0;
            reg_GEN_START <= 1'b0;
            reg_AXIS_SEL <= 1'b0;
            case (fstate)
                state1: begin
                    if (~(PWMEND))
                        reg_fstate <= state1;
                    else if (PWMEND)
                        reg_fstate <= state2;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= state1;

                    reg_GEN_START <= 1'b0;

                    reg_AXIS_SEL <= 1'b0;

                    reg_SM_START <= 1'b0;
                end
                state2: begin
                    reg_fstate <= state3;

                    reg_GEN_START <= 1'b1;

                    reg_AXIS_SEL <= 1'b0;

                    reg_SM_START <= 1'b0;
                end
                state3: begin
                    reg_fstate <= state4;

                    reg_GEN_START <= 1'b0;

                    reg_AXIS_SEL <= 1'b0;

                    reg_SM_START <= 1'b1;
                end
                state4: begin
                    if (~(SMEND))
                        reg_fstate <= state4;
                    else if (SMEND)
                        reg_fstate <= state5;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= state4;

                    reg_GEN_START <= 1'b0;

                    reg_AXIS_SEL <= 1'b0;

                    reg_SM_START <= 1'b0;
                end
                state5: begin
                    reg_fstate <= state6;

                    reg_GEN_START <= 1'b0;

                    reg_AXIS_SEL <= 1'b1;

                    reg_SM_START <= 1'b1;
                end
                state6: begin
                    if (~(SMEND))
                        reg_fstate <= state6;
                    else if (SMEND)
                        reg_fstate <= state1;
                    // Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= state6;

                    reg_GEN_START <= 1'b0;

                    reg_AXIS_SEL <= 1'b1;

                    reg_SM_START <= 1'b0;
                end
                default: begin
                    reg_SM_START <= 1'bx;
                    reg_GEN_START <= 1'bx;
                    reg_AXIS_SEL <= 1'bx;
                    $display ("Reach undefined state");
                end
            endcase
        end
    end
endmodule // dblaxis_statemachine
