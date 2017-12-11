#!/usr/bin/env python
from __future__ import print_function

xrange=range

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
# asm_code = open('asm_code/code1.asm', 'r').readlines()
# asm_code = open('asm_code/code2.asm', 'r').readlines()
asm_code = open('asm_code/rc5_optimized.asm', 'r').readlines()

idx = 0
for line in asm_code:
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

# print(labl2addr)

# compiling
inst_dec = [2**32-1 for _ in xrange(512)]
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
with open('asm_code/rc5_optimized.code', 'w') as f:
    for no, inst in enumerate(instructions):
        if no in addr2labl:
            print(*addr2labl[no])
            f.write(' '.join(addr2labl[no])+'\n')
        if len(inst) == 1:      # halt
            f.write(('%03d:  %-s\n')%((no,)+tuple(inst)))
            print(('%03d:  %-s')%((no,)+tuple(inst)))
        elif len(inst) == 2:    # jmp
            f.write(('%03d:  %-4s %-s\n')%((no,)+tuple(inst)))
            print(('%03d:  %-4s %-s')%((no,)+tuple(inst)))
        else:
            f.write(('%03d:  %-4s %-3s %-3s %-s\n')%((no,)+tuple(inst)))
            print(('%03d:  %-4s %-3s %-3s %-s')%((no,)+tuple(inst)))
    
print()

with open('asm_code/rc5_optimized.binary', 'w') as f:
    for no, _ in enumerate(instructions):
        print(inst_bin[no])
        f.write(inst_bin[no]+'\n')

with open('asm_code/rc5_optimized.hex', 'w') as f:
    for no, _ in enumerate(instructions):
        print(inst_hex[no])
        f.write(inst_hex[no]+'\n')

inst_hex[no], inst_dec[no]

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
    print('\t\tx"%s"'%h)

    while '<<< end <<<' not in inst_mem[i]:
        i += 1
    
    while i < len(inst_mem):
        f.write(inst_mem[i])
        i += 1
