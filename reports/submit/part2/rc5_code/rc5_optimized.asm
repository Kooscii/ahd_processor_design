# instruction format example
# ADD rd rs rt
# ADDI rt ts imm
# JMP addr

#########################################
#   CONSTANTS
#########################################
#   special registers:
#       r31 <- btn&sw (read-only)
#       r30 <- 7-segment led display
#       r29 <- led display
#       r28 <- btn&sw interupt register
#       r27 <- 0xffffffff
#       r26 <- rotate mask 0x001f
#       r25 <- 16 LSB mask 0xffff
#       r24 <- btn[4] mask 0x100000
#       r23 <- btn[3] mask 0x080000
#       r22 <- btn[2] mask 0x040000  
#       r21 <- btn[1] mask 0x020000
#       r20 <- btn[0] mask 0x010000
#
SUB r0 r0 r0            # r0 <- $zero
ORI r1 r0 1             # r1 <- $one
ORI r2 r0 -1            # r2 <- $minus_one
SHL r20 r1 16           # r20 <- 0x00010000
SHL r21 r20 1           # r21 <- 0x00020000
SHL r22 r21 1           # r22 <- 0x00040000
SHL r23 r22 1           # r23 <- 0x00080000
SHL r24 r23 1           # r24 <- 0x00100000
ORI r25 r0 0xffff       
SHR r25 r25 16          # r25 <- 0x0000ffff
ORI r26 r0 0x001f       # r26 <- 0x0000001f
ORI r27 r0 0xffff       # r27 <- 0xffffffff

#############################################
#   MAIN LOOP
#############################################
#   press btn[4] to rst   
#   press btn[3] to set ukey
#   press btn[2] to set din
#   press btn[1] to start encryption
#   press btn[0] to start decryption

MAIN:
SHR r28 r31 16
BNE r28 r0 MAIN                  # wait for all buttons are released

MAIN_LOOP:
# if btn[3] is pressed
AND r28 r23 r31
BNE r28 r23 1
JMP UKEY_INPUT                 # goto UKEY_INPUT subprogram
# JMP FIXED_UKEY_INPUT

# if btn[2] is pressed
AND r28 r22 r31
BNE r28 r22 1
JMP DIN_INPUT                  # goto DIN_INPUT subprogram
# JMP FIXED_DIN_INPUT

# if btn[1] is pressed
AND r28 r21 r31
BNE r28 r21 1
JMP ENCRYPTION                 # goto ENCRYPTO subprogram

# if btn[0] is pressed
AND r28 r20 r31
BNE r28 r20 1
JMP DECRYPTION                 # goto DECRYPTO subprogram

JMP MAIN_LOOP                        

#########################################
#   INPUT
#########################################
#   r10, r11 <= temporary registers
#   ukey memory offset: 50
#   din memory offset: 54

########## FIXED INPUT ##########
# ukey
FIXED_UKEY_INPUT:
ORI r11 r0 0x1946       
SHL r11 r11 16              # r11 <- 16 MSB
ANDI r10 r25 0x5f91         # r10 <- 16 LSB
OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
SW r10 r0 50                # MEM[0+50] = ukey[0]

ORI r11 r0 0x51b2       
SHL r11 r11 16              # r11 <- 16 MSB
ANDI r10 r25 0x41be         # r10 <- 16 LSB
OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
SW r10 r0 51                # MEM[1+50] = ukey[1]

ORI r11 r0 0x01a5       
SHL r11 r11 16              # r11 <- 16 MSB
ANDI r10 r25 0x5563         # r10 <- 16 LSB
OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
SW r10 r0 52                # MEM[2+50] = ukey[2]

ORI r11 r0 0x91ce       
SHL r11 r11 16              # r11 <- 16 MSB
ANDI r10 r25 0xa910         # r10 <- 16 LSB
OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
SW r10 r0 53                # MEM[3+50] = ukey[3]

JMP KEY_EXP                    # goto KEY_EXP

# # din
FIXED_DIN_INPUT:
# A
ORI r11 r0 0xeedb           
SHL r11 r11 16              # r11 <- 16 MSB
ANDI r10 r25 0xa521         # r10 <- 16 LSB
OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
SW r10 r0 54
# B
ORI r11 r0 0x6d8f           
SHL r11 r11 16              # r11 <- 16 MSB
ANDI r10 r25 0x4b15         # r10 <- 16 LSB
OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
SW r10 r0 55

JMP MAIN                       # return to main


