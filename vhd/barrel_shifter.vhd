library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity barrel_shifter is
  
  generic (
    N : positive);
  port (
    Shifter_in : in std_logic_vector(N-1 downto 0);
    Shift_count : in std_logic_vector(N-1 downto 0);                         
    Shifter_out : out std_logic_vector(N-1 downto 0));
end entity barrel_shifter;

architecture A of barrel_shifter is

  --signal bit_fill : std_logic_vector(to_integer(unsigned(Shift_count))-1 downto 0) ;
  
begin  -- architecture A

  --if Shifter_in(N-1) = '1' then bit_fill <= (others => '1');
  --else
    --bit_fill <= (others => '0');
  --end if;
  
  --Shifter_out <= (bit_fill & ( Shifter_in(N-1 downto to_integer(unsigned(Shift_count))))); --
  --ok ??
  --Shifter_out <= Shifter_in sra 2;--to_integer(unsigned(Shift_count));
  Shifter_out <= std_logic_vector(shift_right(signed(Shifter_in), to_integer(unsigned(Shift_count))));
 

end architecture A;
