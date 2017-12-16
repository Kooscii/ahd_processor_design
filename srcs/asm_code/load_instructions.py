#!/usr/bin/env python
from __future__ import print_function

xrange=range




def parse_rtype(inst):
    op = decode[inst[0]]['op']
    # in order of INST rd, rs, rt
    rd = int(inst[1][1:])
    rs = int(inst[2][1:])
    rt = int(inst[3][1:])
    func = decode[inst[0]]['func']
    return pack_rtype(op, rs, rt, rd, func)

def pack_rtype(op, rs, rt, rd, func):
    return (op<<26) + (rs<<21) + (rt<<16) + (rd<<11) + func


def parse_itype(inst):
    op = decode[inst[0]]['op']
    # in order of INST rt, rs
    rt = int(inst[1][1:])
    rs = int(inst[2][1:])
    try:
        # check if immediate is in hex format
        if inst[3][0:2] == '0x':
            imm = int(inst[3], 16)
        # otherwise try to parse as integer
        else:
            imm = (int(float(inst[3])) + 2**16) % 2**16
    except:
        # if fails, it's a label
        # convert the label into pc offset
        label = inst[3]
        addr = labl2addr[label]
        offset = addr - (no + 1)  
        imm = (offset + 2**16) % 2**16
    return pack_itype(op, rs, rt, imm)

def pack_itype(op, rs, rt, imm):
    return (op<<26) + (rs<<21) + (rt<<16) + imm


def parse_jtype(inst):
    op = decode[inst[0]]['op']
    if inst[0] != 'HAL':
        try:
            # try to parse as integer
            addr = int(inst[1])
        except:
            # if fails, it's a label
            # convert the label into pc
            label = inst[1]
            addr = labl2addr[label]
    else:
        addr = 0
    return pack_jtype(op, addr)

def pack_jtype(op, addr):
    return (op<<26) + addr


decode = {
    'ADD':  {'parser':parse_rtype, 'type': 'R', 'op': 0x00, 'func': 0x10},
    'ADDI': {'parser':parse_itype, 'type': 'I', 'op': 0x01},
    'SUB':  {'parser':parse_rtype, 'type': 'R', 'op': 0x00, 'func': 0x11},
    'SUBI': {'parser':parse_itype, 'type': 'I', 'op': 0x02},
    'AND':  {'parser':parse_rtype, 'type': 'R', 'op': 0x00, 'func': 0x12},
    'ANDI': {'parser':parse_itype, 'type': 'I', 'op': 0x03},
    'OR':   {'parser':parse_rtype, 'type': 'R', 'op': 0x00, 'func': 0x13},
    'NOR':  {'parser':parse_rtype, 'type': 'R', 'op': 0x00, 'func': 0x14},
    'ORI':  {'parser':parse_itype, 'type': 'I', 'op': 0x04},
    'SHL':  {'parser':parse_itype, 'type': 'I', 'op': 0x05},
    'SHR':  {'parser':parse_itype, 'type': 'I', 'op': 0x06},
    'LW':   {'parser':parse_itype, 'type': 'I', 'op': 0x07},
    'SW':   {'parser':parse_itype, 'type': 'I', 'op': 0x08},
    'BLT':  {'parser':parse_itype, 'type': 'I', 'op': 0x09},
    'BEQ':  {'parser':parse_itype, 'type': 'I', 'op': 0x0a},
    'BNE':  {'parser':parse_itype, 'type': 'I', 'op': 0x0b},
    'JMP':  {'parser':parse_jtype, 'type': 'J', 'op': 0x0c},
    'HAL':  {'parser':parse_jtype, 'type': 'J', 'op': 0x3f}, 
}




# reading instructions and mapping label to line no.
code_name = 'rc5_optimized'
# code_name = 'rc5'
# asm_code = open('asm_code/code1.asm', 'r').readlines()
# asm_code = open('asm_code/code2.asm', 'r').readlines()
asm_code = open('%s.asm'%code_name, 'r').readlines()


instructions = []       # splitted instructions in list format,
labl2addr = {}          # label to address table
addr2labl = {}          # address to label table

# split each line of instructions into a list
# remove the comments and empty line
# build up label2address and address2label tables
addr = 0
for line in asm_code:
    # trim comment
    inst = line.split('#')[0].strip().split()
    # if not blank line
    if inst and inst[0][-1] == ':':
        # if it is a label
        label = inst[0][:-1].strip()
        # mapping address to label
        if label in labl2addr:
            raise 'Duplicated LABEL'
        labl2addr[label] = addr
        # mapping label to address
        if addr in addr2labl:
            addr2labl[addr].append(label+':')
        else:
            addr2labl[addr] = [label+':']
    elif inst:
        # otherwise, it is an instruction
        instructions.append(inst)
        addr += 1

# compiling
# convert each instruction into machine code (in decimal first)
inst_dec = [2**32-1 for _ in xrange(2048)]
for no, inst in enumerate(instructions):
    inst_dec[no] = decode[inst[0]]['parser'](inst)

# convert decimal format instructions into binary and hex
inst_bin = [bin(i)[2:].zfill(32) for i in inst_dec]
inst_hex = [hex(i)[2:].strip('L').zfill(8) for i in inst_dec]


# print the code into files
# clean code with address number, used for debugging cpu
with open('%s.code'%code_name, 'w') as f:
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

# binary machine code for cpu
with open('%s.binary'%code_name, 'w') as f:
    for no, _ in enumerate(instructions):
        print(no, ':', inst_bin[no])
        f.write(inst_bin[no]+'\n')

# hex machine code for cpu
with open('%s.hex'%code_name, 'w') as f:
    for no, _ in enumerate(instructions):
        print(inst_hex[no])
        f.write(inst_hex[no]+'\n')


# write the machine code into instruction memory (inst_mem.vhd)
inst_mem = open('../sources/ins_mem.vhd', 'r').readlines()
with open('../sources/ins_mem.vhd', 'w') as f:
    i = 0
    while '>>> start >>>' not in inst_mem[i]:
        f.write(inst_mem[i])
        i += 1
    f.write(inst_mem[i])
    
    f.write('\t')
    for l, h in enumerate(inst_hex[:-1], 1):
        f.write('x"%s",'%h)
        if l%2**8 == 0:
            f.write('\n\t')
        print('\t\tx"%s",'%h)
    f.write('x"%s"\n'%inst_hex[-1])
    print('\t\tx"%s"'%h)

    while '<<< end <<<' not in inst_mem[i]:
        i += 1
    
    while i < len(inst_mem):
        f.write(inst_mem[i])
        i += 1
