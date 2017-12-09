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
ORI r0 r0 0             # r0 <- $zero
ORI r1 r0 1             # r1 <- $one
SHL r20 r1 16           # r20 <- 0x00010000
SHL r21 r20 1           # r21 <- 0x00020000
SHL r22 r21 1           # r22 <- 0x00040000
SHL r23 r22 1           # r23 <- 0x00080000
SHL r24 r23 1           # r24 <- 0x00100000
ORI r25 r0 0xffff       
SHR r25 r25 16          # r25 <- 0x0000ffff
ORI r26 r0 0x001f       # r26 <- 0x0000001f
ORI r27 r0 0xffff       # r27 <- 0xffffffff

#########################################
#   INPUT
#########################################
#   r10, r11 <= temporary registers
#   ukey memory offset: 50
#   din memory offset: 54

########## FIXED INPUT ##########
# # ukey
# ORI r11 r0 0x1946       
# SHL r11 r11 16              # r11 <- 16 MSB
# ANDI r10 r25 0x5f91         # r10 <- 16 LSB
# OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
# SW r10 r0 50                # MEM[0+50] = ukey[0]

# ORI r11 r0 0x51b2       
# SHL r11 r11 16              # r11 <- 16 MSB
# ANDI r10 r25 0x41be         # r10 <- 16 LSB
# OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
# SW r10 r0 51                # MEM[1+50] = ukey[1]

# ORI r11 r0 0x01a5       
# SHL r11 r11 16              # r11 <- 16 MSB
# ANDI r10 r25 0x5563         # r10 <- 16 LSB
# OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
# SW r10 r0 52                # MEM[2+50] = ukey[2]

# ORI r11 r0 0x91ce       
# SHL r11 r11 16              # r11 <- 16 MSB
# ANDI r10 r25 0xa910         # r10 <- 16 LSB
# OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
# SW r10 r0 53                # MEM[3+50] = ukey[3]

# # din
# # A
# ORI r11 r0 0xeedb           
# SHL r11 r11 16              # r11 <- 16 MSB
# ANDI r10 r25 0xa521         # r10 <- 16 LSB
# OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
# SW r10 r0 54
# # B
# ORI r11 r0 0x6d8f           
# SHL r11 r11 16              # r11 <- 16 MSB
# ANDI r10 r25 0x4b15         # r10 <- 16 LSB
# OR r10 r11 r10              # r10 <- 16 MSB + 16 LSB
# SW r10 r0 55


###### Input from switches #####
#   r28 <- interupt register
#   r2 <- i
#   r3 <- 4 (upper limit of the loop)
#
#   for(r2=0; r2!=r3; r2++) {
#       wait for btn[0];
#       r10 = switches;
#       wait for btn[0];
#       r11 = switches;
#       MEM[r2+50] = (r11<<16) + r10;
#   }

# ukey
ORI r2 r0 0                         # i = 0
ORI r3 r0 4
UKEY_INPUT:
AND r28 r20 r31                 # wait btn[0] release
BEQ r28 r20 -2
AND r28 r20 r31                 # wait btn[0] press
BNE r28 r20 -2
ANDI r10 r25 r31                # 16 LSB

AND r28 r20 r31                 # wait btn[0] release
BEQ r28 r20 -2
AND r28 r20 r31                 # wait btn[0] press
BNE r28 r20 -2
ORI r11 r0 r31                  # 16 MSB
SHL r11 r11 16

OR r10 r11 r10                  # r10 <- 16 MSB + 16 LSB
SW r10 r2 50                    # MEM[2+50] = ukey[2]

ADDI r2 r2 1                    # i += 1
BNE r2 r3 UKEY_INPUT            # loop until r2 = 5


#########################################
#   UKEY EXPANSION
#########################################
#   K mem_offset 50, S mem_offset 0, L mem_offset 26

# initialize L and S
ORI r2 r0 4             # i = 4
L_INIT:
SUBI r2 r2 1            # i -= 1
LW r11 r2 50            # r11 <- K[i]
SW r11 r2 26            # L[i] <- K[i]
BNE r2 r0 L_INIT
# P, Q
ORI r8 r0 0xB7E1
SHL r8 r8 16
ORI r8 r8 0x5163        # P
ORI r9 r0 0x9E37
SHL r9 r9 16
ORI r9 r9 0x79B9        # Q
# S offset 0
ORI r3 r8 0             # S_acc = P
ORI r2 r0 0             # i = 0
ORI r4 r0 26            # count
S_INIT:
SW r3 r2 0              # S[i] = S_acc
ADD r3 r3 r9            # S_acc += Q
ADDI r2 r2 1            # i += 1
BNE r2 r4 S_INIT

