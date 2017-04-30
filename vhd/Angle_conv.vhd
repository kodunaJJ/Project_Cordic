------------------------------Angle_conv.vhd--------------------------------

-- CONVERT AN ANGLE GIVEN IN RADIANS UNIT BETWEEN -2pi/2pi TO -pi/4,pi/4
-- AND GENERATE SIGNALS CMD TO TRANSFORM THE RESULT AT THE END WITH
-- SIN_COS_ATTRIBUTION

----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Angle_conv is
  generic (
    N : positive -- data size
    );
  port (Clk            : in  std_logic;
        Reset          : in  std_logic;
        Z_in           : in  std_logic_vector(N-1 downto 0);
        Buff_OE_Cad_in : in  std_logic;
        Buff_OE_Z0     : in  std_logic;
        XY_out_cmd     : out std_logic_vector(3 downto 0);
        Z0_out         : out std_logic_vector(N-4 downto 0)
        );
end Angle_conv;

architecture A of Angle_conv is

  component Buff
    generic (
      N : positive);
    port(Buff_in  : in  std_logic_vector(N-1 downto 0);
         Buff_OE  : in  std_logic;
         Clk      : in  std_logic;
         Reset    : in  std_logic;
         Buff_Out : out std_logic_vector(N-1 downto 0));
  end component;

  component Mux2x1
    generic (
      N : positive);
    port (In1, In2 : in  std_logic_vector(N-1 downto 0);
          Sel      : in  std_logic;
          Mux_out  : out std_logic_vector (N-1 downto 0));
  end component;

  component Alu
    generic (
      N : positive);
    port (
      A, B : in  std_logic_vector(N-1 downto 0);
      Cmd  : in  std_logic;
      S    : out std_logic_vector(N-1 downto 0));
  end component;

  component Cadran_finder
    generic (
      N : positive);
    port (Z_in_mod     : in  std_logic_vector(N-1 downto 0);
          Data_sel     : out std_logic_vector(3 downto 0);
          XY_out_cmd   : out std_logic_vector (3 downto 0));
  end component;

  component Z0_value_calculation
    generic (
      N : positive);
    port (Clk      : in  std_logic;
          Reset    : in  std_logic;
          Z_in_mod : in  std_logic_vector(N-1 downto 0);
          Data_sel : in  std_logic_vector(3 downto 0);
          Buff_OE  : in  std_logic;
          Z_conv   : out std_logic_vector (N-4 downto 0));
  end component;

  --N : positive := 16;
  signal Mux_out  : std_logic_vector(N-1 downto 0);
  signal Buff_out : std_logic_vector(N-1 downto 0);
  signal Alu_out  : std_logic_vector(N-1 downto 0);
  signal Sig_data_sel : std_logic_vector(3 downto 0);

begin  -- A

  Mux : Mux2x1
    generic map (
      N => 19)
    port map (
      In1     => Z_in,
      In2     => Alu_out,
      Sel     => Z_in(N-1),
      Mux_out => Mux_out
      );

  Cad_in_buff : Buff
    generic map (
      N => 19)
    port map (
      Buff_in  => Mux_out,
      Buff_Out => Buff_Out,
      Buff_OE  => Buff_OE_Cad_in,
      Clk      => Clk,
      Reset    => Reset);

  Z_mod_calc : Alu
    generic map (
      N => 19)
    port map (
      A   => Z_in,
      B   => "0110010010000111110",     -- 2pi
      Cmd => '0',
      S   => Alu_out);

  Cad_find : Cadran_finder
    generic map (
      N => 19)
    port map (
      Z_in_mod     => Buff_Out,
      Data_sel     => Sig_data_sel, 
      XY_out_cmd   => XY_out_cmd
      );

  Z0_val_calc : Z0_value_calculation
    generic map (
      N => 19)
    port map (
      Clk      => Clk,
      Reset    => Reset,
      Z_in_mod => Buff_Out,
      Data_sel => Sig_data_sel,
      Buff_OE  => Buff_OE_Z0,
      Z_conv   => Z0_out
      );

end A;
