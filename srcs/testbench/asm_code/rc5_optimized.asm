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
#       r24 <- btn[4] mask 0x00000010
#       r23 <- btn[3] mask 0x00000008
#       r22 <- btn[2] mask 0x00000004  
#       r21 <- btn[1] mask 0x00000002
#       r20 <- btn[0] mask 0x00000001
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
ORI r20 r1 0            # r20 <- 0x00000001
SHL r21 r20 1           # r21 <- 0x00000002
SHL r22 r21 1           # r22 <- 0x00000004
SHL r23 r22 1           # r23 <- 0x00000008
SHL r24 r23 1           # r24 <- 0x00000010
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

# iteratively check all buttons in a loop
MAIN_LOOP:
OR r30 r18 r19                  # diplay menu index

CHECK_BTNL:
SHR r28 r31 16
AND r28 r28 r22 
BNE r28 r22 CHECK_BTNR          # if not pressed, check next btn
SUBI r19 r19 1                  # if pressed
BNE r19 r0 1                   
SUBI r19 r17 1                  # if index out of range, reset it
OR r30 r18 r19                  # diplay menu index
SHR r28 r31 16
AND r28 r28 r22                 # wait release
BEQ r28 r22 -3

CHECK_BTNR:
SHR r28 r31 16
AND r28 r28 r23
BNE r28 r23 CHECK_BTNC          # if not pressed, check next btn
ADDI r19 r19 1                  # if pressed
BNE r19 r17 1                   
ADDI r19 r0 1                  # if index out of range, reset it
OR r30 r18 r19                  # diplay menu index
SHR r28 r31 16
AND r28 r28 r23                 # wait release
BEQ r28 r23 -3

CHECK_BTNC:
SHR r28 r31 16
AND r28 r28 r20
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
SHR r28 r31 16
AND r28 r28 r17                 # get state of preivous pressed btn
BNE r28 r0 -3                   # loop
ORI r17 r0 0                    # no btn being pressed

UKEY_CHECK_BTNL:
SHR r28 r31 16
AND r28 r28 r22
BNE r28 r22 UKEY_CHECK_BTNR     # if not pressed, check next btn
BEQ r3 r13 1                    # if r3=7, skip r3+=1
ADDI r3 r3 1             
ORI r17 r22 0                   # set previous pressed btn to btnL  
JMP LOOP_UKEY_INPUT

UKEY_CHECK_BTNR:
SHR r28 r31 16
AND r28 r28 r23
BNE r28 r23 UKEY_CHECK_BTNC     # if not pressed, check next btn
BEQ r3 r0 1                     # if r3=0, skip r3-=1
SUBI r3 r3 1             
ORI r17 r23 0                   # set previous pressed btn to btnR  
JMP LOOP_UKEY_INPUT

UKEY_CHECK_BTNC:
SHR r28 r31 16
AND r28 r28 r20
BNE r28 r20 UKEY_CHECK_BTND     # if not pressed, check next btn
AND r10 r25 r31                 # r10 <- switches
SW r10 r3 60                    # data[60+i] <- r10
ORI r17 r20 0                   # set previous pressed btn to btnC  
JMP LOOP_UKEY_INPUT

UKEY_CHECK_BTND:
SHR r28 r31 16
AND r28 r28 r24
BNE r28 r24 UKEY_CHECK_END      # if not pressed, check next btn
JMP UKEY_MERGE

UKEY_CHECK_END:
JMP LOOP_UKEY_INPUT

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
SHR r28 r31 16
AND r28 r28 r17                 # get state of preivous pressed btn
BNE r28 r0 -3                   # loop
ORI r17 r0 0                    # no btn being pressed

DIN_CHECK_BTNL:
SHR r28 r31 16
AND r28 r28 r22
BNE r28 r22 DIN_CHECK_BTNR      # if not pressed, check next btn
BEQ r3 r13 1                    # if r3=3, skip r3+=1
ADDI r3 r3 1             
ORI r17 r22 0                   # set previous pressed btn to btnL  
JMP LOOP_DIN_INPUT

DIN_CHECK_BTNR:
SHR r28 r31 16
AND r28 r28 r23
BNE r28 r23 DIN_CHECK_BTNC      # if not pressed, check next btn
BEQ r3 r0 1                     # if r3=0, skip r3-=1
SUBI r3 r3 1             
ORI r17 r23 0                   # set previous pressed btn to btnR  
JMP LOOP_DIN_INPUT

DIN_CHECK_BTNC:
SHR r28 r31 16
AND r28 r28 r20
BNE r28 r20 DIN_CHECK_BTND      # if not pressed, check next btn
AND r10 r25 r31                 # r10 <- switches
SW r10 r3 70                    # data[70+i] <- r10
ORI r17 r20 0                   # set previous pressed btn to btnC  
JMP LOOP_DIN_INPUT

DIN_CHECK_BTND:
SHR r28 r31 16
AND r28 r28 r24
BNE r28 r24 DIN_CHECK_END       # if not pressed, check next btn
JMP DIN_MERGE

DIN_CHECK_END:
JMP LOOP_DIN_INPUT

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
ADD r6 r8 r9                    # r6 <- A+B
LW r7 r3 0                      # r7 <- S[i]
ADD r7 r7 r6                    # r7 <- S[i] = S[i] + A + B
# rotate left
SHL r11 r7 3                    # r11 <- r7 << 3 (29 MSB)
SHR r10 r7 29                   # r10 <- r7 >> 29 (3 LSB)
OR r8 r11 r10                   # r8 <- A = rotl(S[i] + A + B, 3)
SW r8 r3 0                      # S[i] = A
# calculate B
ADD r6 r8 r9                    # r6 <- A+B
LW r7 r4 26                     # r7 <- L[j]
ADD r7 r7 r6                    # r7 <- L[j] = L[j] + A + B

