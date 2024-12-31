library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity primary_counter is
  port (
    -- Clock Frequency 27 MHz - adjust elsewhere?
    i_clock             : in  std_logic;
   
    o_pixel_hor_counter : out std_logic_vector(9 downto 0);
    o_pixel_ver_counter : out std_logic_vector(9 downto 0);
    o_blank_ver         : out std_logic;
    o_blank_hor         : out std_logic;
    o_outpu_ena         : out std_logic
    );
end primary_counter;
 
architecture rtl of primary_counter is
 
  constant c_char_lin   : natural := 12;
  constant c_char_col   : natural := 7;

  constant c_pixl_lin   : natural := 800;
  constant c_fron_po_ho : natural := 16;
  constant c_back_po_ho : natural := 48;
  constant c_sync_horiz : natural := 96;

  constant c_lins_frame : natural := 525;
  constant c_fron_po_ve : natural := 10;
  constant c_back_po_ve : natural := 33;
  constant c_sync_verti : natural := 2;

  constant c_fram_px_ho : natural := c_pixl_lin - (c_fron_po_ho + c_back_po_ho + c_sync_horiz);
  constant c_fram_px_ve : natural := c_pixl_lin - (c_fron_po_ve + c_back_po_ve + c_sync_verti);

 
  -- These signals will be the counters:
  signal r_cnt_hor  : natural range 0 to c_pixl_lin;
  signal r_cnt_ver  : natural range 0 to c_lins_frame;
   
begin
 
 
  p_counter : process (i_clock) is
  begin
    if rising_edge(i_clock) then
      -- Counter section

      -- Horizontal and vertical pixel counters
      if r_cnt_hor = c_pixl_lin - 1 then
        r_cnt_hor <= 0;
        r_cnt_ver <= r_cnt_ver + 1;
      else
        r_cnt_hor <= r_cnt_hor + 1;
      end if;
      if r_cnt_ver = c_lins_frame - 1 then
        r_cnt_ver <= 0;
      end if;

      if r_cnt_hor = c_pixl_lin - 1 then
        r_cnt_hor <= 0;
        r_cnt_ver <= r_cnt_ver + 1;
      else
        r_cnt_hor <= r_cnt_hor + 1;
      end if;


      -- Binary signal section

      -- Character Driver Output Enable
      if r_cnt_hor > c_fram_px_ho or r_cnt_ver > c_fram_px_ve then
        o_outpu_ena <= '0';
      else
        o_outpu_ena <= '1';
      end if;

      -- Horizontal blanking pulse
      if r_cnt_hor > c_fram_px_ho + c_back_po_ho and r_cnt_hor < c_fram_px_ho + c_fron_po_ho + c_sync_horiz then
        o_blank_hor <= '1';
      else
        o_blank_hor <= '0';
      end if;
      
      -- Vertical blanking pulse
      if r_cnt_ver > c_fram_px_ve + c_back_po_ve and r_cnt_ver < c_fram_px_ve + c_fron_po_ve + c_sync_verti then
        o_blank_ver <= '1';
      else
        o_blank_ver <= '0';
      end if;
      o_pixel_hor_counter <= std_logic_vector(to_unsigned(r_cnt_hor, 10));
      o_pixel_ver_counter <= std_logic_vector(to_unsigned(r_cnt_ver, 10));
    end if;
  end process p_counter;
 
 
end rtl;