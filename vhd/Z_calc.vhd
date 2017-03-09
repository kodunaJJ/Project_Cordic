
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Z_calc is
  generic (
    N : positive := 16);
  port (
    Z0        : in  std_logic_vector(N-1 downto 0);
    Angle     : in  std_logic_vector(N-1 downto 0);
    Sel       : in  std_logic;
    Sign      : in  std_logic;
    In_Enable : in  std_logic;
    Clk       : in  std_logic;
    Reset     : in  std_logic;
    Msb       : out std_logic);
end Z_calc;

architecture A of Z_calc is

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
      A, B : in  std_logic_vector(N-1 downto 0);  --vrai ou pas
      Cmd  : in  std_logic;
      S    : out std_logic_vector(N-1 downto 0));
  end component;

  --N : positive := 16;
  signal Mux_out  : std_logic_vector(N-1 downto 0);
  signal Buff_out : std_logic_vector(N-1 downto 0);
  signal Alu_out  : std_logic_vector(N-1 downto 0);

begin  -- A

  Msb <= Mux_out(N-1);
  
  U1 : Mux2x1
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
