// Integration test: pass a temporary install root and a disposable deep source.
// Including the launcher tests the actual resolver without another implementation.
#define wWinMain LauncherEntryForTest
#include "../installer/Launcher.cpp"
#undef wWinMain
#include <iostream>
int wmain(int argc, wchar_t** argv) {
    try {
        if (argc != 3 && argc != 4) throw std::runtime_error("Expected root and source, optionally /readonly.");
        bool readOnly = argc == 4 && !_wcsicmp(argv[3], L"/readonly");
        if (argc == 4 && !readOnly) throw std::runtime_error("Unknown test option.");
        wstring resolved = SourcePathForPascal(argv[1], argv[2]);
        if (resolved.size() > 79 || resolved.find_last_of(L'\\') > 63) throw std::runtime_error("Alias exceeds TPW limits.");
        if (!SamePath(resolved.c_str(), argv[2])) throw std::runtime_error("Alias points to another file.");
        wstring again = SourcePathForPascal(argv[1], argv[2]);
        if (again != resolved) throw std::runtime_error("Alias is not reused.");
        if (readOnly) { std::wcout << L"PASS: original file identity and reusable alias: " << resolved << L"\n"; return 0; }
        SaveChanged(resolved, "program SavedThroughAlias; begin end.\r\n");
        if (Read(argv[2]) != "program SavedThroughAlias; begin end.\r\n") throw std::runtime_error("Saving alias did not update original.");
        std::wcout << L"PASS: alias identity, reuse and direct save to original: " << resolved << L"\n";
        return 0;
    } catch (const std::exception& error) { std::cerr << error.what() << '\n'; return 1; }
}
