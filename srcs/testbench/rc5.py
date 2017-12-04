#!/usr/bin/env python

"""
How to use:
1. Put this script at the same folder as 'tb_cpu.vhd'
2. Insert your asm program after '>>> start >>>'
3. Run it, and the binary code of your asm program should 
    be inserted into 'tb_cpu.vhd'
4. Simulate in Vivado/ISE

Notes:
1. Comment start with #
2. LABEL must be in a separate line, letter only and ended with ':'
3. DO NOT modified line '>>> start >>>' and '<<< end <<<'

Instructions
>>> start >>>

# This is an example code calculating 
# the summation from 1 to 100

# Delete all the lines between 'start' and 'end' 
# before you program

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
ORI r20 r0 0x51b2        # high 16bits
SHL r20 r20 16
ORI r21 r0 0x41be       # low 16bits
AND r21 r21 r22
OR r20 r20 r21
SW r20 r0 51
# ukey[2]
ORI r20 r0 0x01a5        # high 16bits
SHL r20 r20 16
ORI r21 r0 0x5563       # low 16bits
AND r21 r21 r22
OR r20 r20 r21
SW r20 r0 52
# ukey[3]
ORI r20 r0 0x91ce        # high 16bits
SHL r20 r20 16
ORI r21 r0 0xa910       # low 16bits
AND r21 r21 r22
OR r20 r20 r21
SW r20 r0 53

# round key generation
# L offset 50, L offset 26
ORI r2 r0 4         # i = 4
L_INIT:
SUBI r2 r2 1        # i -= 1
LW r11 r2 50        # r11 <- K[i]
SW r11 r2 26        # L[i] <- K[i]
BNE r2 r0 L_INIT
# P, Q
ORI r8 r0 0xB7E1
SHL r8 r8 16
ORI r8 r8 0x5163    # P
ORI r9 r0 0x9E37
SHL r9 r9 16
ORI r9 r9 0x79B9    # Q
# S offset 0
ORI r3 r8 0         # S_acc = P
ORI r2 r0 0         # i = 0
ORI r4 r0 26        # count
S_INIT:
SW r3 r2 0          # S[i] = S_acc
ADD r3 r3 r9        # S_acc += Q
ADDI r2 r2 1        # i += 1
BNE r2 r4 S_INIT

ORI r2 r0 0         # i
ORI r3 r0 0         # j
ORI r4 r0 0         # k
ORI r5 r0 78        # 78
ORI r6 r0 0         # A
ORI r7 r0 0         # B
ORI r20 r0 0x001f   # rot mask
ORI r21 r0 26       # t
ORI r22 r0 4        # c
KEY_EXP:
ADD r6 r6 r7        # A = A+B
LW r8 r2 0          # r8 <- S[i]
ADD r8 r6 r8        # S[i]+A+B
# left rotate by 3
SHL r9 r8 3         # r8 <- rotl higher bits
SHR r8 r8 29       # r9 <- rotl lower bits
OR r6 r9 r8        # rotl 3
SW r6 r2 0          # S[i] = A

ADD r7 r6 r7        # B = A+B
LW r8 r3 26         # r8 <- L[j]
ADD r8 r7 r8        # L[j]+A+B
# left rotate
AND r7 r20 r7       # A+B lower 5 bits
SUBI r10 r7 32      # lower 5 bits - 32
OR r9 r0 r8

ORI r11 r0 0
SL_START:
BEQ r11 r7 SL_END
SHL r9 r9 1         # r9 <- rotl higher bits
ADDI r11 r11 1
JMP SL_START
SL_END:

ORI r11 r0 0
SR_START:
BEQ r11 r10 SR_END
SHR r8 r8 1         # r9 <- rotl higher bits
SUBI r11 r11 1
JMP SR_START
SR_END:

OR r7 r9 r8         # rotl A+B
SW r7 r3 26         # L[j] = B
# increment
ADDI r4 r4 1        # k += 1
ADDI r2 r2 1        # i += 1
ADDI r3 r3 1        # j += 1
BNE r2 r21 1        # i = 0 if i = 26
ORI r2 r0 0
BNE r3 r22 1        # j = 0 if j = 4
ORI r3 r0 0

BNE r4 r5 KEY_EXP




HAL

<<< end <<<
"""

from __future__ import print_function
xrang = range

def pack_rtype(op, rs, rt, rd, func):
    return (op<<26) + (rs<<21) + (rt<<16) + (rd<<11) + func

def pack_itype(op, rs, rt, imm):
    return (op<<26) + (rs<<21) + (rt<<16) + imm

def pack_jtype(op, addr):
    return (op<<26) + addr

