def ethernet_receive(udp_host):
        import socket

        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        udp_port = 12345
        sock.bind((udp_host, udp_port))
        while True:
                print("Waiting for a datagram...")
                data,address = sock.recvfrom(100)
                print("Received Message: ", data, " from ", address)
