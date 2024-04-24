#ifndef SOFTPLC_SOCKET_H
#define SOFTPLC_SOCKET_H

#include <stdint.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <errno.h>
#include <arpa/inet.h>

typedef enum
{
    SOCKET_OFF,
    SOCKET_ON,
    SOCKET_ERROR
} socket_status;

typedef enum{
    ECHO,
    START,
    CLOSE,
    STOP,
    RESET,
    INFO,
} function_code;

typedef struct
{
    uint8_t fun_code;
    uint8_t size;
    char *payload;
} message;

typedef struct
{
    char *server_ip;
    int server_port;
    int socket_fd;
    socket_status status;
} server_socket_info;

int setup_socket(char *server_ip, int server_port);
int write_to_server(message *mess);
void *receive_from_server();

#endif