# generate skey
ORI r2 r0 0             # i
ORI r3 r0 0             # j
ORI r4 r0 0             # k
ORI r5 r0 78            # 78
ORI r6 r0 0             # A
ORI r7 r0 0             # B
ORI r20 r0 0x001f       # rot mask
ORI r21 r0 26           # t
ORI r22 r0 4            # c

KEY_EXP:
ADD r6 r6 r7            # A = A+B
LW r8 r2 0              # r8 <- S[i]
ADD r8 r6 r8            # S[i]+A+B
# left rotate by 3
SHL r9 r8 3             # r8 <- rotl higher bits
SHR r8 r8 29            # r9 <- rotl lower bits
OR r6 r9 r8             # rotl 3
SW r6 r2 0              # S[i] = A

ADD r7 r6 r7            # B = A+B
LW r8 r3 26             # r8 <- L[j]
ADD r8 r7 r8            # L[j]+A+B
# left rotate
AND r7 r20 r7           # A+B lower 5 bits
SUBI r10 r7 32          # lower 5 bits - 32
OR r9 r0 r8

ORI r11 r0 0
SL_START:
BEQ r11 r7 SL_END
SHL r9 r9 1             # r9 <- rotl higher bits
ADDI r11 r11 1
JMP SL_START
SL_END:
ORI r11 r0 0
SR_START:
BEQ r11 r10 SR_END
SHR r8 r8 1             # r8 <- rotl lower bits
SUBI r11 r11 1
JMP SR_START
SR_END:

OR r7 r9 r8             # rotl A+B
SW r7 r3 26             # L[j] = B
# increment
ADDI r4 r4 1            # k += 1
ADDI r2 r2 1            # i += 1
ADDI r3 r3 1            # j += 1
BNE r2 r21 1            # i = 0 if i = 26
ORI r2 r0 0
BNE r3 r22 1            # j = 0 if j = 4
ORI r3 r0 0

BNE r4 r5 KEY_EXP



##########################################
#   ENCRYPT
##########################################
# 
LW r15 r0 40
LW r16 r0 41

ORI r20 r0 0x001f       # rot mask
LW r8 r0 0              # r8 <- S[0]
ADD r15 r15 r8          # A = A + S[0]
LW r8 r0 1              # r8 <- S[1]
ADD r16 r16 r8          # B = B + S[1]

# 12 rounds
ORI r2 r0 1             # i
ORI r3 r0 13
EN_ROUND:
SHL r4 r2 1             # r4 <- 2*i
ADDI r5 r4 1            # r5 <- 2*i+1

# calculate A
# XOR operation
AND r14 r15 r16         # AB
NOR r14 r14 r0          # r14 <- ~AB
ORI r13 r14 0           # r13 <- ~AB
AND r14 r14 r16         # r14 <- B(~AB)
NOR r14 r14 r0          # r14 <- ~(B(~AB))
AND r13 r13 r15         # r13 <- A(~AB)
NOR r13 r13 r0          # r13 <- ~(A(~AB))
AND r8 r13 r14          # r8 <- (~(B(~AB)))(~(A(~AB)))
NOR r8 r8 r0            # r8 <- ~((~(B(~AB)))(~(A(~AB)))) = A xor B
# rotate
AND r7 r20 r16          # B lower 5 bits
SUBI r10 r7 32          # B lower 5 bits - 32
OR r9 r0 r8
ORI r11 r0 0
ENA_SL_START:
BEQ r11 r7 ENA_SL_END
SHL r9 r9 1             # r9 <- rotl higher bits
ADDI r11 r11 1
JMP ENA_SL_START
ENA_SL_END:
ORI r11 r0 0
ENA_SR_START:
BEQ r11 r10 ENA_SR_END
SHR r8 r8 1             # r8 <- rotl lower bits
SUBI r11 r11 1
JMP ENA_SR_START
ENA_SR_END:
OR r9 r9 r8             # r9 <- ROTL(A^B, B)
LW r8 r4 0              # r8 <- S[i*2]
ADD r15 r8 r9           # A = S[i*2] + ROTL(A^B, B)

# calculate B
# XOR operation
AND r14 r15 r16         # AB
NOR r14 r14 r0          # r14 <- ~AB
ORI r13 r14 0           # r13 <- ~AB
AND r14 r14 r16         # r14 <- B(~AB)
NOR r14 r14 r0          # r14 <- ~(B(~AB))
AND r13 r13 r15         # r13 <- A(~AB)
NOR r13 r13 r0          # r13 <- ~(A(~AB))
AND r8 r13 r14          # r8 <- (~(B(~AB)))(~(A(~AB)))
NOR r8 r8 r0            # r8 <- ~((~(B(~AB)))(~(A(~AB)))) = A xor B
# rotate
AND r7 r20 r15          # A lower 5 bits
SUBI r10 r7 32          # A lower 5 bits - 32
OR r9 r0 r8
ORI r11 r0 0
ENB_SL_START:
BEQ r11 r7 ENB_SL_END
SHL r9 r9 1             # r9 <- rotl higher bits
ADDI r11 r11 1
JMP ENB_SL_START
ENB_SL_END:
ORI r11 r0 0
ENB_SR_START:
BEQ r11 r10 ENB_SR_END
SHR r8 r8 1             # r8 <- rotl lower bits
SUBI r11 r11 1
JMP ENB_SR_START
ENB_SR_END:
OR r9 r9 r8             # r9 <- ROTL(A^B, A)
LW r8 r5 0              # r8 <- S[i*2+1]
ADD r16 r8 r9           # B = S[i*2+1] + ROTL(A^B, B)

