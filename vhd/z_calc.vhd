library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity z_calc is
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
end z_calc;

architecture A of z_calc is

  component buff
    generic (
      N : positive);
    port(Buff_in  : in  std_logic_vector(N-1 downto 0);
         Buff_OE  : in  std_logic;
         Clk      : in  std_logic;
         Reset    : in  std_logic;
         Buff_Out : out std_logic_vector(N-1 downto 0));
  end component;

  component mux2x1
    generic (
      N : positive);
    port (IN1, IN2 : in  std_logic_vector(N-1 downto 0);
          SEL      : in  std_logic;
          Mux_out  : out std_logic_vector (N-1 downto 0));
  end component;


  component Alu
    generic (
      N : positive);
    port (
      A, B : in  std_logic_vector(N-1 downto 0);  --vrai ou pas
      CMD  : in  std_logic;
      S    : out std_logic_vector(N-1 downto 0));
  end component;

  --N : positive := 16;
  signal Mux_out  : std_logic_vector(N-1 downto 0);
  signal Buff_out : std_logic_vector(N-1 downto 0);
  signal Alu_out  : std_logic_vector(N-1 downto 0);

begin  -- A

  Msb <= Mux_out(N-1);
  
  U1 : mux2x1
    generic map (
      N => 16)
    port map (
      IN1     => Z0,
      IN2     => Alu_out,
      SEL     => Sel,
      Mux_out => Mux_out
      );

  U2 : buff
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
      CMD => sign,
      S   => Alu_out);
end A;
