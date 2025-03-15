# task1
A circuit for utilizing the Altera DE0 board's 7-segment displays to display hexadecimal digits 0-F based on a 4-bit input signal.  
The circuit uses a 4-bit up counter whose values are used to control which segments of the 7-segment display should light up to display the appropriate hex digit.  
`hexdisplay.vhd` contains the logic for turning on specific segments based on the input number.
