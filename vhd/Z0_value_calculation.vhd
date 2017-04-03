-----------------------------Z0_value_calculation--------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Z0_value_calculation is
  generic (
    N : positive);
  port (Clk      : in  std_logic;
        Reset    : in  std_logic;
        Z_in_mod : in  std_logic_vector(N-1 downto 0);
        Data_sel : in  std_logic_vector(3 downto 0);
        Buff_OE  : in  std_logic;
        Z_conv   : out std_logic_vector (N-4 downto 0));
end entity;


architecture A of Z0_value_calculation is

  component Mux4x1
    generic (
      N : positive);
    port (In1, In2, In3, In4 : in  std_logic_vector(N-1 downto 0);
          Sel                : in  std_logic_vector(1 downto 0);
          Mux_out            : out std_logic_vector (N-1 downto 0));
  end component;

  component Alu
    generic (
      N : positive);
    port (
      A, B : in  std_logic_vector(N-1 downto 0);  --vrai ou pas
      Cmd  : in  std_logic;
      S    : out std_logic_vector(N-1 downto 0));
  end component;

  component Buff
    generic (
      N : positive);
    port(Buff_in  : in  std_logic_vector(N-1 downto 0);
         Buff_OE  : in  std_logic;
         Clk      : in  std_logic;
         Reset    : in  std_logic;
         Buff_Out : out std_logic_vector(N-1 downto 0));
  end component;


  signal Alu_out : std_logic_vector(N-1 downto 0);
  signal Alu_A   : std_logic_vector(N-1 downto 0);  -- Z_in (op1)
  signal Alu_B   : std_logic_vector(N-1 downto 0);  -- mux_out (op2)
  signal Sig_data_sel : std_logic_vector(1 downto 0);

begin

  Mux : Mux4x1
    generic map (
      N => 19)
    port map (
      In1     => (others => '0'),
      In2     => "0001100100100001110",  -- pi/2
      In3     => "0011001001000011110",  -- pi
      In4     => "0100101101100101110",  -- 3pi/2
      Sel     => Sig_data_sel,
      Mux_out => Alu_B
      );

  Alu_sub : Alu
    generic map (
      N => 19)
    port map (
      A   => Alu_A,
      B   => Alu_B,
      Cmd => '1',
      S   => Alu_out);

  Out_buff : Buff
    generic map (
      N => 16)
    port map (
      Buff_in  => Alu_out(N-4 downto 0),
      Buff_OE  => Buff_OE,
      Clk      => Clk,
      Reset    => Reset,
      Buff_Out => Z_conv
      );
  
    Alu_A <= Z_in_mod; -- op1 affectation

end architecture;
