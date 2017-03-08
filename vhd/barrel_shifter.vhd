library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;


entity barrel_shifter is
  
  generic (
    N : positive);
  port (
    Barrel_in : in std_logic_vector(N-1 downto 0);
    Shift_cmd : in std_logic_vector(LOG(2,N) downto 0); -- suppose que N est
                                                        -- multiple de 2
    Barrel_out : out std_logic_vector(N-1 downto 0));
end entity barrel_shifter;

architecture A of barrel_shifter is

begin  -- architecture A

  

end architecture A;
