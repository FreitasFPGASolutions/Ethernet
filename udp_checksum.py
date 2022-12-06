def udp_checksum(src_ip_address, dst_ip_address, length, src_port, dst_port, msg):
        word1 = (src_ip_address >> 16) & 0xFFFF #Source IP Address
        word2 = src_ip_address & 0xFFFF         #Source IP Address
        word3 = (dst_ip_address >> 16) & 0xFFFF #Destination IP Address
        word4 = dst_ip_address & 0xFFFF         #Destination IP Address
        word5 = 0x11				#Protocol
        word6 = length				#UDP Length
        word7 = src_port			#Source Port
        word8 = dst_port			#Destination Port
        word9 = length				#UDP Length

        sum = word1 + word2 + word3 + word4 + word5 + word6 + word7 + word8 + word9

        data = bytes(msg, 'ascii')
        if len(data) % 2:
                data = data + bytes([0])
        for i in range(0, len(data), 2):
                sum = sum + ((data[i] << 8) + data[i+1])

        sum = (sum & 0xFFFF) + ((sum >> 16) & 0xFFFF)
        print(hex(~sum & 0xFFFF))

