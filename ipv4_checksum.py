def ipv4_checksum(length, identification, src_ip_address, dst_ip_address):
        word1 = 0x4500                          #Version, IHL, DSCP, ECN
        word2 = length                          #Total Length
        word3 = identification                  #Identification
        word4 = 0x0000                          #Flags, Fragment Offset
        word5 = 0x8011                          #Time to Live, Protocol
        word6 = (src_ip_address >> 16) & 0xFFFF #Source IP Address
        word7 = src_ip_address & 0xFFFF         #Source IP Address
        word8 = (dst_ip_address >> 16) & 0xFFFF #Destination IP Address
        word9 = dst_ip_address & 0xFFFF         #Destination IP Address

        sum = word1 + word2 + word3 + word4 + word5 + word6 + word7 + word8 + word9
        sum = (sum & 0xFFFF) + ((sum >> 16) & 0xFFFF)
        print(hex(~sum & 0xFFFF))
