local naughty = require("naughty")

local utils = require("utils")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup! Fix them and run\n`awesome-client 'awesome.restart()'` to reload the config.",
        text = awesome.startup_errors,
    })
    utils.log(awesome.startup_errors, "error")
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })
        utils.log(tostring(err), "error")
        in_error = false
    end)
end
