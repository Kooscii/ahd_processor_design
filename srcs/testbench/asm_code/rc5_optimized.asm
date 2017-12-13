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
#       r27 <- 16 MSB mask 0xffff0000
#       r26 <- rotate mask 0x0000001f
#       r25 <- 16 LSB mask 0x0000ffff
#       r24 <- btn[4] mask 0x00100000
#       r23 <- btn[3] mask 0x00080000
#       r22 <- btn[2] mask 0x00040000  
#       r21 <- btn[1] mask 0x00020000
#       r20 <- btn[0] mask 0x00010000
#       
#       for leds
#       data[90] <- 1 << 0
#       data[91] <- 1 << 1
#       data[92] <- 1 << 2
#       data[93] <- 1 << 3
#       data[94] <- 1 << 4
#       data[95] <- 1 << 5
#       data[96] <- 1 << 6
#       data[97] <- 1 << 7
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
SHL r27 r25 16          # r27 <- 0xffff0000
ORI r3 r0 8
ORI r4 r0 0x100
SHR r4 r4 1
SUBI r3 r3 1
SW r4 r3 90             # data[90+i] <- 1 << i
BNE r3 r0 -4            

#############################################
#   MAIN LOOP
#############################################
#   btn[4]/btnD: Back
#   btn[3]/btnR: Right
#   btn[2]/btnL: Left
#   btn[1]/btnU: not used
#   btn[0]/btnC: OK
#   
#   Main menu:
#   FFFF0001: set ukey
#   FFFF0002: set Din
#   FFFF0003: encryption
#   FFFF0004: decryption

ORI r19 r0 1                    # r19 <- main menu index
ORI r18 r0 0                    # r18 <- rc5 state

MAIN:
SHR r28 r31 16
BNE r28 r0 MAIN                 # wait for all buttons being released
ORI r29 r0 0                    # turn off led
ORI r17 r0 5                    # menu index upper bound

MAIN_LOOP:
OR r30 r18 r19                  # diplay menu index

CHECK_BTNL:
AND r28 r22 r31
BNE r28 r22 CHECK_BTNR          # if not pressed, check next btn
SUBI r19 r19 1                  # if pressed
BNE r19 r0 1                   
SUBI r19 r17 1                  # if index out of range, reset it
OR r30 r18 r19                  # diplay menu index
AND r28 r22 r31                 # wait release
BEQ r28 r22 -2

CHECK_BTNR:
AND r28 r23 r31
BNE r28 r23 CHECK_BTNC          # if not pressed, check next btn
ADDI r19 r19 1                  # if pressed
BNE r19 r17 1                   
ADDI r19 r0 1                  # if index out of range, reset it
OR r30 r18 r19                  # diplay menu index
AND r28 r23 r31                 # wait release
BEQ r28 r23 -2

CHECK_BTNC:
AND r28 r20 r31
BNE r28 r20 CHECK_END           # if not pressed, check next btn

ORI r10 r0 1
BNE r19 r10 1                   # check if index = 1 (KEY_EXP)
JMP UKEY_INPUT

ORI r10 r0 2
BNE r19 r10 1                   # check if index = 2 (DIN_INPUT)
JMP DIN_INPUT

ORI r10 r0 3
BNE r19 r10 1                   # check if index = 3 (ENCRYPTION)
JMP ENCRYPTION

ORI r10 r0 4
BNE r19 r10 1                   # check if index = 4 (DECRYPTION)
JMP DECRYPTION

CHECK_END:
JMP MAIN_LOOP      


#########################################
#   INPUT
#########################################
#   Input from switches
#
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
#   data[60] ... data[67] ukey: 8 * 16 bits 
#   data[50] ... data[53] ukey: 4 * 32 bits
UKEY_INPUT:
SHR r28 r31 16
BNE r28 r0 UKEY_INPUT                 # wait for all buttons being released

# 16-bit first
ORI r3 r0 7                     # i = 7
ORI r13 r0 7                    # upper bound
ORI r17 r0 0                    # previou pressed btn 
LOOP_UKEY_INPUT:
# refresh display
AND r11 r25 r31                 # r11 <- switches
SHL r11 r11 16                  # r11 <- r11 << 16
LW r10 r3 60                    # r10 <- data[60 + i]
OR r30 r11 r10                  # display r11&r10 (switches&current_value)
LW r29 r3 90                    # turn on led(i)