# left rotate r7 by r6
# start from xxxxx [0, 31] 
AND r12 r24 r6                   
BEQ r12 r24 ROT16_KEY               # 1xxxx, goto [16, 31] 
ROT0_KEY:                           # 0xxxx [0, 15]
AND r12 r23 r6    
BEQ r12 r23 ROT8_KEY                # 01xxx, goto [8, 15]
AND r12 r22 r6
BEQ r12 r22 ROT4_KEY                # 001xx, goto [4, 7]
AND r12 r21 r6
BEQ r12 r21 ROT2_KEY                # 0001x, goto [2, 3]
AND r12 r20 r6
BEQ r12 r20 ROT1_KEY                # 00001, goto [1]
SHL r11 r7 0                        # 00001 [1]
SHR r10 r7 32             
JMP ROT_MERGE_KEY                   # 00000 [0]
ROT1_KEY:                       
SHL r11 r7 1                        # 00001 [1]
SHR r10 r7 31                    
JMP ROT_MERGE_KEY               
ROT2_KEY:                           # 00001 [2, 3]
AND r12 r20 r6                   
BEQ r12 r20 ROT3_KEY                # 00011, goto [3]
SHL r11 r7 2                        # 00010 [2]
SHR r10 r7 30      
JMP ROT_MERGE_KEY               
ROT3_KEY:
SHL r11 r7 3                        # 00011 [3]
SHR r10 r7 29      
JMP ROT_MERGE_KEY              
ROT4_KEY:                           # 001xx [4, 7]
AND r12 r21 r6                   
BEQ r12 r21 ROT6_KEY                # 0011x, goto [6, 7]
AND r12 r20 r6                   
BEQ r12 r20 ROT5_KEY                # 00101, goto [5]
SHL r11 r7 4                        # 00100 [4]
SHR r10 r7 28  
JMP ROT_MERGE_KEY                
ROT5_KEY:                           # 00101 [5]
SHL r11 r7 5                        # 00100 [4]
SHR r10 r7 27  
JMP ROT_MERGE_KEY       
ROT6_KEY:
AND r12 r20 r6                   
BEQ r12 r20 ROT7_KEY                # 00111, goto [7]
SHL r11 r7 6                        # 00110 [6]
SHR r10 r7 26   
JMP ROT_MERGE_KEY      
ROT7_KEY:
SHL r11 r7 7                        # 00111 [7]
SHR r10 r7 25     
JMP ROT_MERGE_KEY    
ROT8_KEY:                           # 01xxx [8, 15]
AND r12 r22 r6
BEQ r12 r22 ROT12_KEY               # 011xx, goto [12, 15]
AND r12 r21 r6
BEQ r12 r21 ROT10_KEY               # 0101x, goto [10, 11]
AND r12 r20 r6
BEQ r12 r20 ROT9_KEY                # 01001, goto [9]
SHL r11 r7 8                        # 01000 [8]
SHR r10 r7 24   
JMP ROT_MERGE_KEY                 
ROT9_KEY:                           # so on and so forth
SHL r11 r7 9                
SHR r10 r7 23   
JMP ROT_MERGE_KEY           
ROT10_KEY:
AND r12 r20 r6
BEQ r12 r20 ROT11_KEY
SHL r11 r7 10                
SHR r10 r7 22   
JMP ROT_MERGE_KEY   
ROT11_KEY:
SHL r11 r7 11                
SHR r10 r7 21   
JMP ROT_MERGE_KEY   
ROT12_KEY:
AND r12 r21 r6
BEQ r12 r21 ROT14_KEY
AND r12 r20 r6
BEQ r12 r20 ROT13_KEY
SHL r11 r7 12                
SHR r10 r7 20   
JMP ROT_MERGE_KEY   
ROT13_KEY:
SHL r11 r7 13                
SHR r10 r7 19   
JMP ROT_MERGE_KEY   
ROT14_KEY:
AND r12 r20 r6
BEQ r12 r20 ROT15_KEY
SHL r11 r7 14                
SHR r10 r7 18   
JMP ROT_MERGE_KEY   
ROT15_KEY:
SHL r11 r7 15                
SHR r10 r7 17   
JMP ROT_MERGE_KEY   
ROT16_KEY:
AND r12 r23 r6
BEQ r12 r23 ROT24_KEY
AND r12 r22 r6
BEQ r12 r22 ROT20_KEY
AND r12 r21 r6
BEQ r12 r21 ROT18_KEY
AND r12 r20 r6
BEQ r12 r20 ROT17_KEY
SHL r11 r7 16                
SHR r10 r7 16   
JMP ROT_MERGE_KEY   
ROT17_KEY:
SHL r11 r7 17                
SHR r10 r7 15   
JMP ROT_MERGE_KEY   
ROT18_KEY:
AND r12 r20 r6
BEQ r12 r20 ROT19_KEY
SHL r11 r7 18                
SHR r10 r7 14   
JMP ROT_MERGE_KEY  
ROT19_KEY:
SHL r11 r7 19                
SHR r10 r7 13   
JMP ROT_MERGE_KEY   
ROT20_KEY:
AND r12 r21 r6
BEQ r12 r21 ROT22_KEY
AND r12 r20 r6
BEQ r12 r20 ROT21_KEY
SHL r11 r7 20                
SHR r10 r7 12   
JMP ROT_MERGE_KEY   
ROT21_KEY:
SHL r11 r7 21                
SHR r10 r7 11   
JMP ROT_MERGE_KEY   
ROT22_KEY:
AND r12 r20 r6
BEQ r12 r20 ROT23_KEY
SHL r11 r7 22                
SHR r10 r7 10   
JMP ROT_MERGE_KEY   
ROT23_KEY:
SHL r11 r7 23                
SHR r10 r7 9   
JMP ROT_MERGE_KEY   
ROT24_KEY:
AND r12 r22 r6
BEQ r12 r22 ROT28_KEY
AND r12 r21 r6
BEQ r12 r21 ROT26_KEY
AND r12 r20 r6
BEQ r12 r20 ROT25_KEY
SHL r11 r7 24                
SHR r10 r7 8   
JMP ROT_MERGE_KEY   
ROT25_KEY:
SHL r11 r7 25                
SHR r10 r7 7   
JMP ROT_MERGE_KEY   
ROT26_KEY:
AND r12 r20 r6
BEQ r12 r20 ROT27_KEY
SHL r11 r7 26                
SHR r10 r7 6   
JMP ROT_MERGE_KEY   
ROT27_KEY:
SHL r11 r7 27                
SHR r10 r7 5   
JMP ROT_MERGE_KEY   
ROT28_KEY:
AND r12 r21 r6
BEQ r12 r21 ROT30_KEY
AND r12 r20 r6
BEQ r12 r20 ROT29_KEY
SHL r11 r7 28                
SHR r10 r7 4   
JMP ROT_MERGE_KEY   
ROT29_KEY:
SHL r11 r7 29                
SHR r10 r7 3   
JMP ROT_MERGE_KEY   
ROT30_KEY:
AND r12 r20 r6
BEQ r12 r20 ROT31_KEY
SHL r11 r7 30                
SHR r10 r7 2   
JMP ROT_MERGE_KEY   
ROT31_KEY:
SHL r11 r7 31                
SHR r10 r7 1

