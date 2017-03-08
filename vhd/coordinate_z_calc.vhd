library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity coordinate_z_calc is
  
  port (
    Z0        : in  std_logic_vector(15 downto 0);
    Angle     : in  std_logic_vector(15 downto 0);
    Sel       : in  std_logic;
    Sign      : in  std_logic;
    In_Enable : in  std_logic;
    Msb       : out std_logic);
end coordinate_z_calc;

architecture A of coordinate_z_calc is

  component buff
    port(Buff_in  : in  std_logic_vector(15 downto 0);
         Buff_OE  : in  std_logic;
         CLK      : in  std_logic;
         Reset    : in  std_logic;
         Buff_Out : out std_logic_vector(15 downto 0)) ;
  end component;

  component mux2x1
    port (in1 , in2 : in  std_logic_vector(15 downto 0);
          sel       : in  std_logic_vector(15 downto 0);
          mux_out   : out std_logic_vector (15 downto 0)); 
  end component;

  component Alu
    port (
      A, B : in  std_logic_vector(15 downto 0);  --vrai ou pas
      cmd  : in  std_logic;
      S    : out std_logic_vector(15 downto 0));
  end component;

  signal Mux_out  : std_logic_vector(15 downto 0);
  signal Buff_out : std_logic_vector(15 downto 0);
  signal Alu_out  : std_logic_vector(15 downto 0);

begin  -- A

U1 : mux2x1 port map (
  in1 => Z0,
  in2 => Alu_out,
  sel => Sign,
  mux_out => Buff_in
  );

U2 : buff port map (
  Buff_in  => mux_out,
  Buff_Out => A,
  Buff_OE  => In_Enable);

U3: ALU port map (
  A => Buff_Out,
  B => Angle,
  cmd => sign,
  S => in2); 
end A;
