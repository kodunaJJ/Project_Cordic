------------------------------Cadran_finder--------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Cadran_finder is
  generic (
    N : positive);
  port (Clk          : in  std_logic;
        Reset        : in  std_logic;
        Z_in_mod     : in  std_logic_vector(N-1 downto 0);
        Comp_val_sel : in  std_logic_vector(1 downto 0);
        Shift_enable : in  std_logic;
        Data_sel     : out std_logic_vector(3 downto 0);
        XY_out_cmd   : out std_logic_vector (3 downto 0));
end Cadran_finder;

architecture A of Cadran_finder is

  --component Mux2x1
  --  generic (
  --    N : positive);
  --  port (In1, In2 : in  std_logic_vector(N-1 downto 0);
  --        Sel      : in  std_logic;
  --        Mux_out  : out std_logic_vector (N-1 downto 0));
  --end component;

  component Mux4x1
    generic (
      N : positive);
    port (In1, In2, In3, In4 : in  std_logic_vector(N-1 downto 0);
          Sel                : in  std_logic_vector(1 downto 0);
          Mux_out            : out std_logic_vector (N-1 downto 0));
  end component;

  --component Buff
  --  generic (
  --    N : positive);
  --  port(Buff_in  : in  std_logic_vector(N-1 downto 0);
  --       Buff_OE  : in  std_logic;
  --       Clk      : in  std_logic;
  --       Reset    : in  std_logic;
  --       Buff_Out : out std_logic_vector(N-1 downto 0));
  --end component;

  component Comparator_GE
    generic (
      N : positive);

    port (A, B : in  std_logic_vector(N-1 downto 0);
          S    : out std_logic;
          );
  end component;

  component Shift_reg
    generic (
      N : positive);
    port (Clk           : in  std_logic;
          Reset         : in  std_logic;
          Shift_enable  : in  std_logic;
          Shift_reg_in  : in  std_logic_vector(N-1 downto 0);
          Shift_reg_out : out std_logic_vector(N-1 downto 0));
  end component;

  --signal Comparator_A   : std_logic_vector(N-1 downto 0);  -- mux2x1 out
  signal Comparator_B   : std_logic_vector(N-1 downto 0);  -- mux4x1 out
  signal Comparator_out : std_logic_vector(N-1 downto 0);
  signal Reg_out       : std_logic_vector(4 downto 0);
begin

  Mux_comp : Mux4x1
    generic map (
      N => 19)
    port map (
      In1     => "0000110010010000110",  -- pi/4
      In2     => "0010010110110010110",  -- 3pi/4
      In3     => "0011111011010100110",  -- 5pi/4
      In4     => "0101011111110110110",  -- 7pi/4
      Sel     => Comp_val_sel,
      Mux_out => Comparator_B
      );

  --Mux_in : Mux2x1
  --  generic map (
  --    N => 19)
  --  port map (
  --    In1     => Z_in_mod,
  --    In2     => Buff_out,
  --    Sel     => Data_sel,
  --    Mux_out => Comparator_A
  --    );

  Comparator : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Z_in_mod,
      B => Comparator_B,
      S => Comparator_out
      );

  --Buff : Buff
  --  generic map (
  --    N => 19)
  --  port map (
  --    Buff_in  => Comparator_out,
  --    Buff_OE  => '1',
  --    Clk      => Clk,
  --    Reset    => Reset,
  --    Buff_Out => Buff_Out
  --    );

  Cmd_reg : Shift_reg
    generic map (
      N => 4)
    port map (
      Clk           => Clk,
      Reset         => Reset,
      Shift_enable  => Shift_enable,
      Shift_reg_in  => Comparator_out,
      Shift_reg_out => Reg_out
      );

  Data_sel <= Reg_out;
  XY_out_cmd <= Reg_out;

end architecture;