ROT_MERGE_KEY:
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
NOR r11 r8 r9                   # r11 <- A nor B
AND r10 r8 r9                   # r11 <- A and B
NOR r7 r10 r11                  # r7  <- A^B

# left rotate r7 by r9
# start from xxxxx [0, 31] 
AND r12 r24 r9                   
BEQ r12 r24 ROT16_ENCA            # 1xxxx, goto [16, 31] 
ROT0_ENCA:                       # 0xxxx [0, 15]
AND r12 r23 r9    
BEQ r12 r23 ROT8_ENCA             # 01xxx, goto [8, 15]
AND r12 r22 r9
BEQ r12 r22 ROT4_ENCA             # 001xx, goto [4, 7]
AND r12 r21 r9
BEQ r12 r21 ROT2_ENCA             # 0001x, goto [2, 3]
AND r12 r20 r9
BEQ r12 r20 ROT1_ENCA             # 00001, goto [1]
SHL r11 r7 0                    # 00001 [1]
SHR r10 r7 32             
JMP ROT_MERGE_ENCA               # 00000 [0]
ROT1_ENCA:                       
SHL r11 r7 1                    # 00001 [1]
SHR r10 r7 31                    
JMP ROT_MERGE_ENCA               
ROT2_ENCA:                       # 00001 [2, 3]
AND r12 r20 r9                   
BEQ r12 r20 ROT3_ENCA             # 00011, goto [3]
SHL r11 r7 2                    # 00010 [2]
SHR r10 r7 30      
JMP ROT_MERGE_ENCA               
ROT3_ENCA:
SHL r11 r7 3                    # 00011 [3]
SHR r10 r7 29      
JMP ROT_MERGE_ENCA              
ROT4_ENCA:                       # 001xx [4, 7]
AND r12 r21 r9                   
BEQ r12 r21 ROT6_ENCA             # 0011x, goto [6, 7]
AND r12 r20 r9                   
BEQ r12 r20 ROT5_ENCA             # 00101, goto [5]
SHL r11 r7 4                    # 00100 [4]
SHR r10 r7 28  
JMP ROT_MERGE_ENCA                
ROT5_ENCA:                       # 00101 [5]
SHL r11 r7 5                    # 00100 [4]
SHR r10 r7 27  
JMP ROT_MERGE_ENCA       
ROT6_ENCA:
AND r12 r20 r9                   
BEQ r12 r20 ROT7_ENCA             # 00111, goto [7]
SHL r11 r7 6                    # 00110 [6]
SHR r10 r7 26   
JMP ROT_MERGE_ENCA      
ROT7_ENCA:
SHL r11 r7 7                    # 00111 [7]
SHR r10 r7 25     
JMP ROT_MERGE_ENCA    
ROT8_ENCA:                       # 01xxx [8, 15]
AND r12 r22 r9
BEQ r12 r22 ROT12_ENCA            # 011xx, goto [12, 15]
AND r12 r21 r9
BEQ r12 r21 ROT10_ENCA            # 0101x, goto [10, 11]
AND r12 r20 r9
BEQ r12 r20 ROT9_ENCA             # 01001, goto [9]
SHL r11 r7 8                    # 01000 [8]
SHR r10 r7 24   
JMP ROT_MERGE_ENCA                 
ROT9_ENCA:
SHL r11 r7 9                
SHR r10 r7 23   
JMP ROT_MERGE_ENCA           
ROT10_ENCA:
AND r12 r20 r9
BEQ r12 r20 ROT11_ENCA
SHL r11 r7 10                
SHR r10 r7 22   
JMP ROT_MERGE_ENCA   
ROT11_ENCA:
SHL r11 r7 11                
SHR r10 r7 21   
JMP ROT_MERGE_ENCA   
ROT12_ENCA:
AND r12 r21 r9
BEQ r12 r21 ROT14_ENCA
AND r12 r20 r9
BEQ r12 r20 ROT13_ENCA
SHL r11 r7 12                
SHR r10 r7 20   
JMP ROT_MERGE_ENCA   
ROT13_ENCA:
SHL r11 r7 13                
SHR r10 r7 19   
JMP ROT_MERGE_ENCA   
ROT14_ENCA:
AND r12 r20 r9
BEQ r12 r20 ROT15_ENCA
SHL r11 r7 14                
SHR r10 r7 18   
JMP ROT_MERGE_ENCA   
ROT15_ENCA:
SHL r11 r7 15                
SHR r10 r7 17   
JMP ROT_MERGE_ENCA   
ROT16_ENCA:
AND r12 r23 r9
BEQ r12 r23 ROT24_ENCA
AND r12 r22 r9
BEQ r12 r22 ROT20_ENCA
AND r12 r21 r9
BEQ r12 r21 ROT18_ENCA
AND r12 r20 r9
BEQ r12 r20 ROT17_ENCA
SHL r11 r7 16                
SHR r10 r7 16   
JMP ROT_MERGE_ENCA   
ROT17_ENCA:
SHL r11 r7 17                
SHR r10 r7 15   
JMP ROT_MERGE_ENCA   
ROT18_ENCA:
AND r12 r20 r9
BEQ r12 r20 ROT19_ENCA
SHL r11 r7 18                
SHR r10 r7 14   
JMP ROT_MERGE_ENCA  
ROT19_ENCA:
SHL r11 r7 19                
SHR r10 r7 13   
JMP ROT_MERGE_ENCA   
ROT20_ENCA:
AND r12 r21 r9
BEQ r12 r21 ROT22_ENCA
AND r12 r20 r9
BEQ r12 r20 ROT21_ENCA
SHL r11 r7 20                
SHR r10 r7 12   
JMP ROT_MERGE_ENCA   
ROT21_ENCA:
SHL r11 r7 21                
SHR r10 r7 11   
JMP ROT_MERGE_ENCA   
ROT22_ENCA:
AND r12 r20 r9
BEQ r12 r20 ROT23_ENCA
SHL r11 r7 22                
SHR r10 r7 10   
JMP ROT_MERGE_ENCA   
ROT23_ENCA:
SHL r11 r7 23                
SHR r10 r7 9   
JMP ROT_MERGE_ENCA   
ROT24_ENCA:
AND r12 r22 r9
BEQ r12 r22 ROT28_ENCA
AND r12 r21 r9
BEQ r12 r21 ROT26_ENCA
AND r12 r20 r9
BEQ r12 r20 ROT25_ENCA
SHL r11 r7 24                
SHR r10 r7 8   
JMP ROT_MERGE_ENCA   
ROT25_ENCA:
SHL r11 r7 25                
SHR r10 r7 7   
JMP ROT_MERGE_ENCA   
ROT26_ENCA:
AND r12 r20 r9
BEQ r12 r20 ROT27_ENCA
SHL r11 r7 26                
SHR r10 r7 6   
JMP ROT_MERGE_ENCA   
ROT27_ENCA:
SHL r11 r7 27                
SHR r10 r7 5   
JMP ROT_MERGE_ENCA   
ROT28_ENCA:
AND r12 r21 r9
BEQ r12 r21 ROT30_ENCA
AND r12 r20 r9
BEQ r12 r20 ROT29_ENCA
SHL r11 r7 28                
SHR r10 r7 4   
JMP ROT_MERGE_ENCA   
ROT29_ENCA:
SHL r11 r7 29                
SHR r10 r7 3   
JMP ROT_MERGE_ENCA   
ROT30_ENCA:
AND r12 r20 r9
BEQ r12 r20 ROT31_ENCA
SHL r11 r7 30                
SHR r10 r7 2   
JMP ROT_MERGE_ENCA   
ROT31_ENCA:
SHL r11 r7 31                
SHR r10 r7 1

