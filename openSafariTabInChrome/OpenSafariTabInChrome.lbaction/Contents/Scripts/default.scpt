--
-- opens current Safari tab in Google Chrome
-- forked from https://gist.github.com/3153606
-- which was forked from https://gist.github.com/3151932
--
property theURL : ""

if is_running("Safari") then
    tell application "Safari"
        if exists URL of current tab of window 1 then
            set theURL to URL of current tab of window 1
        end if
    end tell
end if

if is_running("Google Chrome") then
    tell application "Google Chrome"
        if (count of (every window where visible is true)) is greater than 0 then
            -- running with a visible window, ready for new tab
        else
            -- running but no visible window, so create one
            make new window
        end if
    end tell
else
    -- chrome app not running, so start it
    do shell script "open -a \"Google Chrome\""
end if

-- now that we have made sure chrome is running and has a visible
-- window create a new tab in that window and activate it to bring to the front
tell application "Google Chrome"
    if the URL of the active tab of window 1 is "chrome://newtab/" then
        -- Current tab is empty, open theURL in it
        set the URL of the active tab of window 1 to theURL
    else
        -- Otherwise make a new tab and open theURL
        tell window 1 to make new tab with properties {URL:theURL}
    end if
    activate
end tell

on is_running(appName)
    tell application "System Events" to (name of processes) contains appName
end is_running
