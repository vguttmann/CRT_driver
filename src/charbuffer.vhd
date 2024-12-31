library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity charbuffer is
  port (
    -- Clock Frequency 27 MHz - adjust elsewhere?
    i_clock             : in std_logic;
    i_new_char          : in std_logic;
    i_ps2_code          : in std_logic_vector(7 downto 0);
    -- deciding how to drive those once the frame layout is clear
    -- o_char_ver_counter  : out std_logic_vector(7 downto 0);
    -- o_char_hor_counter  : out std_logic_vector(7 downto 0);
    o_pixel_hor_counter : out std_logic_vector(9 downto 0);
    o_pixel_ver_counter : out std_logic_vector(9 downto 0);
    o_blank_ver         : out std_logic;
    o_blank_hor         : out std_logic;
    o_outpu_ena         : out std_logic
    );
end charbuffer;
 