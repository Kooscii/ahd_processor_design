# instruction format example
# ADD rd rs rt
# ADDI rt ts imm
# JMP addr

#########################################
#   ukey input
#########################################
#   mem_offset : 50

ORI r22 r0 0xffff
SHR r22 r22 16          # mask
# ukey[0]
ORI r20 r0 0x1946       # high 16bits
SHL r20 r20 16
ORI r21 r0 0x5f91       # low 16bits
AND r21 r21 r22
OR r20 r20 r21
SW r20 r0 50
# ukey[1]
ORI r20 r0 0x51b2       # high 16bits
SHL r20 r20 16
ORI r21 r0 0x41be       # low 16bits
AND r21 r21 r22
OR r20 r20 r21
SW r20 r0 51
# ukey[2]
ORI r20 r0 0x01a5       # high 16bits
SHL r20 r20 16
ORI r21 r0 0x5563       # low 16bits
AND r21 r21 r22
OR r20 r20 r21
SW r20 r0 52
# ukey[3]
ORI r20 r0 0x91ce       # high 16bits
SHL r20 r20 16
ORI r21 r0 0xa910       # low 16bits
AND r21 r21 r22
OR r20 r20 r21
SW r20 r0 53

###########################################
#   round key generation
###########################################
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
#   DIN 
########################################## 
#   Ain mem_offset 40, Bin men_offset 41

ORI r22 r0 0xffff
SHR r22 r22 16          # mask
# A
ORI r20 r0 0xeedb       # high 16bits
SHL r20 r20 16
ORI r21 r0 0xa521       # low 16bits
AND r21 r21 r22
OR r15 r20 r21          # r15 <- A
SW r15 r0 40
# ukey[1]
ORI r20 r0 0x6d8f       # high 16bits
SHL r20 r20 16
ORI r21 r0 0x4b15       # low 16bits
AND r21 r21 r22
OR r16 r20 r21          # r16 <- B
SW r16 r0 41

##########################################
#   ENCRYPT
##########################################
# 

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