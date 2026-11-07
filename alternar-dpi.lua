
--[[
============================================================
 TUTORIAL DE CONFIGURACAO - ALTERNANCIA DE DPI
============================================================

1. Abra o Logitech G HUB.

2. Crie uma nova macro com o nome EXATO:
   
   alternar dpi

3. Configure essa macro para executar a acao responsavel
   por alternar o DPI do mouse.

   IMPORTANTE:
   - A macro deve ser responsavel exclusivamente pela
     alternancia do DPI.
   - O script Lua nao altera o DPI diretamente.
   - Ele apenas identifica a combinacao dos botoes
     e chama a macro criada no G HUB.

4. Salve a macro e certifique-se de que ela esteja
   disponivel no perfil ativo do mouse.

5. Quando os botoes laterais 4 e 5 forem pressionados
   simultaneamente, a macro sera executada.

COMPORTAMENTO:
- Pressionar somente o botao 4: nenhuma acao.
- Pressionar somente o botao 5: nenhuma acao.
- Pressionar 4 + 5 simultaneamente: alterna o DPI.
- Manter os dois pressionados: nao repete a acao.
- Soltar qualquer um dos botoes: rearma o gatilho.

============================================================
]]

local BUTTON_4 = 4
local BUTTON_5 = 5

local MACRO_NAME = "alternar dpi"

local buttonState = {
    [BUTTON_4] = false,
    [BUTTON_5] = false
}

local macroTriggered = false

function OnEvent(event, arg, family)
    local now = GetRunningTime()

    if event == "PROFILE_ACTIVATED" then
        buttonState[BUTTON_4] = false
        buttonState[BUTTON_5] = false
        macroTriggered = false

        OutputLogMessage("\n====================================\n")
        OutputLogMessage(" G HUB - MOUSE EVENT LOGGER\n")
        OutputLogMessage(" Profile activated\n")
        OutputLogMessage(" Trigger: Buttons 4 + 5 simultaneously\n")
        OutputLogMessage(" Macro: %s\n", MACRO_NAME)
        OutputLogMessage("====================================\n")

        return
    end

    if event == "MOUSE_BUTTON_PRESSED" then

        OutputLogMessage(
            "[%d ms] BUTTON PRESSED | Button: %d\n",
            now,
            arg
        )

        if arg == BUTTON_4 or arg == BUTTON_5 then
            buttonState[arg] = true

            OutputLogMessage(
                "  -> BUTTON %d STATE: PRESSED\n",
                arg
            )

            if buttonState[BUTTON_4]
                and buttonState[BUTTON_5]
                and not macroTriggered then

                macroTriggered = true

                OutputLogMessage(
                    "  -> BUTTONS 4 + 5 PRESSED SIMULTANEOUSLY!\n"
                )

                OutputLogMessage(
                    "  -> Attempting macro: %s\n",
                    MACRO_NAME
                )

                local success, err = pcall(function()
                    PlayMacro(MACRO_NAME)
                end)

                if success then
                    OutputLogMessage(
                        "  -> MACRO CALL SUCCESSFUL: %s\n",
                        MACRO_NAME
                    )
                else
                    OutputLogMessage(
                        "  -> MACRO EXECUTION ERROR: %s\n",
                        tostring(err)
                    )
                end
            end
        end

    elseif event == "MOUSE_BUTTON_RELEASED" then

        OutputLogMessage(
            "[%d ms] BUTTON RELEASED | Button: %d\n",
            now,
            arg
        )

        if arg == BUTTON_4 or arg == BUTTON_5 then
            buttonState[arg] = false

            OutputLogMessage(
                "  -> BUTTON %d STATE: RELEASED\n",
                arg
            )

            if macroTriggered then
                macroTriggered = false

                OutputLogMessage(
                    "  -> TRIGGER RESET | Ready for next activation\n"
                )
            end
        end
    end
end
