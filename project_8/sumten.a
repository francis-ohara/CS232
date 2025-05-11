# setup
MOVEI 1 RA
MOVEI 0 RB
MOVEI 2 RC
MOVEI 10 RD

# loop
loop:
ADD RA RB RB
ADD RA RC RA
ADD ONES RD RD
BRAZ breakout
BRA loop

breakout: # RB contains the sum
OPORT RB