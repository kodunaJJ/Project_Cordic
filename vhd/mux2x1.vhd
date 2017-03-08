library ieee;
use ieee.std_logic_1164.all;

entity mux2x1 is

  generic (
    N : positive);

  port (
    IN1     : in  std_logic_vector(N-1 downto 0);
    IN2     : in  std_logic_vector(N-1 downto 0);
    SEL     : in  std_logic;
    Mux_out : out std_logic_vector(N-1 downto 0));

end entity mux2x1;

architecture A of mux2x1 is

begin  -- architecture A

  Mux_out <= IN2 when (SEL = '1') else IN1;

end architecture A;
