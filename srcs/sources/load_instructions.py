#!/usr/bin/env python

"""
How to use:
1. Put this script at the same folder as 'ins_mem.vhd'
2. Insert your asm program after '>>> start >>>'
3. Run it, and the binary code of your asm program should 
    be inserted into 'ins_mem.vhd'
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

ADDI r0 r2 100      # initialize r2 to 100
ADD r0 r0 r3        # store the summation in r3
START:
BEQ r0 r2 END       # jump to END if r2 counts down to zero
ADD r2 r3 r3        # r3 = r3 + r2
SUB r2 r1 r2        # r2 = r2 - 1
JMP START           # lopp

END:
ADD r0 r3 r30       # r30 is the 7-seg display register
HAL

<<< end <<<
"""

from __future__ import print_function

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
with open('load_instructions.py', 'r') as f:
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
            rs = int(inst[1][1:])
            rt = int(inst[2][1:])
            rd = int(inst[3][1:])
            func = decode[inst[0]]['func']
            inst_dec[no] = pack_rtype(op, rs, rt, rd, func)
            # print(hex(op), rs, rt, rd, hex(func))

        elif decode[inst[0]]['type'] == 'I':
            rs = int(inst[1][1:])
            rt = int(inst[2][1:])
            try:
                imm = (int(float(inst[3])) + 2**16) % 2**16
            except:     # might be a branch instruction
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
inst_hex = [hex(i)[2:].zfill(8) for i in inst_dec]


# print the code
for no, inst in enumerate(instructions):
    if no in addr2labl:
        print(*addr2labl[no])
    print('%03d:'%no, *inst)
print()

for no, _ in enumerate(instructions):
    print('%03d:'%no, inst_bin[no], inst_hex[no])

# write into inst_mem
inst_mem = open('ins_mem.vhd', 'r').readlines()
with open('ins_mem.vhd', 'w') as f:
    i = 0
    while '>>> start >>>' not in inst_mem[i]:
        f.write(inst_mem[i])
        i += 1
    f.write(inst_mem[i])
    
    for h in inst_hex[:-1]:
        f.write('\t\tx"%s",\n'%h)
    f.write('\t\tx"%s"\n'%inst_hex[-1])

    while '<<< end <<<' not in inst_mem[i]:
        i += 1
    
    while i < len(inst_mem):
        f.write(inst_mem[i])
        i += 1
