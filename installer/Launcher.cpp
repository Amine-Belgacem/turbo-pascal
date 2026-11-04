#define UNICODE
#define _UNICODE
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <shellapi.h>
#include <tlhelp32.h>
#include <winioctl.h>
#include <string>
#include <vector>
#include <stdexcept>

using std::wstring;
static wstring Join(const wstring& a, const wstring& b) { return a + L"\\" + b; }
static bool Exists(const wstring& p) { return GetFileAttributesW(p.c_str()) != INVALID_FILE_ATTRIBUTES; }
static std::string Read(const wstring& p) {
    HANDLE h = CreateFileW(p.c_str(), GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING, 0, nullptr);
    if (h == INVALID_HANDLE_VALUE) throw std::runtime_error("Cannot read Pascal settings.");
    DWORD size = GetFileSize(h, nullptr), got = 0;
    if (size > 65536) { CloseHandle(h); throw std::runtime_error("Pascal settings file is too large."); }
    std::string s(size, '\0'); ReadFile(h, &s[0], size, &got, nullptr); CloseHandle(h); s.resize(got); return s;
}
static void SaveChanged(const wstring& path, const std::string& value) {
    if (Exists(path) && Read(path) == value) return;
    HANDLE h = CreateFileW(path.c_str(), GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (h == INVALID_HANDLE_VALUE) throw std::runtime_error("Cannot save settings. Install Pascal in a writable folder.");
    DWORD wrote = 0; BOOL ok = WriteFile(h, value.data(), (DWORD)value.size(), &wrote, nullptr); CloseHandle(h);
    if (!ok || wrote != value.size()) throw std::runtime_error("Cannot write Pascal settings.");
}
static wstring Short(const wstring& path, bool requireAscii = true) {
    wchar_t buf[4096];
    DWORD n = GetShortPathNameW(path.c_str(), buf, 4096);
    if (!n || n >= 4096) throw std::runtime_error("Cannot access the selected file or Pascal folder.");
    wstring s(buf);
    if (requireAscii) for (auto c : s) if (c > 127 || c == L' ') throw std::runtime_error("Turbo Pascal needs ASCII short filenames. Choose a simpler filename, or use a drive with short filename support.");
    return s;
}
static std::string Ascii(const wstring& s) { std::string result; for (auto c : s) result.push_back(static_cast<char>(c)); return result; }
static wstring Quote(const wstring& s) { return L"\"" + s + L"\""; }
// Serialize shell launches until the editor can accept another file. The mutex
// is per installation and per login session; unrelated copies remain independent.
struct LaunchLock {
    HANDLE handle;
    explicit LaunchLock(const wstring& root) {
        unsigned long long hash = 14695981039346656037ull;
        for (wchar_t c : root) { hash ^= towlower(c); hash *= 1099511628211ull; }
        wstring name = L"Local\\TurboPascal15.Open." + std::to_wstring(hash);
        handle = CreateMutexW(nullptr, FALSE, name.c_str());
        if (!handle) throw std::runtime_error("Cannot coordinate the Pascal launch.");
        DWORD result = WaitForSingleObject(handle, 30000);
        if (result != WAIT_OBJECT_0 && result != WAIT_ABANDONED) {
            CloseHandle(handle); handle = nullptr;
            throw std::runtime_error("Pascal is still opening another file. Please try again after it finishes loading.");
        }
    }
    ~LaunchLock() { if (handle) { ReleaseMutex(handle); CloseHandle(handle); } }
};
static bool SamePath(const wchar_t* a, const wstring& b) {
    // String paths can differ under Windows package redirection, junctions,
    // and short-name aliases. Compare the executable's actual file identity.
    HANDLE first = CreateFileW(a, FILE_READ_ATTRIBUTES, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, nullptr);
    HANDLE second = CreateFileW(b.c_str(), FILE_READ_ATTRIBUTES, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, nullptr);
    BY_HANDLE_FILE_INFORMATION x{}, y{};
    bool same = first != INVALID_HANDLE_VALUE && second != INVALID_HANDLE_VALUE &&
        GetFileInformationByHandle(first, &x) && GetFileInformationByHandle(second, &y) &&
        x.dwVolumeSerialNumber == y.dwVolumeSerialNumber && x.nFileIndexHigh == y.nFileIndexHigh && x.nFileIndexLow == y.nFileIndexLow;
    if (first != INVALID_HANDLE_VALUE) CloseHandle(first);
    if (second != INVALID_HANDLE_VALUE) CloseHandle(second);
    return same;
}
static wstring FullPath(const wstring& path) {
    wchar_t full[32768]; DWORD n = GetFullPathNameW(path.c_str(), 32768, full, nullptr);
    if (!n || n >= 32768) throw std::runtime_error("The selected file path is invalid or too long for Windows.");
    return full;
}
static void CreateFolderJunction(const wstring& link, const wstring& requestedTarget) {
    // Resolve package redirection before writing the NTFS target: the reparse
    // point is interpreted by the filesystem, outside the caller's redirection.
    HANDLE directory = CreateFileW(requestedTarget.c_str(), FILE_READ_ATTRIBUTES,
        FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, nullptr);
    wchar_t finalPath[32768];
    DWORD length = directory == INVALID_HANDLE_VALUE ? 0 : GetFinalPathNameByHandleW(directory, finalPath, 32768, FILE_NAME_NORMALIZED | VOLUME_NAME_DOS);
    if (directory != INVALID_HANDLE_VALUE) CloseHandle(directory);
    if (!length || length >= 32768) throw std::runtime_error("Cannot resolve the original source folder.");
    wstring target(finalPath);
    if (target.compare(0, 4, L"\\\\?\\") == 0) target.erase(0, 4);
    if (target.size() < 3 || target[1] != L':' || target[2] != L'\\')
        throw std::runtime_error("Deep source folders must be on a local drive.");
    // Mount-point reparse data links to the directory itself. Saving through
    // this alias updates the original files, including sibling includes.
    wstring substitute = L"\\??\\" + target;
    size_t subBytes = substitute.size() * sizeof(wchar_t), printBytes = target.size() * sizeof(wchar_t);
    size_t total = 16 + subBytes + sizeof(wchar_t) + printBytes + sizeof(wchar_t);
    if (total > MAXIMUM_REPARSE_DATA_BUFFER_SIZE) throw std::runtime_error("This folder path is too long to alias.");
    std::vector<BYTE> data(total, 0);
    *reinterpret_cast<DWORD*>(data.data()) = IO_REPARSE_TAG_MOUNT_POINT;
    auto words = reinterpret_cast<WORD*>(data.data() + 4);
    words[0] = static_cast<WORD>(total - 8); // ReparseDataLength
    words[2] = 0; words[3] = static_cast<WORD>(subBytes);
    words[4] = static_cast<WORD>(subBytes + sizeof(wchar_t)); words[5] = static_cast<WORD>(printBytes);
    memcpy(data.data() + 16, substitute.data(), subBytes);
    memcpy(data.data() + 16 + subBytes + sizeof(wchar_t), target.data(), printBytes);
    HANDLE h = CreateFileW(link.c_str(), GENERIC_WRITE, 0, nullptr, OPEN_EXISTING,
        FILE_FLAG_BACKUP_SEMANTICS | FILE_FLAG_OPEN_REPARSE_POINT, nullptr);
    if (h == INVALID_HANDLE_VALUE) throw std::runtime_error("Cannot prepare a short folder alias for Pascal.");
    DWORD returned = 0;
    BOOL ok = DeviceIoControl(h, FSCTL_SET_REPARSE_POINT, data.data(), static_cast<DWORD>(data.size()), nullptr, 0, &returned, nullptr);
    CloseHandle(h);
    if (!ok) {
        // The newly created directory is empty; never recurse into a target.
        RemoveDirectoryW(link.c_str());
        throw std::runtime_error("Cannot create a folder alias. Install Pascal on a local NTFS drive and try again.");
    }
}
static wstring SourcePathForPascal(const wstring& root, const wstring& selected) {
    wstring original = FullPath(selected), shortened = Short(original, false);
    // TPW's directory field allows 63 characters; filenames allow 79.
    bool ascii = true; for (auto c : shortened) if (c > 127 || c == L' ') ascii = false;
    if (ascii && shortened.size() <= 79 && shortened.find_last_of(L'\\') <= 63) return shortened;
    size_t slash = original.find_last_of(L'\\');
    if (slash == wstring::npos) throw std::runtime_error("The source file has no parent folder.");
    wstring folder = original.substr(0, slash), filename = original.substr(slash + 1);
    wstring links = Join(root, L"Links");
    if (!CreateDirectoryW(links.c_str(), nullptr) && GetLastError() != ERROR_ALREADY_EXISTS)
        throw std::runtime_error("Cannot create Pascal's short-path alias folder.");
    unsigned long hash = 2166136261u;
    for (wchar_t c : folder) { hash ^= towlower(c); hash *= 16777619u; }
    for (unsigned int attempt = 0; attempt < 256; ++attempt) {
        wchar_t name[9]; swprintf_s(name, L"%08X", hash + attempt);
        wstring link = Join(links, name);
        if (CreateDirectoryW(link.c_str(), nullptr)) CreateFolderJunction(link, folder);
        else {
            DWORD attrs = GetFileAttributesW(link.c_str());
            if (attrs == INVALID_FILE_ATTRIBUTES || !(attrs & FILE_ATTRIBUTE_REPARSE_POINT) || !SamePath(link.c_str(), folder)) continue;
        }
        if (!SamePath(link.c_str(), folder)) throw std::runtime_error("The short folder alias could not be verified.");
        wstring aliased = Short(Join(link, filename));
        if (aliased.size() > 79 || aliased.find_last_of(L'\\') > 63)
            throw std::runtime_error("The Pascal installation path is too deep for source aliases. Reinstall in a shorter writable folder.");
        if (!SamePath(aliased.c_str(), original)) throw std::runtime_error("The short file alias does not identify the original source file.");
        return aliased;
    }
    throw std::runtime_error("Cannot allocate a short folder alias for this source file.");
}
static HWND WaitEditor(DWORD pid, DWORD timeout);
static DWORD RunningEngine(const wstring& engine) {
    HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (snapshot == INVALID_HANDLE_VALUE) throw std::runtime_error("Cannot check whether Pascal is already running.");
    PROCESSENTRY32W entry{}; entry.dwSize = sizeof(entry); DWORD pid = 0;
    for (BOOL more = Process32FirstW(snapshot, &entry); more; more = Process32NextW(snapshot, &entry)) {
        if (_wcsicmp(entry.szExeFile, L"otvdmw.exe")) continue;
        HANDLE process = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, entry.th32ProcessID);
        if (!process) continue;
        wchar_t path[4096]; DWORD length = 4096;
        bool queried = QueryFullProcessImageNameW(process, 0, path, &length) != 0;
        bool match = queried && SamePath(path, engine);
        CloseHandle(process);
        if (match) {
            // WinCrt programs use the same runtime executable. Prefer the
            // process with TPW's editor menu, not a running compiled program.
            if (WaitEditor(entry.th32ProcessID, 0)) { pid = entry.th32ProcessID; break; }
            if (!pid) pid = entry.th32ProcessID;
        }
    }
    CloseHandle(snapshot); return pid;
}
struct EditorSearch { DWORD pid; HWND window = nullptr; bool dialog = false; };
static BOOL CALLBACK FindEditorWindow(HWND window, LPARAM data) {
    auto& search = *reinterpret_cast<EditorSearch*>(data);
    DWORD pid = 0; GetWindowThreadProcessId(window, &pid);
    if (pid != search.pid || !IsWindowVisible(window)) return TRUE;
    if (search.dialog) {
        // This is the bundled English TPW's File Open dialog, not Save As or
        // an unrelated modal. Control 201 is its filename combo box.
        wchar_t title[128]; GetWindowTextW(window, title, 128);
        if (_wcsicmp(title, L"File Open") || !GetDlgItem(window, 201)) return TRUE;
    } else {
        HMENU menu = GetMenu(window);
        if (!menu || GetMenuState(menu, 1002, MF_BYCOMMAND) == (UINT)-1) return TRUE;
    }
    search.window = window; return FALSE;
}
static HWND WaitEditor(DWORD pid, DWORD timeout) {
    ULONGLONG deadline = GetTickCount64() + timeout;
    do {
        EditorSearch search{pid}; EnumWindows(FindEditorWindow, reinterpret_cast<LPARAM>(&search));
        if (search.window) return search.window;
        if (!timeout) return nullptr;
        HANDLE process = OpenProcess(SYNCHRONIZE, FALSE, pid);
        if (!process) return nullptr;
        bool exited = WaitForSingleObject(process, 0) == WAIT_OBJECT_0; CloseHandle(process);
        if (exited) return nullptr;
        Sleep(25);
    } while (GetTickCount64() < deadline);
    return nullptr;
}
static bool SendBounded(HWND window, UINT message, WPARAM wp, LPARAM lp) {
    DWORD_PTR result = 0;
    return SendMessageTimeoutA(window, message, wp, lp, SMTO_ABORTIFHUNG | SMTO_BLOCK, 1000, &result) != 0;
}
static void OpenInEditor(DWORD pid, HWND editor, const wstring& source) {
    if (!IsWindowEnabled(editor)) throw std::runtime_error("Pascal has an open dialog or running program. Finish or close it, then open your file again.");
    AllowSetForegroundWindow(pid); ShowWindowAsync(editor, SW_RESTORE); SetForegroundWindow(editor);
    if (source.empty()) return;
    // Use TPW's own File Open command and system-marshalled text messages.
    // Never inject keystrokes or dismiss existing save/error dialogs.
    if (!PostMessageW(editor, WM_COMMAND, 1002, 0)) throw std::runtime_error("Pascal could not accept the file-open request.");
    EditorSearch dialog{pid, nullptr, true}; ULONGLONG deadline = GetTickCount64() + 3000;
    do { EnumWindows(FindEditorWindow, reinterpret_cast<LPARAM>(&dialog)); if (dialog.window) break; Sleep(20); } while (GetTickCount64() < deadline);
    if (!dialog.window) throw std::runtime_error("Pascal is busy and could not open its file picker. Please try again.");
    std::string filename = Ascii(source);
    HWND combo = GetDlgItem(dialog.window, 201);
    HWND edit = GetDlgItem(combo, 1001);
    if (!edit) edit = FindWindowExA(combo, nullptr, "Edit", nullptr);
    if (!SendBounded(edit ? edit : combo, WM_SETTEXT, 0, reinterpret_cast<LPARAM>(filename.c_str())))
        throw std::runtime_error("Pascal did not accept the filename.");
    if (!SendBounded(dialog.window, WM_COMMAND, MAKEWPARAM(201, CBN_EDITCHANGE), reinterpret_cast<LPARAM>(combo)))
        throw std::runtime_error("Pascal did not process the filename change.");
    if (!PostMessageW(dialog.window, WM_COMMAND, IDOK, reinterpret_cast<LPARAM>(GetDlgItem(dialog.window, IDOK))))
        throw std::runtime_error("Pascal could not open the selected file.");
    // Keep the launch lock until this request's modal has finished. If TPW
    // reports an error, leave it visible rather than issuing further commands.
    deadline = GetTickCount64() + 3000;
    while (IsWindow(dialog.window) && GetTickCount64() < deadline) Sleep(20);
    if (IsWindow(dialog.window)) throw std::runtime_error("Pascal has not finished opening the file. Check its open dialog before trying again.");
}
int WINAPI wWinMain(HINSTANCE, HINSTANCE, PWSTR, int) {
    try {
        wchar_t module[4096]; GetModuleFileNameW(nullptr, module, 4096);
        wstring root(module); root.resize(root.find_last_of(L"\\"));
        wstring programs = Join(root, L"Programs"), app = Join(root, L"TPW"), runtime = Join(root, L"runtime");
        int argc = 0; auto argv = CommandLineToArgvW(GetCommandLineW(), &argc);
        wstring arg = argc > 1 ? argv[1] : L""; LocalFree(argv);
        bool configure = arg == L"/configure";
        wstring engine = Join(runtime, L"otvdmw.exe");
        wstring source;
        if (!configure && !arg.empty()) {
            if (!Exists(arg)) throw std::runtime_error("The selected Pascal file no longer exists.");
        }
        LaunchLock lock(root);
        if (!configure && !arg.empty()) source = SourcePathForPascal(root, arg);
        if (!configure) {
            DWORD running = RunningEngine(engine);
            if (running) {
                HWND editor = WaitEditor(running, 15000);
                if (!editor) throw std::runtime_error("Pascal is still starting or is not responding. Please try again once it is ready.");
                OpenInEditor(running, editor, source); return 0;
            }
        }
        CreateDirectoryW(programs.c_str(), nullptr);
        wstring shortPrograms = Short(programs);
        if (shortPrograms.size() > 63) throw std::runtime_error("This path is too deep for Turbo Pascal. Install in a shorter writable folder, such as C:\\TurboPascal15.");
        wstring config = Join(programs, L"TPW.CFG");
        std::string input = Read(Exists(config) ? config : Join(root, L"TPW-template.cfg"));
        const std::string units = "..\\TPW;..\\TPW\\OWL;..\\TPW\\WIN31;..\\TPW\\DOCDEMOS;..\\TPW\\WINDEMOS;..\\TPW\\OWLDEMOS";
        bool e = false, u = false, r = false; std::string output;
        for (size_t pos = 0; pos < input.size();) {
            size_t end = input.find('\n', pos);
            if (end == std::string::npos) end = input.size();
            std::string line = input.substr(pos, end - pos); pos = end + 1;
            if (!line.empty() && line.back() == '\r') line.pop_back();
            if (line.size() >= 2 && line[0] == '/') switch (toupper(line[1])) {
                case 'E': if (_stricmp(line.c_str(), ("/E" + Ascii(shortPrograms)).c_str())) line = "/E" + Ascii(shortPrograms); e = true; break;
                case 'U': if (_stricmp(line.c_str(), ("/U" + units).c_str())) line = "/U" + units; u = true; break;
                case 'R': if (_stricmp(line.c_str(), ("/R" + units).c_str())) line = "/R" + units; r = true; break;
            }
            output += line + "\r\n";
        }
        if (!e) output += "/E" + Ascii(shortPrograms) + "\r\n";
        if (!u) output += "/U" + units + "\r\n";
        if (!r) output += "/R" + units + "\r\n";
        SaveChanged(config, output);
        wstring ini = Join(runtime, L"WINDOWS\\tpw.ini"), shortConfig = Short(config);
        wchar_t old[4096]; GetPrivateProfileStringW(L"Startup", L"CfgPath", L"", old, 4096, ini.c_str());
        if (shortConfig != old && !WritePrivateProfileStringW(L"Startup", L"CfgPath", shortConfig.c_str(), ini.c_str()))
            throw std::runtime_error("Cannot save the Pascal configuration path.");
        if (configure) return 0;
        if (source.empty() && Exists(Join(programs, L"HELLO.PAS"))) source = Short(Join(programs, L"HELLO.PAS"));
        wstring command = Quote(engine) + L" " + Quote(Short(Join(app, L"TPW.EXE")));
        if (!source.empty()) command += L" " + Quote(source);
        STARTUPINFOW si{}; si.cb = sizeof(si); PROCESS_INFORMATION pi{};
        if (!CreateProcessW(engine.c_str(), &command[0], nullptr, nullptr, FALSE, 0, nullptr, programs.c_str(), &si, &pi))
            throw std::runtime_error("Cannot start the Pascal runtime. Reinstall the Microsoft Visual C++ x86 prerequisite or run Setup again.");
        CloseHandle(pi.hThread); CloseHandle(pi.hProcess);
        WaitEditor(pi.dwProcessId, 15000); return 0;
    } catch (const std::exception& ex) {
        MessageBoxA(nullptr, ex.what(), "Turbo Pascal - Startup problem", MB_OK | MB_ICONERROR); return 1;
    }
}
