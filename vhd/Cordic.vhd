-----------------------------cordic.vhd------------------------------------------


-- CORDIC_FPGA BLOC with CORRECT DATA SIZE and CORRESPONDING to WHAT is FLASHED on THE FPGA BOARD


----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cordic is
  generic (
    N : positive := 19);
  port(
    Z_in                  : in  std_logic_vector(7 downto 0);  --change for bench
    Clk                   : in  std_logic;
    Reset                 : in  std_logic;
    --Start_conv   : in  std_logic;
    Load_button           : in  std_logic;
    Start_button          : in  std_logic;
    New_calc_button       : in  std_logic;
    Toggle_display_button : in  std_logic;
    End_cal               : out std_logic;
    Led_sign              : out std_logic;
    XY_output             : out std_logic_vector(N-4 downto 0)
    );
end Cordic;

architecture A of Cordic is

  component Cordic_core_FPGA is
    generic (
      N : positive);
    port(                               --X, Y,
      Z            : in  std_logic_vector(N-1 downto 0);
      Clk          : in  std_logic;
      Reset        : in  std_logic;
      Start_cal    : in  std_logic;
      End_cal      : out std_logic;
      X_out, Y_out : out std_logic_vector(N-1 downto 0));

  end component Cordic_core_FPGA;

  component Angle_conv is
    generic (
      N : positive);
    port (Clk            : in  std_logic;
          Reset          : in  std_logic;
          Z_in           : in  std_logic_vector(N-1 downto 0);
          Buff_OE_Cad_in : in  std_logic;
          Buff_OE_Z0     : in  std_logic;
          XY_out_cmd     : out std_logic_vector(3 downto 0);
          Z0_out         : out std_logic_vector(N-4 downto 0)
          );
  end component Angle_conv;

  component Sin_Cos_attribution is
    generic (
      N : positive);
    port (Clk         : in  std_logic;
          Reset       : in  std_logic;
          X           : in  std_logic_vector(N-1 downto 0);
          Y           : in  std_logic_vector(N-1 downto 0);
          cmd         : in  std_logic_vector(3 downto 0);
          Out_reg_ena : in  std_logic;
          X_out       : out std_logic_vector(N-1 downto 0);
          Y_out       : out std_logic_vector(N-1 downto 0)
          );

  end component Sin_Cos_attribution;

  component Fsm_UI is
    port(Clk                   : in  std_logic;
         Reset                 : in  std_logic;
         Load_button           : in  std_logic;
         Start_button          : in  std_logic;
         New_calc_button       : in  std_logic;
         Toggle_display_button : in  std_logic;
         XY_msb                : in  std_logic;
         End_cal               : in  std_logic;
         Led_sign              : out std_logic;
         XY_value_sel          : out std_logic;
         --Start_conv            : out std_logic;
         Start_cal             : out std_logic;
         Z_lsb_reg_Ena         : out std_logic;
         Z_mid_reg_Ena         : out std_logic;
         Z_msb_reg_Ena         : out std_logic;
         Z_in_part_sel         : out std_logic_vector(2 downto 0)  -- lsb/mid/msb byte selection of Zin 
     --Op_code_reg_ena       : out std_logic
         );
  end component Fsm_UI;

  component Buff is
    generic (
      N : positive);
    port(Buff_in  : in  std_logic_vector(N-1 downto 0);
         Buff_OE  : in  std_logic;
         Clk      : in  std_logic;
         Reset    : in  std_logic;
         Buff_Out : out std_logic_vector(N-1 downto 0));
  end component Buff;

  component Mux2x1 is
    generic (
      N : positive);
    port (In1, In2 : in  std_logic_vector(N-1 downto 0);
          Sel      : in  std_logic;
          Mux_out  : out std_logic_vector (N-1 downto 0));
  end component Mux2x1;

  component Dmux1x3 is
    generic (
      N : positive
      );
    port(
      Input : in  std_logic_vector(N-1 downto 0);
      Sel   : in  std_logic_vector(2 downto 0);
      Out1  : out std_logic_vector(N-1 downto 0);
      Out2  : out std_logic_vector(N-1 downto 0);
      Out3  : out std_logic_vector(N-1 downto 0)
      );
  end component Dmux1x3;

  signal Z0            : std_logic_vector(N-4 downto 0);
  signal Sig_start_cal : std_logic;
  signal Sig_end_cal   : std_logic;
  signal X             : std_logic_vector(N-4 downto 0);
  signal Y             : std_logic_vector(N-4 downto 0);
  signal Sig_Z_in      : std_logic_vector(7 downto 0);
  signal Sig_Z_in_angle_conv : std_logic_vector(N-1 downto 0);
  signal Sig_attrib    : std_logic_vector(3 downto 0);

  -- buffer' input values
  signal Z_in_lsb : std_logic_vector(7 downto 0);
  signal Z_in_mid : std_logic_vector(7 downto 0);
  signal Z_in_msb : std_logic_vector(7 downto 0);

  -- buffer' output values
  signal Z_lsb : std_logic_vector(7 downto 0);
  signal Z_mid : std_logic_vector(7 downto 0);
  signal Z_msb : std_logic_vector(7 downto 0);

  -- fsm signal
  signal Sig_XY_value_sel  : std_logic;
  signal Sig_Z_lsb_reg_OE  : std_logic;
  signal Sig_Z_mid_reg_OE  : std_logic;
  signal Sig_Z_msb_reg_OE  : std_logic;
  signal Sig_Z_in_part_sel : std_logic_vector(2 downto 0);
  signal Sig_XY_msb : std_logic;

  -- cos and sin final value signal
  signal Sig_X_out : std_logic_vector(N-4 downto 0);
  signal Sig_Y_out : std_logic_vector(N-4 downto 0);

  signal Sig_XY_output : std_logic_vector(N-4 downto 0);


