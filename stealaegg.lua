-- ==========================================
-- LUARMOR AUTOMATISCHER LOADER & KEY-HELPER
-- Kopiere diesen gesamten Block in deinen Executor
-- ==========================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("🚀 Luarmor Loader gestartet...")
print("⏳ Versuche, den Key automatisch zu generieren...")

-- 1. VERSUCH: Automatischer Key-Request
-- Dies funktioniert nur, wenn dein Account im Luarmor-System registriert ist (Rolle im Discord).
local autoSuccess = false
local autoKey = nil

pcall(function()
    -- Wir versuchen, die Standard-API für Key-Generierung zu nutzen
    -- Hinweis: Dies setzt voraus, dass du die "Key-Role" im Discord-Server hast.
    local url = "https://api.luarmor.net/api/v4/key/check"
    local response = game:HttpGet(url)
    local data = HttpService:JSONDecode(response)
    
    if data and data.success then
        autoKey = data.key
        autoSuccess = true
        print("✅ Automatischer Key erfolgreich erhalten!")
    else
        print("⚠️ Automatischer Key nicht gefunden (Hast du die Rolle im Discord?).")
    end
end)

if autoSuccess and autoKey then
    print("🔑 Verwende automatischen Key: " .. autoKey)
    script_key = autoKey
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/3bfa39bce217c43f7be19c701aeb50be.lua"))()
    print("🎉 Script geladen! Das Hack sollte jetzt aktiv sein.")
else
    print("--------------------------------------------------")
    print("🔴 AUTOMATISCHER MODUS FEHLGESCHLAGEN ODER KEY NICHT GEFUNDEN")
    print("📌 MANUELLER WEG (SICHERST & AM EINFACHSTEN):")
    print("--------------------------------------------------")
    print("1. Geh in den Discord-Server von Luarmor.")
    print("2. Suche den Bot: Luarmor#1466")
    print("3. Schreibe den Befehl: /key")
    print("4. Der Bot gibt dir einen Code (z.B. ABC123-XYZ789).")
    print("5. Kopiere diesen Code.")
    print("6. Füge ihn unten in die Zeile: script_key = \"HIER_EINFUEGEN\"")
    print("7. Führe das Script erneut aus.")
    print("--------------------------------------------------")
    
    -- HIER FÜGST DU DEINEN MANUELL GEFUNDENEN KEY EIN
    -- Wenn du den Key vom Discord-Bot hast, ändere diese Zeile:
    local manualKey = "HIER_DEIN_KEY_EINFUEGEN" 
    
    if manualKey ~= "HIER_DEIN_KEY_EINFUEGEN" then
        print("🔑 Verwende manuellen Key: " .. manualKey)
        script_key = manualKey
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/3bfa39bce217c43f7be19c701aeb50be.lua"))()
        print("🎉 Script geladen! Das Hack sollte jetzt aktiv sein.")
    else
        print("⏸️ Warte... Bitte füge deinen Key in den Code ein und führe es erneut aus.")
    end
end
