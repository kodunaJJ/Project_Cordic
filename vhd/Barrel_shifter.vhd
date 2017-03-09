library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Barrel_shifter is
  
  generic (
    N : positive);
  port (
    Shifter_in : in std_logic_vector(N-1 downto 0);
    Shift_count : in std_logic_vector(N-1 downto 0);                         
    Shifter_out : out std_logic_vector(N-1 downto 0));
end entity Barrel_shifter;

architecture A of Barrel_shifter is
  
begin  -- architecture A

  Shifter_out <= std_logic_vector(shift_right(signed(Shifter_in), to_integer(unsigned(Shift_count))));
 

end architecture A;
