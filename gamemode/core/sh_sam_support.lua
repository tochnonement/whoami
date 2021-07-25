--[[

Author: tochonement
Email: tochonement@gmail.com

25.07.2021

--]]


if SAM_LOADED then
    sam.command.set_category("Who am I?")

    sam.command.new("restartround")
        :SetPermission("restartround", "superadmin")
        :OnExecute(function()
            if whoi.round.getState() ~= whoi.state.IDLE then
                whoi.round.finish()
            end
        end)
    :End()

    sam.command.new("changeword")
        :SetPermission("changeword", "superadmin")
        :AddArg("text", {check = function(wordId)
			wordId = wordId:lower()

            for id in pairs(whoi.word.storage) do
                if id == wordId then
                    return true
                end
            end

			return false
		end})
        :OnExecute(function(ply, wordId)
            if whoi.round.getState() == whoi.state.STARTED then
                local word = whoi.word.get(wordId)
                if word then
                    whoi.round.selectWord(wordId)
                end
            end
        end)
    :End()
    
end