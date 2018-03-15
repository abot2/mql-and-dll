// Autobot.Pro.udp.cpp: определяет экспортированные функции для приложения DLL.
//

#include "stdafx.h"
#include "Autobot.Pro.udp.h"

SOCKET s = (SOCKET)SOCKET_ERROR;
bool wsaStarted = false;
struct sockaddr_in si_other;
const int slen = sizeof(si_other);

using convert_type = std::codecvt_utf8<wchar_t>;
std::wstring_convert<convert_type, wchar_t> converter;

AUTOBOTPROUDP_API void __stdcall UDPInit(
	const wchar_t *ip_address,
	const int port
) {
	if (!wsaStarted) {
		WSADATA wsa;

		if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
			return;
		}

		wsaStarted = true;
	}

	if (s == SOCKET_ERROR) {
		s = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

		if (s == SOCKET_ERROR) {
			WSACleanup();
			return;
		}
	}

	std::wstring ip_address_wstr(ip_address);

	memset(&si_other, 0, slen);
	si_other.sin_family = AF_INET;
	si_other.sin_port = htons((u_short)port);
	si_other.sin_addr.S_un.S_addr = inet_addr(converter.to_bytes(ip_address_wstr).c_str());
}

AUTOBOTPROUDP_API void __stdcall UDPMessage(
	const wchar_t *message
) {
	if (!wsaStarted || s == SOCKET_ERROR) {
		return;
	}

	std::wstring message_wstr(message);

	const char *msg = converter.to_bytes(message_wstr).c_str();

	sendto(s, msg, strlen(msg), 0, (struct sockaddr *) &si_other, slen);
}

AUTOBOTPROUDP_API void __stdcall UDPDeInit() {
	if (s != SOCKET_ERROR) {
		closesocket(s);
		s = (SOCKET)SOCKET_ERROR;
	}

	if (wsaStarted) {
		WSACleanup();
		wsaStarted = false;
	}
}