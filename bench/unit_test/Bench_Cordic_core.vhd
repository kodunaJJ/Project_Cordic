library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;
use lib_VHDL.Cordic_core;

entity Cordic_core_test is

  generic (
    N : positive := 16);

end entity Cordic_core_test;

architecture A of Cordic_core_test is

  component Cordic_core is
    generic (
      N : positive := 16);
    port(X, Y, Z      : in  std_logic_vector(N-1 downto 0);
         Clk          : in  std_logic;
         Reset        : in  std_logic;
         Start_cal    : in  std_logic;
         End_cal      : out std_logic;
         X_out, Y_out : out std_logic_vector(N-1 downto 0));
  end component Cordic_core;

  constant Clk_period    : time := 2 ns;
  constant Simu_duration : time := 100*Clk_period;

  signal Sig_Clk       : std_logic := '1';
  signal Sig_Reset     : std_logic;
  signal Sig_Start_cal : std_logic;
  signal Sig_X_in      : std_logic_vector(N-1 downto 0);
  signal Sig_Y_in      : std_logic_vector(N-1 downto 0);
  signal Sig_Z_in      : std_logic_vector(N-1 downto 0);
  signal Sig_End_cal   : std_logic;
  signal Sig_X_out     : std_logic_vector(N-1 downto 0);
  signal Sig_Y_out     : std_logic_vector(N-1 downto 0);


begin  -- architecture A
  
  Cordic_core_test : Cordic_core
    generic map (
      N => 16)
    port map (
      X         => Sig_X_in,
      Y         => Sig_Y_in,
      Z         => Sig_Z_in,
      Clk       => Sig_Clk,
      Reset     => Sig_Reset,
      Start_cal => Sig_Start_cal,
      End_cal   => Sig_End_cal,
      X_out     => Sig_X_out,
      Y_out     => Sig_Y_out);

  Sig_Clk <= not Sig_Clk after Clk_period;

  process
  begin

    Sig_Reset     <= '1';
    Sig_Start_cal <= '0';
    Sig_X_in      <= "0011101100000000";                -- 0.9219 value
    Sig_Y_in      <= (others => '0');
    Sig_Z_in      <= "0000000000000000";                -- angle value
    wait for 3*Clk_period;

    Sig_Reset <= '0';
    wait for Clk_period;

    Sig_Start_cal <= '1';
    wait for 2*Clk_period;

    Sig_Start_cal <= '0';
    wait for Simu_duration;
    Sig_Start_cal <= '1';
    Sig_Z_in      <= "0110010010000110";
    wait for 2*Clk_period;
    Sig_Start_cal <= '0';
    wait for Simu_duration; 

    assert false report "END OF SIMULATION" severity failure;
  end process;


end architecture A;