# wait until preivous pressed btn is released
AND r28 r17 r31                 # get state of preivous pressed btn
BNE r28 r0 -2                   # loop
ORI r17 r0 0                    # no btn being pressed

UKEY_CHECK_BTNL:
AND r28 r22 r31
BNE r28 r22 UKEY_CHECK_BTNR     # if not pressed, check next btn
BEQ r3 r13 1                    # if r3=7, skip r3+=1
ADDI r3 r3 1             
ORI r17 r22 0                   # set previous pressed btn to btnL  
JMP LOOP_UKEY_INPUT

UKEY_CHECK_BTNR:
AND r28 r23 r31
BNE r28 r23 UKEY_CHECK_BTNC     # if not pressed, check next btn
BEQ r3 r0 1                     # if r3=0, skip r3-=1
SUBI r3 r3 1             
ORI r17 r23 0                   # set previous pressed btn to btnR  
JMP LOOP_UKEY_INPUT

UKEY_CHECK_BTNC:
AND r28 r20 r31
BNE r28 r20 UKEY_CHECK_BTND     # if not pressed, check next btn
AND r10 r25 r31                 # r10 <- switches
SW r10 r3 60                    # data[60+i] <- r10
ORI r17 r20 0                   # set previous pressed btn to btnC  
JMP LOOP_UKEY_INPUT

UKEY_CHECK_BTND:
AND r28 r24 r31
BNE r28 r24 UKEY_CHECK_END      # if not pressed, check next btn
JMP UKEY_MERGE

UKEY_CHECK_END:
JMP LOOP_UKEY_INPUT  # loop until r3 = -1

UKEY_MERGE:                     # merge 8*16bits to 4*32bits
ORI r3 r0 3                     # i = 3
LOOP_UKEY_MERGE:
SHL r4 r3 1                     # r4 <- i*2
ADDI r5 r4 1                    # r5 <- i*2+1

LW r11 r5 60                    # r11 <- data[60+i*2+1]
SHL r11 r11 16                  # 16 MSB
LW r10 r4 60                    # r10 <- data[60+i*2]
AND r10 r25 r10                 # 16 LSB

OR r10 r11 r10                  # r10 <- 16 MSB + 16 LSB
SW r10 r3 50                    # data[50+i] = data[60+i*2+1]&data[60+i*2]

SUBI r3 r3 1                    # i -= 1
BNE r3 r2 LOOP_UKEY_MERGE       # loop until r3 = -1

JMP KEY_EXP                     # goto KEY_EXP

#############################################
#   Subprogram: DIN_INPUT
#############################################
#   data[70] ... data[73] ukey: 4 * 16 bits 
#   data[54] ... data[55] ukey: 2 * 32 bits
DIN_INPUT:
SHR r28 r31 16
BNE r28 r0 DIN_INPUT            # wait for all buttons being released

# 16-bit first
ORI r3 r0 3                     # i = 3
ORI r13 r0 3                    # upper bound
ORI r17 r0 0                    # previou pressed btn 
LOOP_DIN_INPUT:
# refresh display
AND r11 r25 r31                 # r11 <- switches
SHL r11 r11 16                  # r11 <- r11 << 16
LW r10 r3 70                    # r10 <- data[70 + i]
OR r30 r11 r10                  # display r11&r10 (switches&current_value)
LW r29 r3 90                    # turn on led(i)

# wait until preivous pressed btn is released
AND r28 r17 r31                 # get state of preivous pressed btn
BNE r28 r0 -2                   # loop
ORI r17 r0 0                    # no btn being pressed

DIN_CHECK_BTNL:
AND r28 r22 r31
BNE r28 r22 DIN_CHECK_BTNR      # if not pressed, check next btn
BEQ r3 r13 1                    # if r3=3, skip r3+=1
ADDI r3 r3 1             
ORI r17 r22 0                   # set previous pressed btn to btnL  
JMP LOOP_DIN_INPUT

DIN_CHECK_BTNR:
AND r28 r23 r31
BNE r28 r23 DIN_CHECK_BTNC      # if not pressed, check next btn
BEQ r3 r0 1                     # if r3=0, skip r3-=1
SUBI r3 r3 1             
ORI r17 r23 0                   # set previous pressed btn to btnR  
JMP LOOP_DIN_INPUT