ROT_MERGE_ENCA:
OR r10 r11 r10                  # r10 <- rotl(A^B, B)
LW r7 r4 0                      # r7 <- S[i*2]
ADD r8 r10 r7                   # r8 <- A = ROTL(A^B, B) + S[i*2]

# calculate B
# XOR operation
NOR r11 r8 r9                   # r11 <- A nor B
AND r10 r8 r9                   # r11 <- A and B
NOR r7 r10 r11                  # r7  <- A^B

# left rotate r7 by r8
# start from xxxxx [0, 31] 
AND r12 r24 r8                   
BEQ r12 r24 ROT16_ENCB            # 1xxxx, goto [16, 31] 
ROT0_ENCB:                       # 0xxxx [0, 15]
AND r12 r23 r8    
BEQ r12 r23 ROT8_ENCB             # 01xxx, goto [8, 15]
AND r12 r22 r8
BEQ r12 r22 ROT4_ENCB             # 001xx, goto [4, 7]
AND r12 r21 r8
BEQ r12 r21 ROT2_ENCB             # 0001x, goto [2, 3]
AND r12 r20 r8
BEQ r12 r20 ROT1_ENCB             # 00001, goto [1]
SHL r11 r7 0                    # 00001 [1]
SHR r10 r7 32             
JMP ROT_MERGE_ENCB               # 00000 [0]
ROT1_ENCB:                       
SHL r11 r7 1                    # 00001 [1]
SHR r10 r7 31                    
JMP ROT_MERGE_ENCB               
ROT2_ENCB:                       # 00001 [2, 3]
AND r12 r20 r8                   
BEQ r12 r20 ROT3_ENCB             # 00011, goto [3]
SHL r11 r7 2                    # 00010 [2]
SHR r10 r7 30      
JMP ROT_MERGE_ENCB               
ROT3_ENCB:
SHL r11 r7 3                    # 00011 [3]
SHR r10 r7 29      
JMP ROT_MERGE_ENCB              
ROT4_ENCB:                       # 001xx [4, 7]
AND r12 r21 r8                   
BEQ r12 r21 ROT6_ENCB             # 0011x, goto [6, 7]
AND r12 r20 r8                   
BEQ r12 r20 ROT5_ENCB             # 00101, goto [5]
SHL r11 r7 4                    # 00100 [4]
SHR r10 r7 28  
JMP ROT_MERGE_ENCB                
ROT5_ENCB:                       # 00101 [5]
SHL r11 r7 5                    # 00100 [4]
SHR r10 r7 27  
JMP ROT_MERGE_ENCB       
ROT6_ENCB:
AND r12 r20 r8                   
BEQ r12 r20 ROT7_ENCB             # 00111, goto [7]
SHL r11 r7 6                    # 00110 [6]
SHR r10 r7 26   
JMP ROT_MERGE_ENCB      
ROT7_ENCB:
SHL r11 r7 7                    # 00111 [7]
SHR r10 r7 25     
JMP ROT_MERGE_ENCB    
ROT8_ENCB:                       # 01xxx [8, 15]
AND r12 r22 r8
BEQ r12 r22 ROT12_ENCB            # 011xx, goto [12, 15]
AND r12 r21 r8
BEQ r12 r21 ROT10_ENCB            # 0101x, goto [10, 11]
AND r12 r20 r8
BEQ r12 r20 ROT9_ENCB             # 01001, goto [9]
SHL r11 r7 8                    # 01000 [8]
SHR r10 r7 24   
JMP ROT_MERGE_ENCB                 
ROT9_ENCB:
SHL r11 r7 9                
SHR r10 r7 23   
JMP ROT_MERGE_ENCB           
ROT10_ENCB:
AND r12 r20 r8
BEQ r12 r20 ROT11_ENCB
SHL r11 r7 10                
SHR r10 r7 22   
JMP ROT_MERGE_ENCB   
ROT11_ENCB:
SHL r11 r7 11                
SHR r10 r7 21   
JMP ROT_MERGE_ENCB   
ROT12_ENCB:
AND r12 r21 r8
BEQ r12 r21 ROT14_ENCB
AND r12 r20 r8
BEQ r12 r20 ROT13_ENCB
SHL r11 r7 12                
SHR r10 r7 20   
JMP ROT_MERGE_ENCB   
ROT13_ENCB:
SHL r11 r7 13                
SHR r10 r7 19   
JMP ROT_MERGE_ENCB   
ROT14_ENCB:
AND r12 r20 r8
BEQ r12 r20 ROT15_ENCB
SHL r11 r7 14                
SHR r10 r7 18   
JMP ROT_MERGE_ENCB   
ROT15_ENCB:
SHL r11 r7 15                
SHR r10 r7 17   
JMP ROT_MERGE_ENCB   
ROT16_ENCB:
AND r12 r23 r8
BEQ r12 r23 ROT24_ENCB
AND r12 r22 r8
BEQ r12 r22 ROT20_ENCB
AND r12 r21 r8
BEQ r12 r21 ROT18_ENCB
AND r12 r20 r8
BEQ r12 r20 ROT17_ENCB
SHL r11 r7 16                
SHR r10 r7 16   
JMP ROT_MERGE_ENCB   
ROT17_ENCB:
SHL r11 r7 17                
SHR r10 r7 15   
JMP ROT_MERGE_ENCB   
ROT18_ENCB:
AND r12 r20 r8
BEQ r12 r20 ROT19_ENCB
SHL r11 r7 18                
SHR r10 r7 14   
JMP ROT_MERGE_ENCB  
ROT19_ENCB:
SHL r11 r7 19                
SHR r10 r7 13   
JMP ROT_MERGE_ENCB   
ROT20_ENCB:
AND r12 r21 r8
BEQ r12 r21 ROT22_ENCB
AND r12 r20 r8
BEQ r12 r20 ROT21_ENCB
SHL r11 r7 20                
SHR r10 r7 12   
JMP ROT_MERGE_ENCB   
ROT21_ENCB:
SHL r11 r7 21                
SHR r10 r7 11   
JMP ROT_MERGE_ENCB   
ROT22_ENCB:
AND r12 r20 r8
BEQ r12 r20 ROT23_ENCB
SHL r11 r7 22                
SHR r10 r7 10   
JMP ROT_MERGE_ENCB   
ROT23_ENCB:
SHL r11 r7 23                
SHR r10 r7 9   
JMP ROT_MERGE_ENCB   
ROT24_ENCB:
AND r12 r22 r8
BEQ r12 r22 ROT28_ENCB
AND r12 r21 r8
BEQ r12 r21 ROT26_ENCB
AND r12 r20 r8
BEQ r12 r20 ROT25_ENCB
SHL r11 r7 24                
SHR r10 r7 8   
JMP ROT_MERGE_ENCB   
ROT25_ENCB:
SHL r11 r7 25                
SHR r10 r7 7   
JMP ROT_MERGE_ENCB   
ROT26_ENCB:
AND r12 r20 r8
BEQ r12 r20 ROT27_ENCB
SHL r11 r7 26                
SHR r10 r7 6   
JMP ROT_MERGE_ENCB   
ROT27_ENCB:
SHL r11 r7 27                
SHR r10 r7 5   
JMP ROT_MERGE_ENCB   
ROT28_ENCB:
AND r12 r21 r8
BEQ r12 r21 ROT30_ENCB
AND r12 r20 r8
BEQ r12 r20 ROT29_ENCB
SHL r11 r7 28                
SHR r10 r7 4   
JMP ROT_MERGE_ENCB   
ROT29_ENCB:
SHL r11 r7 29                
SHR r10 r7 3   
JMP ROT_MERGE_ENCB   
ROT30_ENCB:
AND r12 r20 r8
BEQ r12 r20 ROT31_ENCB
SHL r11 r7 30                
SHR r10 r7 2   
JMP ROT_MERGE_ENCB   
ROT31_ENCB:
SHL r11 r7 31                
SHR r10 r7 1