###### Input from switches #####
#   r28 <- interupt register
#   r3 <- i
#   r4 <- 4 (upper limit of the loop)
#
#   for(r3=0; r3!=r4; r3++) {
#       wait for btn[0];
#       r10 = switches;
#       wait for btn[0];
#       r11 = switches;
#       MEM[r3+50] = (r11<<16) + r10;
#   }

#############################################
#   Subprogram: UKEY_INPUT
#############################################
UKEY_INPUT:
ORI r3 r0 3                         # i = 0
ORI r4 r0 4
LOOP_UKEY_INPUT:
AND r28 r23 r31                 # wait btn[0] release
BEQ r28 r23 -2
AND r28 r23 r31                 # wait btn[0] press
BNE r28 r23 -2
OR r11 r0 r31                   # 16 MSB
SHL r11 r11 16

AND r28 r23 r31                 # wait btn[0] release
BEQ r28 r23 -2
AND r28 r23 r31                 # wait btn[0] press
BNE r28 r23 -2
AND r10 r25 r31                 # 16 LSB

OR r10 r11 r10                  # r10 <- 16 MSB + 16 LSB
SW r10 r3 50                    # MEM[2+50] = ukey[2]

SUBI r3 r3 1                    # i -= 1
BNE r3 r2 LOOP_UKEY_INPUT       # loop until r3 = -1

JMP KEY_EXP                    # goto KEY_EXP

#############################################
#   Subprogram: DIN_INPUT
#############################################
DIN_INPUT:
ORI r3 r0 0                         # i = 0
ORI r4 r0 2
LOOP_DIN_INPUT:
AND r28 r22 r31                 # wait btn[0] release
BEQ r28 r22 -2
AND r28 r22 r31                 # wait btn[0] press
BNE r28 r22 -2
OR r11 r0 r31                   # 16 MSB
SHL r11 r11 16

AND r28 r22 r31                 # wait btn[0] release
BEQ r28 r22 -2
AND r28 r22 r31                 # wait btn[0] press
BNE r28 r22 -2
AND r10 r25 r31                 # 16 LSB

OR r10 r11 r10                  # r10 <- 16 MSB + 16 LSB
SW r10 r3 54                    # MEM[2+50] = ukey[2]

ADDI r3 r3 1                    # i += 1
BNE r3 r4 LOOP_DIN_INPUT        # loop until r3 = 2
JMP MAIN                        # return to main

#########################################
#   UKEY EXPANSION
#########################################
#   K memory offset: 50
#   S memory offset: 0
#   L memory offset: 26
#   r10, r11 <- temporary registers

KEY_EXP:
# initialize L
ORI r3 r0 3                     # i = 3
INIT_L:
LW r10 r3 50                    # r11 <- K[i]
SW r10 r3 26                    # L[i] <- K[i]
SUBI r3 r3 1                    # i -= 1
BLT r3 r2 INIT_L                # loop if r3 > -1 (3,...,0)

# P, Q
# r8, r9 <- P, Q
ORI r11 r0 0xB7E1       
SHL r11 r11 16                  # r11 <- 16 MSB
ANDI r10 r25 0x5163             # r10 <- 16 LSB
OR r8 r11 r10                   # r8 <- P = 16 MSB + 16 LSB
ORI r11 r0 0x9E37       
SHL r11 r11 16                  # r11 <- 16 MSB
ANDI r10 r25 0x79B9             # r10 <- 16 LSB
OR r9 r11 r10                   # r9 <- Q = 16 MSB + 16 LSB

# initialize S
ORI r7 r8 0                     # r7 <- S[i]; S[0] = P
SW r7 r0 0                      # MEM[0] <- S[0]
ORI r3 r0 1                     # i = 1
ORI r4 r0 26                    # loop upper bound
INIT_S:
ADD r7 r7 r9                    # S[i] <- S[i-1] + Q
SW r7 r3 0                      # MEM[i] <- S[i]
ADDI r3 r3 1                    # i += 1
BLT r4 r3 INIT_S                # loop if i < 26

# generate skey
ORI r3 r0 0                     # i
ORI r4 r0 0                     # j
ORI r5 r0 0                     # k
ORI r13 r0 26                   # i upper bound
ORI r14 r0 4                    # j upper bound
ORI r15 r0 78                   # k upper bound
ORI r8 r0 0                     # A
ORI r9 r0 0                     # B

