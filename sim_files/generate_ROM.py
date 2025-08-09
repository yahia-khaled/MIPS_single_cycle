import re

inst_address = []
with open ("../../../Tests/Test5.hex",'r') as file:
    file_read = file.readlines()
    for line in file_read:
        instr = re.findall(r'[0-9A-Fa-f]{8}',line)
        address = re.findall(r'(?<=0x)\w{4}_\w{4}',line)
        if len(address) != 0 and len(instr) != 0:
            address_hex = address[0].replace('_',"")
            address_num = int(address_hex,16)
            instr_rev = instr[0][::-1]
            for i in range(4):
                inst_address.append({'instruction' : instr_rev[i*2:i*2+2][::-1], 'address' : address_num+i})

with open ("ROM_contents.mem",'w') as file:
    for inst in inst_address:
        file.write(f"MEM[{inst["address"]}] = 8'h" + inst["instruction"] + ";\n")