ROT_MERGE_ENCB:
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
SHR r28 r31 16
AND r28 r28 r22
BNE r28 r22 ENC_CHECK_BTNR      # if not pressed, check next btn
LW r30 r0 31                    # display 16 MSB
LW r29 r1 90                    # turn on led(1)


ENC_CHECK_BTNR:
SHR r28 r31 16
AND r28 r28 r23
BNE r28 r23 ENC_CHECK_BTND      # if not pressed, check next btn
LW r30 r0 30                    # display 16 LSB
LW r29 r0 90                    # turn on led(0)


ENC_CHECK_BTND:
SHR r28 r31 16
AND r28 r28 r24
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
SUB r7 r9 r7                    # r7 <- B - S[i*2+1]

# right rotate r7 by r8
# start from xxxxx [0, 31] 
AND r12 r24 r8                   
BEQ r12 r24 ROT16_DECB            # 1xxxx, goto [16, 31] 
ROT0_DECB:                       # 0xxxx [0, 15]
AND r12 r23 r8    
BEQ r12 r23 ROT8_DECB             # 01xxx, goto [8, 15]
AND r12 r22 r8
BEQ r12 r22 ROT4_DECB             # 001xx, goto [4, 7]
AND r12 r21 r8
BEQ r12 r21 ROT2_DECB             # 0001x, goto [2, 3]
AND r12 r20 r8
BEQ r12 r20 ROT1_DECB             # 00001, goto [1]
SHR r11 r7 0                    # 00001 [1]
SHL r10 r7 32             
JMP ROT_MERGE_DECB               # 00000 [0]
ROT1_DECB:                       
SHR r11 r7 1                    # 00001 [1]
SHL r10 r7 31                    
JMP ROT_MERGE_DECB               
ROT2_DECB:                       # 00001 [2, 3]
AND r12 r20 r8                   
BEQ r12 r20 ROT3_DECB             # 00011, goto [3]
SHR r11 r7 2                    # 00010 [2]
SHL r10 r7 30      
JMP ROT_MERGE_DECB               
ROT3_DECB:
SHR r11 r7 3                    # 00011 [3]
SHL r10 r7 29      
JMP ROT_MERGE_DECB              
ROT4_DECB:                       # 001xx [4, 7]
AND r12 r21 r8                   
BEQ r12 r21 ROT6_DECB             # 0011x, goto [6, 7]
AND r12 r20 r8                   
BEQ r12 r20 ROT5_DECB             # 00101, goto [5]
SHR r11 r7 4                    # 00100 [4]
SHL r10 r7 28  
JMP ROT_MERGE_DECB                
ROT5_DECB:                       # 00101 [5]
SHR r11 r7 5                    # 00100 [4]
SHL r10 r7 27  
JMP ROT_MERGE_DECB       
ROT6_DECB:
AND r12 r20 r8                   
BEQ r12 r20 ROT7_DECB             # 00111, goto [7]
SHR r11 r7 6                    # 00110 [6]
SHL r10 r7 26   
JMP ROT_MERGE_DECB      
ROT7_DECB:
SHR r11 r7 7                    # 00111 [7]
SHL r10 r7 25     
JMP ROT_MERGE_DECB    
ROT8_DECB:                       # 01xxx [8, 15]
AND r12 r22 r8
BEQ r12 r22 ROT12_DECB            # 011xx, goto [12, 15]
AND r12 r21 r8
BEQ r12 r21 ROT10_DECB            # 0101x, goto [10, 11]
AND r12 r20 r8
BEQ r12 r20 ROT9_DECB             # 01001, goto [9]
SHR r11 r7 8                    # 01000 [8]
SHL r10 r7 24   
JMP ROT_MERGE_DECB                 
ROT9_DECB:
SHR r11 r7 9                
SHL r10 r7 23   
JMP ROT_MERGE_DECB           
ROT10_DECB:
AND r12 r20 r8
BEQ r12 r20 ROT11_DECB
SHR r11 r7 10                
SHL r10 r7 22   
JMP ROT_MERGE_DECB   
ROT11_DECB:
SHR r11 r7 11                
SHL r10 r7 21   
JMP ROT_MERGE_DECB   
ROT12_DECB:
AND r12 r21 r8
BEQ r12 r21 ROT14_DECB
AND r12 r20 r8
BEQ r12 r20 ROT13_DECB
SHR r11 r7 12                
SHL r10 r7 20   
JMP ROT_MERGE_DECB   
ROT13_DECB:
SHR r11 r7 13                
SHL r10 r7 19   
JMP ROT_MERGE_DECB   
ROT14_DECB:
AND r12 r20 r8
BEQ r12 r20 ROT15_DECB
SHR r11 r7 14                
SHL r10 r7 18   
JMP ROT_MERGE_DECB   
ROT15_DECB:
SHR r11 r7 15                
SHL r10 r7 17   
JMP ROT_MERGE_DECB   
ROT16_DECB:
AND r12 r23 r8
BEQ r12 r23 ROT24_DECB
AND r12 r22 r8
BEQ r12 r22 ROT20_DECB
AND r12 r21 r8
BEQ r12 r21 ROT18_DECB
AND r12 r20 r8
BEQ r12 r20 ROT17_DECB
SHR r11 r7 16                
SHL r10 r7 16   
JMP ROT_MERGE_DECB   
ROT17_DECB:
SHR r11 r7 17                
SHL r10 r7 15   
JMP ROT_MERGE_DECB   
ROT18_DECB:
AND r12 r20 r8
BEQ r12 r20 ROT19_DECB
SHR r11 r7 18                
SHL r10 r7 14   
JMP ROT_MERGE_DECB  
ROT19_DECB:
SHR r11 r7 19                
SHL r10 r7 13   
JMP ROT_MERGE_DECB   
ROT20_DECB:
AND r12 r21 r8
BEQ r12 r21 ROT22_DECB
AND r12 r20 r8
BEQ r12 r20 ROT21_DECB
SHR r11 r7 20                
SHL r10 r7 12   
JMP ROT_MERGE_DECB   
ROT21_DECB:
SHR r11 r7 21                
SHL r10 r7 11   
JMP ROT_MERGE_DECB   
ROT22_DECB:
AND r12 r20 r8
BEQ r12 r20 ROT23_DECB
SHR r11 r7 22                
SHL r10 r7 10   
JMP ROT_MERGE_DECB   
ROT23_DECB:
SHR r11 r7 23                
SHL r10 r7 9   
JMP ROT_MERGE_DECB   
ROT24_DECB:
AND r12 r22 r8
BEQ r12 r22 ROT28_DECB
AND r12 r21 r8
BEQ r12 r21 ROT26_DECB
AND r12 r20 r8
BEQ r12 r20 ROT25_DECB
SHR r11 r7 24                
SHL r10 r7 8   
JMP ROT_MERGE_DECB   
ROT25_DECB:
SHR r11 r7 25                
SHL r10 r7 7   
JMP ROT_MERGE_DECB   
ROT26_DECB:
AND r12 r20 r8
BEQ r12 r20 ROT27_DECB
SHR r11 r7 26                
SHL r10 r7 6   
JMP ROT_MERGE_DECB   
ROT27_DECB:
SHR r11 r7 27                
SHL r10 r7 5   
JMP ROT_MERGE_DECB   
ROT28_DECB:
AND r12 r21 r8
BEQ r12 r21 ROT30_DECB
AND r12 r20 r8
BEQ r12 r20 ROT29_DECB
SHR r11 r7 28                
SHL r10 r7 4   
JMP ROT_MERGE_DECB   
ROT29_DECB:
SHR r11 r7 29                
SHL r10 r7 3   
JMP ROT_MERGE_DECB   
ROT30_DECB:
AND r12 r20 r8
BEQ r12 r20 ROT31_DECB
SHR r11 r7 30                
SHL r10 r7 2   
JMP ROT_MERGE_DECB   
ROT31_DECB:
SHR r11 r7 31                
SHL r10 r7 1