begin

  Cordic_core : Cordic_core_FPGA
    generic map(
      N => 16
      )
    port map (
      Z         => Z0,
      Clk       => Clk,
      Reset     => Reset,
      Start_cal => Sig_start_cal,
      End_cal   => Sig_end_cal,
      X_out     => X,
      Y_out     => Y
      );

  Angle_conversion : Angle_conv
    generic map(
      N => 19
      )
    port map(
      Clk            => Clk,
      Reset          => Reset,
      Z_in           => Sig_Z_in_angle_conv,
      Buff_OE_Cad_in => '1',
      Buff_OE_Z0     => '1',
      XY_out_cmd     => Sig_attrib,
      Z0_out         => Z0
      );

  Output_val_attrib : Sin_Cos_attribution
    generic map(
      N => 16
      )
    port map (
      Clk         => Clk,
      Reset       => Reset,
      X           => X,
      Y           => Y,
      cmd         => Sig_attrib,
      Out_reg_ena => '1',
      X_out       => Sig_X_out,
      Y_out       => Sig_Y_out
      );

  Fsm : Fsm_UI

    port map (
      Clk                   => Clk,
      Reset                 => Reset,
      Load_button           => Load_button,
      Start_button          => Start_button,
      New_calc_button       => New_calc_button,
      Toggle_display_button => Toggle_display_button,
      XY_msb                => Sig_XY_msb,
      End_cal               => Sig_end_cal,
      Led_sign              => Led_sign,
      XY_value_sel          => Sig_XY_value_sel,
      Start_cal             => Sig_start_cal,
      Z_lsb_reg_Ena         => Sig_Z_lsb_reg_OE,
      Z_mid_reg_Ena         => Sig_Z_mid_reg_OE,
      Z_msb_reg_Ena         => Sig_Z_msb_reg_OE,
      Z_in_part_sel         => Sig_Z_in_part_sel
      );

  In_buff_lsb : Buff
    generic map (
      N => 8)
    port map (
      Buff_in  => Z_in_lsb,
      Buff_OE  => Sig_Z_lsb_reg_OE,
      Clk      => Clk,
      Reset    => Reset,
      Buff_Out => Z_lsb
      );

  In_buff_mid : Buff
    generic map (
      N => 8)
    port map (
      Buff_in  => Z_in_mid,
      Buff_OE  => Sig_Z_mid_reg_OE,
      Clk      => Clk,
      Reset    => Reset,
      Buff_Out => Z_mid
      );

  In_buff_msb : Buff
    generic map (
      N => 8)
    port map (
      Buff_in  => Z_in_msb,
      Buff_OE  => Sig_Z_msb_reg_OE,
      Clk      => Clk,
      Reset    => Reset,
      Buff_Out => Z_msb
      );

  In_Dmux : Dmux1x3
    generic map (
      N => 8)
    port map (
      Input => Z_in,
      Sel   => Sig_Z_in_part_sel,
      Out1  => Z_in_lsb,
      Out2  => Z_in_mid,
      Out3  => Z_in_msb
      );

  out_Mux : Mux2x1
    generic map (
      N => 16)
    port map (
      In1     => Sig_X_out,
      In2     => Sig_Y_out,
      Sel     => Sig_XY_value_sel,
      Mux_out => Sig_XY_output
      );

  --Sig_Z_in_angle_conv <= (Z_in_msb & Z_in_mid & Z_in_lsb);
  Sig_Z_in_angle_conv(7 downto 0) <= Z_in_lsb;
  Sig_Z_in_angle_conv(15 downto 8) <= Z_in_mid;
  Sig_Z_in_angle_conv(18 downto 16) <= Z_in_msb(2 downto 0);
  Sig_Z_in      <= Z_in;                --change for bench
  --Sig_start_cal <= Start_cal;           -- change for bench
  End_cal       <= Sig_end_cal;         -- end_cal : cordic_FPGA
  Sig_XY_msb <= Sig_XY_output(N-4);
  XY_output <= Sig_XY_output; -- value to display
  
end architecture;
