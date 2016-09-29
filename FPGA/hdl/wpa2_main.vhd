--------------------------------------------------------------------------------
--                        wpa2_main.vhd
--    Master file, starting at PBKDF2 and cascading down
--    Copyright (C) 2016  Jarrett Rainier
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.sha1_pkg.all;


entity wpa2_main is

port(
    clk_i           : in    std_ulogic;
    rst_i           : in    std_ulogic;
    cont_i          : in    std_ulogic;
    ssid_dat_i      : in    w_input;
    data_dat_i      : in    w_input;
    pke_dat_i       : in    w_input;
    mic_dat_i       : in    w_input;
    pmk_dat_o       : out   w_output;
    pmk_valid_o     : out   std_ulogic
    );
end wpa2_main;

architecture RTL of wpa2_main is
    
    -- Fixed input format for benchmarking
    -- Generates sample passwords of ten ascii digits, 0-f
    component gen_tenhex
    port(
        clk_i          : in    std_ulogic;
        rst_i          : in    std_ulogic;
        complete_o     : out    std_ulogic;
        dat_mk_o       : out    mk_data
    );
    end component;
    
    
    signal w: w_input;
    signal w_temp: w_input;
    
    signal mk: w_input;
    signal pmk: w_input;

begin
    process(clk_i)   
    begin
        if (clk_i'event and clk_i = '1') then
            if rst_i = '1' then
                pmk_valid_o <= '0';
            else
                if cont_i = '1' then
                    i <= 0;
                else
                    i <= i + 1;
                end if;
            end if;
        end if;
    end process;
    


end RTL; 