ROT_MERGE_DECB:
OR r9 r11 r10                   # r9 <- rotr(B - S[i*2+1], A)

# xor
NOR r11 r8 r9                   # r11 <- A nor B
AND r10 r8 r9                   # r11 <- A and B
NOR r9 r10 r11                  # r9  <- rotr()^A

# calculate A
LW r7 r4 0                      # r7 <- S[i*2]
SUB r7 r8 r7                    # r10 <- A - S[i*2]

# right rotate r7 by r9
# start from xxxxx [0, 31] 
AND r12 r24 r9                   
BEQ r12 r24 ROT16_DECA            # 1xxxx, goto [16, 31] 
ROT0_DECA:                       # 0xxxx [0, 15]
AND r12 r23 r9    
BEQ r12 r23 ROT8_DECA             # 01xxx, goto [8, 15]
AND r12 r22 r9
BEQ r12 r22 ROT4_DECA             # 001xx, goto [4, 7]
AND r12 r21 r9
BEQ r12 r21 ROT2_DECA             # 0001x, goto [2, 3]
AND r12 r20 r9
BEQ r12 r20 ROT1_DECA             # 00001, goto [1]
SHR r11 r7 0                    # 00001 [1]
SHL r10 r7 32             
JMP ROT_MERGE_DECA               # 00000 [0]
ROT1_DECA:                       
SHR r11 r7 1                    # 00001 [1]
SHL r10 r7 31                    
JMP ROT_MERGE_DECA               
ROT2_DECA:                       # 00001 [2, 3]
AND r12 r20 r9                   
BEQ r12 r20 ROT3_DECA             # 00011, goto [3]
SHR r11 r7 2                    # 00010 [2]
SHL r10 r7 30      
JMP ROT_MERGE_DECA               
ROT3_DECA:
SHR r11 r7 3                    # 00011 [3]
SHL r10 r7 29      
JMP ROT_MERGE_DECA              
ROT4_DECA:                       # 001xx [4, 7]
AND r12 r21 r9                   
BEQ r12 r21 ROT6_DECA             # 0011x, goto [6, 7]
AND r12 r20 r9                   
BEQ r12 r20 ROT5_DECA             # 00101, goto [5]
SHR r11 r7 4                    # 00100 [4]
SHL r10 r7 28  
JMP ROT_MERGE_DECA                
ROT5_DECA:                       # 00101 [5]
SHR r11 r7 5                    # 00100 [4]
SHL r10 r7 27  
JMP ROT_MERGE_DECA       
ROT6_DECA:
AND r12 r20 r9                   
BEQ r12 r20 ROT7_DECA             # 00111, goto [7]
SHR r11 r7 6                    # 00110 [6]
SHL r10 r7 26   
JMP ROT_MERGE_DECA      
ROT7_DECA:
SHR r11 r7 7                    # 00111 [7]
SHL r10 r7 25     
JMP ROT_MERGE_DECA    
ROT8_DECA:                       # 01xxx [8, 15]
AND r12 r22 r9
BEQ r12 r22 ROT12_DECA            # 011xx, goto [12, 15]
AND r12 r21 r9
BEQ r12 r21 ROT10_DECA            # 0101x, goto [10, 11]
AND r12 r20 r9
BEQ r12 r20 ROT9_DECA             # 01001, goto [9]
SHR r11 r7 8                    # 01000 [8]
SHL r10 r7 24   
JMP ROT_MERGE_DECA                 
ROT9_DECA:
SHR r11 r7 9                
SHL r10 r7 23   
JMP ROT_MERGE_DECA           
ROT10_DECA:
AND r12 r20 r9
BEQ r12 r20 ROT11_DECA
SHR r11 r7 10                
SHL r10 r7 22   
JMP ROT_MERGE_DECA   
ROT11_DECA:
SHR r11 r7 11                
SHL r10 r7 21   
JMP ROT_MERGE_DECA   
ROT12_DECA:
AND r12 r21 r9
BEQ r12 r21 ROT14_DECA
AND r12 r20 r9
BEQ r12 r20 ROT13_DECA
SHR r11 r7 12                
SHL r10 r7 20   
JMP ROT_MERGE_DECA   
ROT13_DECA:
SHR r11 r7 13                
SHL r10 r7 19   
JMP ROT_MERGE_DECA   
ROT14_DECA:
AND r12 r20 r9
BEQ r12 r20 ROT15_DECA
SHR r11 r7 14                
SHL r10 r7 18   
JMP ROT_MERGE_DECA   
ROT15_DECA:
SHR r11 r7 15                
SHL r10 r7 17   
JMP ROT_MERGE_DECA   
ROT16_DECA:
AND r12 r23 r9
BEQ r12 r23 ROT24_DECA
AND r12 r22 r9
BEQ r12 r22 ROT20_DECA
AND r12 r21 r9
BEQ r12 r21 ROT18_DECA
AND r12 r20 r9
BEQ r12 r20 ROT17_DECA
SHR r11 r7 16                
SHL r10 r7 16   
JMP ROT_MERGE_DECA   
ROT17_DECA:
SHR r11 r7 17                
SHL r10 r7 15   
JMP ROT_MERGE_DECA   
ROT18_DECA:
AND r12 r20 r9
BEQ r12 r20 ROT19_DECA
SHR r11 r7 18                
SHL r10 r7 14   
JMP ROT_MERGE_DECA  
ROT19_DECA:
SHR r11 r7 19                
SHL r10 r7 13   
JMP ROT_MERGE_DECA   
ROT20_DECA:
AND r12 r21 r9
BEQ r12 r21 ROT22_DECA
AND r12 r20 r9
BEQ r12 r20 ROT21_DECA
SHR r11 r7 20                
SHL r10 r7 12   
JMP ROT_MERGE_DECA   
ROT21_DECA:
SHR r11 r7 21                
SHL r10 r7 11   
JMP ROT_MERGE_DECA   
ROT22_DECA:
AND r12 r20 r9
BEQ r12 r20 ROT23_DECA
SHR r11 r7 22                
SHL r10 r7 10   
JMP ROT_MERGE_DECA   
ROT23_DECA:
SHR r11 r7 23                
SHL r10 r7 9   
JMP ROT_MERGE_DECA   
ROT24_DECA:
AND r12 r22 r9
BEQ r12 r22 ROT28_DECA
AND r12 r21 r9
BEQ r12 r21 ROT26_DECA
AND r12 r20 r9
BEQ r12 r20 ROT25_DECA
SHR r11 r7 24                
SHL r10 r7 8   
JMP ROT_MERGE_DECA   
ROT25_DECA:
SHR r11 r7 25                
SHL r10 r7 7   
JMP ROT_MERGE_DECA   
ROT26_DECA:
AND r12 r20 r9
BEQ r12 r20 ROT27_DECA
SHR r11 r7 26                
SHL r10 r7 6   
JMP ROT_MERGE_DECA   
ROT27_DECA:
SHR r11 r7 27                
SHL r10 r7 5   
JMP ROT_MERGE_DECA   
ROT28_DECA:
AND r12 r21 r9
BEQ r12 r21 ROT30_DECA
AND r12 r20 r9
BEQ r12 r20 ROT29_DECA
SHR r11 r7 28                
SHL r10 r7 4   
JMP ROT_MERGE_DECA   
ROT29_DECA:
SHR r11 r7 29                
SHL r10 r7 3   
JMP ROT_MERGE_DECA   
ROT30_DECA:
AND r12 r20 r9
BEQ r12 r20 ROT31_DECA
SHR r11 r7 30                
SHL r10 r7 2   
JMP ROT_MERGE_DECA   
ROT31_DECA:
SHR r11 r7 31                
SHL r10 r7 1

