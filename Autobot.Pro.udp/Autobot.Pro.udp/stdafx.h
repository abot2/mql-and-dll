// stdafx.h: ���������� ���� ��� ����������� ��������� ���������� ������
// ��� ���������� ������ ��� ����������� �������, ������� ����� ������������, ��
// �� ����� ����������
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN             // ��������� ����� ������������ ���������� �� ���������� Windows
// ����� ���������� Windows:
//#include <windows.h>



// TODO: ���������� ����� ������ �� �������������� ���������, ����������� ��� ���������
#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include <winsock2.h>
#include <codecvt>

#pragma comment(lib, "ws2_32.lib")