------------------------------Cadran_finder--------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Cadran_finder is
  generic (
    N : positive);
  port (Z_in_mod     : in  std_logic_vector(N-1 downto 0);
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

  --component Mux4x1
  --  generic (
  --    N : positive);
  --  port (In1, In2, In3, In4 : in  std_logic_vector(N-1 downto 0);
  --        Sel                : in  std_logic_vector(1 downto 0);
  --        Mux_out            : out std_logic_vector (N-1 downto 0));
  --end component;

  --component Buff
  --  generic (
  --    N : positive);
  --  port(Buff_in  : in  std_logic_vector(N-1 downto 0);
  --       Buff_OE  : in  std_logic;
  --       Clk      : in  std_logic;
  --       Reset    : in  std_logic;
  --       Buff_Out : out std_logic_vector(N-1 downto 0));
  --end component;

  component Comparator_G
    generic (
      N : positive);

    port (A, B : in  std_logic_vector(N-1 downto 0);
          S    : out std_logic
          );
  end component;

  --component Shift_reg
  --  generic (
  --    N : positive);
  --  port (Clk           : in  std_logic;
  --        Reset         : in  std_logic;
  --        Shift_enable  : in  std_logic;
  --        Shift_reg_in  : in  std_logic_vector(N-1 downto 0);
  --        Shift_reg_out : out std_logic_vector(N-1 downto 0));
  --end component;

  --signal Comparator_A   : std_logic_vector(N-1 downto 0);  -- mux2x1 out
  signal Comparator_B         : std_logic_vector(N-1 downto 0);  -- mux4x1 out
  signal Comparator_pi_4_out  : std_logic;
  signal Comparator_3pi_4_out : std_logic;
  signal Comparator_5pi_4_out : std_logic;
  signal Comparator_7pi_4_out : std_logic;
  signal Sig_XY_cmd           : std_logic_vector(3 downto 0);

begin

  --Mux_comp : Mux4x1
  --  generic map (
  --    N => 19)
  --  port map (
  --    In1     => "0000110010010000110",  -- pi/4
  --    In2     => "0010010110110010110",  -- 3pi/4
  --    In3     => "0011111011010100110",  -- 5pi/4
  --    In4     => "0101011111110110110",  -- 7pi/4
  --    Sel     => Comp_val_sel,
  --    Mux_out => Comparator_B
  --    );

  --Mux_in : Mux2x1
  --  generic map (
  --    N => 19)
  --  port map (
  --    In1     => Z_in_mod,
  --    In2     => Buff_out,
  --    Sel     => Data_sel,
  --    Mux_out => Comparator_A
  --    );

  Comparator_pi_4 : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Z_in_mod,
      B => "0000110010010000110",
      S => Comparator_pi_4_out
      );

  Comparator_3pi_4 : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Z_in_mod,
      B => "0010010110110010110",
      S => Comparator_3pi_4_out
      );

  Comparator_5pi_4 : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Z_in_mod,
      B => "0011111011010100110",
      S => Comparator_5pi_4_out
      );

  Comparator_7pi_4 : Comparator_G
    generic map (
      N => 19)
    port map (
      A => Z_in_mod,
      B => "0101011111110110110",
      S => Comparator_7pi_4_out
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

    --Cmd_reg : Shift_reg
    --generic map (
    --  N => 4)
    --port map (
    --  Clk           => Clk,
    --  Reset         => Reset,
    --  Shift_enable  => Shift_enable,
    --  Shift_reg_in  => Comparator_out,
    --  Shift_reg_out => Reg_out
    --  );
    Sig_XY_cmd(0) <= Comparator_pi_4_out;
  Sig_XY_cmd(1) <= Comparator_3pi_4_out;
  Sig_XY_cmd(2) <= Comparator_5pi_4_out;
  Sig_XY_cmd(3) <= Comparator_7pi_4_out;
  Data_sel      <= Sig_XY_cmd;
  XY_out_cmd    <= Sig_XY_cmd;

end architecture;


