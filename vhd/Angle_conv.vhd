------------------------------Angle_conv.vhd--------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Angle_conv is
  generic (
    N : positive);
  port (Clk        : in  std_logic;
        Reset      : in  std_logic;
        Z_in       : in  std_logic_vector(N-1 downto 0);
        XY_out_cmd : out std_logic_vector(3 downto 0);
        Z0_out     : out std_logic_vector(N-4 downto 0)
        );
end Angle_conv;

architecture A of Angle_conv is

  --component Buff
  --  generic (
  --    N : positive);
  --  port(Buff_in  : in  std_logic_vector(N-1 downto 0);
  --       Buff_OE  : in  std_logic;
  --       Clk      : in  std_logic;
  --       Reset    : in  std_logic;
  --       Buff_Out : out std_logic_vector(N-1 downto 0));
  --end component;

  component Mux2x1
    generic (
      N : positive);
    port (In1, In2 : in  std_logic_vector(N-1 downto 0);
          Sel      : in  std_logic;
          Mux_out  : out std_logic_vector (N-1 downto 0));
  end component;

  component Dmux1x2
    generic (
      N : positive);
    port (in         : in  std_logic_vector(N-1 downto 0);
          Sel        : in  std_logic;
          Out1, Out2 : out std_logic_vector (N-1 downto 0));
  end component;

  component Alu
    generic (
      N : positive);
    port (
      A, B : in  std_logic_vector(N-1 downto 0);  --vrai ou pas
      Cmd  : in  std_logic;
      S    : out std_logic_vector(N-1 downto 0));
  end component;

  component Quadran_finder
    generic (
      N : positive);
    port (Clk          : in  std_logic;
          Reset        : in  std_logic;
          Z_in         : in  std_logic_vector(N-1 downto 0);
          Comp_val_sel : in  std_logic;
          Data_sel     : in  std_logic;
          XY_out_cmd   : out std_logic_vector (3 downto 0));
  end component;

  component Z0_value_calculation
    generic (
      N : positive);
    port (Clk      : in  std_logic;
          Reset    : in  std_logic;
          Z_in     : in  std_logic_vector(N-1 downto 0);
          Data_sel : in  std_logic_vector(3 downto 0);
          Z0_out   : out std_logic_vector (N-4 downto 0));
  end component;

  --N : positive := 16;
  signal Mux_out  : std_logic_vector(N-1 downto 0);
  signal Buff_out : std_logic_vector(N-1 downto 0);
  signal Alu_out  : std_logic_vector(N-1 downto 0);

begin  -- A

  Demux : Dmux1x2
  
  Mux : Mux2x1
    generic map (
      N => 16)
    port map (
      In1     => Z0,
      In2     => Alu_out,
      Sel     => Sel,
      Mux_out => Mux_out
      );

  U2 : Buff
    generic map (
      N => 16)
    port map (
      Buff_in  => Mux_out,
      Buff_Out => Buff_Out,
      Buff_OE  => In_Enable,
      Clk      => Clk,
      Reset    => Reset);

  U3 : Alu
    generic map (
      N => 16)
    port map (
      A   => Buff_Out,
      B   => Angle,
      Cmd => Sign,
      S   => Alu_out);
end A;