LOOP_SKEY:
# calculate A
ADD r8 r8 r9                    # r8 <- A = A+B
LW r7 r3 0                      # r7 <- S[i]
ADD r7 r7 r8                    # r7 <- S[i] = S[i] + A + B
# rotate left
SHL r11 r7 3                    # r11 <- r7 << 3 (29 MSB)
SHR r10 r7 29                   # r10 <- r7 >> 29 (3 LSB)
OR r8 r11 r10                   # r8 <- A = rotl(S[i] + A + B, 3)
SW r8 r3 0                      # S[i] = A
# calculate B
ADD r9 r8 r9                    # r9 <- B = A+B
LW r7 r4 26                     # r7 <- L[j]
ADD r7 r7 r9                    # r7 <- L[j] = L[j] + A + B
# rotate left
ORI r6 r0 0                     # rotation counter
AND r16 r26 r9                  # A + B: 5 LSB rotation bits
OR r11 r0 r7
BEQ r0 r0 2
SHL r11 r11 1                   # r11 <- r11 << 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < rotation bits

ORI r16 r0 32                   # total rotation bits = 32
OR r10 r0 r7
BEQ r0 r0 2
SHR r10 r10 1                   # r10 <- r10 >> 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < 32

OR r9 r11 r10                   # r9 <- B = rotl(L[j] + A + B, A+B)
SW r9 r4 26                     # L[j] = B
# increment
ADDI r3 r3 1                    # i += 1
ADDI r4 r4 1                    # j += 1
BLT r13 r3 1                    # if i >= 26:
ORI r3 r0 0                     #   i = 0
BLT r14 r4 1                    # if j >= 4:
ORI r4 r0 0                     #   j = 0

ADDI r5 r5 1                    # k += 1
BLT r15 r5 LOOP_SKEY            # loop if k < 78

JMP MAIN                        # return to main


##########################################
#   ENCRYPTION
##########################################
# 
ENCRYPTION:
LW r8 r0 54                     # r8 <- A
LW r9 r0 55                     # r9 <- B
LW r7 r0 0                      # r7 <- S[0]
ADD r8 r8 r7                    # r8 <- A = A + S[0]
LW r7 r0 1                      # r7 <- S[1]
ADD r9 r9 r7                    # r9 <- B = B + S[1]

# 12 rounds
ORI r3 r0 1                     # i
ORI r13 r0 13                   # upper bound
LOOP_ENC:
SHL r4 r3 1                     # r4 <- 2*i
ADDI r5 r4 1                    # r5 <- 2*i+1

# calculate A
# XOR operation
AND r11 r8 r9                   # r11 <- A and B
NOR r11 r11 r0                  # r11 <- A nand B
ORI r10 r11 0                   # r10 <- A nand B
AND r11 r11 r9                  # r11 <- B and (A nand B)
NOR r11 r11 r0                  # r11 <- B nand (A nand B))
AND r10 r10 r8                  # r10 <- A and (A nand B)
NOR r10 r10 r0                  # r10 <- A nand (A nand B))
AND r10 r11 r10                 # r10 <- (B nand (A nand B))) and (A nand (A nand B)))
NOR r10 r10 r0                  # r10 <- (B nand (A nand B))) nand (A nand (A nand B)))
OR r11 r10 r10                  # r11 <- r10

ORI r6 r0 0                     # rotation counter
AND r16 r26 r9                  # B: 5 LSB rotation bits
BEQ r0 r0 2
SHL r11 r11 1                   # r11 <- r11 << 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < rotation bits

ORI r16 r0 32                   # total rotation bits = 32
BEQ r0 r0 2
SHR r10 r10 1                   # r10 <- r10 >> 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < 32

OR r10 r11 r10                  # r10 <- rotl(A^B, B)
LW r7 r4 0                      # r7 <- S[i*2]
ADD r8 r10 r7                   # r8 <- A = ROTL(A^B, B) + S[i*2]

# calculate B
# XOR operation
AND r11 r8 r9                   # r11 <- A and B
NOR r11 r11 r0                  # r11 <- A nand B
ORI r10 r11 0                   # r10 <- A nand B
AND r11 r11 r9                  # r11 <- B and (A nand B)
NOR r11 r11 r0                  # r11 <- B nand (A nand B))
AND r10 r10 r8                  # r10 <- A and (A nand B)
NOR r10 r10 r0                  # r10 <- A nand (A nand B))
AND r10 r11 r10                 # r10 <- (B nand (A nand B))) and (A nand (A nand B)))
NOR r10 r10 r0                  # r10 <- A^B = (B nand (A nand B))) nand (A nand (A nand B)))
OR r11 r10 r10                  # r11 <- r10

