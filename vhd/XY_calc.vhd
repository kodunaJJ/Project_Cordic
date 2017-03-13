library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity XY_calc is
  generic (
    N : positive);
  port (
    Clk           : in  std_logic;
    Reset         : in  std_logic;
    Data_in       : in  std_logic_vector(N-1 downto 0);
    Sel           : in  std_logic;
    Sign          : in  std_logic;
    In_Enable     : in  std_logic;
    Out_Enable    : in  std_logic;
    Data_in_i     : in  std_logic_vector(N-1 downto 0);
    Data_out_i    : out std_logic_vector (N-1 downto 0);
    Shift_count_1 : in  std_logic_vector (3 downto 0);
    Shift_count_2 : in  std_logic_vector (3 downto 0);
    Data_n        : out std_logic_vector (N-1 downto 0)
    );
end entity XY_calc;

architecture A of XY_calc is

  component Buff
    generic (
      N : positive);
    port (
      Buff_in  : in  std_logic_vector(15 downto 0);
      Buff_OE  : in  std_logic;
      CLK      : in  std_logic;
      Reset    : in  std_logic;
      Buff_Out : out std_logic_vector(15 downto 0));
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

  component Barrel_shifter
    generic (
      N : positive);
    port(
      Shifter_in  : in  std_logic_vector (N-1 downto 0);
      Shifter_out : out std_logic_vector(N-1 downto 0);
      Shift_count : in  std_logic_vector(3 downto 0)
      );
  end component;

  signal Alu_out_2     : std_logic_vector(N-1 downto 0);
  signal Buff_in       : std_logic_vector(N-1 downto 0);   --maker 0
  signal Buff_in_2     : std_logic_vector(N-1 downto 0);   -- maker "3" pink
  signal Buff_out_1    : std_logic_vector(N-1 downto 0);   -- maker "1" pink
  signal Shifter_out_2 : std_logic_vector(N-1 downto 0);   -- maker "2" pink
  signal A_2           : std_logic_vector (N-1 downto 0);  -- maker "4" pink
  signal Buff_in_3     : std_logic_vector(N-1 downto 0);   -- maker "5" pink 
  signal Shifter_out_1 : std_logic_vector (N-1 downto 0);
begin  -- A
  U1 : Mux2x1
    generic map(N => 16)
    port map (
      In1     => Data_in,
      In2     => Buff_in_3,
      Sel     => Sel,
      Mux_out => Buff_in);

  U2 : Buff
    generic map (N => 16)
    port map (
      Buff_in  => Buff_in,
      Buff_Out => Buff_out_1,
      Buff_OE  => In_Enable,
      Clk      => Clk,
      Reset    => Reset
      );

  U3 : Barrel_shifter                   -- Shifter i in the shematic
    generic map (N => 16)
    port map (
      Shifter_in  => Buff_out_1,
      Shifter_out => Shifter_out_1,
      Shift_count => Shift_count_1);

  U4 : Barrel_shifter                   -- Shifter "i+2" in the shematic
    generic map (N => 16)
    port map (
      Shifter_in  => Shifter_out_1,
      Shifter_out => Shifter_out_2,
      Shift_count => Shift_count_2
      );

  U5 : Alu                              -- ALU 1 in the shematic
    generic map (N => 16)
    port map (
      A   => Buff_out_1,
      B   => Shifter_out_2,
      Cmd => '1',
      S   => Buff_in_2);

  U6 : Buff                             -- ALU 1 Buffer
    generic map (N => 16)
    port map (
      Buff_in  => Buff_in_2,
      Buff_out => A_2,
      Buff_OE  => '1',
      Clk      => Clk,
      Reset    => Reset
      );

  U7 : ALU                              -- ALU 2 
    generic map (N => 16)
    port map (
      A   => A_2,
      B   => Data_in_i,
      Cmd => Sign,
      S   => Buff_in_3
      );
  U8 : Buff                             --  Output Buffer
    generic map (N => 16)
    port map (
      Buff_in  => A_2,
      Buff_out => Data_n,
      Buff_OE  => Out_Enable,
      Clk      => Clk,
      Reset    => Reset);

  Data_out_i <= Shifter_out_1;
end A;