ROT_MERGE_DECA:
OR r8 r11 r10                   # r9 <- rotr(B - S[i*2+1], A)

# xor
NOR r11 r8 r9                   # r11 <- A nor B
AND r10 r8 r9                   # r11 <- A and B
NOR r8 r10 r11                  # r8  <- rotr()^B 

# decrement and loop
SUBI r3 r3 1
BNE r3 r0 LOOP_DEC              # loop until i = 0

LW r7 r0 1                      # r7 <- S[1]
SUB r9 r9 r7                    # r9 <- B = B - S[1]
LW r7 r0 0                      # r7 <- S[0]
SUB r8 r8 r7                    # r8 <- A = A - S[0]

# A_dec, B_dec offset 44, 45
SW r8 r0 33
SW r9 r0 32

# display
LW r30 r0 33                    # display 16 MSB
LW r29 r1 90                    # turn on led(1)
SHR r28 r31 16
BNE r28 r0 -2                   # wait for all buttons being released

DEC_CHECK_BTNL:
SHR r28 r31 16
AND r28 r28 r22
BNE r28 r22 DEC_CHECK_BTNR      # if not pressed, check next btn
LW r30 r0 33                    # display 16 MSB
LW r29 r1 90                    # turn on led(1)

DEC_CHECK_BTNR:
SHR r28 r31 16
AND r28 r28 r23
BNE r28 r23 DEC_CHECK_BTND      # if not pressed, check next btn
LW r30 r0 32                    # display 16 LSB
LW r29 r0 90                    # turn on led(0)

DEC_CHECK_BTND:
SHR r28 r31 16
AND r28 r28 r24
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