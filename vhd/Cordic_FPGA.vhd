-----------------------------cordic_FPGA.vhd-------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cordic_FPGA is
  generic (
    N : positive := 19);
  port(
    Z_in         : in  std_logic_vector(N-1 downto 0);  --change for bench
    Clk          : in  std_logic;
    Reset        : in  std_logic;
    Start_conv   : in  std_logic;
    Start_cal    : in  std_logic; -- change for bench
    End_cal      : out std_logic;
    X_out, Y_out : out std_logic_vector(N-4 downto 0)
    );
end Cordic_FPGA;

architecture A of Cordic_FPGA is

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

  --component Fsm_FPGA_interface is


  --end Fsm_FPGA_interface;

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
      Sel   : in  std_logic_vector(1 downto 0);
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
  signal Sig_Z_in      : std_logic_vector(N-1 downto 0);
  signal Sig_attrib    : std_logic_vector(3 downto 0);

  -- buffer' input values
  signal Z_in_lsb : std_logic_vector(7 downto 0);
  signal Z_in_mid : std_logic_vector(7 downto 0);
  signal Z_in_msb : std_logic_vector(7 downto 0);

  -- buffer' output values
  signal Z_lsb : std_logic_vector(7 downto 0);
  signal Z_mid : std_logic_vector(7 downto 0);
  signal Z_msb : std_logic_vector(7 downto 0);

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
      Z_in           => Sig_Z_in,
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
      X_out       => X_out,
      Y_out       => Y_out
      );

  --Fsm : Fsm_FPGA_interface
  --  generic map (

  --    )
  --  port map (

  --    );

  --In_buff_lsb : Buff
  --  generic map (
  --    N => 8)
  --  port map (
  --    Buff_in  => Z_in_lsb,
  --    Buff_OE  => ,
  --    Clk      => Clk,
  --    Reset    => Reset,
  --    Buff_Out => Z_lsb
  --    );

  --In_buff_mid : Buff
  --  generic map (
  --    N => 8)
  --  port map (
  --    Buff_in  => Z_in_mid,
  --    Buff_OE  => ,
  --    Clk      => Clk,
  --    Reset    => Reset,
  --    Buff_Out => Z_mid
  --    );

  --In_buff_msb : Buff
  --  generic map (
  --    N => 8)
  --  port map (
  --    Buff_in  => Z_in_msb,
  --    Buff_OE  => ,
  --    Clk      => Clk,
  --    Reset    => Reset,
  --    Buff_Out => Z_msb
  --    );

  --In_Dmux : Dmux1x3
  --  generic map (
  --    N => 8)
  --  port map (
  --    Input => Z_in,
  --    Sel   => Data_dest,
  --    Out1  => Z_in_lsb,
  --    Out2  => Z_in_mid,
  --    Out3  => Z_in_msb
  --    );

  --Sig_Z_in <= Z_in_msb & Z_in_mid & Z_in_lsb;
  Sig_Z_in <= Z_in;                     --change for bench
  Sig_start_cal <= Start_cal;           -- change for bench
  End_cal <= Sig_end_cal; -- end_cal : cordic_FPGA
end architecture;
