module rcvr
#(
  parameter [7:0] MATCH = 8'hA5 //10100101
 )
 (
  input  wire      clock   ,
  input  wire      reset   ,
  input  wire      data_in ,
  input  wire      reading ,
  output reg       ready   ,
  output reg       overrun ,
  output reg [7:0] data_out
 );

  localparam SHIFT_HEAD = 0 ,
             SHIFT_BODY = 1 ;

  reg [6:0] head_reg ;
  reg [6:0] body_reg ;
  reg [2:0] count ;
  reg phase ;

  always @(posedge clock)

    if (reset) begin

        // INITIALIZE PHASE TO SHIFTING HEADER
        // INITIALIZE HEADER TO OPPOSITE OF LEFTMOST MATCH BIT
        // INITIALIZE CONTROL REGISTERS TO INACTIVE STATE (IGNORE DATA PATH)
      phase <= SHIFT_HEAD;
      head_reg <= 0;
      ready <= 0;
      overrun <= 0;
      count <= 0;
      end

    else begin

        // IF PHASE IS SHIFT_BODY THEN CLEAR HEAD REGISTER, ELSE
        // IF PHASE IS SHIFT_HEAD THEN SHIFT INPUT DATA LEFT INTO HEAD REGISTER
        if (phase == SHIFT_BODY) head_reg <= 0; else
        if (phase == SHIFT_HEAD) head_reg <= {head_reg, data_in};




        // IF CONCATENATION OF HEAD REG AND INPUT DATA IS MATCH CHARACTER THEN
        // SET PHASE TO SHIFT_BODY, ELSE
        // IF COUNT IS 7 THEN SET PHASE BACK TO SHIFT_HEAD

        if({head_reg, data_in} == MATCH) phase <= SHIFT_BODY; else
        if(count == 7) phase <= SHIFT_HEAD;



        // IF PHASE IS SHIFT_BODY THEN INCREMENT COUNT
        if (phase == SHIFT_BODY) count <= count + 1;

        // IF PHASE IS SHIFT_BODY THEN SHIFT INPUT DATA LEFT INTO BODY REGISTER

        if (phase == SHIFT_BODY) body_reg <= {body_reg, data_in}; 
        // IF COUNT IS 7 THEN COPY CONCATENATION OF BODY REGISTER AND INPUT DATA
        // TO OUTPUT DATA

        if (count == 7) data_out <= { body_reg, data_in } ;
        // IF COUNT IS 7 THEN SET READY ELSE IF READING THEN CLEAR READY
        if (count == 7) ready <= 1; else if (reading) ready <= 0;

        // IF READING THEN CLEAR OVERRUN, ELSE
        // IF COUNT IS 7 AND STILL READY THEN SET OVERRUN
        if (reading) overrun <= 0; else if (count==7 && ready) overrun <= 1;

      end

endmodule