ORI r6 r0 0                     # rotation counter
AND r16 r26 r8                  # A: 5 LSB rotation bits
BEQ r0 r0 2
SHL r11 r11 1                   # r11 <- r11 << 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < rotation bits

ORI r16 r0 32                   # total rotation bits = 32
BEQ r0 r0 2
SHR r10 r10 1                   # r10 <- r10 >> 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < 32

OR r10 r11 r10                  # r10 <- rotl(A^B, A)
LW r7 r5 0                      # r7 <- S[i*2+1]
ADD r9 r10 r7                   # r9 <- B = ROTL(A^B, A) + S[i*2+1]

# increment and loop
ADDI r3 r3 1
BNE r3 r13 LOOP_ENC             # loop until i = 13

# Store enc(A) enc(B)
SW r8 r0 30
SW r9 r0 31

JMP MAIN


##########################################
#   DECRYPTION
##########################################
#
DECRYPTION:
# LOAD A_enc, B_enc
LW r8 r0 54
LW r9 r0 55

# 12 rounds
ORI r3 r0 12                    # i
LOOP_DEC:
SHL r4 r3 1                     # r4 <- 2*i
ADDI r5 r4 1                    # r5 <- 2*i+1

# calculate B
LW r7 r5 0                      # r7 <- S[i*2+1]
SUB r10 r9 r7                   # r10 <- B - S[i*2+1]
OR r11 r10 r10                  # r11 <- r10

ORI r6 r0 0                     # rotation counter
AND r16 r26 r8                  # A: 5 LSB rotation bits
BEQ r0 r0 2
SHR r10 r10 1                   # r10 <- r10 >> 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < rotation bits

ORI r16 r0 32                   # total rotation bits = 32
BEQ r0 r0 2
SHL r11 r11 1                   # r11 <- r11 << 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < 32

OR r9 r11 r10                   # r9 <- rotr(B - S[i*2+1], A)

# xor
AND r11 r8 r9                   # r11 <- A and B
NOR r11 r11 r0                  # r11 <- A nand B
ORI r10 r11 0                   # r10 <- A nand B
AND r11 r11 r9                  # r11 <- B and (A nand B)
NOR r11 r11 r0                  # r11 <- B nand (A nand B))
AND r10 r10 r8                  # r10 <- A and (A nand B)
NOR r10 r10 r0                  # r10 <- A nand (A nand B))
AND r10 r11 r10                 # r10 <- (B nand (A nand B))) and (A nand (A nand B)))
NOR r9 r10 r0                   # r9 <- B = (B nand (A nand B))) nand (A nand (A nand B)))

# calculate A
LW r7 r4 0                      # r7 <- S[i*2]
SUB r10 r8 r7                   # r10 <- A - S[i*2]
OR r11 r10 r10                  # r11 <- r10

ORI r6 r0 0                     # rotation counter
AND r16 r26 r9                  # B: 5 LSB rotation bits
BEQ r0 r0 2
SHR r10 r10 1                   # r10 <- r10 >> 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < rotation bits

ORI r16 r0 32                   # total rotation bits = 32
BEQ r0 r0 2
SHL r11 r11 1                   # r11 <- r11 << 1
ADDI r6 r6 1                    # r6 += 1
BLT r16 r6 -3                   # loop if r6 < 32

OR r8 r11 r10                   # r9 <- rotr(B - S[i*2+1], A)

# xor
AND r11 r8 r9                   # r11 <- A and B
NOR r11 r11 r0                  # r11 <- A nand B
ORI r10 r11 0                   # r10 <- A nand B
AND r11 r11 r9                  # r11 <- B and (A nand B)
NOR r11 r11 r0                  # r11 <- B nand (A nand B))
AND r10 r10 r8                  # r10 <- A and (A nand B)
NOR r10 r10 r0                  # r10 <- A nand (A nand B))
AND r10 r11 r10                 # r10 <- (B nand (A nand B))) and (A nand (A nand B)))
NOR r8 r10 r0                   # r9 <- B = (B nand (A nand B))) nand (A nand (A nand B)))

# decrement and loop
SUBI r3 r3 1
BNE r3 r0 LOOP_DEC              # loop until i = 0

LW r7 r0 1                      # r7 <- S[1]
SUB r9 r9 r7                    # r9 <- B = B - S[1]
LW r7 r0 0                      # r7 <- S[0]
SUB r8 r8 r7                  # r8 <- A = A - S[0]

# A_dec, B_dec offset 44, 45
SW r8 r0 32
SW r9 r0 33

JMP MAIN

HAL

# If everything goes right, DATA[40] = DATA[44]; DATA[41] = DATA[45]