# increment and loop
ADDI r2 r2 1
BLT r3 r2 EN_ROUND

# A_enc, B_enc offset 42, 43
SW r15 r0 42
SW r16 r0 43

##########################################
#   DECRYPTO
##########################################
#

# LOAD A_enc, B_enc
LW r15 r0 42
LW r16 r0 43

ORI r20 r0 0x001f       # rot mask
# 12 rounds
ORI r2 r0 12            # i
DE_ROUND:
SHL r4 r2 1             # r4 <- 2*i
ADDI r5 r4 1            # r5 <- 2*i+1

# calculate B
LW r8 r5 0              # r8 <- S[2*i+1]
SUB r8 r16 r8           # r8 <- B - S[2*i+1]
# rotate
AND r7 r20 r15          # A lower 5 bits
SUBI r10 r7 32          # A lower 5 bits - 32
OR r9 r0 r8
ORI r11 r0 0
DEB_SR_START:
BEQ r11 r7 DEB_SR_END
SHR r9 r9 1             # r9 <- rotl lower bits
ADDI r11 r11 1
JMP DEB_SR_START
DEB_SR_END:
ORI r11 r0 0
DEB_SL_START:
BEQ r11 r10 DEB_SL_END
SHL r8 r8 1             # r8 <- rotl higher bits
SUBI r11 r11 1
JMP DEB_SL_START
DEB_SL_END:
OR r16 r8 r9            # r16 <- ROTR A
# XOR
AND r14 r15 r16         # AB
NOR r14 r14 r0          # r14 <- ~AB
ORI r13 r14 0           # r13 <- ~AB
AND r14 r14 r16         # r14 <- B(~AB)
NOR r14 r14 r0          # r14 <- ~(B(~AB))
AND r13 r13 r15         # r13 <- A(~AB)
NOR r13 r13 r0          # r13 <- ~(A(~AB))
AND r8 r13 r14          # r8 <- (~(B(~AB)))(~(A(~AB)))
NOR r16 r8 r0           # B = r16 <- ~((~(B(~AB)))(~(A(~AB)))) = A xor B

# calculate A
LW r8 r4 0              # r8 <- S[2*i]
SUB r8 r15 r8           # r8 <- A - S[2*i]
# rotate
AND r7 r20 r16          # B lower 5 bits
SUBI r10 r7 32          # B lower 5 bits - 32
OR r9 r0 r8
ORI r11 r0 0
DEA_SR_START:
BEQ r11 r7 DEA_SR_END
SHR r9 r9 1             # r9 <- rotl lower bits
ADDI r11 r11 1
JMP DEA_SR_START
DEA_SR_END:
ORI r11 r0 0
DEA_SL_START:
BEQ r11 r10 DEA_SL_END
SHL r8 r8 1             # r8 <- rotl higher bits
SUBI r11 r11 1
JMP DEA_SL_START
DEA_SL_END:
OR r15 r8 r9            # r16 <- ROTR B
# XOR
AND r14 r15 r16         # AB
NOR r14 r14 r0          # r14 <- ~AB
ORI r13 r14 0           # r13 <- ~AB
AND r14 r14 r16         # r14 <- B(~AB)
NOR r14 r14 r0          # r14 <- ~(B(~AB))
AND r13 r13 r15         # r13 <- A(~AB)
NOR r13 r13 r0          # r13 <- ~(A(~AB))
AND r8 r13 r14          # r8 <- (~(B(~AB)))(~(A(~AB)))
NOR r15 r8 r0           # A = r8 <- ~((~(B(~AB)))(~(A(~AB)))) = A xor B

# decrement and loop
SUBI r2 r2 1
BNE r2 r0 DE_ROUND

LW r8 r0 1              # r8 <- S[1]
SUB r16 r16 r8          # B = B - S[1]
LW r8 r0 0              # r8 <- S[0]
SUB r15 r15 r8          # A = A - S[0]

# A_dec, B_dec offset 44, 45
SW r15 r0 44
SW r16 r0 45

HAL

# If everything goes right, DATA[40] = DATA[44]; DATA[41] = DATA[45]