DIN_CHECK_BTNC:
AND r28 r20 r31
BNE r28 r20 DIN_CHECK_BTND      # if not pressed, check next btn
AND r10 r25 r31                 # r10 <- switches
SW r10 r3 70                    # data[70+i] <- r10
ORI r17 r20 0                   # set previous pressed btn to btnC  
JMP LOOP_DIN_INPUT

DIN_CHECK_BTND:
AND r28 r24 r31
BNE r28 r24 DIN_CHECK_END       # if not pressed, check next btn
JMP DIN_MERGE

DIN_CHECK_END:
JMP LOOP_DIN_INPUT  # loop until r3 = -1

DIN_MERGE:                      # merge 4*16bits to 2*32bits
ORI r3 r0 1                     # i = 1
LOOP_DIN_MERGE:
SHL r4 r3 1                     # r4 <- i*2
ADDI r5 r4 1                    # r5 <- i*2+1

LW r11 r5 70                    # r11 <- data[70+i*2+1]
SHL r11 r11 16                  # 16 MSB
LW r10 r4 70                    # r10 <- data[70+i*2]
AND r10 r25 r10                 # 16 LSB

OR r10 r11 r10                  # r10 <- 16 MSB + 16 LSB
SW r10 r3 54                    # data[54+i] = data[70+i*2+1]&data[70+i*2]

SUBI r3 r3 1                    # i -= 1
BNE r3 r2 LOOP_DIN_MERGE        # loop until r3 = -1

JMP MAIN                        # goto MAIN

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

ORI r18 r0 0x8888
SHL r18 r18 16                  # if skey is generated, r18 <- 0x88880000 

JMP MAIN                        # return to main


##########################################
#   ENCRYPTION
##########################################
# 
ENCRYPTION:
LW r8 r0 55                     # r8 <- A
LW r9 r0 54                     # r9 <- B
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
NOR r10 r10 r0                  # r10 <- (B nand (A nand B))) nand (A nand (A nand B)))
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
SW r8 r0 31
SW r9 r0 30

# display
LW r30 r0 31                    # display 16 MSB
LW r29 r1 90                    # turn on led(1)
SHR r28 r31 16
BNE r28 r0 -2                   # wait for all buttons being released

ENC_CHECK_BTNL:
AND r28 r22 r31
BNE r28 r22 ENC_CHECK_BTNR      # if not pressed, check next btn
LW r30 r0 31                    # display 16 MSB
LW r29 r1 90                    # turn on led(1)


ENC_CHECK_BTNR:
AND r28 r23 r31
BNE r28 r23 ENC_CHECK_BTND      # if not pressed, check next btn
LW r30 r0 30                    # display 16 LSB
LW r29 r0 90                    # turn on led(0)


ENC_CHECK_BTND:
AND r28 r24 r31
BNE r28 r24 ENC_CHECK_BTNL       # if not pressed, check next btn
JMP MAIN
             

##########################################
#   DECRYPTION
##########################################
#
DECRYPTION:
# LOAD A_enc, B_enc
LW r8 r0 55
LW r9 r0 54

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
SW r8 r0 33
SW r9 r0 32

# display
LW r30 r0 33                    # display 16 MSB
LW r29 r1 90                    # turn on led(1)
SHR r28 r31 16
BNE r28 r0 -2                   # wait for all buttons being released

DEC_CHECK_BTNL:
AND r28 r22 r31
BNE r28 r22 DEC_CHECK_BTNR      # if not pressed, check next btn
LW r30 r0 33                    # display 16 MSB
LW r29 r1 90                    # turn on led(1)

DEC_CHECK_BTNR:
AND r28 r23 r31
BNE r28 r23 DEC_CHECK_BTND      # if not pressed, check next btn
LW r30 r0 32                    # display 16 LSB
LW r29 r0 90                    # turn on led(0)

DEC_CHECK_BTND:
AND r28 r24 r31
BNE r28 r24 DEC_CHECK_BTNL       # if not pressed, check next btn
JMP MAIN

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

HAL

# If everything goes right, DATA[40] = DATA[44]; DATA[41] = DATA[45]