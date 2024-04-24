#include "softplc_client_socket.h"
#define MAX_PAYLOAD_SIZE 255

extern timer_t PLC_timer;
extern unsigned long long common_ticktime__;
extern pthread_mutex_t run_mutex;
extern char* PLC_info;
extern char* PLC_file_name;
void PLC_SetTimer(unsigned long long next, unsigned long long period);
void config_init__(void);

server_socket_info server_info = {
    .server_ip = NULL,
    .server_port = 0,
    .socket_fd = 0,
    .status = SOCKET_OFF};

int parse_packet(char *buf, message *msg)
{
    msg->fun_code = (uint8_t)(buf[0]);
    uint8_t size = (uint8_t)(buf[1]);
    msg->size = size;
    if (size >= 0)
    {
        msg->payload = (char *)malloc(size + 1);
        strncpy(msg->payload, buf + 2, size);
        // strncpy will append '\0' to the tail of string automatically.
        // (msg->payload)[size] = '\0';
        return 1;
    }
    // error
    return -1;
}

void handle_echo(message *msg)
{
    write_to_server(msg);
}

void handle_stop(message *msg){
    if((msg->payload)[0]=='0'){
        //stop
        PLC_SetTimer(0,0);
    }else if((msg->payload)[0]=='1'){
        //continue
        PLC_SetTimer(common_ticktime__,common_ticktime__);
    }else{
        //error
        printf("handle_stop() error: invaild payload\n");
    }
}

void handle_reset(message *msg){
    pthread_mutex_lock(&run_mutex);
    config_init__();
    pthread_mutex_unlock(&run_mutex);
}

void handle_info(message *msg){
    message response;
    response.fun_code=INFO;
    response.payload=(char*)malloc(MAX_PAYLOAD_SIZE+1);
    sprintf(response.payload,"1 %s %s",PLC_file_name,PLC_info);
    response.size=strlen(response.payload);
    write_to_server(&response);
    if(response.payload!=NULL){
        free(response.payload);
    }
}

int setup_socket(char *server_ip, int server_port)
{
    struct sockaddr_in server_addr;
    server_info.socket_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_info.socket_fd < 0)
    {
        printf("create socket failed: %d\n", server_info.socket_fd);
        exit(1);
    }
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(server_port);
    server_addr.sin_addr.s_addr = inet_addr(server_ip);

    if (connect(server_info.socket_fd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr)) == -1)
    {
        printf("socket connect failed: %d\n", server_info.socket_fd);
        exit(1);
    }

    // 创建socket并连接成功
    server_info.server_ip = (char *)malloc(strlen(server_ip) + 1);
    strcpy(server_info.server_ip, server_ip);
    server_info.server_port = server_port;
    server_info.status = SOCKET_ON;

    pthread_t pid;
    int re = pthread_create(&pid, NULL, receive_from_server, NULL);
    if (re != 0)
    {
        printf("create pthread failed: %d\n", server_info.socket_fd);
        exit(1);
    }
    return 1;
}

void *receive_from_server()
{
    int buffer_size = 264;
    int sockfd = server_info.socket_fd;
    char buffer[buffer_size];
    while (1)
    {
        int len = recv(sockfd, buffer, buffer_size, 0);
        if (len == 0)
        {
            printf("The socket connection is closed unexpectedly!\n");
            // TODO: reconnect
            sleep(1);
            continue;
        }
        if (len < 0)
        {
            printf("The socket reading is error! Erron message: %s\n", strerror(errno));
            // TODO: error handle
            sleep(1);
            continue;
        }
        printf("new socket message! size: %d\n", len);
        if (len < 2)
        {
            // TODO: incomplete message
            printf("incomplete message!\n");
            continue;
        }
        message msg;
        if (parse_packet(buffer, &msg) < 0)
        {
            // TODO: handle parse packet error
            continue;
        }
        switch (msg.fun_code)
        {
        case ECHO:
        {
            printf("function code: echo\n");
            handle_echo(&msg);
            break;
        }
        case START:{
            printf("function code: start (do nothing)\n");
            break;
        }
        case CLOSE:{
            printf("function code: close (do nothing)\n");
            break;
        }
        case STOP:{
            printf("function code: stop\n");
            handle_stop(&msg);
            break;
        }
        case RESET:{
            printf("function code: reset\n");
            handle_reset(&msg);
            break;
        }
        case INFO:{
            printf("function code: info\n");
            handle_info(&msg);
            break;
        }
        default:
        {
            // TODO: handle unfitable function code
            printf("Invaild function code: %hhu\n", msg.fun_code);
            break;
        }
        }
        if(msg.payload!=NULL){
            free(msg.payload);
        }
    }
}

int write_to_server(message *mess)
{
    char *data = (char *)malloc(mess->size + 2);
    int sockfd = server_info.socket_fd;
    data[0] = mess->fun_code;
    data[1] = mess->size;
    memcpy(data + 2, mess->payload, mess->size);
    int sz = send(sockfd, data, mess->size + 2, 0);
    free(data);
    if (sz >= 0)
    {
        return 1;
    }
    else
    {
        printf("The socket sending is error! Error message: %s\n", strerror(errno));
        return -1;
    }
}