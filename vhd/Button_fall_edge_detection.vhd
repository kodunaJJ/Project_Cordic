library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Button_fall_edge_detection is
  port(
    Clk        : in  std_logic;
    Reset      : in  std_logic;
    Button_in  : in  std_logic;
    Button_out : out std_logic
    );
end Button_fall_edge_detection;

architecture a of Button_fall_edge_detection is

  signal Sig_Button_in  : std_logic;
  signal Sig_Button_mem : std_logic;
begin

  Sig_Button_in <= Button_in;
  process(Clk, Reset)
    begin
    if (Clk'event and Clk = '1') then
      if(Reset = '1') then
        Sig_Button_mem <= '0';
      else
        Sig_Button_mem <= Sig_Button_in;
      end if;
    end if;
    end process;
    Button_out <= (Sig_Button_mem xor Sig_Button_in) and (not Sig_Button_in);
end architecture;
