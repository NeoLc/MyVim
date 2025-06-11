import socket
import threading
import sys
import requests
import select

BUFFER_SIZE = 8192

def tunnel(client_sock, server_sock):
    """在客户端和目标服务器之间双向转发数据"""
    sockets = [client_sock, server_sock]
    try:
        while True:
            # 使用 select 监控两个套接字
            rlist, _, xlist = select.select(sockets, [], sockets, 60)
            
            if xlist:
                break
                
            for sock in rlist:
                # 从源套接字读取数据
                data = sock.recv(BUFFER_SIZE)
                if not data:
                    return
                    
                # 确定目标套接字
                if sock is client_sock:
                    target = server_sock
                else:
                    target = client_sock
                
                # 转发数据
                try:
                    target.sendall(data)
                except:
                    return
    except Exception as e:
        print(f"隧道错误: {str(e)}")
    finally:
        client_sock.close()
        server_sock.close()

def handle_client(client_socket):
    # 接收客户端请求
    request_data = client_socket.recv(BUFFER_SIZE)
    if not request_data:
        client_socket.close()
        return

    # 解析HTTP请求
    try:
        request_lines = request_data.decode('utf-8', errors='ignore').split('\r\n')
        request_line = request_lines[0]
        
        # 解析请求行
        parts = request_line.split(' ')
        if len(parts) < 3:
            client_socket.close()
            return
        
        # 解析请求行
        method, url, version = parts[:3]
    except:
        client_socket.close()
        return
    
    # ==== 新增：处理CONNECT请求（HTTPS隧道）====
    # 处理 CONNECT 请求（HTTPS 隧道）
    if method.upper() == "CONNECT":
        try:
            # 解析目标地址 (格式：host:port)
            host_port = url.split(':')
            target_host = host_port[0]
            target_port = int(host_port[1]) if len(host_port) > 1 else 443
            
            # 连接到目标服务器
            server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server_socket.settimeout(10)
            server_socket.connect((target_host, target_port))
            
            # 检查是否有额外的数据（TLS 握手开始部分）
            # 找到请求头结束位置（\r\n\r\n）
            end_of_headers = request_data.find(b'\r\n\r\n')
            if end_of_headers != -1:
                extra_data = request_data[end_of_headers+4:]
                if extra_data:
                    # 将额外数据发送到目标服务器
                    server_socket.sendall(extra_data)
            
            # 通知客户端隧道已建立
            client_socket.sendall(b"HTTP/1.1 200 Connection Established\r\n\r\n")
            
            # 启动双向数据转发
            tunnel(client_socket, server_socket)
            return
            
        except Exception as e:
            error_msg = f"CONNECT failed: {str(e)}"
            print(error_msg)
            client_socket.sendall(f"HTTP/1.1 502 {error_msg}\r\n\r\n".encode())
            client_socket.close()
            return
    # ========== 结束CONNECT处理 ==========
    
    # 解析头部
    for line in request_lines[1:]:
        if line.strip() == '':
            break
        key, value = line.split(': ', 1)
        headers[key] = value
    
    # 提取请求体
    body_index = request_data.find(b'\r\n\r\n') + 4
    body = request_data[body_index:]
    
    print(f"请求方法:{method}, Url:{url}, version:{version}, body:{body}")
    
    # 设置请求头，模拟浏览器访问
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    try:
    
        #response = requests.get(url, headers=headers, timeout=10)
    
        #使用requests库发送请求
        response = requests.request(
            method=method,
            url=url,
            headers=headers,
            data=body,
            #allow_redirects=False,
            timeout=10
        )
        print(f"响应状态:{response.status_code}")

        # 构建响应头
        #response_headers = (
        #    f"HTTP/1.1 {response.status_code} {response.reason}\r\n"
        #)
        
        response_headers = f"HTTP/1.1 {response.status_code} {response.reason}\r\n"
        
        # 处理响应头，正确处理分块编码和内容长度
        content_length = response.headers.get('Content-Length')
        transfer_encoding = response.headers.get('Transfer-Encoding', '').lower()
        
        # 添加响应头，保留原始头信息，除了可能需要调整的
        for key, value in response.headers.items():
            # 避免重复添加Transfer-Encoding和Content-Length
            if key.lower() not in ('transfer-encoding', 'content-length'):
                response_headers += f"{key}: {value}\r\n"
        
        # 根据响应是否使用分块编码来决定如何设置头部
        if transfer_encoding == 'chunked':
            # 如果是分块编码，添加Transfer-Encoding头，不添加Content-Length
            response_headers += "Transfer-Encoding: chunked\r\n"
        elif content_length:
            # 如果有Content-Length，添加它
            response_headers += f"Content-Length: {content_length}\r\n"
        
        # 添加空行
        response_headers += "\r\n"
        
        # 发送响应头
        client_socket.sendall(response_headers.encode('utf-8'))
        
        # 发送响应体
        if response.content:
            # 如果是分块编码，需要手动将内容分块发送
            if transfer_encoding == 'chunked':
                # 手动实现分块编码发送
                chunk_size = 8192
                for i in range(0, len(response.content), chunk_size):
                    chunk = response.content[i:i+chunk_size]
                    # 分块格式: 块大小(十六进制)\r\n块数据\r\n
                    chunk_header = f"{len(chunk):x}\r\n".encode('utf-8')
                    client_socket.sendall(chunk_header + chunk + b"\r\n")
                # 发送结束块
                client_socket.sendall(b"0\r\n\r\n")
            else:
                # 非分块编码直接发送
                client_socket.sendall(response.content)

    except Exception as e:
        error_response = f"HTTP/1.1 502 Bad Gateway\r\nContent-Type: text/plain\r\nContent-Length: {len(str(e))}\r\n\r\n{str(e)}"
        print(f"请求异常: {error_response}")
        client_socket.sendall(error_response.encode('utf-8'))
    finally:
        client_socket.close()

def start_proxy(proxy_host, proxy_port):
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((proxy_host, proxy_port))
    server.listen(5)
    print(f"[*] 代理服务器运行在 {proxy_host}:{proxy_port}")

    while True:
        client_socket, addr = server.accept()
        print(f"[*] 收到来自 {addr[0]}:{addr[1]} 的连接")
        threading.Thread(target=handle_client, args=(client_socket,)).start()

if __name__ == "__main__":
    # 设置监听地址和端口
    PROXY_HOST = "0.0.0.0"        # 监听所有接口
    #PROXY_HOST = "10.10.204.43"   # 监听所有接口
    PROXY_PORT = 54321            # 代理端口
    
    try:
        start_proxy(PROXY_HOST, PROXY_PORT)
    except KeyboardInterrupt:
        print("\n[*] 正在关闭代理服务器...")
        sys.exit(0)