decode = {
    'ADD':  {'type': 'R', 'op': 0x00, 'func': 0x10},
    'ADDI': {'type': 'I', 'op': 0x01},
    'SUB':  {'type': 'R', 'op': 0x00, 'func': 0x11},
    'SUBI': {'type': 'I', 'op': 0x02},
    'AND':  {'type': 'R', 'op': 0x00, 'func': 0x12},
    'ANDI': {'type': 'I', 'op': 0x03},
    'OR':   {'type': 'R', 'op': 0x00, 'func': 0x13},
    'NOR':  {'type': 'R', 'op': 0x00, 'func': 0x14},
    'ORI':  {'type': 'I', 'op': 0x04},
    'SHL':  {'type': 'I', 'op': 0x05},
    'SHR':  {'type': 'I', 'op': 0x06},
    'LW':   {'type': 'I', 'op': 0x07},
    'SW':   {'type': 'I', 'op': 0x08},
    'BLT':  {'type': 'I', 'op': 0x09},
    'BEQ':  {'type': 'I', 'op': 0x0a},
    'BNE':  {'type': 'I', 'op': 0x0b},
    'JMP':  {'type': 'J', 'op': 0x0c},
    'HAL':  {'type': 'J', 'op': 0x3f}, 
}

instructions = []
labl2addr = {}
addr2labl = {}
# reading instructions and mapping label to line no.
with open('rc5.py', 'r') as f:
    while True:
        line = f.readline()
        if line == '>>> start >>>\n':
            break

    idx = 0
    while True:
        line = f.readline().strip()
        # if not the end of the code
        if line != '<<< end <<<':
            # trim comment
            inst = line.split('#')[0].strip().split()
            # if not blank line
            if inst and inst[0][-1] == ':':
                label = inst[0][:-1].strip()
                # mapping address to label
                if label in labl2addr:
                    raise 'Duplicated LABEL'
                labl2addr[label] = idx
                # mapping label to address
                if idx in addr2labl:
                    addr2labl[idx].append(label+':')
                else:
                    addr2labl[idx] = [label+':']
            elif inst:
                instructions.append(inst)
                idx += 1
        else:
            break

# compiling
inst_dec = [2**32-1 for _ in xrange(256)]
for no, inst in enumerate(instructions):
        op = decode[inst[0]]['op']

        # r-type
        if decode[inst[0]]['type'] == 'R':
            rd = int(inst[1][1:])
            rs = int(inst[2][1:])
            rt = int(inst[3][1:])
            func = decode[inst[0]]['func']
            inst_dec[no] = pack_rtype(op, rs, rt, rd, func)
            # print(hex(op), rs, rt, rd, hex(func))

        elif decode[inst[0]]['type'] == 'I':
            rt = int(inst[1][1:])
            rs = int(inst[2][1:])
            try:
                if inst[3][0:2] == '0x':
                    imm = int(inst[3], 16)
                else:
                    imm = (int(float(inst[3])) + 2**16) % 2**16
            except:     # might be a branch instruction
                label = inst[3]
                addr = labl2addr[label]
                offset = addr - (no + 1)  
                imm = (offset + 2**16) % 2**16

            inst_dec[no] = pack_itype(op, rs, rt, imm)
            # print(hex(op), rs, rt, imm if imm < 2**15 else imm-2**16)

        elif decode[inst[0]]['type'] == 'J':
            addr = no
            if inst[0] != 'HAL':
                try:
                    addr = int(inst[1])
                except:
                    label = inst[1]
                    addr = labl2addr[label]
            inst_dec[no] = pack_jtype(op, addr)
            # print(hex(op), addr)

inst_bin = [bin(i)[2:].zfill(32) for i in inst_dec]
inst_hex = [hex(i)[2:].strip('L').zfill(8) for i in inst_dec]


# print the code
for no, inst in enumerate(instructions):
    if no in addr2labl:
        print(*addr2labl[no])
    print('%03d:'%no, *inst)
print()

for no, _ in enumerate(instructions):
    print('%03d:'%no, inst_bin[no], inst_hex[no], inst_dec[no])

# write into inst_mem
inst_mem = open('tb_cpu.vhd', 'r').readlines()
with open('tb_cpu.vhd', 'w') as f:
    i = 0
    while '>>> start >>>' not in inst_mem[i]:
        f.write(inst_mem[i])
        i += 1
    f.write(inst_mem[i])
    
    for h in inst_hex[:-1]:
        f.write('\t\tx"%s",\n'%h)
        print('\t\tx"%s",'%h)
    f.write('\t\tx"%s"\n'%inst_hex[-1])
    print('\t\tx"%s",'%h)

    while '<<< end <<<' not in inst_mem[i]:
        i += 1
    
    while i < len(inst_mem):
        f.write(inst_mem[i])
        i += 1
