-----------------------------cordic_core.vhd----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cordic_core is
  generic (
    N : positive := 16);
  port(X, Y, Z      : in  std_logic_vector(N-1 downto 0);
       Clk          : in  std_logic;
       Reset        : in  std_logic;
       Start_cal    : in  std_logic;
       End_cal      : out std_logic;
       X_out, Y_out : out std_logic_vector(N-1 downto 0));
end Cordic_core;

architecture A of Cordic_core is

  component Z_calc is
    generic (
      N : positive);
    port (
      Z0        : in  std_logic_vector(N-1 downto 0);
      Angle     : in  std_logic_vector(N-1 downto 0);
      Sel       : in  std_logic;
      Sign      : in  std_logic;
      In_Enable : in  std_logic;
      Clk       : in  std_logic;
      Reset     : in  std_logic;
      Msb       : out std_logic);
  end component Z_calc;

  component XY_calc is
    generic (
      N : positive;
      P: positive);
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
      Shift_count_1 : in  std_logic_vector (P-1 downto 0);
      Shift_count_2 : in  std_logic_vector (P-1 downto 0);
      Data_n        : out std_logic_vector (N-1 downto 0)
      );
  end component XY_calc;

  component Fsm_cordic_core
    generic (
      N :positive
      );
    port(
      Clk            : in  std_logic;
      Reset          : in  std_logic;
      Start_cal      : in  std_logic;
      iteration      : in  std_logic_vector(3 downto 0);
      Counter_enable : out std_logic;
      Counter_reset  : out std_logic;
      End_cal        : out std_logic;
      Buff_IE_X_Y    : out std_logic;
      Buff_IE_Z      : out std_logic;
      Data_sel       : out std_logic;
      Rom_Address    : out std_logic_vector(3 downto 0);
      Shift_count_1  : out std_logic_vector(N-1 downto 0);  -- really
                                                          -- needed ??
      Shift_count_2  : out std_logic_vector(N-1 downto 0);
      Buff_OE        : out std_logic);
  end component;

  component Rom_atan_cordic
    port(Rom_Address : in  std_logic_vector(3 downto 0);
         Rom_out     : out std_logic_vector(15 downto 0));
  end component;

  component Counter is
    generic (
      P : positive;
      N : natural);
    port (
      Clk          : in  std_logic;
      Reset        : in  std_logic;
      Count_enable : in  std_logic;
      Count_out    : out std_logic_vector(P-1 downto 0));
  end component Counter;

  component Clock_divider is
    port (
      Reset   : in  std_logic;
      Clk     : in  std_logic;
      Clk_out : out std_logic);
  end component Clock_divider;


  --signal X_intern, Y_intern, Z_intern : std_logic_vector (15 downto 0);
  signal Data_sel_intern    : std_logic;
  --signal START_CAL_intern             : std_logic;
  --signal END_CAL_intern               : std_logic;
  signal Buff_IE_X_Y_intern : std_logic;
  signal Buff_IE_Z_intern   : std_logic;
  signal Buff_OE_intern     : std_logic;
  signal Rom_Address_intern : std_logic_vector(3 downto 0);
  signal Rom_out_intern     : std_logic_vector(15 downto 0);
  signal Buff_z_intern_out  : std_logic_vector(N-1 downto 0);  --
                                                               --preciser
                                                               --N !!!

  signal Iter_count    : std_logic_vector(3 downto 0);
  signal Shift_count_1 : std_logic_vector(4 downto 0);
  signal Shift_count_2 : std_logic_vector(4 downto 0);
  signal Sign_intern   : std_logic;
  signal Y_shifted     : std_logic_vector(N-1 downto 0);
  signal X_shifted     : std_logic_vector(N-1 downto 0);
  signal Clk_counter   : std_logic;
  signal Count_enable  : std_logic;
  signal Count_reset   : std_logic;
  signal Sign_b        : std_logic;


begin

  Sign_b <= not Sign_intern;

  U1 : Rom_atan_cordic port map (
    Rom_Address => Rom_Address_intern,
    Rom_out     => Rom_out_intern
    );

  U2 : Z_calc
    generic map (
      N => 16)
    port map (

      Clk       => Clk,
      Reset     => Reset,
      Z0        => Z,
      Angle     => Rom_out_intern,
      Sel       => Data_sel_intern,
      Sign      => Sign_b,
      In_Enable => Buff_IE_Z_intern,
      Msb       => Sign_intern
      );

  U3 : XY_calc
    generic map (
      N => 16,
      P => 5)
    port map (                          -- X calculation

      Clk           => Clk,
      Reset         => Reset,
      Data_in       => X,
      Sel           => Data_sel_intern,
      Sign          => Sign_b,
      In_Enable     => Buff_IE_X_Y_intern,
      Out_Enable    => Buff_OE_intern,
      Data_in_i     => Y_shifted,
      Data_out_i    => X_shifted,
      Shift_count_1 => Shift_count_1,
      Shift_count_2 => Shift_count_2,
      Data_n        => X_out
      );

  U4 : XY_calc
    generic map (
      N => 16,
      P => 5)
    port map (                          -- Y calculation

      Clk           => Clk,
      Reset         => Reset,
      Data_in       => Y,
      Sel           => Data_sel_intern,
      Sign          => Sign_b,
      In_Enable     => Buff_IE_X_Y_intern,
      Out_Enable    => Buff_OE_intern,
      Data_in_i     => X_shifted,
      Data_out_i    => Y_shifted,
      Shift_count_1 => Shift_count_1,
      Shift_count_2 => Shift_count_2,
      Data_n        => Y_out
      );

  U6 : Fsm_cordic_core
    generic map (
      N => 5)
    port map (
    Clk            => Clk,
    Reset          => Reset,
    Start_cal      => Start_cal,
    iteration      => Iter_count,
    Counter_enable => Count_enable,
    Counter_reset  => Count_reset,
    End_cal        => End_cal,
    Buff_IE_X_Y    => Buff_IE_X_Y_intern,
    Buff_IE_Z      => Buff_IE_Z_intern,
    Data_sel       => Data_sel_intern,
    Rom_Address    => Rom_Address_intern,
    Shift_count_1  => Shift_count_1,    
    Shift_count_2  => Shift_count_2,
    Buff_OE        => Buff_OE_intern
    );

  U7 : Clock_divider port map (
    Clk     => Clk,
    Reset   => Reset,
    Clk_out => Clk_counter
    );

  U8 : Counter
    generic map (
      P => 4, N => 16)
    port map (
      Clk          => Clk_counter,
      Reset        => Count_reset,
      Count_enable => Count_enable,
      Count_out    => Iter_count
      );


end A;

